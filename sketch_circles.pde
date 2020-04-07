class Krug {
  float x,y,r, dx=0, dy=0;
  boolean end_of_box=false;
  int cvet=0;
  Krug(float px, float py, float pr) {
    x=px;
    y=py;
    r=pr;
    cvet = round(random(80,220));
  }
  void draw() {
    fill(cvet);
    ellipse(x,y,2*r,2*r);
    stroke(cvet);
    if (dx != 0 || dy != 0) {
     line(x,y, x+ (dx*1.6*r)/sqrt(dx*dx+dy*dy), y+ (dy*1.6*r)/sqrt(dx*dx+dy*dy));
    }
    noStroke();
  }
  void move() {
    int a = round(random(10000));
    if (end_of_box || a%109 == 0) {
    dx = random(-2.5, 2.5);
    dy = random(-2.5, 2.5);
    } //
     if (x+r+dx<=600 && x-r+dx>=0 && y+r+dy<=600 && y-r+dy>=0){
       x+=dx;
       y+=dy;
       end_of_box=false;
    }
    else {
      end_of_box=true;
    }
    draw();
  }
}
int k=0;
Krug ser[] = new Krug[0];

void setup() {
  size(600,600);
  background(0);
}

void draw() {
  background(0);
  for (int i=0; i<k; i++) {
    ser[i].move();
  }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    Krug Circle = new Krug(mouseX, mouseY, 40);
    ser = (Krug[])append(ser, Circle);
    ser[k].draw();
    ser[k].dx=random(-2.5, 2.5);
    ser[k].dy=random(-2.5, 2.5);
    k++; 
  }
}
