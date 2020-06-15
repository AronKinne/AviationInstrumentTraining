// https://en.wikipedia.org/wiki/Primary_flight_display#/media/File:PFD.png
// https://en.wikipedia.org/wiki/List_of_aviation,_aerospace_and_aeronautical_abbreviations

Environment env;

Map map;

void setup() {
    size(1600, 900, P2D);

    env = new Environment("data/environment.json");

    map = new Map(10, 10, 70, 20);
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

void mouseReleased() {
    env.mouseReleased();    
}

void mouseWheel(MouseEvent e) {
    env.mouseWheel(e);;
}

float sign(float value) {
    if(value == 0) return 0;
    return round(value / abs(value));
}