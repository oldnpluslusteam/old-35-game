
class Mob extends Monster {
  void drawShape() {
    // TODO: Draw shape
  };
  
  void onHitTheLight(MonsterShape targetShape) {/*Do nothing*/};
  
  void onHitTheWall(Wall wall, float nx, float ny) {
    // TODO: Ricochet!
  };
}

// However you are a Monster
class Player extends Monster {
  void drawShape() {
    // TODO: Draw shape
  };
  
  void onHitTheLight(MonsterShape targetShape) {
    // TODO: Shift shape
  };
  
  void onHitTheWall(Wall wall, float nx, float ny) {
    // TODO: Slow down
  };
}