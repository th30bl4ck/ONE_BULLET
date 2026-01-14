// Movement speeds
walk_speed = 1.5;
dash_speed = 12;

// Ranges
mid_range = 250;   // starts charge when player is within this distance

// Timing
charge_time = 25;  // frames to wind-up
charge_timer = 0;

// State
state = "chase";

cooldown_time = 45;   // frames
cooldown_timer = 0;

xp_value = 5; 

// --- Enemy separation settings ---
sep_radius      = 14;   
sep_strength    = 0.55; 
sep_max_push    = 2.5;  
sep_refresh_mod = 3;    


sep_neigh = ds_list_create();
sep_tick  = irandom(sep_refresh_mod - 1);
