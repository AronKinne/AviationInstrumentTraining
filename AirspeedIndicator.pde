// https://en.wikipedia.org/wiki/Airspeed_indicator#/media/File:ASI.png

class AirspeedIndicator extends Indicator {

    float ktInPx;   // 1 kt = <ktInPx> px
    float ktAbvVne = 10;
    float maxScala = ac.vne + ktAbvVne;

    float bgW, bgH;

    AirspeedIndicator(Aircraft ac, float x, float y, float w, float h, float ktInPx) {
        super(ac, x, y, w, h);

        this.ktInPx = ktInPx;

        bgW = w;
        bgH = (ac.vne - ac.vs0 + ktAbvVne) * ktInPx + h;
        
        mask = createGraphics((int)bgW, (int)bgH);

        generateBackground(bgW, bgH);
    }

    void draw() {
        float bgY = y - bgH + h * 1 + (ac.ias - ac.vs0) * ktInPx;

        updateMask();
        background.mask(mask);
        image(background, x, bgY);

        stroke(255);
        noFill();
        rect(x, y, w, h);
        
    }

    void generateBackground(float w, float h) {
        color colRed = color(255, 0, 0);
        color colYellow = color(255, 255, 0);
        color colGreen = color(0, 150, 0);

        float redLine = map(ac.vne, ac.vs0, maxScala, bgH - this.h * .5, this.h * .5);
        float yellowLower = map(ac.vno, ac.vs0, maxScala, bgH - this.h * .5, this.h * .5);
        float greenLower = map(ac.vs, ac.vs0, maxScala, bgH - this.h * .5, this.h * .5);
        float whiteUpper = map(ac.vfe, ac.vs0, maxScala, bgH - this.h * .5, this.h * .5);

        float textSize = 25;
        float arcW = 10;
        float whiteArcW = 5;
        float bigLineStep = 10;
        float wBigLine = 15;
        float wSmallLine = 10;
        float wRedLine = 3;

        background = createGraphics((int)w, (int)h);

        background.beginDraw();
        background.background(51);
        background.noStroke();

        // yellow arc
        background.fill(colYellow);
        background.rect(w - arcW, redLine, arcW, yellowLower - redLine);

        // green arc
        background.fill(colGreen);
        background.rect(w - arcW, yellowLower, arcW, greenLower - yellowLower);

        // white arc
        background.fill(255);
        background.rect(w - arcW, whiteUpper, whiteArcW, bgH - this.h * .5 - whiteUpper);

        // lines
        float offset = ac.vs0 - floor(ac.vs0 / bigLineStep) * bigLineStep;
        float speed = ac.vs0 - offset;
        background.stroke(255);
        background.fill(255);
        background.textSize(textSize);
        background.textAlign(RIGHT, CENTER);
        background.strokeWeight(1);
        for(float y = bgH + offset * ktInPx - this.h * .5; y >= this.h * .5; y -= bigLineStep * ktInPx) {
            background.line(w - wBigLine, y, w, y);
            background.text((int)speed, w - arcW - textSize * .5, y - textSize * .1);
            speed += bigLineStep;
        }
        for(float y = bgH + (offset - bigLineStep + bigLineStep * .5) * ktInPx - this.h * .5; y > this.h * .5; y -= bigLineStep * ktInPx) background.line(w - wSmallLine, y, w, y);

        // red line
        background.stroke(colRed);
        background.strokeWeight(wRedLine);
        background.line(w - wBigLine, redLine, w, redLine);
        
        background.endDraw();
    }

    void updateMask() {
        mask.beginDraw();
        mask.background(0);

        mask.noStroke();
        mask.fill(255, 200);
        mask.rect(0, -y + bgH - h * 0.8 - (ac.ias - ac.vs0) * ktInPx, w, h);

        mask.endDraw();
    }

}