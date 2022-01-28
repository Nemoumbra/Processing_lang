PVector project(PVector a, PVector b) {
  PVector res = b.mult(a.dot(b) / b.magSq());
  return res;
}

float cross(PVector a, PVector b) {
  return a.x * b.y - a.y * b.x;
}

void ellipse(float fx1, float fy1, float fx2, float fy2, float a, float b) {
  //later
}

float distance_squared(float x1, float y1, float x2, float y2) {
  return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2);
}

void stop_time() {
  stopped_time = true;
}

void add_obj(Circle circle) {
  objects = (Circle[]) append(objects, circle);
  objects[obj_count].draw();
  obj_count++;
}

void add_traj(Circle circle, int size, int max_size, color special_color, int frequency) {
  Trajectory traj = new Trajectory(circle, size, max_size, special_color, frequency);
  trails = (Trajectory[]) append(trails, traj);
  trails_count++;
}
