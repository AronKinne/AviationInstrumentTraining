abstract class Station {

    Map map;

    PVector pos;

    Station(Map map, float x, float y) {
        setMap(map);

        pos = new PVector(x, y);
    }

    Station(Map map) {
        this(map, 0, 0);
    }

    Station() {
        this(null, 0, 0);
    }

    void setMap(Map map) {
        this.map = map;
    }

    void renderOnMap() {
        stroke(0);
        strokeWeight(8);
        point(0, 0);
    }
}