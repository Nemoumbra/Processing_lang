// This Processing function is run first
void setup() {
  size(900,900);
  background(0);
  cannon.setPower(5);
  
  rocket.start_engines();
  G = 0.01;
}

// This Processing function is run repeatedly after setup and is terminated once the window is closed
void draw() {
   // We need to redraw the frame
   background(0);
   
   // Write some data to screen (user interface)
   textSize(22);
   fill(10, 100, 10);
   text("Uniform gravity on: " + uniform_grav_field, 38, 45);
   fill(110, 40, 40);
   text("Time stopped: " + stopped_time, 645, 45);
   
   if (recording) {
     stroke(110, 40, 40);
     text("REC", 645, 70);
     circle(700, 62, 10);
   }
   
   fill(110, 110, 0);
   text("Air friction on: " + air_friction, 40, 70);
   
   if (fbf_debug_on) {
     fill(40, 40, 100);
     text("Frame-by-frame debug on", 305, 45);
   }
   
   
   // draw trajectories
   if (!(stopped_time || fbf_lock)) {
     for (Trajectory traj : trails) {
       traj.save_new();
       traj.draw();
     }
   }
   
   // draw cannon
   cannon.draw();
   
   // apply forces
   //for rocket we only count air drag and uniform gravity now
   if (!(stopped_time || fbf_lock || rocket.immovable)) {
     PVector rocket_forces = new PVector(0, 0);
     if (uniform_grav_field && !perp_plane_g && rocket.position.y + 10 < border.right_bottom.y) {
       rocket_forces.add(PVector.mult(g, rocket.cur_mass));
     }
     if (air_friction) {
       rocket_forces.add(PVector.mult(rocket.speed, -air_fr_k));
     }
     rocket.move(rocket_forces);
     if (rocket.position.y - 10 <= border.left_up.y) {
       rocket.immovable = true;
       rocket.speed.y = 0;
       rocket.stop_engines();
     }
     if (rocket.position.y + 10 >= border.right_bottom.y) {
       rocket.position.y = border.right_bottom.y - 10;
     }
   }
   
   // draw rocket
   rocket.draw();
   
   // draw borders
   if (borders_on) {
     border.draw();
   }
   
   // prepare circles
   if (!(stopped_time || fbf_lock)) {
     for (Circle circle: objects) {
       circle.acceleration.x = 0;
       circle.acceleration.y = 0;
     }
   }
   
   // apply forces if the time isn't stopped and frame-by-frame debug lock doesn't prevent the continuation
   for (int i = 0; i < obj_count; i++) {
       if (!(stopped_time || fbf_lock)) {
       
         // uniform gravity field
         if (uniform_grav_field && !perp_plane_g && !objects[i].immovable) {
           objects[i].acceleration.add(g);
         }
         
         //now general gravity/Kulon's forces:
         if (gravity) {
           for (int j = i+1; j < obj_count; j++) {
             PVector obj_i_obj_j = PVector.sub(objects[j].position, objects[i].position);
             float r_squared = obj_i_obj_j.magSq();
             obj_i_obj_j.normalize();
             
             if (!objects[i].immovable) {
               objects[i].acceleration.add(PVector.mult(obj_i_obj_j, G*objects[j].mass/r_squared));
             }
             if (!objects[j].immovable) {
               objects[j].acceleration.add(PVector.mult(obj_i_obj_j, -G*objects[i].mass/r_squared));
             }
           }
         }
         
         //now air friction
         if (air_friction) {
           objects[i].acceleration.add(PVector.mult(objects[i].speed, -air_fr_k / objects[i].mass));
         }
         
         
         //dry and staic friction have to be computed after others.
         if (uniform_grav_field && perp_plane_g) {
           if (objects[i].acceleration.mag() <= mu * g.mag()) {
             objects[i].acceleration.x = 0;
             objects[i].acceleration.y = 0;
           }
           else {
             if (objects[i].speed.mag() > 0) {
               objects[i].acceleration.add(PVector.mult(objects[i].speed, -mu * g.mag() / objects[i].speed.mag()));
             }
           }
         }
         // Move the circles
         objects[i].move();
       }
       else {
         // Either way, the circles must be drawn
         objects[i].draw();
       }
   }
   
   // Collision detection and resolving
   if (!(stopped_time || fbf_lock)) {
     //check collisions with O(n^2) approach
     for (int i = 0; i < obj_count; i++) {
       for (int j = i+1; j < obj_count; j++) {
         float var = distance_squared(objects[i].position.x, objects[i].position.y, objects[j].position.x, objects[j].position.y);
         if (var <= (objects[i].r + objects[j].r)*(objects[i].r + objects[j].r)) {
         
           // Точка между центрами полагается точкой удара. Дальше ЗСИ и ЗСЭ. Пока что абсолютно упругий удар и нет потерь на тепло.
           // Всё происходит в вертикальной плоскости, трения между телами нет => движение поступательное
           // Мы не считаем, что надо сразу учитывать удар тела о несколько других. Да, возможно, будет небольшая беда.
           
           //English version:
           // The point between the centers is assumed to be the point of impact. Then the laws of energy and momentum conservation come into play.
           // This far we want the collision to be perfectly elastic, there are no energy conversions into heat. Everything occurs in the vertical plane,
           // there is no friction between circles => the motion is translational
           // We don't consider the need to account for the simultaneous collisions between one circle and a few other circles. 
           // Yes, this may result in a possibility of a slight problem arising later.
           
           //stopped_time = true;
           PVector O1O2 = PVector.sub(objects[j].position, objects[i].position);
           
           //print("Debug started: \nO1O2 :", O1O2, "\n");
           
           //Below code is rendered unusable due to this simple correction:
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
         }
       }
       //now check borders
       if (borders_on && !objects[i].immovable) {
         
         if (objects[i].position.x - objects[i].r <= border.left_up.x) {
           if (logging_on) {
             print("Left border hit start! Speed: ", objects[i].speed, "\n");
           }
           
           if (objects[i].projectile) {
             objects[i].immovable = true;
             objects[i].speed.x = 0;
             objects[i].speed.y = 0;
           }
           else {
             objects[i].speed.x *= -1;
             objects[i].speed.mult(sqrt(1 - border_hit_loss));
           }
           
           if (logging_on) {
             print("Left border hit end! Speed: ", objects[i].speed, "\n");
           }
         }
         
         if (objects[i].position.y - objects[i].r <= border.left_up.y) {
           if (logging_on) {
             print("Up border hit start! Speed: ", objects[i].speed, "\n");
           }
           
           if (objects[i].projectile) {
             objects[i].immovable = true;
             objects[i].speed.x = 0;
             objects[i].speed.y = 0;
           }
           else {
             objects[i].speed.y *= -1;
             objects[i].speed.mult(sqrt(1 - border_hit_loss));
           }
           
           if (logging_on) {
             print("Up border hit end! Speed: ", objects[i].speed, "\n");
           }
         }
         
         if (objects[i].position.x + objects[i].r >= border.right_bottom.x) {
           if (logging_on) {
             print("Right border hit start! Speed: ", objects[i].speed, "\n");
           }
           
           if (objects[i].projectile) {
             objects[i].immovable = true;
             objects[i].speed.x = 0;
             objects[i].speed.y = 0;
           }
           else {
             objects[i].speed.x *= -1;
             objects[i].speed.mult(sqrt(1 - border_hit_loss));
           }
           
           if (logging_on) {
             print("Right border hit end! Speed: ", objects[i].speed, "\n");
           }
         }
         
         if (objects[i].position.y + objects[i].r >= border.right_bottom.y) {
           if (logging_on) {
             print("Bottom border hit start! Speed: ", objects[i].speed, "\n");
           }
           
           if (objects[i].projectile) {
             objects[i].immovable = true;
             objects[i].speed.x = 0;
             objects[i].speed.y = 0;
           }
           else {
             objects[i].speed.x *= -1;
             objects[i].speed.mult(sqrt(1 - border_hit_loss));
           }
           
           if (logging_on) {
             print("Bottom border hit end! Speed: ", objects[i].speed, "\n");
           }
         }
       }
     }
     
     // The lock is reset here
     if (fbf_debug_on && !fbf_lock) {
       fbf_lock = true;
     }
   }
   // Saves a screenshot of the window to the disk
   if (recording) {
     saveFrame(String.join("", record_path, "simulation_", str(recordings_finished), "_####", record_extension));
   }
}
