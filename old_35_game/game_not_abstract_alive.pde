
class Mob extends Monster {
  float vx, vy, ca = 0.;
  
  Mob(MonsterShape shape, float x, float y, float a) {
    super(shape,x,y,shape.radius,a);
    
    float vm = random(50,100);
    vx = sin(a) * vm;
    vy = -cos(a) * vm;
  }
  
  public void update(float dt) {
    x += vx * dt;
    y += vy * dt;
    ca += dt * (1.+getAudioPeak()) * 10.;
  };

  void drawShape() {
    pushStyle();
    if (this.shape.eats == player.shape) {
      float cca = .5+.5*cos(ca*2.);
      float sca = .5+.5*sin(ca*2.);
      stroke(128+128.*cca,0,0);
      fill(128+128.*sca,64,64);
    }
    if (this.shape == player.shape.eats) {
      float cca = .5+.5*cos(ca);
      float sca = .5+.5*sin(ca);
      stroke(0,128+128.*cca,0);
      fill(128,128+128.*sca,128);
    }
    simpleShapeDrawers.get(this.shape).run();
    popStyle();
  };
  
  void onHitTheLight(MonsterShape targetShape) {/*Do nothing*/};
  
  void onHitTheWall(Wall wall, float nx, float ny) {
    //println("Hit the Wall!",nx,ny);
    
    float d = vx * nx + vy * ny;
    
    if (d <= 0)
      return;
    
    vx -= 2. * nx * d;
    vy -= 2. * ny * d;
  };
  
  void onEaten(Monster other) {
    world.kill(this);
  }
}

class DeathException extends RuntimeException {
  Player player;
  
  DeathException(Player player) {
    this.player = player;
  }
};

class WinException extends RuntimeException {
  Player player;
  
  WinException(Player player) {
    this.player = player;
  }
};

// However you are a Monster
class Player extends Monster {
  static final float CAM_POS_DELAY_K = 5.0;
  static final float CAM_ANGLE_DELAY_K = 2.0;
  
  static final float ANGULAR_VELOCITY_K = 2.0;
  static final float LINEAR_VELOCITY_K = 300.0;
  
  static final float MORPH_SPEED = 1.0;
  
  static final float NOIZE_WEIGHT = 20.0;
  
  float camX, camY, camA;
  PlayerController controller;
  boolean inCollision = false;
  float collX, collY;
  MonsterShape targetShape, prevShape;
  float morph;
  float[] noizze = new float[World.PLAYER_SHAPE_VERTICES];
  
  Player(MonsterShape shape, float x, float y, float r, float a, PlayerController controller) {
    super(shape,x,y,r,a);
    camX = x; camY = y;
    camA = a;
    this.controller = controller;
  }

  void drawShape() {
    beginShape();
    getAudioNoise(noizze);
    if (this.shape == MonsterShape.MORPHING) {
      for (int i = 0; i < World.PLAYER_SHAPE_VERTICES; ++i) {
        float[] vt = this.targetShape.playerShape[i];
        float[] vp = this.prevShape.playerShape[i];
        float a = PI*2.*((float)i)/((float)World.PLAYER_SHAPE_VERTICES);
        vertex(vt[0] * morph + vp[0] * (1.-morph) + noizze[i] * NOIZE_WEIGHT * cos(a), vt[1] * morph + vp[1] * (1.-morph) + noizze[i] * NOIZE_WEIGHT * sin(a));
      }
    } else {
      for (int i = 0; i < World.PLAYER_SHAPE_VERTICES; ++i) {
        float[] v = this.shape.playerShape[i];
        float a = PI*2.*((float)i)/((float)World.PLAYER_SHAPE_VERTICES);
        vertex(v[0] + noizze[i] * NOIZE_WEIGHT * cos(a), v[1] + noizze[i] * NOIZE_WEIGHT * sin(a));
      }
    }
    endShape(CLOSE);
  };
  
  void onHitTheLight(MonsterShape targetShape) {
    println("Hit the light!", targetShape.toString());
    if (targetShape == this.targetShape || this.shape == MonsterShape.MORPHING)
      return;

    this.prevShape = this.shape;
    this.targetShape = targetShape;
    this.shape = MonsterShape.MORPHING;
    this.morph = 0.0;
    this.r = this.shape.radius;
  };
  
  void onHitTheWall(Wall wall, float nx, float ny) {
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
    
    this.morph += MORPH_SPEED * dt;
    
    if (this.morph >= 1.0 && this.shape == MonsterShape.MORPHING) {
      this.shape = this.targetShape;
      this.r = this.shape.radius;
    }
  };
  
  void onEaten(Monster other) {
    //throw new DeathException(this);
    end = true;
    exitShape = shape;
    winState = false;
  }
}

class WinMob extends PhysicalCircleEntity {
  public WinMob(float x, float y) {
    this.x = x;
    this.y = y;
    this.r = World.TUNNEL_WIDTH;
  }
  
  @Override
  public void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy) {
    if (other instanceof Player) {
      //throw new WinException((Player) other);
      end = true;
      exitShape = ((Player) other).shape;
      winState = true;
    }
  };
}