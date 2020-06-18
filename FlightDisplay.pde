class FlightDisplay {

    Aircraft ac;
    ArrayList<Indicator> indicators;
    AttitudeIndicator adi;   // Attitude Director Indicator

    float x, y, w, h;   // x and y is top left corner
    color bgColor;   // color if anywhere is no indicator

    boolean mouseActive;

    FlightDisplay(Aircraft ac, float x, float y, float w, float h, color bgColor) {
        this.ac = ac;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.bgColor = bgColor;

        indicators = new ArrayList<Indicator>();
    }

    void draw() {
        noStroke();
        fill(bgColor);
        rect(x, y, w, h);

        for(Indicator i : indicators) i.draw();
        
        stroke(0);
        strokeWeight(1);
        noFill();
        rect(x, y, w, h);
    }

    void processMouseInput() {
        if(adi != null) adi.processMouseInput();
    }

    void setADI(float x, float y, float w, float h, float pivotX, float pivotY, float degInPx) {
        adi = new AttitudeIndicator(ac, x + w * .5, y + h * .5, w, h, pivotX, pivotY, degInPx);
        if(!addIndicator(adi)) println("ERROR: could not add ADI to indicators");
    }

    boolean addIndicator(Indicator i) {
        if(indicators.contains(i)) return false;
        indicators.add(i);
        return true;
    }

    void mousePressed() {
        if((mouseX < x + w && mouseX > x && mouseY > y && mouseY < y + h) || mouseActive) {
            mouseActive = !mouseActive;
        }
    }

}