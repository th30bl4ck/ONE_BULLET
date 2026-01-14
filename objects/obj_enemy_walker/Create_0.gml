move_speed = 1.5;

ai_enabled = true;

xp_value = 3; 

// --- Enemy separation settings ---
sep_radius      = 14;   
sep_strength    = 0.55; 
sep_max_push    = 2.5;  
sep_refresh_mod = 3;    


sep_neigh = ds_list_create();
sep_tick  = irandom(sep_refresh_mod - 1);
