if (!variable_global_exists("coins")) {
    global.coins = 0;
}

global.coins += 1;
audio_play_sound(snd_coinz, 1, false);
instance_destroy();
