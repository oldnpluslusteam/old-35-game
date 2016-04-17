
class Wall implements CollidableEntity, DrawableEntity {
  float x1, y1, x2, y2;
  
  float dx, dy, l2, l;
  
  Wall(int x1, int y1, int x2, int y2) {
    this.x1 = World.TUNNEL_WIDTH * (float)x1;
    this.y1 = World.TUNNEL_WIDTH * (float)y1;
    this.x2 = World.TUNNEL_WIDTH * (float)x2;
    this.y2 = World.TUNNEL_WIDTH * (float)y2;
    
    dx = this.x2 - this.x1; dy = this.y2 - this.y1;
    l2 = this.dx*this.dx + this.dy*this.dy;
    l = sqrt(l2);
  }
  
  @Override
  public void draw() {
    line(x1,y1,x2,y2);
  }
  
  void checkCollision(CollidableEntity other) {
    if (other instanceof PhysicalCircleEntity) {
     PhysicalCircleEntity pc = (PhysicalCircleEntity)other;
     float fx = x1 - pc.x;
     float fy = y1 - pc.y;

     float a = l2, b = 2. * (fx*dx + fy*dy), c = fx*fx + fy*fy - pc.r*pc.r;
     float desc = b*b - 4*a*c;
      
     if (desc < 0)
       return;
      
     desc = sqrt(desc);
     a = .5 / a;
     float t1 = (-b - desc) * a;
     float t2 = (-b + desc) * a;

     if ((t1 > 0. && t1 < 1.) ||
         (t2 > 0. && t2 < 1.)) {
       float cx = dy / l;
       float cy = -dx / l;

       float sg = Math.signum(fx*cx + fy*cy);

       other.onHit(this, 0,0, cx * sg, cy * sg);
     }
    }
  };
  
  void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy) {};
}

enum MonsterShape {
  // Shape of Wolf and Man
  SQUARE,
  CIRCLE,
  TRIANGLE,
  MORPHING;
  
  MonsterShape eats;
  float radius;
  float[][] playerShape;
  //PImage lightImage;
  PGraphics lightImage;
  
  static {
    SQUARE.eats = TRIANGLE;
    SQUARE.radius = 20;
    
    CIRCLE.eats = SQUARE;
    CIRCLE.radius = 20;
    
    TRIANGLE.eats = CIRCLE;
    TRIANGLE.radius = 15;
    
    MORPHING.eats = null;
    MORPHING.radius = 20;
    
    {
      CIRCLE.playerShape = new float[World.PLAYER_SHAPE_VERTICES][];
      for (int i = 0; i < World.PLAYER_SHAPE_VERTICES; ++i) {
        float a = PI*2.*((float)i)/((float)World.PLAYER_SHAPE_VERTICES);
        float r = SH_FN_Circle(a) * CIRCLE.radius;
        CIRCLE.playerShape[i] = new float[] {r*cos(a), r*sin(a)};
      }
    }
    { //<>//
      SQUARE.playerShape = new float[World.PLAYER_SHAPE_VERTICES][]; //<>// //<>//
      for (int i = 0; i < World.PLAYER_SHAPE_VERTICES; ++i) { //<>// //<>//
        float a = PI*2.*((float)i)/((float)World.PLAYER_SHAPE_VERTICES);
        float r = SH_FN_Square(a) * SQUARE.radius;
        SQUARE.playerShape[i] = new float[] {r*cos(a), r*sin(a)};
      }
    }
    {
      TRIANGLE.playerShape = new float[World.PLAYER_SHAPE_VERTICES][];
      for (int i = 0; i < World.PLAYER_SHAPE_VERTICES; ++i) {
        float a = PI*2.*((float)i)/((float)World.PLAYER_SHAPE_VERTICES);
        float r = SH_FN_Triangle(a) * TRIANGLE.radius;
        TRIANGLE.playerShape[i] = new float[] {r*cos(a), r*sin(a)};
      }
    }
  }
}

static float SH_FN_Circle(float a) {
  return 1;
}

static float SH_FN_Square(float a) {
  if (a < PI*.25 || a > PI*(2.-.25))
    return 1. / cos(a);
  if (a >= PI*.25 && a <= PI*(.5+.25))
   return 1. / cos(a - .5*PI);
  if (a >= PI*(.5+.25) && a <= PI*(1.+.25))
   return 1. / cos(a - PI);
  return 1. / cos(a - (1.+.5)*PI);
}

static float SH_FN_Triangle(float a) {
  a += .5*PI;
  if (a < PI*2./3. || a > 2.*PI)
  return 1. / cos(a - PI/3.);
  if (a > PI*(1.+1./3.) && a < 2.*PI)
  return 1. / cos(a - (1.+2./3.)*PI);
  return 1. / cos(a - 1.*PI);
}

Map<MonsterShape, Runnable> simpleShapeDrawers = new HashMap();

{
  simpleShapeDrawers.put(MonsterShape.CIRCLE, new Runnable() {
    public void run() {
      float r = MonsterShape.CIRCLE.radius; //<>//
      ellipse(0,0,2*r,2*r); //<>// //<>//
    } //<>// //<>//
  });
  simpleShapeDrawers.put(MonsterShape.SQUARE, new Runnable() {
    public void run() {
      float r = MonsterShape.SQUARE.radius;
      rect(-1*r,-1*r,2*r,2*r);
    }
  });
  simpleShapeDrawers.put(MonsterShape.TRIANGLE, new Runnable() {
    public void run() {
      float r = MonsterShape.TRIANGLE.radius;
      //triangle(1,0,-1,-1,1,1);
      beginShape();
      vertex(0,-1*r);
      vertex(1*r,1*r);
      vertex(-1*r,1*r);
      endShape(CLOSE);
    }
  });
}

abstract class PhysicalCircleEntity implements CollidableEntity {
  float x, y, r;
  
  public void checkCollision(CollidableEntity other) {
    if (!(other instanceof PhysicalCircleEntity)) {
      other.checkCollision(this);
      return;
    }

    PhysicalCircleEntity ce = (PhysicalCircleEntity)other;
    
    float d2 = (x-ce.x)*(x-ce.x) + (y-ce.y)*(y-ce.y);
    
    if (d2 > ((r+ce.r)*(r+ce.r)))
      return;

    float d = d2>0.01?1./sqrt(d2):0;
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
    blendMode(ADD);
    float r = this.r *3.;
    image(targetShape.lightImage, -(r)/2,-(r)/2, r, r);
    blendMode(BLEND);
    //pushStyle();
    //fill(255,128,128,100);
    //rect(-40,-40,80,80);
    //ellipse(0,0,80,80);
    //popStyle();
    popMatrix();
  }
  
  public void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy) {};
}

abstract class Monster extends PhysicalCircleEntity implements DrawableEntity, CollidableEntity, UpdatebleEntity {
  float a;
  MonsterShape shape;
  
  Monster(MonsterShape shape, float x, float y, float r, float a) {
    this.shape = shape;
    this.x = x;
    this.y = y;
    this.r = r;
    this.a = a;
  }
  
  public void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy) {
    if (other instanceof Light)
      this.onHitTheLight(((Light)other).targetShape);
    
    if (other instanceof Wall)
      this.onHitTheWall((Wall)other, normx, normy);
    
    if (other instanceof Monster) {
      Monster om = (Monster)other;
      if (this.shape.eats == om.shape) {
        om.onEaten(this);
      }
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
  abstract void onEaten(Monster by);
}