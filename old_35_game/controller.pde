
List<PlayerController> controllers = new ArrayList();

class PlayerController {
  int fwKey, bkKey, lfKey, rtKey;
  Map<Integer, Boolean> keyStatus = new HashMap();
  
  PlayerController(int fwKey, int bkKey, int lfKey, int rtKey) {
    controllers.add(this);
    
    this.fwKey = fwKey; this.bkKey = bkKey;
    this.lfKey = lfKey; this.rtKey = rtKey;
    
    keyStatus.put(fwKey,false);
    keyStatus.put(bkKey,false);
    keyStatus.put(rtKey,false);
    keyStatus.put(lfKey,false);
  }
  
  int getDirectVelocity() {
    return (keyStatus.get(fwKey)?1:0) +
           (keyStatus.get(bkKey)?-1:0);
  }
  
  int getAngularVelocity() {
    return (keyStatus.get(lfKey)?1:0) +
           (keyStatus.get(rtKey)?-1:0);
  }
}

void keyPressed() {
  int code = keyCode;
  
  for (PlayerController pc : controllers)
    if (pc.keyStatus.get(code) != null)
      pc.keyStatus.put(code,true);
}

void keyReleased() {
  int code = keyCode;
  
  for (PlayerController pc : controllers)
    if (pc.keyStatus.get(code) != null)
      pc.keyStatus.put(code,false);
}