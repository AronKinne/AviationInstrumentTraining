class Instrument {

    float x, y, w, h;
    color colHeaven, colGround;
    PGraphics background;
    
    Instrument(float x, float y, String imgRimPath) {
        this.x = x;
        this.y = y;

        colHeaven = color(135, 206, 250);
        colGround = color(160, 82, 45);
        
        generateBackground(500, 1000);
    }

    void draw() {
        image(background, x, y);
    }

    private void generateBackground(int w, int h) {
        float scale = 10; // 1 deg = <scale> px
        int textSize = 20;

        int amt10 = 4;
        int w10 = 150;
        int w5 = 100;
        int w25 = 50;

        background = createGraphics(w, h);
        background.beginDraw();

        background.background(colHeaven);
        background.noStroke();
        background.fill(colGround);
        background.rect(0, h * .5, w, h * .5);

        background.stroke(255);
        background.strokeWeight(5);
        background.line(0, h * .5, w, h * .5);

        background.strokeWeight(3);
        background.fill(255);
        background.textSize(textSize);

        for(int i = -amt10; i <= amt10; i++) {
            if(i == 0) continue;

            background.line(w * .5 - w10 * .5, h * .5 - i * 10 * scale, w * .5 + w10 * .5, h * .5 - i * 10 * scale);
            background.line(w * .5 - w5 * .5, h * .5 - i * 10 * scale + 5 * scale * sign(i), w * .5 + w5 * .5, h * .5 - i * 10 * scale + 5 * scale * sign(i));
            background.line(w * .5 - w25 * .5, h * .5 - i * 10 * scale + 2.5 * scale * sign(i), w * .5 + w25 * .5, h * .5 - i * 10 * scale + 2.5 * scale * sign(i));
            background.line(w * .5 - w25 * .5, h * .5 - i * 10 * scale + 7.5 * scale * sign(i), w * .5 + w25 * .5, h * .5 - i * 10 * scale + 7.5 * scale * sign(i));

            background.textAlign(RIGHT, CENTER);
            background.text(abs(i) * 10, w * .5 - w10 * .5 - textSize * .5, h * .5 - i * 10 * scale - textSize * .1);
            background.textAlign(LEFT, CENTER);
            background.text(abs(i) * 10, w * .5 + w10 * .5 + textSize * .5, h * .5 - i * 10 * scale - textSize * .1);
        }

        background.endDraw();
    }

}