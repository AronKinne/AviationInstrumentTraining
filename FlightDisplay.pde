class FlightDisplay {

    Aircraft ac;
    ArrayList<Indicator> indicators;
    AttitudeIndicator adi;   // Attitude Director Indicator

    float x, y, w, h;   // x and y is top left corner

    FlightDisplay(Aircraft ac, float x, float y, float w, float h) {
        this.ac = ac;
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

    void setADI(float offX, float offY, float scale) {
        adi = new AttitudeIndicator(ac, x + w * .5, y + h * .5, w, h, offX, offY, scale);
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