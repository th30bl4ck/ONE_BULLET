if (start == true){
    alarm[0] = 1
    start = false
}

var enemy_speed = move_speed;

sight = collision_line(x, y, obj_player.x, obj_player.y, obj_wall, false, false);

if (variable_instance_exists(id, "slowed") && slowed) {
    enemy_speed *= slow_multiplier;
}
    // SAFETY
if (global.levelup_active) exit;
if (!instance_exists(obj_player)) exit;



// TARGET DATA
px = obj_player.x;
py = obj_player.y;

dist      = point_distance(x, y, px, py);
to_player = point_direction(x, y, px, py);




// ORBIT DIRECTION TIMER
orbit_timer--;
if (orbit_timer <= 0)
{
    orbit_timer = orbit_timer_max;
    orbit_dir = choose(-1, 1);
}



// ORBIT TARGET DISTANCE 
orbit_dist_timer--;
if (orbit_dist_timer <= 0)
{
    orbit_dist_timer = orbit_dist_timer_max;

    orbit_target = irandom_range(orbit_min, orbit_max);

    if (irandom(1) == 0) orbit_dir = -orbit_dir;
}

desired_orbit_dist = lerp(desired_orbit_dist, orbit_target, orbit_dist_lerp);


//------------------------------------
// MOVEMENT
//------------------------------------
var ang = to_player; // default
enter_range = desired_orbit_dist + 80;

if (dist > enter_range)
{
    // Walk in
    alarm[0] = 1;
}
else
{
    tangential = to_player + 90 * orbit_dir;

    radial = (dist > desired_orbit_dist) ? to_player : to_player + 180;

    t = clamp(abs(dist - desired_orbit_dist) / 120, 0, 1) * approach_strength;

    ang = tangential + angle_difference(tangential, radial) * t;
}

var hspd = lengthdir_x(move_speed, ang);
var vspd = lengthdir_y(move_speed, ang);

if (place_meeting(x + hspd, y + vspd, obj_wall)){
    orbit_dir = -orbit_dir;
    
    if (dist <= enter_range){
        tangential = to_player + 90 * orbit_dir;
        ang = tangential + angle_difference(tangential, radial) * t;
        hspd = lengthdir_x(move_speed, ang); 
        vspd = lengthdir_y(move_speed, ang);
    }
}



// Apply movement
x += lengthdir_x(move_speed, ang);
y += lengthdir_y(move_speed, ang);



// SHOOTING
shoot_cd = max(0, shoot_cd - 1);

if (state == 0)
{
    if (dist <= shoot_range && shoot_cd <= 0 and sight == noone)
    {
        state = 1;
        windup = windup_max;
    }
}
else 
{
    windup--;

    if (windup <= 0)
    {
        var b = instance_create_layer(x, y, "Instances", obj_enemy_blob);
        b.dir = point_direction(x, y, px, py);

        shoot_cd = shoot_cd_max;
        state = 0;
    }
}


// Anchor target 
if (!instance_exists(obj_player)) exit;

if (!variable_instance_exists(id, "anchor_id"))
{
    anchor_id = irandom(3);
    anchor_jitter = irandom_range(-18, 18);
    anchor_claimed = false;
}

var ox = global.enemy_anchor_offsets[anchor_id][0];
var oy = global.enemy_anchor_offsets[anchor_id][1];

var tx = obj_player.x + ox;
var ty = obj_player.y + oy;

tx += anchor_jitter;
ty += anchor_jitter * 0.5;

// Shooter spacing movement

 
var prefer_dist = 140; 
var slack = 20;

var d = point_distance(x, y, tx, ty);
var dir = point_direction(x, y, tx, ty);

if (d > prefer_dist + slack)
{
    x += lengthdir_x(enemy_speed, dir);
    y += lengthdir_y(move_speed, dir);
}
else if (d < prefer_dist - slack)
{
    x -= lengthdir_x(enemy_speed, dir);
    y -= lengthdir_y(move_speed, dir);
}

if (place_meeting(x, y, obj_player)) {
    with (obj_player) {

        if (invuln <= 0) {
            take_damage(1);
            invuln = 60; 
            hit_flash_timer = 15;

            if (variable_global_exists("room_damage_taken")) {
                global.room_damage_taken += 1;
            }
        }

        // if HP is zero or below start death
        if (hp <= 0) {
            state = "dying";
            sprite_index = spr_player_death;
            image_index = 0;
            image_speed = 1;
        }
    }
}


// Face direction of player
if (obj_player.x > x) {
    image_xscale = 1;    // Face right
} else {
    image_xscale = -1;   // Face left
}

if (flash_red > 0)
{
    flash_red--;
}