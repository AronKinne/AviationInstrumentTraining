class Map {

    float x, y, w, h;
    color bgColor;

    Map(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        bgColor = color(255, 255, 200);
    }

    void draw() {
        stroke(0);
        strokeWeight(1);
        fill(bgColor);
        rect(x, y, w, h);
    }

}