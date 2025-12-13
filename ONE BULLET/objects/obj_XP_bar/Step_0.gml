if (global.levelup_active) exit;

// LEVEL UP CHECK
if (global.xp >= global.xp_required)
{
    // Remove the cost
    global.xp -= global.xp_required;

    // Increase level
    global.level += 1;

    // Increase XP required for next level
    global.xp_required = round(global.xp_required * 1.5);

    // OPTIONAL: play a sound or flash
    // audio_play_sound(snd_levelup, 1, false);

    open_levelup_menu();
}
