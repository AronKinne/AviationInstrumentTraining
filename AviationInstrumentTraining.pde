Aircraft ac;

void setup() {
    size(900, 700, P2D);

    ac = new Aircraft(200);
    ac.createPFD(50, 50, 900, 700, 10);
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