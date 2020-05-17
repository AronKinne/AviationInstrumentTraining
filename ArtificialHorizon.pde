Instrument attInd;

void setup() {
    size(1600, 900);

    attInd = new Instrument(1450, 750, 300, 5);
}

void draw() {
    background(255);

    attInd.draw();
    attInd.processMouseInput();
}

float sign(float value) {
    if(value == 0) return 0;
    return round(value / abs(value));
}

void mouseReleased() {
    attInd.mouseReleased();    
}