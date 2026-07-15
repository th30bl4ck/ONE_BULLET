max_hp = 500;
hp = max_hp;
boss_name = "ABOMINATION";

state = "idle";
attack_cooldown = room_speed;
attack_timer = 0;
attack_index = 0;

facing = 1;
hsp = 0;
vsp = 0;

bounce_hits = 0;
bounce_max_hits = 5;
bounce_speed = 9;

dash_speed = 14;
dash_time = 26;
dash_dir = 0;

spit_done = false;
spit_count = 3;
spit_spread = 18;

hit_flash_timer = 0;
bar_beat_timer = 0;
death_timer = room_speed * 2;
touch_damage_cooldown = 0;

sprite_index = spr_f_f_f_right;
image_speed = 0.2;

function boss_set_sprite(_sprite, _speed, _restart)
{
    if (sprite_index != _sprite || _restart)
    {
        sprite_index = _sprite;
        image_index = 0;
    }

    image_speed = _speed;
}

function boss_face_player()
{
    if (!instance_exists(obj_player)) return;

    facing = (obj_player.x >= x) ? 1 : -1;

    if (facing == 1)
    {
        boss_set_sprite(spr_f_f_f_right, 0.2, false);
    }
    else
    {
        boss_set_sprite(spr_f_f_f_left, 0.2, false);
    }
}

function boss_start_idle(_cooldown)
{
    state = "idle";
    attack_cooldown = _cooldown;
    hsp = 0;
    vsp = 0;
    boss_face_player();
}

function boss_start_bounce()
{
    state = "bounce";
    bounce_hits = 0;

    var dir = irandom_range(0, 359);
    if (instance_exists(obj_player))
    {
        dir = point_direction(x, y, obj_player.x, obj_player.y) + irandom_range(-20, 20);
    }

    hsp = lengthdir_x(bounce_speed, dir);
    vsp = lengthdir_y(bounce_speed, dir);
    boss_set_sprite(spr_bounce, 0.35, true);
}

function boss_start_dash()
{
    state = "dash_windup";
    attack_timer = 24;
    boss_face_player();

    if (facing == 1)
    {
        boss_set_sprite(spr_f_f_f_build_up_R, 0.35, true);
    }
    else
    {
        boss_set_sprite(spr_f_f_f_build_up_L, 0.35, true);
    }
}

function boss_start_spit()
{
    state = "spit_windup";
    attack_timer = 28;
    spit_done = false;
    boss_face_player();

    if (facing == 1)
    {
        boss_set_sprite(spr_spitr, 0.25, true);
    }
    else
    {
        boss_set_sprite(spr_spitL, 0.25, true);
    }
}

function boss_die()
{
    state = "dead";
    hsp = 0;
    vsp = 0;
    hp = 0;
    boss_set_sprite(spr_boss_defeat, 0.25, true);

    with (obj_door_parent)
    {
        unlocked = true;
    }
}
