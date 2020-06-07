// https://en.wikipedia.org/wiki/Primary_flight_display#/media/File:PFD.png
// https://en.wikipedia.org/wiki/List_of_aviation,_aerospace_and_aeronautical_abbreviations

Aircraft ac;

void setup() {
    size(1600, 900, P2D);

    ac = new Aircraft("data/a320.json");
    ac.createPFD(200, 100, 1200, 700, 10);
}

void draw() {
    background(255);
    keyHandler();

    ac.drawInstruments();
    ac.processMouseInput();
}

float sign(float value) {
    if(value == 0) return 0;
    return round(value / abs(value));
}