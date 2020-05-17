Instrument attInd;

void setup() {
    size(500, 500);

    attInd = new Instrument(250, 250, "img/rim.png");
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