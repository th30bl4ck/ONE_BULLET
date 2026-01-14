//------------------------------------
// SAFETY
//------------------------------------
if (global.levelup_active) exit;
if (!instance_exists(obj_player)) exit;


//------------------------------------
// TARGET DATA
//------------------------------------
var px = obj_player.x;
var py = obj_player.y;

var dist      = point_distance(x, y, px, py);
var to_player = point_direction(x, y, px, py);
scr_enemy_separation();


//------------------------------------
// ORBIT DIRECTION TIMER (prevents twitching)
//------------------------------------
orbit_timer--;
if (orbit_timer <= 0)
{
    orbit_timer = orbit_timer_max;
    orbit_dir = choose(-1, 1);
}


//------------------------------------
// ORBIT TARGET DISTANCE 
//------------------------------------
orbit_dist_timer--;
if (orbit_dist_timer <= 0)
{
    orbit_dist_timer = orbit_dist_timer_max;

    // pick a new target distance inside THIS shooter's band
    orbit_target = irandom_range(orbit_min, orbit_max);

    // occasional direction flip helps variety
    if (irandom(1) == 0) orbit_dir = -orbit_dir;
}

// smoothly drift toward target distance (no snapping)
desired_orbit_dist = lerp(desired_orbit_dist, orbit_target, orbit_dist_lerp);


//------------------------------------
// MOVEMENT
//------------------------------------
var ang = to_player; // default
var enter_range = desired_orbit_dist + 80;

if (dist > enter_range)
{
    // Walk in
    ang = to_player;
}
else
{
    // Tangential orbit angle
    var tangential = to_player + 90 * orbit_dir;

    // Radial correction: in/out to maintain desired distance
    var radial = (dist > desired_orbit_dist) ? to_player : to_player + 180;

    // Blend amount: 0 near perfect distance, 1 when far off
    var t = clamp(abs(dist - desired_orbit_dist) / 120, 0, 1) * approach_strength;

    // Angle blend using angle_difference (works on all GM versions)
    ang = tangential + angle_difference(tangential, radial) * t;
}

// Apply movement
x += lengthdir_x(move_spd, ang);
y += lengthdir_y(move_spd, ang);


//------------------------------------
// SHOOTING
//------------------------------------
shoot_cd = max(0, shoot_cd - 1);

if (state == 0)
{
    if (dist <= shoot_range && shoot_cd <= 0)
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



