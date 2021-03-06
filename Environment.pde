class Environment {

    Aircraft ac;
    Map map;

    ArrayList<Integer> pressedKeys;

    Environment(String jsonPath) {
        JSONObject jsonEnv = null;

        try {
            jsonEnv = loadJSONObject(jsonPath);
        } catch (Exception e) {
            println("ERROR: Could not load environment file from path: \"" + jsonPath + "\". App will terminate now!");
            exit();
        }

        try {
            // aircraft
            JSONObject jsonAC = jsonEnv.getJSONObject("aircraft");
            ac = new Aircraft(jsonAC.getString("path"));

            JSONObject jsonPFD = jsonAC.getJSONObject("pfd");
            ac.createPFD(jsonPFD.getFloat("x"), jsonPFD.getFloat("y"),
                jsonPFD.get("w") == null ? 0 : jsonPFD.getFloat("w"),
                jsonPFD.get("h") == null ? 0 : jsonPFD.getFloat("h"));

            // map
            JSONObject jsonMap = jsonEnv.getJSONObject("map");

            JSONObject jsonMapBounds = jsonMap.getJSONObject("bounds");
            map = new Map(this, jsonMapBounds.getFloat("x"), jsonMapBounds.getFloat("y"), jsonMapBounds.getFloat("w"), jsonMapBounds.getFloat("h"));
            ac.setMap(map);

        } catch (Exception e) {
            println("ERROR: Environment file from path: \"" + jsonPath + "\" loaded successfully, but it contains errors. See readme for correct syntax. App will terminate now!");
            exit();
        }

        pressedKeys = new ArrayList<Integer>();
    }

    void draw() {
        ac.drawInstruments();

        map.draw();
    }

    void run() {
        keyHandler();

        ac.processMouseInput(); 
    }

    void keyHandler() {
        //println(pressedKeys);

        // speed
        if(ac.pfd != null && ac.pfd.mouseActive) {
            if(pressedKeys.contains(UP)) {
                ac.changeIas(1);
            } else if(pressedKeys.contains(DOWN)) {
                ac.changeIas(-1);
            }
        }
    }

    void keyReleased() {
        if(pressedKeys.contains(keyCode)) pressedKeys.remove((Integer)keyCode);
    }

    void keyPressed() {
        if(!pressedKeys.contains(keyCode)) pressedKeys.add(keyCode);
    }

    void mousePressed() {
        map.mousePressed();
        ac.mousePressed(); 
    }

    void mouseReleased() {
        map.mouseReleased();   
    }

    void mouseWheel(MouseEvent e) {
        ac.mouseWheel(e);
        map.mouseWheel(e);
    }

}