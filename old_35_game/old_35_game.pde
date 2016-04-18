
Integer k = 25;

Integer[][] labirint;

List<Integer[]> walls;
List<Integer[]> objects;

Integer labirintWidth = 21;
Integer labirintHeight = 21;

Integer objectsSum = 10;

Integer x_offset_labirint = k/2*labirintWidth, y_offset_labirint = 100;
Integer x_offset_walls = k*labirintWidth + x_offset_labirint + k, y_offset_walls = 100 + k/2;

WinMob win;

World world;
Player player;
Camera camera;

Boolean end = false;
Boolean reset = false;

Boolean winState = false;

MonsterShape exitShape;

PImage lostBackground;
PImage lostSquare;
PImage lostCircle;
PImage lostTriangle;

PImage winBackgroundSquare;
PImage winBackgroundCircle;
PImage winBackgroundTriangle;
PImage winSquare;
PImage winCircle;
PImage winTriangle;

PGraphics minimapGraphics;

void setup() {
  fullScreen();
  minimapGraphics = createGraphics(128, 128);
  
  //MonsterShape.SQUARE.lightImage = loadImage("light-square.png");
  lostBackground = loadImage("lost-background.png");
  lostSquare = loadImage("lost-square.png");
  lostCircle = loadImage("lost-circle.png");
  lostTriangle = loadImage("lost-triangle.png");
  
  winBackgroundSquare = loadImage("win-background-square.png");
  winBackgroundCircle = loadImage("win-background-circle.png");
  winBackgroundTriangle = loadImage("win-background-triangle.png");
  winSquare = loadImage("win-square.png");
  winCircle = loadImage("win-circle.png");
  winTriangle = loadImage("win-triangle.png");
  {
    MonsterShape.SQUARE.lightImage = createGraphics(128,128);
    PGraphics g = MonsterShape.SQUARE.lightImage;
    g.beginDraw();
    g.translate(64,64);
    g.background(0,0,0,0);
    g.noFill();
    for (int i = 0; i < 64; ++i) {
      g.stroke((64-i)*255/128);
      g.ellipse(0,0,i,i);
    }
    g.blendMode(REPLACE);
    g.fill(0,0,0,0);
    g.rect(-10,-10,20,20);
    g.endDraw();
  }  {
    MonsterShape.TRIANGLE.lightImage = createGraphics(128,128);
    PGraphics g = MonsterShape.TRIANGLE.lightImage;
    g.beginDraw();
    g.translate(64,64);
    g.background(0,0,0,0);
    g.noFill();
    for (float i = 0; i < 64; i += 0.8) {
      g.stroke((64-i)*255/128);
      g.ellipse(0,0,i,i);
    }
    g.blendMode(REPLACE);
    g.fill(0,0,0,0);
    g.beginShape();
    g.vertex(0,10);
    g.vertex(-10,-10);
    g.vertex(10,-10);
    g.endShape(CLOSE);
    g.endDraw();
  }  {
    MonsterShape.CIRCLE.lightImage = createGraphics(128,128);
    PGraphics g = MonsterShape.CIRCLE.lightImage;
    g.beginDraw();
    g.translate(64,64);
    g.background(0,0,0,0);
    g.noFill();
    for (int i = 0; i < 64; ++i) {
      g.stroke((64-i)*255/128);
      g.ellipse(0,0,i,i);
    }
    g.blendMode(REPLACE);
    g.fill(0,0,0,0);
    g.ellipse(0,0,20,20);
    g.endDraw();
  }
  
  // TODO:
  // - uncomment
  // - insert file name
  // - run
  // - ENJOY MADNESS
  //playMusic("<fileName>.mp3");
  playMusic("./data/ld35.mp3");
  
  world = new World();
  
  // Just another wall in the world
  //world.add(new Wall(1,1,1,-1));
  //world.add(new Wall(-1,1,-1,-1));
  //world.add(new Wall(-1,1,1,1));
  
  addLabirint();
  
  //world.add(new Mob(MonsterShape.CIRCLE, 100, 100, 0));
  //world.add(new Mob(MonsterShape.TRIANGLE, -100, 0, 0.5));
  //world.add(new Mob(MonsterShape.CIRCLE, 100, 100, 0));
}

void addLabirint() {  
  Integer[][] labirint = generateLabirintWithQuit(labirintWidth, labirintHeight);
  
  Random random = new Random(new Date().getTime() + k);
  
  List<Integer[]> walls = generateWalls(labirint);
  
  List<Integer[]> objectsChords = new ArrayList<Integer[]>();
  objectsChords = generateChordsForObjectInFreeSpace(75, labirint); //<>//
  
  List<Integer[]> lightsChords = new ArrayList<Integer[]>();
  lightsChords = generateLights(labirintWidth, labirintHeight, 30, 50, 20);
  
  Integer[] winPlace = getWinPlace(labirint);
  
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
      player = new Player(MonsterShape.CIRCLE, objectChords[0]*World.TUNNEL_WIDTH - (World.TUNNEL_WIDTH/2), objectChords[1]*World.TUNNEL_WIDTH - (World.TUNNEL_WIDTH/2), MonsterShape.CIRCLE.radius, 0, new PlayerController(UP, DOWN, LEFT, RIGHT));
      world.add(player);
      camera = new Camera(player);
    }
  }
  
  for (Integer[] light : lightsChords) {
    world.add(new Light(shapes.get(random.nextInt(3)), light[0]*World.TUNNEL_WIDTH - (random.nextInt((int)World.TUNNEL_WIDTH)), light[1]*World.TUNNEL_WIDTH - (random.nextInt((int)World.TUNNEL_WIDTH)), light[2]));
  }
  win = new WinMob(winPlace[0]*World.TUNNEL_WIDTH, winPlace[1]*World.TUNNEL_WIDTH);
  world.add(win);
  
}

void draw() {
  
  if (reset) {
    reset = false;
    end = false;
    setup();
    return;
  }
  if (end) {
    clear();
    if (winState){
      if (exitShape.equals(MonsterShape.SQUARE)){
        image(winBackgroundSquare, 0, 0, width, height);
        image(winSquare, width/2 - winSquare.width/2, height/2 - winSquare.height/2);
      }
      if (exitShape.equals(MonsterShape.CIRCLE)){
        image(winBackgroundCircle, 0, 0, width, height);
        image(winCircle, width/2 - winCircle.width/2, height/2 - winCircle.height/2);
      }
      if (exitShape.equals(MonsterShape.TRIANGLE)){
        image(winBackgroundTriangle, 0, 0, width, height);
        image(winTriangle, width/2 - winTriangle.width/2, height/2 - winTriangle.height/2);
      }
      return;
    }
    image(lostBackground, 0, 0, width, height);
    if (exitShape.equals(MonsterShape.SQUARE)){
      image(lostSquare, width/2 - lostSquare.width/2, height/2 - lostSquare.height/2);
    }
    if (exitShape.equals(MonsterShape.CIRCLE)){
      image(lostCircle, width/2 - lostCircle.width/2, height/2 - lostCircle.height/2);
    }
    if (exitShape.equals(MonsterShape.TRIANGLE)){
      image(lostTriangle, width/2 - lostTriangle.width/2, height/2 - lostTriangle.height/2);
    }
    return;
  }
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
  //line(width/2,0,width/2,height);
  //line(0,height/2,width,height/2);
  
  minimapGraphics.beginDraw();
  minimapGraphics.clear();
  minimapGraphics.background(0,0,0,0);
  minimapGraphics.stroke(255);
  minimapGraphics.strokeWeight(1);
  minimapGraphics.translate(5,5);
  minimapGraphics.stroke(200);
  minimapGraphics.fill(128);
  minimapGraphics.rect(-5,-5,110,110,5);
  minimapGraphics.strokeWeight(10);
  minimapGraphics.scale(5./World.TUNNEL_WIDTH);
  for (DrawableEntity de : world.des)
    if (de instanceof Wall) {
      Wall w = (Wall)de;
      minimapGraphics.line(w.x1,w.y1,w.x2,w.y2);
    }
  minimapGraphics.stroke(255);
  minimapGraphics.fill(255,128,128);
  minimapGraphics.ellipse(player.x, player.y, 100,100);
  minimapGraphics.stroke(255);
  minimapGraphics.fill(128,255,128);
  minimapGraphics.ellipse(win.x, win.y, 100,100);
  minimapGraphics.endDraw();
  
  image(minimapGraphics, width-128, height-128);
}