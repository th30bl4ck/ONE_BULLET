if (global.sound_muted)
{
    audio_master_gain(0);
}
else
{
    audio_master_gain(1);
}if (in_shop)

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
