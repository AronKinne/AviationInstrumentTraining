abstract class Indicator {

    Aircraft ac;
    float x, y, w, h;

    PGraphics background, mask;

    Indicator(Aircraft ac, float x, float y, float w, float h) {
        this.ac = ac;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    abstract void draw();

    abstract void generateBackground(float bgW, float bgH);

    abstract void updateMask();

}