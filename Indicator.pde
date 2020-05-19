abstract class Indicator {

    float x, y, w, h;

    PGraphics background, mask;

    Indicator(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    abstract void draw();

    abstract void generateBackground(float bgW, float bgH);

    abstract void updateMask();

}