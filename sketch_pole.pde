int pole[][];
int size = 100;
int side = 600/size;
void setup() {
  size(600,600);
  background(0);
  pole = new int[size][size];
  been = new boolean[size][size];
  for (int i=0; i<size; i++) {
    for (int j=0; j<size; j++) {
      pole[i][j]=0;
    }
  }
}

void draw() {
  background(0);
  for (int i=0; i<size; i++) {
    for (int j=0; j<size; j++) { 
        if (pole[i][j] == -1) {
         //stroke(250, 0, 0);
         //strokeWeight(1);
         noStroke();
         fill(100, 100, 100);
         square(i*side, j*side, side);
        }
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (pole[mouseX/side][mouseY/side] == 0) {
      pole[mouseX/side][mouseY/side]=-1;
    }
  }
  else if (mouseButton == RIGHT) {
    if (pole[mouseX/side][mouseY/side] == -1) {
      pole[mouseX/side][mouseY/side]=0;
    }
  }
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    pole[mouseX/side][mouseY/side]=-1;
  }
  else if (mouseButton == RIGHT) {
    pole[mouseX/side][mouseY/side]=0;
  }
}
