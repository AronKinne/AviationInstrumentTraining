Aircraft ac;

void setup() {
    size(500, 500, P2D);

    ac = new Aircraft(200);
    ac.createPFD(0, 0, 500, 10);
}

void draw() {
    background(255);

    ac.drawInstruments();
    ac.processMouseInput();
}

float sign(float value) {
    if(value == 0) return 0;
    return round(value / abs(value));
}

void mouseReleased() {
    ac.mouseReleased();    
}