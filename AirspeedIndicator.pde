class AirspeedIndicator extends Indicator {

    float ktInPx;   // 1 kt = <scale> px

    AirspeedIndicator(float x, float y, float w, float h, float ktInPx) {
        super(x, y, w, h);

        this.ktInPx = ktInPx;

        generateBackground(w, h);
    }

    void draw() {
        
    }

    void generateBackground(float w, float h) {

    }

    void updateMask() {

    }

}