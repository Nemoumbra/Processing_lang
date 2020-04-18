class Krug {
  float x,y,r, d=0, angle=0;
  boolean end_of_box=false, chosen=false;
  int colour, cvet;
  Krug(float px, float py, float pr) {
    x=px;
    y=py;
    r=pr;
    colour = round(random(80,220));
    cvet = colour;
  }
  void draw_eyes() {
    stroke(0);
    circle(x + 0.7*r*cos(angle+0.58), y + 0.7*r*sin(angle+0.58), r/3);
    circle(x + 0.7*r*cos(angle-0.58), y + 0.7*r*sin(angle-0.58), r/3);
    fill(0);
    circle(x + 0.7*r*cos(angle+0.58), y + 0.7*r*sin(angle+0.58), r/9);
    circle(x + 0.7*r*cos(angle-0.58), y + 0.7*r*sin(angle-0.58), r/9);
    noFill();
    stroke(cvet);
  }
  void draw_arms() {
    strokeWeight(2);
    line(x + 2*r*cos(angle+PI/2), y + 2*r*sin(angle+PI/2), x + 2*r*cos(angle-PI/2), y + 2*r*sin(angle-PI/2));
    strokeWeight(1);
  }
  
  void draw() {
    stroke(200, 100, 0);
    if (d!=0) {
     //strokeJoin(MITER); 
     line(x, y, x+1.6*r*cos(angle), y + 1.6*r*sin(angle));
    }
    if (chosen) {
      fill(250, 0, 0);
      stroke(250,0,0);
    }
    else {
      fill(cvet);
      stroke(cvet);
    }
    draw_arms();
    circle(x,y,2*r);
    draw_eyes();
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
int k=0, n=0;
Krug ser[] = new Krug[0];

float F (float x1, float y1, float x2, float y2, float x) {
  return x*(y2-y1)/(x2-x1) + (y1*x2-y2*x1)/(x2-x1);
}
void dotted_line (Krug target, Krug chosen_one) {
  fill(250);
  if (target.x == chosen_one.x) {
    if (chosen_one.y > target.y) {
      for (int i=round(chosen_one.y); i>=target.y; i-=15) {
        circle(chosen_one.x, i, 4);
      }
    }
    else { //chosen_one.y <= target.y
      for (int i = round(chosen_one.y); i <= target.y; i+=15) {
        circle(chosen_one.x, i, 4);
      }
    }
  }
  else if (target.x > chosen_one.x) {
    for (int i = round(chosen_one.x); i <= target.x; i+=10) {
      circle(i, F(target.x, target.y, chosen_one.x, chosen_one.y, i), 4);
    }
  }
  else { //target.x < chosen_one.x
    for (int i = round(chosen_one.x); i >= target.x; i-=10) {
      circle(i, F(target.x, target.y, chosen_one.x, chosen_one.y, i), 4);
    }
  }
}

void setup() {
  size(600,600);
  background(0);
}

void draw() {
  background(0);
  for (int i=0; i<k; i++) {
    if (!ser[i].chosen) {
     ser[i].move();
    }
    else {
      stroke(200);
      for (int j=0; j<k; j++) {
        if (j == n) continue;
        dotted_line(ser[j], ser[n]);
      }
      ser[i].draw();
    }
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
void keyPressed() {
  if (k>0) {
   if (key == 'Q' || key == 'q') {
     ser[n].chosen=false;
     if (n==0) {
       n=k-1;
     }
     else {
       n--;
     }
     ser[n].chosen=true;
   }
   if (key == 'W' || key == 'w') {
     ser[n].chosen=false;
     if (n==k-1) {
       n=0;
     }
     else {
       n++;
     }
     ser[n].chosen=true;
   }
   if (keyCode == LEFT) {
     ser[n].angle-=0.1;
   }
   if (keyCode == RIGHT) {
     ser[n].angle+=0.1;
   }
   if (keyCode == UP) {
     ser[n].d=4;
     ser[n].x+=ser[n].d*cos(ser[n].angle);
     ser[n].y+=ser[n].d*sin(ser[n].angle);
   }
   if (keyCode == DOWN) {
     ser[n].d=4;
     ser[n].x-=ser[n].d*cos(ser[n].angle);
     ser[n].y-=ser[n].d*sin(ser[n].angle);
   }
 }
}
