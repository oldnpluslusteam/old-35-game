
class Camera {
  Player player;
  float sa = 0;
  
  Camera(Player player) {
    this.player = player;
  }
  
  void setup(float w, float h) {
    translate(w*0.5, h*0.5);
    rotate(-player.camA);
    {
      float peak = getAudioPeak()*.3;
      scale(2.+peak*(1.+cos(sa)), 2.+peak*(1.+sin(sa)));
      sa += peak*1.5;
    }
    translate(-player.camX, -player.camY);
  }
}