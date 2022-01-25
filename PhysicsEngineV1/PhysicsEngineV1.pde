

PVector project(PVector a, PVector b) {
  PVector res = b.mult(a.dot(b) / b.magSq());
  return res;
}

float cross(PVector a, PVector b) {
  return a.x * b.y - a.y * b.x;
}

class Border {
  PVector left_up, right_bottom;
  PVector up_norm, left_norm, right_norm, bottom_norm;
  Border(float x1, float y1, float x2, float y2) {
    left_up = new PVector(x1, y1);
    right_bottom = new PVector(x2, y2);
    up_norm = new PVector(0, -1);
    bottom_norm = new PVector(0, 1);
    left_norm = new PVector(-1, 0);
    right_norm = new PVector(0, 1);
  }
}
class Circle {
  float r/*, d=0, angle=0*/;
  int cvet;
  PVector position;
  PVector speed, acceleration;
  float mass;
  Circle(float x, float y, float pr) {
    position = new PVector(x, y);
    r=pr;
    cvet = round(random(80,220));
    speed = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 0;
  }
  Circle(PVector pos, float pr) {
    r=pr;
    cvet = round(random(80,220));
    position = pos.copy();
    speed = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 0;
  }
  
  void draw() {
    stroke(200, 100, 0);
    fill(cvet);
    stroke(cvet);
    circle(position.x, position.y, 2*r);
  }
  void move() {
    //apply physics?
    speed.add(acceleration);
    position.add(speed);
    draw();
  }
}

Circle objects[] = new Circle[0];
Border border = new Border(20, 20, 880, 880);
int obj_count = 0;
boolean stopped_time = true;
float epsilon = 1;
boolean fbf_debug_on = true;
boolean fbf_lock = false;

float distance_squared(float x1, float y1, float x2, float y2) {
  return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2);
}
void stop_time() {
  stopped_time = true;
}
void setup() {
  size(900,900);
  background(0);
  
}
void draw() {
   background(0);
   stroke(200, 100, 0);
   strokeWeight(5);
   line(border.left_up.x, border.left_up.y, border.left_up.x, border.right_bottom.y);
   line(border.left_up.x, border.left_up.y, border.right_bottom.x, border.left_up.y);
   line(border.left_up.x, border.right_bottom.y, border.right_bottom.x, border.right_bottom.y);
   line(border.right_bottom.x, border.left_up.y, border.right_bottom.x, border.right_bottom.y);
   
   for (Circle circle : objects) {
       // compute new acceleration
       if (!(stopped_time || fbf_lock)) {
         circle.move();
       }
       else {
         circle.draw();
       }
   }
   if (!(stopped_time || fbf_lock)) {
     //check collisions with O(n^2) approach
     for (int i = 0; i < obj_count; i++) {
       for (int j = i+1; j < obj_count; j++) {
         float var = distance_squared(objects[i].position.x, objects[i].position.y, objects[j].position.x, objects[j].position.y);
         if (var <= (objects[i].r + objects[j].r)*(objects[i].r + objects[j].r)) {
           //точка между центрами полагается точкой удара. Дальше ЗСИ и ЗСЭ. Пока что абсолютно упругий удар и нет потерь на тепло.
           //Всё происходит в вертикальной плоскости, трения между телами нет => движение поступательное
           //Мы не считаем, что надо сразу учитывать удар тела о несколько других. Да, будет небольшая беда.
           //stopped_time = true;
           PVector O1O2 = PVector.sub(objects[j].position, objects[i].position);
           //print("Debug started: \nO1O2 :", O1O2, "\n");
           //Below code is rendered unusable be this simple correction:
           O1O2.normalize();
           //print("Normalized O1O2: ", O1O2);
           //PVector collision_point = PVector.add(objects[i].position, PVector.mult(O1O2, 1/(1 + objects[i].r/objects[j].r)));
           //PVector momentum_par_1 = PVector.mult(project(objects[i].speed, O1O2), objects[i].mass), 
           //  momentum_par_2 = PVector.mult(project(objects[j].speed, O1O2), objects[j].mass);
           //PVector momentum_perp_1 = PVector.sub(PVector.mult(objects[i].speed, objects[i].mass), momentum_par_1),
           //  momentum_perp_2 = PVector.sub(PVector.mult(objects[j].speed, objects[j].mass), momentum_par_2);
           float v_1 = objects[i].speed.dot(O1O2), v_2 = objects[j].speed.dot(O1O2);
           float v_c = (objects[i].mass * v_1 + objects[j].mass * v_2) / (objects[i].mass + objects[j].mass);
           float V_1 = 2*v_c - v_1, V_2 = 2*v_c - v_2;
           //print("Computed v_1, v_2, v_c, V_1, V_2: ", v_1, v_2, v_c, V_1, V_2, "\n");
           //print("Old speeds: ", objects[i].speed, objects[j].speed, "\n");
           objects[i].speed.add(PVector.mult(O1O2, V_1 - v_1));
           objects[j].speed.add(PVector.mult(O1O2, V_2 - v_2));
           //print("New speeds: ", objects[i].speed, objects[j].speed, "\n");
           //stopped_time = true;
           //-2.9802322E-8
         }
       }
       //now check borders
       if (objects[i].position.x - objects[i].r <= border.left_up.x) {
         print("Left border hit start! Speed: ", objects[i].speed, "\n");
         objects[i].speed.rotate(2 * asin(border.left_norm.cross(objects[i].speed).mag() / objects[i].speed.mag()));
         objects[i].speed.mult(-1);
         print("Left border hit end! Speed: ", objects[i].speed, "\n");
       }
       if (objects[i].position.y - objects[i].r <= border.left_up.y) {
         print("Up border hit start! Speed: ", objects[i].speed, "\n");
         objects[i].speed.rotate(2 * asin(border.up_norm.cross(objects[i].speed).mag() / objects[i].speed.mag()));
         objects[i].speed.mult(-1);
         print("Up border hit end! Speed: ", objects[i].speed, "\n");
       }
       if (objects[i].position.x + objects[i].r >= border.right_bottom.x) {
         print("Right border hit start! Speed: ", objects[i].speed, "\n");
         objects[i].speed.rotate(2 * asin(border.right_norm.cross(objects[i].speed).mag() / objects[i].speed.mag()));
         objects[i].speed.mult(-1);
         print("Right border hit end! Speed: ", objects[i].speed, "\n");
       }
       if (objects[i].position.y + objects[i].r >= border.right_bottom.y) {
         print("Bottom border hit start! Speed: ", objects[i].speed, "\n");
         objects[i].speed.rotate(2 * asin(border.bottom_norm.cross(objects[i].speed).mag() / objects[i].speed.mag()));
         objects[i].speed.mult(-1);
         print("Bottom border hit end! Speed: ", objects[i].speed, "\n");
       }
     }
     if (fbf_debug_on && !fbf_lock) {
       fbf_lock = true;
     }
   }
}

void mouseClicked() {
  Circle obj = new Circle(mouseX, mouseY, 40);
  obj.acceleration.x = 0;
  //obj.acceleration.y = 0.35;
  //obj.acceleration.y = 0.05;
  obj.mass = round(random(2, 10));
  obj.cvet = round(obj.mass * 15);
  //obj.mass = 10;
  objects = (Circle[]) append(objects, obj);
  objects[obj_count].draw();
  obj_count++;
}

void keyPressed() {
  if (key == 'T' || key == 't' || key == 'Е' || key == 'е') {
    stopped_time = !stopped_time;
  }
  if (key == ' ') {
    objects[0].speed.x += 0.3;
    objects[0].speed.y -= 0.4;
  }
  if (key == 'D' || key == 'd' || key == 'В' || key == 'в') {
    if (fbf_debug_on) {
      fbf_debug_on = false;
      fbf_lock = false;
    }
    else {
      fbf_debug_on = true;
      fbf_lock = false;
    }
  }
  if (fbf_debug_on) {
    if (key == 'F' || key == 'f' || key == 'А' || key == 'а') {
      fbf_lock = false;
    }
  }
}
