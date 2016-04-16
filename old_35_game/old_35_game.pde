

Integer k = 5;

Integer[][] labirint;

List<Integer[]> walls;

Integer labirintWidth = 91;
Integer labirintHeight = 91;

Integer x_offset_labirint = k/2*labirintWidth, y_offset_labirint = 100;
Integer x_offset_walls = k*labirintWidth + x_offset_labirint + k, y_offset_walls = 100;

void setup() {
  fullScreen();
  labirint = generateLabirint(labirintWidth, labirintHeight);
  labirint[0][1] = VISITED;
  walls = generateWalls(labirint);
}

void draw() {
  clear();
  fill(0, 0, 0);
  background(255);
  color(0);
  for (int i = 0; i < labirintHeight; i++) {
    for (int j = 0; j < labirintWidth; j++) {
       if (labirint[i][j] == WALL) {
        rect(k*j + x_offset_labirint, k*i + y_offset_labirint, k, k);
       }
    }
  }
  
  for (Integer[] wall : walls) {
    line(k*wall[0] + x_offset_walls, k*wall[1] + y_offset_walls, k*wall[2] + x_offset_walls, k*wall[3] + y_offset_walls);
  } //<>// //<>//
}