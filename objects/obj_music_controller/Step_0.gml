// ===============================
// MUTE
// ===============================

if (global.sound_muted)
{
    audio_master_gain(0);
}
else
{
    audio_master_gain(1);
}


// ===============================
// BOSS DEATH MUSIC1
// ===============================

if (boss_death_music)
{
    // Don't let the normal music system override the
    // boss death section.
    exit;
}


// ===============================
// BOSS ROOM1
// ===============================

if (boss_music)
{
    play_music(snd_boss1);
}
else if (in_shop)
{
    play_music(snd_music_shop);
}
else if (instance_number(obj_enemy_parent) > 0)
{
    play_music(snd_music_combat);
}
else
{
    play_music(snd_music_general);
}


// ===============================
// 1 HP MUSIC BOOST
// ===============================

var music_gain = 1;

if (variable_global_exists("player_health"))
{
    if (is_struct(global.player_health))
    {
        if (global.player_health.current == 1)
        {
            music_gain = 1.5;
        }
    }
}

if (current_music_instance != noone)
{
    audio_sound_gain(current_music_instance, music_gain, 0);
}