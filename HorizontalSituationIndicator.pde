class HorizontalSituationIndicator extends Indicator {

    final String iconPath = "data/resources/aircraft.svg";
    PShape icon;

    // x, y is center
    float d;   // d = w = h
    float smallLineW, bigLineW;
    float textSize, numberStep;
    float iconSize;

    HeadingPointer hp;

    HorizontalSituationIndicator(Aircraft ac, float x, float y, float d, float bigLineWidth, float numberStep) {
        super(ac, x, y, d, d);

        icon = loadShape(iconPath);
        icon.setFill(color(255));

        this.d = d;
        bigLineW = bigLineWidth;
        smallLineW = bigLineW * 2/3;

        textSize = bigLineW * 2;
        this.numberStep = numberStep;
        iconSize = textSize * 2;

        hp = new HeadingPointer(this, textSize * 1.2);

        generateBackground();
        createMask();
    }

    void draw() {
        generateMask();
        background.mask(mask);
        hp.draw();

        pushMatrix();

        translate(x, y);
        rotate(radians(-ac.hdg));
        image(background, -w * .5, -h * .5);
        
        rotate(radians(ac.hdg));
        if(icon != null) shape(icon, -iconSize * .5, -iconSize * .5, iconSize, iconSize);

        popMatrix();
    }

    void generateBackground() {
        createBackground();
        background.beginDraw();
        background.background(71);

        background.pushMatrix();
        background.translate(w * .5, h * .5);

        background.stroke(255);
        background.strokeWeight(2);
        background.point(0, 0);
        background.textAlign(CENTER, TOP);
        background.textSize(textSize);
        background.fill(255);

        for(float a = 0; a < 360; a += 10) {
            background.rotate(radians(a));
            background.line(0, d * .5, 0, d * .5 - bigLineW);
            
            if(a % (int)numberStep == 0) {
                String text = "";
                if(a == 0) text = "N";
                else if(a == 90) text = "E";
                else if(a == 180) text = "S";
                else if(a == 270) text = "W";
                else text = nf(floor(a * .1), 2);
                background.text(text, 0, -d * .5 + bigLineW * 1.2);
            }

            background.rotate(radians(-a));
        }

        for(float a = 5; a < 360; a += 10) {
            float xO = cos(radians(a)) * d * .5;
            float xI = cos(radians(a)) * (d * .5 - smallLineW);
            float yO = sin(radians(a)) * d * .5;
            float yI = sin(radians(a)) * (d * .5 - smallLineW);
            background.line(xO, yO, xI, yI);
        }

        background.endDraw();
    }

    void generateMask() {
        mask.beginDraw();

        mask.translate(w * .5, h * .5);
        mask.rotate(radians(ac.hdg));
        mask.translate(-w * .5, -h * .5);

        mask.background(0);
        mask.noStroke();
        mask.fill(255, 200);
        mask.ellipse(w * .5, h * .5, w, h);

        mask.fill(0);
        if(x + w * .5 > ac.pfd.w) mask.rect(w * .5 - x + ac.pfd.x + ac.pfd.w, 0, x + w * .5 - ac.pfd.w, h);
        if(x - w * .5 < ac.pfd.x) mask.rect(0, 0, ac.pfd.x - x + w * .5 + 1, h);
        if(y + h * .5 > ac.pfd.h) mask.rect(0, h * .5 - y + ac.pfd.y + ac.pfd.h, w, y + h * .5 - ac.pfd.h);
        if(y - h * .5 < ac.pfd.y) mask.rect(0, 0, w, ac.pfd.y - y + h * .5 + 1);

        mask.endDraw();
    }

    class HeadingPointer extends Indicator {

        HorizontalSituationIndicator hsi;
        PShape shape;
        float textSize;

        HeadingPointer(HorizontalSituationIndicator hsi, float textSize) {
            super(hsi.ac, hsi.x - textSize * 41/18 * 0.6, hsi.y - hsi.d * .5 - textSize - hsi.bigLineW, textSize * 41/18 * 1.2, textSize + hsi.bigLineW); 
            //                    textSize * 41/18 = textWidth for "999°"

        	this.hsi = hsi;
            this.textSize = textSize;

            createBackground();
            generateShape(true);
            generateMask();
            generateShape(false);
        }

        void draw() {
            generateBackground();
            background.mask(mask);
            image(background, x, y);
            shape(shape, x, y);
        }

        void generateBackground() {
            background.beginDraw();
            background.background(0);

            background.fill(255);
            background.textAlign(CENTER, TOP);
            background.textSize(textSize);
            background.text(nf(floor(ac.hdg), 3) + "°", w * .5, -textSize * .1);

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
                shape.fill(255);
            } else {
                shape.stroke(255);
                shape.noFill();
            }

            shape.vertex(0, 0);
            shape.vertex(w - 1, 0);
            shape.vertex(w - 1, h - hsi.bigLineW);
            shape.vertex(w * .5 + hsi.bigLineW * .5, h - hsi.bigLineW);
            shape.vertex(w * .5, h - 1);
            shape.vertex(w * .5 - hsi.bigLineW * .5, h - hsi.bigLineW);
            shape.vertex(0, h - hsi.bigLineW);

            shape.endShape(CLOSE);
        }

    }

}