persistent = true;

current_music = noone;
in_shop = false;

function play_music(_music)
{
    if (current_music == _music) exit;

    audio_stop_all();
    audio_play_sound(_music, 1, true);

    current_music = _music;
}