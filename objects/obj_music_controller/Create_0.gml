persistent = true;

current_music = noone;
current_music_instance = noone;

in_shop = false;
boss_music = false;
boss_death_music = false;

global.sound_muted = false;

function play_music(_music)
{
    if (current_music == _music && current_music_instance != noone)
    {
        return;
    }

    audio_stop_all();

    current_music_instance = audio_play_sound(_music, 1, true);
    current_music = _music;
}

function play_boss_death_music()
{
    // Stop the current boss music
    if (current_music_instance != noone)
    {
        audio_stop_sound(current_music_instance);
    }

    // Start boss music again
    current_music_instance = audio_play_sound(snd_boss1, 1, false);
    current_music = snd_boss1;

    // Jump to the final 20 seconds
    var boss_length = audio_sound_length(snd_boss1);
    var death_start = max(0, boss_length - 20);

    audio_sound_set_track_position(current_music_instance, death_start);

    boss_death_music = true;
}