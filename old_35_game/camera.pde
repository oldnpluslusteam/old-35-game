
class Camera {
  Player player;
  
  Camera(Player player) {
    this.player = player;
  }
  
  void setup(float w, float h) {
    translate(w*0.5, h*0.5);
    rotate(-player.camA);
    translate(-player.camX, -player.camY);
  }
}