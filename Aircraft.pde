class Aircraft {

    JSONObject jsonAC;   // Aircraft of JSON file as JSON Object
    FlightDisplay pfd;   // Primary Flight Display
    
    // Aircraft principal axes
    float pitch, pitchVel, maxPitchVel;
    float roll, rollVel, maxRollVel;

    // Speeds
    float ias;   // Indicated Airspeed
    float vs0;   // stall speed in landing configuration    scala begins, white arc begins
    float vs;    // stall speed *vs1*                       green arc begins
    float vfe;   // maximum flaps extended speed            white arc ends
    float vno;   // normal operating speed limit            green arc ends, yellow arc begins
    float vne;   // never-exceed speed                      yellow arc ends, red line

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
    }

    void drawInstruments() {
        if(pfd != null) pfd.draw();
        
        //println(pitch, roll);
        println(ias);
    }

    void processMouseInput() {
        if(pfd != null) pfd.processMouseInput();
    }

    void createPFD(float x, float y, float w, float h, float scale) {
        pfd = new FlightDisplay(this, x, y, w, h);

        pfd.setADI(scale);
        pfd.addIndicator(new AirspeedIndicator(this, x + 50, y + 50, 100, h - 100, scale));
    }

    void mouseReleased() {
        pfd.mouseReleased();    
    }
}