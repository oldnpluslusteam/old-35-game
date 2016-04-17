
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
  
  camera = new Camera(player);
  // Just another wall in the world
  //world.add(new Wall(1,1,1,-1));
  //world.add(new Wall(-1,1,-1,-1));
  //world.add(new Wall(-1,1,1,1));
  
  addLabirint();
  
  //world.add(new Mob(MonsterShape.CIRCLE, 100, 100, 0));
  //world.add(new Mob(MonsterShape.TRIANGLE, -100, 0, 0.5));
  //world.add(new Mob(MonsterShape.CIRCLE, 100, 100, 0));
  
  world.add(new Light(MonsterShape.CIRCLE, 200, 200, 0));
  world.add(new Light(MonsterShape.SQUARE, 200, 100, 0));
  world.add(new Light(MonsterShape.TRIANGLE, 200, 0, 0));
  
  // TODO:
  // - uncomment
  // - insert file name
  // - run
  // - ENJOY MADNESS
  //playMusic("<fileName>.mp3");
  //playMusic("/media/aleksey/16GB Volume/Apocalyptica/2003 - Reflections/09 Heat.mp3");
  
}

void addLabirint() {  
  Integer[][] labirint = generateLabirintWithQuit(labirintWidth, labirintWidth);
  
  Random random = new Random(new Date().getTime() + k);
  
  List<Integer[]> walls = generateWalls(labirint);
  
  List<Integer[]> objectsChords = new ArrayList<Integer[]>();
  objectsChords = generateChordsForObjectInFreeSpace(10, labirint); //<>//
  
  for (Integer[] wall : walls) { //<>//
    world.add(new Wall(wall[0], wall[1], wall[2], wall[3]));
  }
  
  List<MonsterShape> shapes = new ArrayList<MonsterShape>();
  
  shapes.add(MonsterShape.CIRCLE);
  shapes.add(MonsterShape.TRIANGLE);
  shapes.add(MonsterShape.SQUARE);
  
  for (Integer[] objectChords : objectsChords) {
    if (labirint[objectChords[0]][objectChords[1]] == NPC_PLACE) {
      world.add(new Mob(shapes.get(random.nextInt(3)), objectChords[0]*World.TUNNEL_WIDTH - (World.TUNNEL_WIDTH/2), objectChords[1]*World.TUNNEL_WIDTH - (World.TUNNEL_WIDTH/2), radians(random.nextInt(360))));
    } else if (labirint[objectChords[0]][objectChords[1]] == PLAYER){
      player = new Player(MonsterShape.CIRCLE, 0, 0, 20, 0, new PlayerController(UP, DOWN, LEFT, RIGHT));
      world.add(player);
    }
  }
  
  System.out.println(objectsChords);
  
} //<>//

void draw() {
  
  world.updateUpdateables();

  clear();
  fill(0, 0, 0);
  background(getAudioPeak()*244);
  
  stroke(255);
  fill(189);
  pushMatrix();
  camera.setup(width,height);
  world.collideCollidables();
  world.drawDrawables();
  popMatrix();
  
  stroke(128);
  line(width/2,0,width/2,height);
  line(0,height/2,width,height/2);
}