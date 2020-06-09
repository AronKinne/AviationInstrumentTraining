// https://en.wikipedia.org/wiki/Primary_flight_display#/media/File:PFD.png
// https://www.aopa.org/-/media/Images/AOPA-Main/News-and-Media/2017/January/0103_kingair_g1000_nxi_03.jpg
// https://en.wikipedia.org/wiki/List_of_aviation,_aerospace_and_aeronautical_abbreviations

Aircraft ac;

void setup() {
    size(1200, 800, P2D);

    ac = new Aircraft("data/aircraft/a320.json");
    ac.createPFD(200, 50, "data/pfdlayout/g1000.json");
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