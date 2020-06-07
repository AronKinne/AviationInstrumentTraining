// https://en.wikipedia.org/wiki/Airspeed_indicator#/media/File:ASI.png

class AirspeedIndicator extends Indicator {

    float ktInPx;   // 1 kt = <ktInPx> px
    final float ktAbvVne = 10;   // amount of kts above the aircrafts never-exceed speed

    final float maxScala = ac.vne + ktAbvVne;
    final float textSize = 25;
    final float arcW = 10;

    AirspeedPointer asp;

    AirspeedIndicator(Aircraft ac, float x, float y, float w, float h, float ktInPx) {
        super(ac, x, y, w, h);

        this.ktInPx = ktInPx;

        bgH = (ac.vne - ac.vs0 + ktAbvVne) * ktInPx + h;
        
        asp = new AirspeedPointer(this, y + h * .5 - textSize * 1.25, textSize * 2.5);

        mask = createGraphics((int)bgW, (int)bgH);

        generateBackground();
    }

    void draw() {
        float bgY = y - bgH + h + (ac.ias - ac.vs0) * ktInPx;

        generateMask();
        background.mask(mask);
        image(background, x, bgY);

        stroke(255);
        strokeWeight(1);
        noFill();
        rect(x, y, w, h);
        
        asp.draw();
    }

    void generateBackground() {
        color colRed = color(255, 0, 0);
        color colYellow = color(255, 255, 0);
        color colGreen = color(0, 150, 0);

        float redLine = map(ac.vne, ac.vs0, maxScala, bgH - h * .5, h * .5);
        float yellowLower = map(ac.vno, ac.vs0, maxScala, bgH - h * .5, h * .5);
        float greenLower = map(ac.vs, ac.vs0, maxScala, bgH - h * .5, h * .5);
        float whiteUpper = map(ac.vfe, ac.vs0, maxScala, bgH - h * .5, h * .5);

        float whiteArcW = 5;
        float bigLineStep = 10;
        float wBigLine = 15;
        float wSmallLine = 10;
        float wRedLine = 3;

        background = createGraphics((int)bgW, (int)bgH);

        background.beginDraw();
        background.background(51);
        background.noStroke();

        // yellow arc
        background.fill(colYellow);
        background.rect(bgW - arcW, redLine, arcW, yellowLower - redLine);

        // green arc
        background.fill(colGreen);
        background.rect(bgW - arcW, yellowLower, arcW, greenLower - yellowLower);

        // white arc
        background.fill(255);
        background.rect(bgW - arcW, whiteUpper, whiteArcW, bgH - h * .5 - whiteUpper);

        // lines
        float offset = ac.vs0 % bigLineStep;
        float speed = ac.vs0 - offset;
        background.stroke(255);
        background.fill(255);
        background.textSize(textSize);
        background.textAlign(RIGHT, CENTER);
        background.strokeWeight(1);
        for(float y = bgH + offset * ktInPx - h * .5; y >= h * .5; y -= bigLineStep * ktInPx) {
            background.line(bgW - wBigLine, y, bgW, y);
            background.text((int)speed, bgW - arcW - textSize * .5, y - textSize * .1);
            speed += bigLineStep;
        }
        for(float y = bgH + (offset - bigLineStep + bigLineStep * .5) * ktInPx - h * .5; y > h * .5; y -= bigLineStep * ktInPx)
            background.line(bgW - wSmallLine, y, bgW, y);

        // red line
        background.stroke(colRed);
        background.strokeWeight(wRedLine);
        background.line(bgW - wBigLine, redLine, bgW, redLine);
        
        background.endDraw();
    }

    void generateMask() {
        mask.beginDraw();
        mask.background(0);

        mask.noStroke();
        mask.fill(255, 200);
        // draw: y - bgH + h + (ac.ias - ac.vs0) * ktInPx
        mask.rect(0, bgH - h - (ac.ias - ac.vs0) * ktInPx, w, h);

        mask.endDraw();
    }

    private class AirspeedPointer extends Indicator {

        AirspeedIndicator asi;
        float textSize;
        PShape shape;

        AirspeedPointer(AirspeedIndicator asi, float y, float h) {
            super(asi.ac, asi.x, y, asi.w, h);

            this.asi = asi;
            this.textSize = asi.textSize * 1.3;

            bgH = h * 2;

            background = createGraphics((int)bgW, (int)bgH);

            generateShape(true);
            generateMask();
            generateShape(false);
        }

        void draw() {
            generateBackground();
            background.mask(mask);
            image(background, x, y - bgH * .5 + h * .5);
            shape(shape, x, y - bgH * .5 + h);
        }

        void generateBackground() {
            final int sucDig = (int)((ac.ias + 1) % 10);
            final int preDig = (int)((ac.ias - 1) % 10);

            background.beginDraw();
            background.background(0);

            background.fill(255);
            background.textSize(textSize);
            background.textAlign(RIGHT, CENTER);
            background.text((int)ac.ias, bgW - arcW - textSize * .2, bgH * .5 - textSize * .1);
            background.text(sucDig, bgW - arcW - textSize * .2, bgH * .5 - textSize * 1.1);
            background.text(preDig, bgW - arcW - textSize * .2, bgH * .5 + textSize * 0.9);

            background.endDraw();
        }

        void generateMask() {
            mask = createGraphics((int)bgW, (int)bgH);
            mask.beginDraw();
            mask.background(0);
            mask.shape(shape, 0, bgH * .5 - h * .5);
            mask.endDraw();
        }

        void generateShape(boolean forMask) {
            shape = createShape();
            shape.beginShape();

            if(forMask) {
                shape.noStroke();
                shape.fill(255);
            } else {
                shape.stroke(255);
                shape.noFill();
            }

            shape.vertex(0, h / 6);
            shape.vertex(w - textSize - arcW, h / 6);
            shape.vertex(w - textSize - arcW, 0);
            shape.vertex(w - arcW, 0);
            shape.vertex(w - arcW, h * .5 - arcW);
            shape.vertex(w, h * .5);
            shape.vertex(w - arcW, h * .5 + arcW);
            shape.vertex(w - arcW, h);
            shape.vertex(w - textSize - arcW, h);
            shape.vertex(w - textSize - arcW, h * 5/6);
            shape.vertex(0, h * 5/6);

            shape.endShape(CLOSE);
        }

    }

}