
class Mob extends Monster {
  float vx, vy;
  
  Mob(MonsterShape shape, float x, float y, float a) {
    super(shape,x,y,shape.radius,a);
    
    float vm = random(50,100);
    vx = sin(a) * vm;
    vy = -cos(a) * vm;
  }
  
  public void update(float dt) {
    x += vx * dt;
    y += vy * dt;
  };

  void drawShape() {
    simpleShapeDrawers.get(this.shape).run();
  };
  
  void onHitTheLight(MonsterShape targetShape) {/*Do nothing*/};
  
  void onHitTheWall(Wall wall, float nx, float ny) {
    println("Hit the Wall!",nx,ny);
    
    float d = vx * nx + vy * ny;
    
    if (d <= 0)
      return;
    
    vx -= 2. * nx * d;
    vy -= 2. * ny * d;
  };
}

// However you are a Monster
class Player extends Monster {
  static final float CAM_POS_DELAY_K = 5.0;
  static final float CAM_ANGLE_DELAY_K = 2.0;
  
  static final float ANGULAR_VELOCITY_K = 1.0;
  static final float LINEAR_VELOCITY_K = 100.0;
  
  float camX, camY, camA;
  PlayerController controller;
  boolean inCollision = false;
  float collX, collY;
  
  Player(MonsterShape shape, float x, float y, float r, float a, PlayerController controller) {
    super(shape,x,y,r,a);
    camX = x; camY = y;
    camA = a;
    this.controller = controller;
  }

  void drawShape() {
    simpleShapeDrawers.get(this.shape).run();
  };
  
  void onHitTheLight(MonsterShape targetShape) {
    // TODO: Shift shape
  };
  
  void onHitTheWall(Wall wall, float nx, float ny) {
    println("Player hit the Wall!",nx,ny);
    if (!inCollision) {
    inCollision = true;
      collX = nx; collY = ny;
    } else {
      collX += nx; collY += ny;
    }
  };
  
  public void update(float dt) {
    float dx = sin(this.a)  * dt*LINEAR_VELOCITY_K*(float)controller.getDirectVelocity(),
          dy = -cos(this.a) * dt*LINEAR_VELOCITY_K*(float)controller.getDirectVelocity();
    
    if (inCollision) {
      float d = dx * collX + dy * collY;
      if (d > 0) {
        dx -= collX * d * 5.;
        dy -= collY * d * 5.;
      }
      inCollision = false;
    }
    
    this.x += dx;
    this.y += dy;
    this.a += dt*ANGULAR_VELOCITY_K*(float)controller.getAngularVelocity()*-1.;
    
    this.camX = this.x * CAM_POS_DELAY_K * dt + this.camX * (1.0 - CAM_POS_DELAY_K * dt);
    this.camY = this.y * CAM_POS_DELAY_K * dt + this.camY * (1.0 - CAM_POS_DELAY_K * dt);
    this.camA = this.a * CAM_ANGLE_DELAY_K * dt + this.camA * (1.0 - CAM_ANGLE_DELAY_K * dt);
  };
}