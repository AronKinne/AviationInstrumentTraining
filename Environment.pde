class Environment {

    Aircraft ac;
    Map map;

    final float apIasChange = 1;
    final float apAltChange = 10;
    final float apVsChange = 50;
    final float apHdgChange = 1;

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
                ac.ias = ac.constrainSpeed(ac.ias, 1);
            } else if(pressedKeys.contains(DOWN)) {
                ac.ias = ac.constrainSpeed(ac.ias, -1);
            }
        }

        // autopilot
        if(pressedKeys.contains(129))   // numpad 1
            ac.apIAS = ac.constrainSpeed(ac.apIAS, -apIasChange);
        if(pressedKeys.contains(135))   // numpad 7
            ac.apIAS = ac.constrainSpeed(ac.apIAS, apIasChange);
        if(pressedKeys.contains(130))   // numpad 2
            ac.apALT -= apAltChange;
        if(pressedKeys.contains(136))   // numpad 8
            ac.apALT += apAltChange;
        if(pressedKeys.contains(131))   // numpad 3
            ac.apVS -= apVsChange;
        if(pressedKeys.contains(137))   // numpad 9
            ac.apVS += apVsChange;
        if(pressedKeys.contains(132))   // numpad 4
            ac.apHDG -= apHdgChange;
        if(pressedKeys.contains(134))   // numpad 6
            ac.apHDG += apHdgChange;
    }

    void keyReleased() {
        if(pressedKeys.contains(keyCode)) pressedKeys.remove((Integer)keyCode);

        // autopilot
        if(keyCode == 133) {   // numpad 5
            ac.autopilot = !ac.autopilot;
            ac.apIAS = ac.ias;
            ac.apALT = ac.alt;
            ac.apVS = ac.vs;
            ac.apHDG = ac.hdg;
        }
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