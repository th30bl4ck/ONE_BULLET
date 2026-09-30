event_inherited();

move_speed = 0.5;
hp = 20;
xp_value = 5; 
image_xscale = 2;   
image_yscale = 2;

mid_range = 250;           
shield_deployed = false;   

shield = instance_create_depth(x, y, depth-10, obj_enemy_shield);
shield.owner = id;         

path = path_add();
ai_enabled = true;