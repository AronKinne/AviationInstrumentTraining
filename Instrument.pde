class Instrument {

    float x, y;
    color colHeaven, colGround, colReference;
    PGraphics background;

    final float scale = 10; // 1 deg = <scale> px
    float pitch, pitchVel;
    float roll, rollVel;
    final float maxPitchVel = 1;
    final float maxRollVel = 2;
    boolean mouseActive = false;

    private final int bgW = 800, bgH = 2500;
    
    Instrument(float x, float y, String imgRimPath) {
        this.x = x;
        this.y = y;

        colHeaven = color(135, 206, 250);
        colGround = color(160, 82, 45);
        colReference = color(255, 255, 0);
        
        generateBackground(bgW, bgH);
    }

    void draw() {
        pushMatrix();

        translate(x, y);
        rotate(radians(-roll));
        translate(0, pitch * scale);
        image(background, -bgW * .5, -bgH * .5);
        
        popMatrix();

        drawReference();

        println(pitch, roll);
    }

    void processMouseInput() {
        if(mouseActive) {
            pitchVel = map(mouseY, 0, height, -maxPitchVel, maxPitchVel) * cos(radians(roll));
            rollVel = map(mouseX, 0, width, -maxRollVel, maxRollVel);
        }

        pitch += pitchVel;
        roll = (roll + rollVel) % 360;

        if(pitch > 90 || pitch < -90) {
            float diff = pitch - (90 * sign(pitch));
            pitch = (90 * sign(pitch)) - diff;
            roll += 180;
        }
    }

    void mouseReleased() {
        mouseActive = !mouseActive;
    }

    private void generateBackground(int w, int h) {
        int textSize = 20;
        int strokeWeight0 = 5;
        int strokeWeightLine = 3;
        int amt10 = 9;
        int w10 = 200;
        int w5 = 100;
        int w25 = 50;

        float cx = w * .5;
        float cy = h * .5;

        background = createGraphics(w, h);
        background.beginDraw();

        background.background(colHeaven);
        background.noStroke();
        background.fill(colGround);
        background.rect(0, cy, w, cy);

        background.stroke(255);
        background.strokeWeight(strokeWeight0);
        background.line(0, cy, w, cy);

        background.strokeWeight(strokeWeightLine);
        background.fill(255);
        background.textSize(textSize);

        for(int i = -amt10; i <= amt10; i++) {
            if(i == 0) continue;

            background.line(cx - w10 * .5, cy - i * 10 * scale, cx + w10 * .5, cy - i * 10 * scale);
            background.line(cx - w5 * .5, cy - i * 10 * scale + 5 * scale * sign(i), cx + w5 * .5, cy - i * 10 * scale + 5 * scale * sign(i));
            background.line(cx - w25 * .5, cy - i * 10 * scale + 2.5 * scale * sign(i), cx + w25 * .5, cy - i * 10 * scale + 2.5 * scale * sign(i));
            background.line(cx - w25 * .5, cy - i * 10 * scale + 7.5 * scale * sign(i), cx + w25 * .5, cy - i * 10 * scale + 7.5 * scale * sign(i));

            background.textAlign(RIGHT, CENTER);
            background.text(abs(i) * 10, w * .5 - w10 * .5 - textSize * .5, cy - i * 10 * scale - textSize * .1);
            background.textAlign(LEFT, CENTER);
            background.text(abs(i) * 10, w * .5 + w10 * .5 + textSize * .5, cy - i * 10 * scale - textSize * .1);
        }

        background.endDraw();
    }

    void drawReference() {
        float thickness = 10;
        float wingLength = 80;
        float wingDepth = 30;
        float wingDist = 50;

        float cx = width * .5;
        float cy = height * .5;

        noStroke();
        fill(colReference);

        rect(cx - thickness * .5, cy - thickness * .5, thickness, thickness);
        rect(cx - wingDist - wingLength, cy - thickness * .5, wingLength, thickness);
        rect(cx + wingDist, cy - thickness * .5, wingLength, thickness);
        rect(cx - wingDist - thickness, cy - thickness * .5, thickness, wingDepth);
        rect(cx + wingDist, cy - thickness * .5, thickness, wingDepth);
    }

}