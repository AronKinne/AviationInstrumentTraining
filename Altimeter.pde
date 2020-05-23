class Altimeter extends Indicator {

    float ftInPx;   // 1 ft = <ftInPx> px

    float nextThousand;

    final float textSize = 20;

    Altimeter(Aircraft ac, float x, float y, float w, float h, float ftInPx) {
        super(ac, x, y, w, h);

        this.ftInPx = ftInPx;

        bgH = h * 3;

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
    }

    void generateBackground() {
        float bigLineStep = 100;
        float smallLineStep = bigLineStep * .2;
        float wBigLine = 14;
        float wSmallLine = 7;

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

}