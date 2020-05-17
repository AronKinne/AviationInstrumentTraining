Instrument attInd;

void setup() {
    size(500, 1000);

    attInd = new Instrument(0, 0, "img/rim.png");
}

void draw() {
    background(255);

    attInd.draw();
}

float sign(float value) {
    if(value == 0) return 0;
    return round(value / abs(value));
}