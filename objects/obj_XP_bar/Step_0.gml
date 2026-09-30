if (global.levelup_active) exit;


if (global.xp >= global.xp_required)
{

    global.xp -= global.xp_required;

    global.level += 1;

    global.xp_required = round(global.xp_required * 1.5);

    open_levelup_menu();
}



