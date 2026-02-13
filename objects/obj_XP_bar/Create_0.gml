global.levelup_active = false;
global.choice_1 = "";
global.choice_2 = "";


if (!variable_global_exists("upgrade_icons"))
{
    global.upgrade_icons = ds_map_create();
    global.upgrade_icons[? "rollershoes"] = spr_rollershoes;
    global.upgrade_icons[? "medkit"]     = spr_used_medkit;
    global.upgrade_icons[? "stim"]     = spr_health;
    global.upgrade_icons[? "Sticky Finger"] = spr_stickysock;
    global.upgrade_icons[? "Big Boy Boots"] = spr_bigboyboots;
    global.upgrade_icons[? "Magnet Core"] = spr_magnet_core;
}

if (!variable_global_exists("upgrade_counts"))
{
    global.upgrade_counts = ds_map_create();
}


