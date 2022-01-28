void mouseClicked() {
  if (clicking_allowed) {
    Circle obj = new Circle(mouseX, mouseY, round(random(30, 40)));
    obj.acceleration.x = 0;
    //obj.acceleration.y = 0.35;
    //obj.acceleration.y = 0.06;
    obj.mass = round(random(1, 15));
    obj.colour = round(obj.mass * 15);
    //obj.mass = 10;
    objects = (Circle[]) append(objects, obj);
    objects[obj_count].draw();
    obj_count++;
  }
}


void keyPressed() {
  if (key == 'T' || key == 't' || key == 'Е' || key == 'е') {
    stopped_time = !stopped_time;
  }
  //if (key == ' ') {
    //objects[0].speed.x += 0.1;
    //objects[0].speed.y -= 0.1;
  //}
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
  if (key == 'G' || key == 'g' || key == 'П' || key == 'п') {
    uniform_grav_field = !uniform_grav_field;
  }
  if (key == 'L' || key == 'l' || key == 'Д' || key == 'д') {
    logging_on = !logging_on;
  }
  if (key == 'B' || key == 'b' || key == 'И' || key == 'и') {
    borders_on = !borders_on;
  }
  /*if (key == '+' || key == '=') {
    G += 0.002;
  }*/
  if (key == 'S' || key == 's' || key == 'Ы' || key == 'ы') {
    //cannon.setPower(5);
    //add_obj(cannon.shoot(1));
    Circle shot = cannon.shoot();
    add_obj(shot);
    add_traj(shot, 1, 30, #ffffff, 2);
  }
  if (keyCode == LEFT) {
    cannon.rotate_by(5);
  }
  if (keyCode == RIGHT) {
    cannon.rotate_by(-5);
  }
  if (key == 'A' || key == 'a' || key == 'Ф' || key == 'ф') {
    air_friction = !air_friction;
  }
}
