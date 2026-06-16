if (instance_exists(obj_player))
{
    var dist = point_distance(x, y, obj_player.x, obj_player.y);

    if (dist < 300)
    {
        var snd = audio_play_sound(snd_enemy_grunt, 0, false);

        // Convert distance to volume
        var vol = 1 - (dist / 300);

        // Clamp between 0 and 1
        vol = clamp(vol, 0, 1);

        audio_sound_gain(snd, vol, 0);
    }
}

alarm[0] = irandom_range(room_speed, room_speed * 3);