class AttitudeIndicator extends Indicator {

    float size; // x, y is center; size is width and height
    color colSky, colGround, colReference; // colors of sky, ground and reference marker
    PGraphics background; // background graphics with sky, ground and scala; generated once in generateBackground

    float degInPx; // 1 deg = <scale> px
    float pitch, pitchVel;
    float roll, rollVel;
    final float maxPitchVel = 1;
    final float maxRollVel = 3;
    boolean mouseActive = false;

    private float bgW, bgH; // width and height for background graphics
    private float scale; // necessary because other values are optimized for size = 500
    
    AttitudeIndicator(float x, float y, float size, float degInPx) {
        this.x = x;
        this.y = y;
        this.size = size;
        this.w = size;
        this.h = size;
        this.degInPx = degInPx;

        colSky = color(135, 206, 250);
        colGround = color(160, 82, 45);
        colReference = color(255, 255, 0);
        
        bgW = size * 1.5;
        bgH = (90 * degInPx + size * .75) * 2;
        scale = size / 500;
        
        generateBackground(bgW, bgH);
    }

    void draw() {
        pushMatrix();

        translate(x, y);
        rotate(radians(-roll));
        translate(0, pitch * degInPx);
        image(background, -bgW * .5, -bgH * .5);
        
        popMatrix();

        drawReference();
        noFill();
        stroke(0);
        strokeWeight(1);
        rect(x - size * .5, y - size * .5, size, size);

        println(pitch, roll);
    }

    void processMouseInput() {
        if(mouseActive) {
            pitchVel = constrain(map(mouseY, y - size * .5, y + size * .5, -maxPitchVel, maxPitchVel) * cos(radians(roll)), -maxPitchVel, maxPitchVel);
            rollVel = constrain(map(mouseX, x - size * .5, x + size * .5, -maxRollVel, maxRollVel), -maxRollVel, maxRollVel);
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
        if((mouseX < x + size * .5 && mouseX > x - size * .5 && mouseY > y - size * .5 && mouseY < y + size * .5) || mouseActive) {
            mouseActive = !mouseActive;
        }
    }

    private void generateBackground(float w, float h) {
        float textSize = 20 * scale;
        float strokeWeight0 = 5 * scale;
        float strokeWeightLine = 3 * scale;
        int amt10 = 9;
        float w10 = 200 * scale;
        float w5 = 100 * scale;
        float w25 = 50 * scale;

        float cx = w * .5;
        float cy = h * .5;

        background = createGraphics((int)w, (int)h);
        background.beginDraw();

        background.background(colSky);
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

            background.line(cx - w10 * .5, cy - i * 10 * degInPx, cx + w10 * .5, cy - i * 10 * degInPx);
            background.line(cx - w5 * .5, cy - i * 10 * degInPx + 5 * degInPx * sign(i), cx + w5 * .5, cy - i * 10 * degInPx + 5 * degInPx * sign(i));
            background.line(cx - w25 * .5, cy - i * 10 * degInPx + 2.5 * degInPx * sign(i), cx + w25 * .5, cy - i * 10 * degInPx + 2.5 * degInPx * sign(i));
            background.line(cx - w25 * .5, cy - i * 10 * degInPx + 7.5 * degInPx * sign(i), cx + w25 * .5, cy - i * 10 * degInPx + 7.5 * degInPx * sign(i));

            background.textAlign(RIGHT, CENTER);
            background.text(abs(i) * 10, w * .5 - w10 * .5 - textSize * .5, cy - i * 10 * degInPx - textSize * .1);
            background.textAlign(LEFT, CENTER);
            background.text(abs(i) * 10, w * .5 + w10 * .5 + textSize * .5, cy - i * 10 * degInPx - textSize * .1);
        }

        background.endDraw();
    }

    void drawReference() {
        float thickness = 10 * scale;
        float wingLength = 80 * scale;
        float wingDepth = 30 * scale;
        float wingDist = 50 * scale;

        noStroke();
        fill(colReference);

        rect(x - thickness * .5, y - thickness * .5, thickness, thickness);
        rect(x - wingDist - wingLength, y - thickness * .5, wingLength, thickness);
        rect(x + wingDist, y - thickness * .5, wingLength, thickness);
        rect(x - wingDist - thickness, y - thickness * .5, thickness, wingDepth);
        rect(x + wingDist, y - thickness * .5, thickness, wingDepth);
    }

}