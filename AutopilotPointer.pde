class AutopilotPointer extends Indicator {

    /*
     * +----+
     * |    |
     * |   /   ^
     * |  /    | arrowH
     * |  \    |
     * |   \   v
     * |    |
     * +----+
     *
     *    <-> arrowW
     *
     */

    final color col = color(223, 79, 255);
    boolean visible;

    float angle;   // in radians
    float arrowW, arrowH;

    AutopilotPointer(Indicator parent, float w, float h, float arrowW, float arrowH, float angle) {
        super(parent.ac, parent.x, parent.y, w, h);

        visible = true;

        this.angle = angle;
        this.arrowW = arrowW;
        this.arrowH = arrowH;

        generateBackground();
    }

    void draw() {
        if(!visible) return;

        pushMatrix();
        translate(x, y);
        rotate(angle);
        image(background, 0, 0);
        popMatrix();
    }

    void generateBackground() {
        createBackground();
        background.beginDraw();
        background.beginShape();

        background.noStroke();
        background.fill(col);

        background.vertex(0, 0);
        background.vertex(w - 1, 0);
        background.vertex(w - 1, h * .5 - arrowH * .5 - 1);
        background.vertex(w - arrowW, h * .5 - 1);
        background.vertex(w - 1, h * .5 + arrowH * .5 - 1);
        background.vertex(w - 1, h - 1);
        background.vertex(0, h - 1);

        background.endShape(CLOSE);
        background.endDraw();
    }

    void generateMask() {}

}