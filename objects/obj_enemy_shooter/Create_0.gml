shoot_range = 400;

shoot_cd_max = room_speed * 1.2;
shoot_cd = irandom(shoot_cd_max); 

windup_max = round(room_speed * 0.5);
windup = 0;

state = 0; 

orbit_dir = choose(-1, 1);         
orbit_timer_max = room_speed * 2;  
orbit_timer = irandom(orbit_timer_max);

orbit_strength = 1.0;             
approach_strength = 0;           
desired_orbit_dist = 380;         
move_spd = 1.4;


orbit_min = 140;
orbit_max = 260;


orbit_target = irandom_range(orbit_min, orbit_max);


orbit_dist_timer_max = room_speed * 2;   
orbit_dist_timer = irandom(orbit_dist_timer_max);


orbit_dist_lerp = 0.04;

desired_orbit_dist = orbit_target;

// --- Enemy separation settings ---
sep_radius      = 14;   
sep_strength    = 0.55; 
sep_max_push    = 2.5;  
sep_refresh_mod = 3;    


sep_neigh = ds_list_create();
sep_tick  = irandom(sep_refresh_mod - 1);
