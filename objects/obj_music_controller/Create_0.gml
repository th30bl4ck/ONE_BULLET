persistent = true;

current_music = noone;
in_shop = false;

function play_music(_music)
{
    if (current_music == _music) exit;

    if (current_music != noone) {
        audio_stop_sound(current_music);
    }
    audio_play_sound(_music, 1, true);

    current_music = _music;
}