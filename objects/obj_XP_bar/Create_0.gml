global.levelup_active = false;
global.choice_1 = "";
global.choice_2 = "";


if (!variable_global_exists("upgrade_icons"))
{
    global.upgrade_icons = ds_map_create();
    global.upgrade_icons[? "Move Speed +1"] = rollershoes;
    global.upgrade_icons[? "Heal 1 HP"]     = used_medkit;
    global.upgrade_icons[? "Max HP +1"]     = spr_health;
    global.upgrade_icons[? "Sticky Finger"] = stickysock;
    global.upgrade_icons[? "Big Boy Boots"] = spr_bigboyboots;
}
