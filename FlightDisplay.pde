class FlightDisplay {

    ArrayList<Indicator> indicators;
    AttitudeIndicator adi;   // Attitude Director Indicator

    float x, y, w, h;   // x and y is top left corner

    FlightDisplay(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        indicators = new ArrayList<Indicator>();
    }

    void draw() {
        for(Indicator i : indicators) i.draw();
    }

    void processMouseInput() {
        if(adi != null) adi.processMouseInput();
    }

    void setADI(float scale) {
        adi = new AttitudeIndicator(x + w * .5, y + h * .5, w, h, scale);
        if(!addIndicator(adi)) println("ERROR: could not add ADI to indicators");
    }

    boolean addIndicator(Indicator i) {
        if(indicators.contains(i)) return false;
        indicators.add(i);
        return true;
    }

    void mouseReleased() {
        if(adi != null) adi.mouseReleased();
    }

}