class Aircraft {

    FlightDisplay pfd;   // Primary Flight Display
    
    float ias;   // Indicated Airspeed

    Aircraft(float ias) {
        this.ias = ias;
    }

    void drawInstruments() {
        if(pfd != null) pfd.draw();
    }

    void processMouseInput() {
        if(pfd != null) pfd.processMouseInput();
    }

    void createPFD(float x, float y, float size, float scale) {
        pfd = new FlightDisplay(x, y, size);

        pfd.addIndicator(new AttitudeIndicator(x + size * .5, y + size * .5, size, scale));
    }

    void mouseReleased() {
        pfd.mouseReleased();    
    }
}