instance_create_layer(x, y, layer, obj_death_animation_plitter);
dead = true;

// Play death sound
audio_play_sound(snd_splitter_die, 1, false);

// Destroy enemy
instance_destroy();