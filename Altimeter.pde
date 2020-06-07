class Altimeter extends Indicator {

    float ftInPx;   // 1 ft = <ftInPx> px

    float nextThousand;

    float textSize, wSmallLine, wBigLine;

    AltimeterPointer altmp;

    Altimeter(Aircraft ac, float x, float y, float w, float h, float ftInPx) {
        super(ac, x, y, w, h);

        this.ftInPx = ftInPx;

        textSize = w * .17;
        wSmallLine = w * .08;
        wBigLine = wSmallLine * 2;
        bgH = h * 3;

        altmp = new AltimeterPointer(this, y + h * .5 - textSize * 2.8, textSize * 2.8);

        background = createGraphics((int)bgW, (int)bgH);
        mask = createGraphics((int)bgW, (int)bgH);
    }

    void draw() {
        if(nextThousand != round(ac.alt / 1000) * 1000) {
            nextThousand = round(ac.alt / 1000) * 1000;
            generateBackground();
        }

        float bgY = y + h * .5 - bgH * .5 + (ac.alt - nextThousand) * ftInPx;

        generateMask();
        background.mask(mask);
        image(background, x, bgY);

        stroke(255);
        strokeWeight(1);
        rect(x, y, w, h);

        altmp.draw();
    }

    void generateBackground() {
        float bigLineStep = 100;
        float smallLineStep = bigLineStep * .2;

        float bigLines = h / ftInPx / bigLineStep * 2;

        background.beginDraw();
        background.background(51);

        background.stroke(255);
        background.strokeWeight(1);
        for(float y = bgH * .5; y > 0; y -= smallLineStep * ftInPx) background.line(0, y, wSmallLine, y);
        for(float y = bgH * .5; y < bgH; y += smallLineStep * ftInPx) background.line(0, y, wSmallLine, y);

        background.fill(255);
        background.textSize(textSize);
        background.textAlign(LEFT, CENTER);
        int i = 0;
        for(float y = bgH * .5; y > 0; y -= bigLineStep * ftInPx) {
            background.line(0, y, wBigLine, y);
            background.text((int)nextThousand + i++ * (int)bigLineStep, wBigLine + textSize * .3, y - textSize * .1);
        }
        i = 0;
        for(float y = bgH * .5; y < bgH; y += bigLineStep * ftInPx) {
            background.line(0, y, wBigLine, y);
            if(i != 0) background.text((int)nextThousand - i * (int)bigLineStep, wBigLine + textSize * .3, y - textSize * .1);
            i++;
        }

        background.endDraw();
    }

    void generateMask() {
        mask.beginDraw();

        mask.background(0);
        mask.noStroke();
        mask.fill(255, 200);
        // draw:  y + h * .5 - bgH * .5 + (ac.alt - nextThousand) * ftInPx;
        mask.rect(0, -h * .5 + bgH * .5 - (ac.alt - nextThousand) * ftInPx, w, h);

        mask.endDraw();
    }

    class AltimeterPointer extends Indicator {

        Altimeter altm;
        float textSize;
        PShape shape;

        AltimeterPointer(Altimeter altm, float y, float h) {
            super(altm.ac, altm.x, y, altm.w, h);

            this.altm = altm;
            this.textSize = altm.textSize * 1.4;

            bgH = h * 2;

            background = createGraphics((int)bgW, (int)bgH);

            generateShape(true);
            generateMask();
            generateShape(false);
        }

        void draw() {
            generateBackground();
            background.mask(mask);
            image(background, x, y);
            shape(shape, x, y + h * .5);
        }

        void generateBackground() {
            final int acc = 20;
            final int diff = (int)(ac.alt % acc);
            int roundAlt = (int)ac.alt - diff;
            if(diff >= acc * .5) roundAlt += acc;
            final int sucNum = (int)((roundAlt + acc) % 100);
            final int preNum = (int)max(((roundAlt - acc) % 100), 0);
            final float digW = textSize * 1.9/3;

            int len = String.valueOf(nf(roundAlt, 2)).length();

            background.beginDraw();
            background.background(0);

            background.fill(255);
            background.noStroke();
            background.textAlign(LEFT, CENTER);
            background.textSize(textSize);
            background.text(nf(roundAlt, 2), wBigLine + textSize * .1 + (5 - len) * digW, bgH * .5 - textSize * .1);
            background.text(nf(sucNum, 2), wBigLine + textSize * .1 + digW * 3, bgH * .5 - textSize * 1.1);
            background.text(nf(preNum, 2), wBigLine + textSize * .1 + digW * 3, bgH * .5 + textSize * 0.9);

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
            final float wLeftPart = textSize * 1.8;

            shape = createShape();
            shape.beginShape();

            if(forMask) {
                shape.noStroke();
                shape.fill(255);
            } else {
                shape.stroke(255);
                shape.noFill();
            }

            shape.vertex(wSmallLine, h * .5);
            shape.vertex(wBigLine, h * .5 - wSmallLine);
            shape.vertex(wBigLine, h / 6);
            shape.vertex(wBigLine + wLeftPart, h / 6);
            shape.vertex(wBigLine + wLeftPart, 0);
            shape.vertex(w, 0);
            shape.vertex(w, h);
            shape.vertex(wBigLine + wLeftPart, h);
            shape.vertex(wBigLine + wLeftPart, h * 5/6);
            shape.vertex(wBigLine, h * 5/6);
            shape.vertex(wBigLine, h * .5 + wSmallLine);

            shape.endShape(CLOSE);
        }

    }

}