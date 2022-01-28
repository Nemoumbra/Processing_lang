boolean circle_stroke = false;
boolean clicking_allowed = false;

Circle objects[] = new Circle[0];
int obj_count = 0;

boolean borders_on = true;
Border border = new Border(20, 20, 880, 880);

boolean stopped_time = true;

float epsilon = 1;

boolean fbf_debug_on = false;
boolean fbf_lock = false;

boolean uniform_grav_field = false;
boolean perp_plane_g = false;
PVector g = new PVector(0, 0.05);
float mu = 0.00;

float border_hit_loss = 0.0;

boolean logging_on = false;

boolean gravity = true;
float G = 20.0;

Trajectory trails[] = new Trajectory[0];
int trails_count = 0;

boolean air_friction = false;
float air_fr_k = 0.004;

Cannon cannon = new Cannon(50, 862, 6, 1, #ff0000, new PVector(1, 0));

Rocket rocket = new Rocket(300, 870, #ff0000, #ffffff, new PVector(0, 5.8), 1010, 15, 1.3);

//Trajectory circle_traj = new Trajectory(1, 180, #ffffff, 2);
//Trajectory ellipse_traj = new Trajectory(1, 180, #ffffff, 2);
//232
