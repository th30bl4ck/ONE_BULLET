// Only make noise if alive
if (!dead)
{
    audio_play_sound(snd_splitter_walk, 1, false);

    // Restart timer
    alarm[0] = room_speed * 0.75;
}