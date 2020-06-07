ArrayList<Integer> pressedKeys = new ArrayList<Integer>();

void keyHandler() {
    //println(pressedKeys);

    // speed
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

void mouseReleased() {
    ac.mouseReleased();    
}

void mouseWheel(MouseEvent e) {
    ac.ias = constrain(ac.ias - 3 * e.getCount(), ac.vs0, ac.vne);
}