class Krug {
  float x,y,r, dx=0, dy=0;
  int cvet=0;
  Krug(float px, float py, float pr) {
    x=px;
    y=py;
    r=pr;
    cvet = round(random(80,220));
  }
  void draw() {
    fill(cvet);
    ellipse(x,y,r,r);
  }
  void move() {
    int a = round(random((x+y)*100));
    if (a%109 == 0) {
    dx = random(-1.5, 1.5);
    dy = random(-1.5, 1.5);
    } //
    if ((x+dx<=565) && (x+dx>=-35) && (y+dy<=565) && (y+dy>=-35)){
     x+=dx;
     y+=dy;
    }
    draw();
  }
}
void setup() {
  size(600,600);
  background(0);
  for (int i=0; i<4; i++) {
    Krug Circle = new Krug(random(70, 530), random(70, 530), 70);
    ser = (Krug[])append(ser, Circle);
    ser[i].draw();
  }
}
Krug ser[] = new Krug[0];

void draw() {
  background(0);
  for (int i=0; i<4; i++) {
    ser[i].move();
  }
  
}
