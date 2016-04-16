
Integer x_offset = 0, y_offset = 0;

Integer k = 25;

Integer[][] labirint;

Integer labirintWidth = 31;
Integer labirintHeight = 31;

void setup() {
  fullScreen();
  labirint = generateLabirint(labirintWidth, labirintHeight);
  labirint[0][1] = VISITED;
}

void draw() {
  clear();
  fill(0, 0, 0);
  background(255);
  color(0);
  for (int i = 0; i < labirintHeight; i++) {
    for (int j = 0; j < labirintWidth; j++) {
       if (labirint[i][j] == WALL) {
        rect(k*j + x_offset, k*i + y_offset, k/2, k/2);
       }
    }
  }
}