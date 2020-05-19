class FlightDisplay {

    ArrayList<Indicator> indicators;

    float x, y, size;   /// x and y is top left corner

    FlightDisplay(float x, float y, float size) {
        indicators = new ArrayList<Indicator>();

        this.x = x;
        this.y = y;
        this.size = size;
    }

    void draw() {
        for(Indicator i : indicators) i.draw();
    }

    void processMouseInput() {
        for(Indicator i : indicators) i.processMouseInput();
    }

    boolean addIndicator(Indicator i) {
        if(indicators.contains(i)) return false;
        indicators.add(i);
        return true;
    }

    void mouseReleased() {
        for(Indicator i : indicators) i.mouseReleased();
    }

}