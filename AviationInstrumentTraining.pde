// https://en.wikipedia.org/wiki/Primary_flight_display#/media/File:PFD.png
// https://en.wikipedia.org/wiki/List_of_aviation,_aerospace_and_aeronautical_abbreviations

Environment env;

void setup() {
    size(1600, 900, P2D);

    env = new Environment("data/configs/environment.json");
}

void draw() {
    background(255);

    env.run();
    env.draw();
}

void keyReleased() {
    env.keyReleased();
}

void keyPressed() {
    env.keyPressed();
}

void mousePressed() {
    env.mousePressed();
}

void mouseReleased() {
    env.mouseReleased();    
}

void mouseWheel(MouseEvent e) {
    env.mouseWheel(e);;
}

// util
float sign(float value) {
    if(value == 0) return 0;
    return round(value / abs(value));
}

float round(float value, int dig) {
    return round(value * pow(10, -dig)) * pow(10, dig);
}