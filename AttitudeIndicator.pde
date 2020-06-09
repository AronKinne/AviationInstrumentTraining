class AttitudeIndicator extends Indicator {

    boolean isFlat = true;

    // x, y is center of frame
    float pivotX, pivotY;   // center of 0 pitch and 0 roll
    color colSky, colGround, colReference;   // colors of sky, ground and reference marker

    float degInPx;   // 1 deg = <degInPx> px
    boolean mouseActive = false;

    private float scale;   // necessary because other values are optimized for degInPx = 10
    
    AttitudeIndicator(Aircraft ac, float x, float y, float w, float h, float pivotX, float pivotY, float degInPx) {
        super(ac, x, y, w, h);
        this.degInPx = degInPx;

        this.pivotX = pivotX;
        this.pivotY = pivotY;

        colSky = color(135, 206, 250);
        colGround = color(160, 82, 45);
        colReference = color(255, 255, 0);
        
        float dh = h + abs(pivotY - y) * 2;
        float dw = w + abs(pivotX - x) * 2;
        float diag = sqrt(dw * dw + dh * dh);
        bgW = diag + 10;
        bgH = (90 * degInPx + diag * .5 + 5) * 2;
        scale = degInPx / 10;
        
        mask = createGraphics((int)bgW, (int)bgH);

        generateBackground();
    }

    void draw() {
        pushMatrix();

        translate(pivotX, pivotY);
        rotate(radians(-ac.roll));
        translate(0, ac.pitch * degInPx);

        generateMask();
        background.mask(mask);
        image(background, -bgW * .5, -bgH * .5);
        
        popMatrix();

        drawReference();
        noFill();
        stroke(0);
        strokeWeight(1);
        rect(x - w * .5, y - h * .5, w, h);
    }

    void processMouseInput() {
        if(mouseActive) {
            ac.pitchVel = constrain(map(mouseY, pivotY - h * .5, pivotY + h * .5, -ac.maxPitchVel, ac.maxPitchVel) * cos(radians(ac.roll)), -ac.maxPitchVel, ac.maxPitchVel);
            ac.rollVel = constrain(map(mouseX, pivotX - w * .5, pivotX + w * .5, -ac.maxRollVel, ac.maxRollVel), -ac.maxRollVel, ac.maxRollVel);
        }

        ac.pitch += ac.pitchVel;
        ac.roll = (ac.roll + ac.rollVel) % 360;

        if(ac.pitch > 90 || ac.pitch < -90) {
            float diff = ac.pitch - (90 * sign(ac.pitch));
            ac.pitch = (90 * sign(ac.pitch)) - diff;
            ac.roll += 180;
        }
    }

    void mouseReleased() {
        if((mouseX < x + w * .5 && mouseX > x - w * .5 && mouseY > y - h * .5 && mouseY < y + h * .5) || mouseActive) {
            mouseActive = !mouseActive;
        }
    }

    void generateBackground() {
        float textSize = 20 * scale;
        float strokeWeight0 = 5 * scale;
        float strokeWeightLine = 3 * scale;
        int amt10 = 9;
        float w10 = 200 * scale;
        float w5 = 100 * scale;
        float w25 = 50 * scale;

        float cx = bgW * .5;
        float cy = bgH * .5;

        background = createGraphics((int)bgW, (int)bgH);
        background.beginDraw();

        background.background(colSky);
        background.noStroke();
        background.fill(colGround);
        if(isFlat) background.rect(0, cy, bgW, cy);

        background.stroke(255);
        background.strokeWeight(strokeWeight0);
        if(isFlat) background.line(0, cy, bgW, cy);

        if(!isFlat) background.ellipse(bgW * .5, bgH, bgH, bgH);

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
            background.text(abs(i) * 10, bgW * .5 - w10 * .5 - textSize * .5, cy - i * 10 * degInPx - textSize * .1);
            background.textAlign(LEFT, CENTER);
            background.text(abs(i) * 10, bgW * .5 + w10 * .5 + textSize * .5, cy - i * 10 * degInPx - textSize * .1);
        }

        background.endDraw();
    }

    void generateMask() {
        mask.beginDraw();
        mask.background(0);

        mask.noStroke();
        mask.fill(255);
        mask.pushMatrix();

        mask.translate(bgW * .5, -ac.pitch * degInPx + bgH * .5);
        mask.rotate(radians(ac.roll));
        mask.translate(-w * .5 + x - pivotX, -h * .5 + y - pivotY);

        mask.rect(0, 0, w, h);

        mask.popMatrix();
        mask.endDraw();
    }

    void drawReference() {
        float thickness = 10 * scale;
        float wingLength = 80 * scale;
        float wingDepth = 30 * scale;
        float wingDist = 50 * scale;

        noStroke();
        fill(colReference);

        rect(pivotX - thickness * .5, pivotY - thickness * .5, thickness, thickness);
        rect(pivotX - wingDist - wingLength, pivotY - thickness * .5, wingLength, thickness);
        rect(pivotX + wingDist, pivotY - thickness * .5, wingLength, thickness);
        rect(pivotX - wingDist - thickness, pivotY - thickness * .5, thickness, wingDepth);
        rect(pivotX + wingDist, pivotY - thickness * .5, thickness, wingDepth);
    }

}