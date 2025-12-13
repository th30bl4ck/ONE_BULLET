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

    open_levelup_menu();
}
