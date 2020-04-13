class Krug {
  float x,y,r, d=0, angle=0;
  boolean end_of_box=false;
  int cvet=0;
  Krug(float px, float py, float pr) {
    x=px;
    y=py;
    r=pr;
    cvet = round(random(80,220));
  }
  void draw() {
    stroke(200, 100, 0);
    if (d!=0) {
     line(x, y, x+1.6*r*cos(angle), y + 1.6*r*sin(angle));
    }
    noStroke();
    fill(cvet);
    circle(x,y,2*r);
  }
  void move() {
    int a = round(random(10000));
    if (end_of_box || a%109 == 0) {
    angle = random(-PI, PI);
    d = random(0, 2.5);
    } //
     if (x+r+d*cos(angle)<=600 && x-r+d*cos(angle)>=0 && y+r+d*sin(angle)<=600 && y-r+d*sin(angle)>=0){
       x+=d*cos(angle);
       y+=d*sin(angle);
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
    ser[k].d=random(0, 5);
    ser[k].angle=random(-PI, PI);
    k++; 
  }
}
