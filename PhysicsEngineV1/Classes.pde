
// That's just a box to keep objects from leaving the screen
class Border {
  PVector left_up, right_bottom;
  PVector up_norm, left_norm, right_norm, bottom_norm;
  Border(float x1, float y1, float x2, float y2) {
    left_up = new PVector(x1, y1); //corners
    right_bottom = new PVector(x2, y2);
    up_norm = new PVector(0, -1);
    bottom_norm = new PVector(0, 1);
    left_norm = new PVector(-1, 0);
    right_norm = new PVector(0, 1);
  }
  void draw() {
    stroke(200, 100, 0);
    strokeWeight(5);
    line(border.left_up.x, border.left_up.y, border.left_up.x, border.right_bottom.y);
    line(border.left_up.x, border.left_up.y, border.right_bottom.x, border.left_up.y);
    line(border.left_up.x, border.right_bottom.y, border.right_bottom.x, border.right_bottom.y);
    line(border.right_bottom.x, border.left_up.y, border.right_bottom.x, border.right_bottom.y);
  }
}

// Main class for any circle-shaped thing, like projectiles
class Circle {
  float r/*, d=0, angle=0*/;
  int colour;
  PVector position;
  PVector speed, acceleration;
  float mass;
  boolean special; // in case a special color is requested by the user
  color special_color;
  boolean opaque; // mainly for trajectories
  float opacity;
  boolean immovable; // position is supposed to remain constant
  boolean projectile; // this is a marker for shots from the cannon
  //float 
  Circle(float x, float y, float pr) {
    position = new PVector(x, y);
    r=pr;
    colour = round(random(80,220));
    speed = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 0;
    special = false;
    opaque = true;
    immovable = false;
    projectile = false;
  }
  Circle(PVector pos, float pr) {
    r = pr;
    colour = round(random(80,220));
    position = pos.copy();
    speed = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 0;
    special = false;
    opaque = true;
    immovable = false;
    projectile = false;
  }
  
  void draw() {
    strokeWeight(1);
    if (circle_stroke) {
      if (opaque) {
        stroke(200, 0, 0);
      }
      else {
        stroke(200, 0, 0, opacity);
      }
    }
    else {
      if (opaque) {
        if (special) {
          stroke(special_color);
        }
        else {
          stroke(colour);
        }
      }
      else {
        if (special) {
          stroke(special_color, opacity);
        }
        else {
          stroke(colour, opacity);
        }
      }
    }
    if (opaque) {
      if (special) {
        fill(special_color);
      } 
      else {
        fill(colour);
      }
    }
    else {
      if (special) {
        fill(special_color, opacity);
      } 
      else {
        fill(colour, opacity);
      }
    }
    circle(position.x, position.y, 2*r);
  }
  void move() {
    //apply physics
    if (!immovable) {
      speed.add(acceleration);
      position.add(speed);
    }
    draw();
  }
}

//This class represents a trail which is left behind a moving circle
class Trajectory {
  ArrayList <Circle> path;
  color colour;
  int max_size;
  int r;
  int counter;
  int frequency;
  Circle child;
  
  Trajectory(Circle circle, int r, int max_size, color colour, int frequency) {
    this.r = r;
    this.max_size = max_size;
    this.colour = colour;
    this.frequency = frequency;
    counter = 0;
    path = new ArrayList<Circle>();
    child = circle;
  }
  void add(PVector pos) {
    if (path.size() == max_size) {
      path.remove(0);
    }
    Circle obj = new Circle(pos, r);
    obj.special = true;
    obj.special_color = colour;
    obj.opaque = false;
    path.add(obj);
  }
  void save_new() {
    counter++;
    counter %= frequency;
    if (counter == 0) {
      add(child.position);
    }
  }
  void draw() {
    int i = 0;
    for (Circle circle: path) {
      i++;
      //The idea is that circles get more and more transparent as the time goes on until they are removed from the array
      circle.opacity = 100 * i/ (path.size() + 1); 
      circle.draw();
    }
  }
}

//class Projectile extends Circle {
  
//}

//This immovable shape cannot react with objects and has no special support in draw() function
class Cannon {
  PVector position;
  int r;
  color colour;
  PVector direction;
  float cur_angle;
  float power;
  float mass;
  Cannon(float x, float y, int r, float mass, color colour, PVector direction) {
    position = new PVector(x, y);
    cur_angle = 0;
    this.r = r;
    this.colour = colour;
    this.direction = new PVector();
    this.direction.x = direction.x;
    this.direction.y = direction.y;
    this.mass = mass;
  }
  Cannon(PVector pos, int r, float mass, color colour, PVector direction) {
    position = pos.copy();
    cur_angle = 0;
    this.r = r;
    this.colour = colour;
    this.direction = new PVector();
    this.direction.x = direction.x;
    this.direction.y = direction.y;
    this.mass = mass;
  }
  
  void setPower(float new_power) {
    power = new_power;
  }
  
  // shoot(0) means shoot in the direction specified by field "direction"
  Circle shoot(float angle) {
    Circle res = new Circle(position, r);
    res.special = true;
    res.special_color = colour;
    res.speed = PVector.mult(direction.copy().rotate(-radians(angle)), power);
    res.mass = mass;
    res.projectile = true;
    return res;
  }
  Circle shoot() {
    Circle res = new Circle(position, r);
    res.special = true;
    res.special_color = colour;
    res.speed = PVector.mult(direction.copy().rotate(-radians(cur_angle)), power);
    res.mass = mass;
    res.projectile = true;
    return res;
  }
  void rotate_by(float angle) {
    cur_angle += angle;
  }
  
  void draw() {
    fill(colour);
    strokeWeight(1);
    stroke(colour);
    square(position.x, position.y, 10);
    line(position.x + 5, position.y + 5, position.x + 5 + 40 * cos(radians(cur_angle)), position.y + 5 - 40 * sin(radians(cur_angle)));
  }
}

// A standard rectangular-shaped rocket, which is only affected by air drag and uniform gravity field facing parallel to the main plane.
// It can only move along some line and has no special support in draw() function
class Rocket {
  PVector position;
  PVector speed;
  PVector gas_jet_speed;
  float dM; // when engines are on, rocket looses "minus this value" of mass every frame
  float rocket_mass;
  float cur_mass;
  float st_mass_minus_r_mass;
  color colour;
  boolean engines_on;
  boolean immovable;
  color empty;
  
  Rocket(float x, float y, color colour, color empty, PVector gas, float start_mass, float rocket_mass, float per_frame_losses) {
    position = new PVector(x, y);
    gas_jet_speed = gas.copy();
    st_mass_minus_r_mass = start_mass - rocket_mass;
    cur_mass = start_mass;
    dM = - per_frame_losses;
    this.colour = colour;
    engines_on = false;
    speed = new PVector(0, 0);
    this.rocket_mass = rocket_mass;
    immovable = false;
    this.empty = empty;
  }
  Rocket(PVector pos, color colour, color empty, PVector gas, float start_mass, float rocket_mass, float per_frame_losses) {
    position = pos.copy();
    gas_jet_speed = gas.copy();
    st_mass_minus_r_mass = start_mass - rocket_mass;
    cur_mass = start_mass;
    dM = - per_frame_losses;
    this.colour = colour;
    engines_on = false;
    speed = new PVector(0, 0);
    this.rocket_mass = rocket_mass;
    immovable = false;
    this.empty = empty;
  }
  
  void draw() {
    fill(colour);
    stroke(colour);
    float l = 20/st_mass_minus_r_mass * (cur_mass - rocket_mass);
    //The rocket is colored in such way that it would represent how much fuel is left (in %)
    rect(position.x - 3, position.y + 10 - l, 6, l);
    fill(empty);
    if (l != 20) {
      stroke(empty);
    }
    rect(position.x - 3, position.y - 10, 6, 20 - 20/st_mass_minus_r_mass * (cur_mass - rocket_mass));
  }
  
  void start_engines() {
    if (cur_mass > rocket_mass) {
      engines_on = true;
    }
  }
  void stop_engines() {
    engines_on = false;
  }
  
  void move(PVector forces) {
    if (!immovable) {
      speed.add(PVector.mult(forces, 1/cur_mass));
      if (engines_on) {
        speed.add(PVector.mult(gas_jet_speed, dM/cur_mass));
        cur_mass += dM;
        if (cur_mass < rocket_mass) {
          cur_mass = rocket_mass;
          engines_on = false;
          colour = empty;
        }
      }
      position.add(speed);
    }
    //draw();
  }
}
