class VerticalSpeedIndicator extends Indicator {

    float fpmInPx;   // 1 fpm = <fpmInPx> px
    float textSize;

    PShape shape;

    VsPointer vsPointer;

    VerticalSpeedIndicator(Aircraft ac, float x, float y, float w, float h, float pointerWidth, float fpmInPx) {
        super(ac, x, y, w, h);

        this.fpmInPx = fpmInPx;

        textSize = w * 2/3;

        vsPointer = new VsPointer(this, pointerWidth);

        generateShape(true);
        generateBackground();
        generateMask();
        generateShape(false);
    }

    void draw() {
        background.mask(mask);
        image(background, x, y);
        shape(shape, x, y);

        vsPointer.draw();
    }

    void generateBackground() {
        float wLine = 5;
        int numberStep = 2;

        createBackground();

        background.beginDraw();
        background.background(71);
        
        // lines and number
        background.stroke(255);
        background.strokeWeight(1);
        background.fill(255);
        background.textAlign(LEFT, CENTER);
        background.textSize(textSize);

        int num = 0;
        for(float y = h * .5; y > 0; y -= 1000 * fpmInPx) {
            background.line(0, y, wLine, y);
            if(num % numberStep == 0) background.text(num, wLine + textSize * .2, y - textSize * .1);
            num++;
        }
        num = 0;
        for(float y = h * .5; y < h; y += 1000 * fpmInPx) {
            background.line(0, y, wLine, y);
            if(num % numberStep == 0) background.text(num, wLine + textSize * .2, y - textSize * .1);
            num++;
        }
        
        background.endDraw();
    }

    void generateMask() {
        createMask();
        mask.beginDraw();
        mask.background(0);
        mask.shape(shape, 0, 0);
        mask.endDraw();
    }

    void generateShape(boolean forMask) {
        shape = createShape();
        shape.beginShape();

        if(forMask) {
            shape.noStroke();
            shape.fill(255, 200);
        } else {
            shape.stroke(255);
            shape.noFill();
        }

        shape.vertex(0, 0);
        shape.vertex(w - 1, 0);
        shape.vertex(w - 1, h * .5 - w * .5);
        shape.vertex(0, h * .5);
        shape.vertex(w - 1, h * .5 + w * .5);
        shape.vertex(w - 1, h - 1);
        shape.vertex(0, h - 1);

        shape.endShape(CLOSE);
    }

    class VsPointer extends Pointer<VerticalSpeedIndicator> {

        VsPointer(VerticalSpeedIndicator vsi, float w) {
            super(vsi, vsi.x, vsi.y, w, vsi.textSize * 1.2);

            createBackground();
        }

        void draw() {
            generateBackground();

            y = constrain(parent.y + parent.h * .5 - ac.vs * parent.fpmInPx, parent.y, parent.y + parent.h) - h * .5;

            image(background, x, y);
        }

        void generateBackground() {
            float textSize = w / max(str(floor(abs(ac.vs))).length(), 3);

            background.beginDraw();

            background.fill(0);
            background.stroke(255);

            background.beginShape();
            background.vertex(0, h * .5);
            background.vertex(h - 1, 0);
            background.vertex(w - 1, 0);
            background.vertex(w - 1, h - 1);
            background.vertex(h - 1, h - 1);
            background.endShape(CLOSE);

            if(floor(ac.vs / 10) * 10 != 0) {
                background.fill(255);
                background.textAlign(RIGHT, CENTER);
                background.textSize(textSize);
                background.text(floor(ac.vs / 10) * 10, w - textSize * .1, h * .5 - textSize * .1);
            }

            background.endDraw();
        }

        void generateMask() {}

        void generateShape(boolean forMask) {}

    }
}