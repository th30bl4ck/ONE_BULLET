hp = 100;

hsp = 0;
vsp = 0;

slowed = false;
slow_timer = 0;
slow_multiplier = 1;

if (!variable_instance_exists(id, "base_speed")) {
    base_speed = move_speed;
}

;
hsp = 0;
vsp = 0;