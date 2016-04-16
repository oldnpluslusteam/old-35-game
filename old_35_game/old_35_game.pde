

Integer k = 25;

Integer[][] labirint;

List<Integer[]> walls;
List<Integer[]> objects;

Integer labirintWidth = 21;
Integer labirintHeight = 33;

Integer objectsSum = 10;

Integer x_offset_labirint = k/2*labirintWidth, y_offset_labirint = 100;
Integer x_offset_walls = k*labirintWidth + x_offset_labirint + k, y_offset_walls = 100 + k/2;

void setup() {
  fullScreen();
  labirint = generateLabirint(labirintWidth, labirintHeight);
  labirint[0][1] = VISITED;
  walls = generateWalls(labirint);
  objects = generateChordsForObjectInFreeSpace(objectsSum, labirint);
}

void draw() {
  clear();
  fill(0, 0, 0);
  background(255);
  color(0);
  for (int i = 0; i < labirintWidth; i++) {
    for (int j = 0; j < labirintHeight; j++) {
       if (labirint[i][j] == WALL) {
        rect(k*i + x_offset_labirint, k*j + y_offset_labirint, k, k);
       }
    }
  }
  
  for (Integer[] wall : walls) {
   line(k*wall[0] + x_offset_walls, k*wall[1] + y_offset_walls, k*wall[2] + x_offset_walls, k*wall[3] + y_offset_walls);
  } //<>// //<>//
  for (Integer[] object : objects) {
   ellipse(k*object[0] + x_offset_walls, k*object[1] + y_offset_walls, k/2, k/2);
   ellipse(k*object[0] + x_offset_labirint, k*object[1] + y_offset_labirint, k/2, k/2);
  }
} //<>//