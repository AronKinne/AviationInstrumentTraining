class Aircraft {

    String layoutPath;   // Path of json file for pfd layout
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
        JSONObject jsonAC = null;

        try {
            jsonAC = loadJSONObject(jsonPath);
        } catch (Exception e) {
            println("ERROR: Could not load JSON File from path: \"" + jsonPath + "\". App will terminate now!");
            exit();
        }

        try {
            layoutPath = jsonAC.getString("pfdlayout");

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
        
        //println(pitch, roll);
    }

    void processMouseInput() {
        if(pfd != null) pfd.processMouseInput();
    }

    void createPFD(float x, float y) {
        createPFD(x, y, 0, 0);
    }

    void createPFD(float x, float y, float w, float h) {
        JSONObject jsonFile = null;

        try {
            jsonFile = loadJSONObject(layoutPath);
        } catch (Exception e) {
            println("ERROR: Could not load JSON File from path: \"" + layoutPath + "\". App will terminate now!");
            exit();
        }

        try {
            JSONObject jsonLayout = jsonFile.getJSONObject("layout");

            float sX = w / jsonLayout.getFloat("width");
            float sY = h / jsonLayout.getFloat("height");

            if(w <= 0 && h <= 0) {
                sX = 1;
                sY = 1;
            } else if(w <= 0 && h > 0) {
                sX = sY;
            } else if(w > 0 && h <= 0) {
                sY = sX;
            }

            pfd = new FlightDisplay(this, x, y, jsonLayout.getFloat("width") * sX, jsonLayout.getFloat("height") * sY);

            JSONObject jsonADI = jsonLayout.getJSONObject("adi");
            pfd.setADI(x + jsonADI.getFloat("pivotX") * sX, y + jsonADI.getFloat("pivotY") * sY, jsonADI.getFloat("degInPx") * sY);

            JSONObject jsonASI = jsonLayout.getJSONObject("asi");
            pfd.addIndicator(new AirspeedIndicator(this, x + jsonASI.getFloat("x") * sX, y + jsonASI.getFloat("y") * sY,
                jsonASI.getFloat("width") * sX, jsonASI.getFloat("height") * sY, jsonASI.getFloat("pointerY") * sY, jsonASI.getFloat("ktInPx") * sY));

            JSONObject jsonALTM = jsonLayout.getJSONObject("altm");
            pfd.addIndicator(new Altimeter(this, x + jsonALTM.getFloat("x") * sX, y + jsonALTM.getFloat("y") * sY,
                jsonALTM.getFloat("width") * sX, jsonALTM.getFloat("height") * sY, jsonALTM.getFloat("pointerY") * sY, jsonALTM.getFloat("ftInPx") * sY));

            JSONObject jsonVSI = jsonLayout.getJSONObject("vsi");
            pfd.addIndicator(new VerticalSpeedIndicator(this, x + jsonVSI.getFloat("x") * sX, y + jsonVSI.getFloat("y") * sY,
                jsonVSI.getFloat("width") * sX, jsonVSI.getFloat("height") * sY, jsonVSI.getFloat("pointerW") * sX, jsonVSI.getFloat("fpmInPx") * sY));

        } catch (Exception e) {
            println("ERROR: JSON File from path: \"" + layoutPath + "\" loaded successfully, but it contains errors. See \"template.json\" for correct syntax. App will terminate now!");
            exit();
        }
    }

    void mouseReleased() {
        pfd.mouseReleased();    
    }
}