// https://en.wikipedia.org/wiki/Airspeed_indicator#/media/File:ASI.png

class AirspeedIndicator extends Indicator {

    float ktInPx;   // 1 kt = <ktInPx> px

    float bgW, bgH;

    AirspeedIndicator(Aircraft ac, float x, float y, float w, float h, float ktInPx) {
        super(ac, x, y, w, h);

        this.ktInPx = ktInPx;

        bgW = w;
        bgH = + h;

        generateBackground(bgW, bgH);
    }

    void draw() {
        
    }

    void generateBackground(float w, float h) {
        background = createGraphics((int)w, (int)h);
    }

    void updateMask() {

    }

}