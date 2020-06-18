class Map {

    Environment env;
    Aircraft ac;

    float x, y, w, h;
    color bgColor;

    PVector center, mouse;
    float zoom;
    final float nmInPx = 0.1;   // 1 nm = <nmInPx> px at zoom = 0

    ArrayList<Station> stations;

    Map(Environment env, float x, float y, float w, float h) {
        this.env = env;
        ac = env.ac;

        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        bgColor = color(255, 255, 200);

        center = new PVector(0, 0);
        zoom = 0;

        stations = new ArrayList<Station>();
        stations.add(new NonDirectionalBeacon(this, -100, -100));
    }

    void draw() {
        stroke(0);
        strokeWeight(1);
        fill(bgColor);
        rect(x, y, w, h);

        if(mouse != null) {
            mouse.sub(new PVector(mouseX, mouseY));
            center.add(mouse);
            mouse = new PVector(mouseX, mouseY);
        }

        pushMatrix();
        translate(x + w * .5 - center.x, y + h * .5 - center.y);
        scale(pow(2, zoom));

        stroke(255, 0, 0);
        strokeWeight(3);
        if(w * .5 - center.x > 0 && w * .5 - center.x < w && h * .5 - center.y > 0 && h * .5 - center.y < h) point(0, 0);
        
        stroke(0);
        strokeWeight(5);

        for(int i = 0; i <= stations.size(); i++) {
            Station s;
            if(i == stations.size()) s = ac;
            else s = stations.get(i);

            if(w * .5 - center.x + s.pos.x * pow(2, zoom) > 0 && w * .5 - center.x + s.pos.x * pow(2, zoom) < w &&
               h * .5 - center.y + s.pos.y * pow(2, zoom) > 0 && h * .5 - center.y + s.pos.y * pow(2, zoom) < h) {

                pushMatrix();
                translate(s.pos.x, s.pos.y);
                s.renderOnMap();
                popMatrix();
            }
        }

        popMatrix();
    }

    void mousePressed() {
        if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
            mouse = new PVector(mouseX, mouseY);
        }
    }

    void mouseReleased() {
        mouse = null;    
    }

    void mouseWheel(MouseEvent e) {
        if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
            zoom -= e.getCount() * .1;
        }
    }
}