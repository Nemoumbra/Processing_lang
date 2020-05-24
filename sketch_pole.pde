int pole[][];
int size = 60;
int t1=0, t2=0;
void setup() {
  size(600,600);
  background(0);
  pole = new int[size][size];
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
      switch(pole[i][j]) {
        case 1 : {
         noFill(); 
         stroke(100, 150, 50);
         square(10*i, 10*j, 10);
         break;
        }
        case 2 : {
         noStroke(); 
         fill(250, 0, 0);
         square(i*10, j*10, 10);
         noFill();
         break;
        }
      }
    }
  }
}
void mouseMoved() {
  if (!(t1 == mouseX/10 && t2 == mouseY/10)) {
   if (pole[t1][t2] == 1)
     pole[t1][t2]=0;
   if (pole[mouseX/10][mouseY/10] == 0) {
     pole[mouseX/10][mouseY/10]=1;
     t1=mouseX/10; t2=mouseY/10;
   }
  }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    if (pole[mouseX/10][mouseY/10] == 1) {
      pole[mouseX/10][mouseY/10]=2;
    }
    else if (pole[mouseX/10][mouseY/10] == 2){
     pole[mouseX/10][mouseY/10]=1;
     t1=mouseX/10; t2=mouseY/10;
    }
  }
}
