
Integer k = 25;

Integer[][] labirint;

List<Integer[]> walls;
List<Integer[]> objects;

Integer labirintWidth = 21;
Integer labirintHeight = 33;

Integer objectsSum = 10;

Integer x_offset_labirint = k/2*labirintWidth, y_offset_labirint = 100;
Integer x_offset_walls = k*labirintWidth + x_offset_labirint + k, y_offset_walls = 100 + k/2;

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
  world.add(new Mob(MonsterShape.TRIANGLE, -100, 0, 0.5));
  world.add(new Mob(MonsterShape.CIRCLE, 100, 100, 0));
}

void draw() {
  world.collideCollidables();
  world.updateUpdateables();

  clear();
  fill(0, 0, 0);
  background(255);
  color(0);
  
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