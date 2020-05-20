ArrayList<Integer> pressedKeys = new ArrayList<Integer>();

void keyHandler() {
    //println(pressedKeys);

    if(pressedKeys.contains(UP)) {
        ac.ias = min(ac.ias + 1, ac.vne);
    } else if(pressedKeys.contains(DOWN)) {
        ac.ias = max(ac.ias - 1, ac.vs0);
    }
}

void keyReleased() {
    if(pressedKeys.contains(keyCode)) pressedKeys.remove((Integer)keyCode);
}

void keyPressed() {
    if(!pressedKeys.contains(keyCode)) pressedKeys.add(keyCode);
}