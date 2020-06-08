class Aircraft {

    JSONObject jsonAC;   // Aircraft of JSON file as JSON Object
    FlightDisplay pfd;   // Primary Flight Display
    
    // Aircraft principal axes
    float pitch, pitchVel, maxPitchVel;
    float roll, rollVel, maxRollVel;

    // Speeds in kt
    float ias;   // indicated airspeed
    float vs0;   // stall speed in landing configuration    scala begins, white arc begins
    float vs;    // stall speed *vs1*                       green arc begins
    float vfe;   // maximum flaps extended speed            white arc ends
    float vno;   // normal operating speed limit            green arc ends, yellow arc begins
    float vne;   // never-exceed speed                      yellow arc ends, red line

    // Performance
    float alt;   // altitude in ft

    Aircraft(String jsonPath) {
        try {
            jsonAC = loadJSONObject(jsonPath);
        } catch (Exception e) {
            println("ERROR: Could not load JSON File from path: \"" + jsonPath + "\". App will terminate now!");
            exit();
        }

        try {
            JSONObject jsonAxes = jsonAC.getJSONObject("axes");
            maxPitchVel = jsonAxes.getFloat("maxPitchVel");
            maxRollVel = jsonAxes.getFloat("maxRollVel");

            JSONObject jsonSpeeds = jsonAC.getJSONObject("speeds");
            vs0 = jsonSpeeds.getFloat("vs0");
            vs = jsonSpeeds.getFloat("vs");
            vfe = jsonSpeeds.getFloat("vfe");
            vno = jsonSpeeds.getFloat("vno");
            vne = jsonSpeeds.getFloat("vne");
            ias = (vno + vfe) * .5;

            //println(maxPitchVel, maxRollVel, vs0, vs, vfe, vno, vne);
        } catch (Exception e) {
            println("ERROR: JSON File from path: \"" + jsonPath + "\" loaded successfully, but it contains errors. App will terminate now!");
            exit();
        }

        alt = 9000;
    }

    void drawInstruments() {
        if(pfd != null) pfd.draw();
        
        //println(pitch, roll);
    }

    void processMouseInput() {
        if(pfd != null) pfd.processMouseInput();
    }

    /* old
    void createPFD(float x, float y, float w, float h, float scale) {
        pfd = new FlightDisplay(this, x, y, w, h);

        pfd.setADI(0, -100, scale);
        pfd.addIndicator(new AirspeedIndicator(this, x + 50, y + 50, 100, h - 100, scale * .6));
        pfd.addIndicator(new Altimeter(this, x + w - 150, y + 50, 110, h - 100, scale * .06));
    }
    */

    void createPFD(float x, float y, String jsonPath) {
        JSONObject jsonFile = null;

        try {
            jsonFile = loadJSONObject(jsonPath);
        } catch (Exception e) {
            println("ERROR: Could not load JSON File from path: \"" + jsonPath + "\". App will terminate now!");
            exit();
        }

        try {
            JSONObject jsonLayout = jsonFile.getJSONObject("layout");
            pfd = new FlightDisplay(this, x, y, jsonLayout.getFloat("width"), jsonLayout.getFloat("height"));

            JSONObject jsonADI = jsonLayout.getJSONObject("adi");
            pfd.setADI(x + jsonADI.getFloat("pivotX"), y + jsonADI.getFloat("pivotY"), jsonADI.getFloat("degInPx"));

            JSONObject jsonASI = jsonLayout.getJSONObject("asi");
            pfd.addIndicator(new AirspeedIndicator(this, x + jsonASI.getFloat("x"), y + jsonASI.getFloat("y"),
                jsonASI.getFloat("width"), jsonASI.getFloat("height"), jsonASI.getFloat("pointerY"), jsonASI.getFloat("ktInPx")));

            JSONObject jsonALTM = jsonLayout.getJSONObject("altm");
            pfd.addIndicator(new Altimeter(this, x + jsonALTM.getFloat("x"), y + jsonALTM.getFloat("y"),
                jsonALTM.getFloat("width"), jsonALTM.getFloat("height"), jsonALTM.getFloat("pointerY"), jsonALTM.getFloat("ftInPx")));

        } catch (Exception e) {
            println("ERROR: JSON File from path: \"" + jsonPath + "\" loaded successfully, but it contains errors. See \"template.json\" for correct syntax. App will terminate now!");
            exit();
        }
    }

    void mouseReleased() {
        pfd.mouseReleased();    
    }
}