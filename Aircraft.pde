class Aircraft {

    JSONObject jsonAC;   // Aircraft of JSON file as JSON Object
    FlightDisplay pfd;   // Primary Flight Display
    
    // Aircraft principal axes
    float pitch, pitchVel, maxPitchVel;
    float roll, rollVel, maxRollVel;

    // Speeds in kt
    float ias;   // indicated airspeed
    float vs0;   // stall speed in landing configuration    scala begins, white arc begins
    float vs1;   // stall speed                             green arc begins
    float vfe;   // maximum flaps extended speed            white arc ends
    float vno;   // normal operating speed limit            green arc ends, yellow arc begins
    float vne;   // never-exceed speed                      yellow arc ends, red line

    // Performance
    float alt;   // altitude in ft
    float vs;    // vertical speed in ft/min

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
            vs1 = jsonSpeeds.getFloat("vs1");
            vfe = jsonSpeeds.getFloat("vfe");
            vno = jsonSpeeds.getFloat("vno");
            vne = jsonSpeeds.getFloat("vne");
            ias = (vno + vfe) * .5;

            //println(maxPitchVel, maxRollVel, vs0, vs1, vfe, vno, vne);
        } catch (Exception e) {
            println("ERROR: JSON File from path: \"" + jsonPath + "\" loaded successfully, but it contains errors. App will terminate now!");
            exit();
        }

        alt = 1000;
    }

    void drawInstruments() {
        if(pfd != null) pfd.draw();

        vs = sin(radians(pitch)) * ias * 101.269;   // 1 kt = 101.269 ft/min
        alt += vs / (frameRate * frameRate);
        
        println(pitch, roll);
    }

    void processMouseInput() {
        if(pfd != null) pfd.processMouseInput();
    }

    void createPFD(float x, float y, float w, float h, float scale) {
        pfd = new FlightDisplay(this, x, y, w, h);

        pfd.setADI(scale);
        pfd.addIndicator(new AirspeedIndicator(this, x + 150, y + 50, 100, 400, scale * .6));
        pfd.addIndicator(new Altimeter(this, x + w - 300, y + 50, 110, 400, scale * .06));
        pfd.addIndicator(new VerticalSpeedIndicator(this, x + w - 190, y + 60, 30, 380, 80, scale * .004));
    }

    void mouseReleased() {
        pfd.mouseReleased();    
    }
}