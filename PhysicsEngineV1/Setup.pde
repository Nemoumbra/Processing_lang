// This parameter defines whether the circles should have a visible border
boolean circle_stroke = false;

// This parameter defines whether clicking will result in new circles creation
boolean clicking_allowed = true;

// This part of code is used to handle circle objects
Circle objects[] = new Circle[0];
int obj_count = 0;

// Self-explanatory
boolean borders_on = true;

// The default borders are made here
Border border = new Border(20, 20, 880, 880);

// Self-explanatory
boolean stopped_time = true;

// Self-explanatory (the frame-by-frame lock being set prevents the engine from continuing to the next frame)
boolean fbf_debug_on = false;
boolean fbf_lock = false;

// Are circles affected by the uniform gravitational field equivalent to Earth's gravity
boolean uniform_grav_field = false;

// Is the vector of standard acceleration of free fall perpendicular to the "screen" plane
boolean perp_plane_g = false;

// The aforementioned vector is made here
PVector g = new PVector(0, 0.05);

// The friction coefficient of the dry and static friction forces that occur when g is facing "inside the screen"
float mu = 0.00;

// The percentage of total energy that the circles loose during a collision
float border_hit_loss = 0.0;

// Self-explanatory
boolean logging_on = false;

// Should Newton's law of universal gravitation be applied to circles
boolean gravity = true;
// The gravitational constant
float G = 20.0;

// This part of code is used to handle trajectories which represent trails that circles can leave behind
Trajectory trails[] = new Trajectory[0];
int trails_count = 0;

// Should the additional friction force be applied to the objects?
boolean air_friction = false;

// The friction coefficient of the Stokes' drag equation "vector F_drag = -k * vector v" 
// Note: k here is not considered to be dependent on the radius of the circle as Stoke's law suggests (k = 6 * PI * viscosity of the fluid * radius)
float air_fr_k = 0.005;

// The instance of cannon is made here
Cannon cannon = new Cannon(50, 862, 6, 1, #ff0000, new PVector(1, 0));

// The instance of rocket is made here
Rocket rocket = new Rocket(300, 870, #ff0000, #ffffff, new PVector(0, 6.9), 200, 15, 1);

// Is there an ongoing recording?
boolean recording = false;

//Put the the path to the folder where screenshots will be put
String record_path = "";

// The extension should be from the following list: ".tif", ".tga", ".jpg", or ".png".
String record_extension = ".png";

// The counter for recodrings made while the program is running
int recordings_finished = 0;
