
class Wall implements CollidableEntity, DrawableEntity {
  float x1, y1, x2, y2;
  
  Wall(int x1, int y1, int x2, int y2) {
    this.x1 = World.TUNNEL_WIDTH * (float)x1;
    this.y1 = World.TUNNEL_WIDTH * (float)y1;
    this.x2 = World.TUNNEL_WIDTH * (float)x2;
    this.y2 = World.TUNNEL_WIDTH * (float)y2;
  }
  
  @Override
  public void draw() {
    line(x1,y1,x2,y2);
  }
  
  void checkCollision(CollidableEntity other) {
  };
  
  void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy) {};
}

enum MonsterShape {
  // Shape of Wolf and Man
  SQUARE,
  CIRCLE,
  TRIANGLE,
  MORPHING;
}

abstract class PhysicalCircleEntity implements CollidableEntity {
  float x, y, r;
  
  public void checkCollision(CollidableEntity other) {
    if (!(other instanceof PhysicalCircleEntity))
      return;

    PhysicalCircleEntity ce = (PhysicalCircleEntity)other;
    
    float d2 = (x-ce.x)*(x-ce.x) + (y-ce.y)*(y-ce.y);
    
    if (d2 > ((r+ce.r)*(r+ce.r)))
      return;
    
    float d = sqrt(d2);
    float nx = (ce.x-x)*d, ny = (ce.y-y)*d;
    float px = x+r*nx, py = y+r*ny;
    
    this.onHit(other, px, py, nx, ny);
    other.onHit(this, px, py, -nx, -ny);
  };
}

class Light extends PhysicalCircleEntity implements DrawableEntity {
  MonsterShape targetShape;
  
  Light(MonsterShape targetShape, float x, float y, float r) {
    this.targetShape = targetShape;
    this.x = x; this.y = y; this.r = r;
  }
  
  public void draw() {
    pushMatrix();
    translate(x,y);
    // TODO: Draw an imgae or m.b. just use blit with no matrix.
    popMatrix();
  }
  
  public void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy) {};
}

abstract class Monster extends PhysicalCircleEntity implements DrawableEntity, CollidableEntity, UpdatebleEntity {
  float a;
  
  public void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy) {
    if (other instanceof Light)
      this.onHitTheLight(((Light)other).targetShape);
    
    if (other instanceof Wall)
      this.onHitTheWall((Wall)other, normx, normy);
    
    if (other instanceof Monster) {
      // TODO: Eat it
    }
  };
  
  public void update(float dt) {
    // TODO
  };
  
  void draw() {
    pushMatrix();
    translate(x,y);
    rotate(a);
    drawShape();
    popMatrix();
  };
  
  abstract void drawShape();
  abstract void onHitTheLight(MonsterShape targetShape);
  abstract void onHitTheWall(Wall wall, float nx, float ny);
}