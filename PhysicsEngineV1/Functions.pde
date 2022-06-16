// Returns the orthogonal projection of vector a onto vector b
PVector project(PVector a, PVector b) {
  PVector res = b.mult(a.dot(b) / b.magSq());
  return res;
}

// The cross product of vector a and vector b (the [a, b] opearation)
float cross(PVector a, PVector b) {
  return a.x * b.y - a.y * b.x;
}

// Self-explanatory
float distance_squared(float x1, float y1, float x2, float y2) {
  return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2);
}

// Self-explanatory
void stop_time() {
  stopped_time = true;
}

// The circle that is passed to this function is added to the list and participates in the simulation
void add_obj(Circle circle) {
  objects = (Circle[]) append(objects, circle);
  objects[obj_count].draw();
  obj_count++;
}

// This function "attaches" a trail to the circle passes as a parameter
void add_traj(Circle circle, int size, int max_size, color special_color, int frequency) {
  Trajectory traj = new Trajectory(circle, size, max_size, special_color, frequency);
  trails = (Trajectory[]) append(trails, traj);
  trails_count++;
}
