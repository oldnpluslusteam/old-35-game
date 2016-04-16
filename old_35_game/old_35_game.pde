
World world;
Player player;
Camera camera;

void setup() {
  fullScreen();
  
  world = new World();
  player = new Player(MonsterShape.CIRCLE,0,0,20,0, new PlayerController(UP, DOWN, LEFT, RIGHT));
  world.add(player);
  camera = new Camera(player);
  
  // Just another wall in the world
  world.add(new Wall(1,1,1,-1));
  world.add(new Wall(-1,1,-1,-1));
  world.add(new Wall(-1,1,1,1));
  
  world.add(new Mob(MonsterShape.CIRCLE, 100, 100, 0));
  world.add(new Mob(MonsterShape.TRIANGLE, -100, -100, 0));
  world.add(new Mob(MonsterShape.CIRCLE, 100, 100, 0));
}

void draw() {
  world.updateUpdateables();

  clear();
  stroke(255);
  fill(189);
  pushMatrix();
  camera.setup(width,height);
  world.drawDrawables();
  popMatrix();
  
  stroke(128);
  line(width/2,0,width/2,height);
  line(0,height/2,width,height/2);
}