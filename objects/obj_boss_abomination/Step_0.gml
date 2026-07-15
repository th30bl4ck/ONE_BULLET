if (global.levelup_active) exit;
if (variable_global_exists("note_open") && global.note_open) exit;

if (hit_flash_timer > 0) hit_flash_timer--;
if (bar_beat_timer > 0) bar_beat_timer--;
if (touch_damage_cooldown > 0) touch_damage_cooldown--;

if (state == "dead")
{
    death_timer--;

    if (death_timer <= 0)
    {
        instance_destroy();
    }

    exit;
}

if (hp <= 0)
{
    boss_die();
    exit;
}

if (!instance_exists(obj_player))
{
    boss_start_idle(room_speed);
    exit;
}

if (touch_damage_cooldown <= 0 && place_meeting(x, y, obj_player))
{
    with (obj_player)
    {
        if (invuln <= 0)
        {
            take_damage(1);
            invuln = 45;
            hit_flash_timer = 15;

            if (variable_global_exists("room_damage_taken"))
            {
                global.room_damage_taken += 1;
            }
        }

        if (hp <= 0)
        {
            state = "dying";
            sprite_index = spr_player_death;
            image_index = 0;
            image_speed = 1;
        }
    }

    touch_damage_cooldown = 20;
}

if (state == "idle")
{
    boss_face_player();
    attack_cooldown--;

    var drift_dir = point_direction(x, y, obj_player.x, obj_player.y);
    x += lengthdir_x(0.8, drift_dir);
    y += lengthdir_y(0.8, drift_dir);

    if (attack_cooldown <= 0)
    {
        attack_index = (attack_index + 1) mod 3;

        if (attack_index == 0)
        {
            boss_start_bounce();
        }
        else if (attack_index == 1)
        {
            boss_start_dash();
        }
        else
        {
            boss_start_spit();
        }
    }
}
else if (state == "bounce")
{
    x += hsp;
    y += vsp;

    var pad = 24;
    var hit_wall = false;

    if (x < pad)
    {
        x = pad;
        hsp = abs(hsp);
        hit_wall = true;
    }
    else if (x > room_width - pad)
    {
        x = room_width - pad;
        hsp = -abs(hsp);
        hit_wall = true;
    }

    if (y < pad)
    {
        y = pad;
        vsp = abs(vsp);
        hit_wall = true;
    }
    else if (y > room_height - pad)
    {
        y = room_height - pad;
        vsp = -abs(vsp);
        hit_wall = true;
    }

    if (hit_wall)
    {
        bounce_hits++;
        bar_beat_timer = 8;
    }

    if (bounce_hits >= bounce_max_hits)
    {
        boss_start_idle(room_speed * 0.75);
    }
}
else if (state == "dash_windup")
{
    attack_timer--;
    boss_face_player();

    if (facing == 1)
    {
        boss_set_sprite(spr_f_f_f_build_up_R, 0.35, false);
    }
    else
    {
        boss_set_sprite(spr_f_f_f_build_up_L, 0.35, false);
    }

    if (attack_timer <= 0)
    {
        state = "dash";
        attack_timer = dash_time;
        dash_dir = point_direction(x, y, obj_player.x, obj_player.y);

        if (lengthdir_x(1, dash_dir) >= 0)
        {
            facing = 1;
            boss_set_sprite(spr_dash_right, 0.5, true);
        }
        else
        {
            facing = -1;
            boss_set_sprite(spr_dash_left, 0.5, true);
        }
    }
}
else if (state == "dash")
{
    attack_timer--;

    x += lengthdir_x(dash_speed, dash_dir);
    y += lengthdir_y(dash_speed, dash_dir);

    x = clamp(x, 24, room_width - 24);
    y = clamp(y, 24, room_height - 24);

    if (attack_timer <= 0)
    {
        boss_start_idle(room_speed * 0.7);
    }
}
else if (state == "spit_windup")
{
    attack_timer--;
    boss_face_player();

    if (facing == 1)
    {
        boss_set_sprite(spr_spitr, 0.25, false);
    }
    else
    {
        boss_set_sprite(spr_spitL, 0.25, false);
    }

    if (!spit_done && attack_timer <= 12)
    {
        spit_done = true;
        var base_dir = point_direction(x, y, obj_player.x, obj_player.y);

        for (var i = 0; i < spit_count; i++)
        {
            var offset = (i - (spit_count - 1) * 0.5) * spit_spread;
            var b = instance_create_layer(x + facing * 54, y + 8, "Instances", obj_enemy_blob);
            b.dir = base_dir + offset;
            b.spd = 6.5;
            b.life = room_speed * 3;
            b.sprite_index = (facing == 1) ? spr_boss_spit_right : spr_spit_left;
            b.image_xscale = 1.5;
            b.image_yscale = 1.5;
            b.image_angle = b.dir;
        }
    }

    if (attack_timer <= 0)
    {
        boss_start_idle(room_speed);
    }
}

x = clamp(x, 16, room_width - 16);
y = clamp(y, 16, room_height - 16);
