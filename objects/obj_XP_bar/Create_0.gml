global.levelup_active = false;
global.choice_1 = "";
global.choice_2 = "";


if (!variable_global_exists("upgrade_icons"))
{
    global.upgrade_icons = ds_map_create();
    global.upgrade_icons[? "Rollershoes"] = spr_rollershoes;
    global.upgrade_icons[? "Medkit"]     = spr_used_medkit;
    global.upgrade_icons[? "Stim"]     = spr_health;
    global.upgrade_icons[? "Sticky Finger"] = spr_stickysock;
    global.upgrade_icons[? "Big Boy Boots"] = spr_bigboyboots;
    global.upgrade_icons[? "Magnet Core"] = spr_magnet_core;
    global.upgrade_icons[? "Trigger Finger"] = spr_tf;
}

if (!variable_global_exists("upgrade_counts"))
{
    global.upgrade_counts = ds_map_create();
}


