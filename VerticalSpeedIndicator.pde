class VerticalSpeedIndicator extends Indicator {

    float fpmInPx;   // 1 fpm = <ftInPx> px

    VerticalSpeedIndicator(Aircraft ac, float x, float y, float w, float h, float fpmInPx) {
        super(ac, x, y, w, h);

        this.fpmInPx = fpmInPx;

        generateBackground();
    }

    void draw() {
        image(background, x, y);
    }

    void generateBackground() {
        background = createGraphics((int)bgW, (int)bgH);

        background.beginDraw();
        background.background(71);

        background.noFill();
        background.stroke(255);
        background.beginShape();
        background.vertex(0, 0);
        background.vertex(w - 1, 0);
        background.vertex(w - 1, h * .5 - w * .5);
        background.vertex(0, h * .5);
        background.vertex(w - 1, h * .5 + w * .5);
        background.vertex(w - 1, h - 1);
        background.vertex(0, h - 1);
        background.endShape(CLOSE);

        background.endDraw();
    }

    void generateMask() {

    }
}