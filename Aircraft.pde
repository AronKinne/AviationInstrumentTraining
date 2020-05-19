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

    void createPFD(float x, float y, float w, float h, float scale) {
        pfd = new FlightDisplay(x, y, w, h);

        pfd.setADI(scale);
    }

    void mouseReleased() {
        pfd.mouseReleased();    
    }
}