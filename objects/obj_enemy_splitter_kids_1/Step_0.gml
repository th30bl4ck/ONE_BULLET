if (global.note_open) exit;

if (global.levelup_active) exit;

if (!ai_enabled) exit;


var p = obj_player;
direction = point_direction(x, y, p.x, p.y);
x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);

if (place_meeting(x, y, obj_player)) {
    with (obj_player) {

        // only take damage if not invulnerable
        if (invuln <= 0) {
            take_damage(1);
            invuln = 30; // half-second of safety
            hit_flash_timer = 15;

            if (variable_global_exists("room_damage_taken")) {
                global.room_damage_taken += 1;
            }


        }

        // if HP is zero or below → start death
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


var d_player = point_distance(x, y, obj_player.x, obj_player.y);


if (d_player >= last_player_dist - 0.2)
    stuck_timer++;
else
    stuck_timer = 0;

last_player_dist = d_player;


var anchor_snap = 20; 
if (point_distance(x, y, tx, ty) <= anchor_snap || stuck_timer >= 15)
{
    tx = obj_player.x;
    ty = obj_player.y;
}


var dir = point_direction(x, y, tx, ty);

x += lengthdir_x(move_speed, dir);
y += lengthdir_y(move_speed, dir);