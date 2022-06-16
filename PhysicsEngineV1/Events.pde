// This Processing function is run once a click occurs
void mouseClicked() {
  if (clicking_allowed) {
    Circle obj = new Circle(mouseX, mouseY, round(random(30, 40)));
    obj.mass = round(random(1, 15));
    obj.colour = round(obj.mass * 15);
    add_obj(obj);
  }
}

// This Processing function is run once some key is pressed
void keyPressed() {
  // Time manipulation
  if (key == 'T' || key == 't' || key == 'Е' || key == 'е') {
    stopped_time = !stopped_time;
  }
  
  // For testing purposes
  //if (key == ' ') {
    //objects[0].speed.x += 0.1;
    //objects[0].speed.y -= 0.1;
  //}
  
  //Activate/deactivate frame-by-frame debug
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
  
  //When frame-by-frame debug is on, this is the "make one more step" key
  if (fbf_debug_on) {
    if (key == 'F' || key == 'f' || key == 'А' || key == 'а') {
      fbf_lock = false;
    }
  }
  
  // Uniform gravity manipulation
  if (key == 'G' || key == 'g' || key == 'П' || key == 'п') {
    uniform_grav_field = !uniform_grav_field;
  }
  
  // Activate/deactivate printing collision logs to console
  if (key == 'L' || key == 'l' || key == 'Д' || key == 'д') {
    logging_on = !logging_on;
  }
  
  // Show/hide borders
  if (key == 'B' || key == 'b' || key == 'И' || key == 'и') {
    borders_on = !borders_on;
  }
  
  // For testing purposes
  /*if (key == '+' || key == '=') {
    G += 0.002;
  }*/
  
  // Cannon shoot control
  if (key == 'S' || key == 's' || key == 'Ы' || key == 'ы') {
    //cannon.setPower(5);
    //add_obj(cannon.shoot(1));
    Circle shot = cannon.shoot();
    add_obj(shot);
    add_traj(shot, 1, 30, #ffffff, 2);
  }
  
  //Cannon angle control
  if (keyCode == LEFT) {
    cannon.rotate_by(5);
  }
  
  if (keyCode == RIGHT) {
    cannon.rotate_by(-5);
  }
  
  // Air friction manipulation
  if (key == 'A' || key == 'a' || key == 'Ф' || key == 'ф') {
    air_friction = !air_friction;
  }
  
  // Start/stop recording 
  if (key == 'R' || key == 'r' || key == 'К' || key == 'к') {
    if (recording) {
      recordings_finished++;
    }
    recording = !recording;
  }
}
