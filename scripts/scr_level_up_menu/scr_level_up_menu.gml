function open_levelup_menu()
{
    if (global.levelup_active) return;

    var upgrades = [
        "Rollershoes",
        "Medkit",
        "Stim",
        "Sticky Finger",
        "Big Boy Boots",
        "Magnet Core",
        "Trigger Finger"
    ];

    var upgrade_count = array_length(upgrades);

    global.choice_1 = upgrades[irandom(upgrade_count - 1)];
    global.choice_2 = global.choice_1;

    // Ensure the two choices are different
    repeat (10)
    {
        global.choice_2 = upgrades[irandom(upgrade_count - 1)];
        if (global.choice_2 != global.choice_1) break;
    }

    global.levelup_active = true;
}

function close_levelup_menu()
{
    global.levelup_active = false;
}

function scr_apply_upgrade(choice)
{
    if (!variable_global_exists("upgrade_counts"))
    {
        global.upgrade_counts = ds_map_create();
    }

    if (ds_map_exists(global.upgrade_counts, choice))
    {
        global.upgrade_counts[? choice] += 1;
    }
    else
    {
        global.upgrade_counts[? choice] = 1;
    }

    switch (choice)
    {
        case "rollershoes":
            with (obj_player) { move_speed += 1; }
        break;

case "medkit":
    with (obj_player)
    {
        heal_hp(1);
    }
break;


        case "stim":
    with (obj_player)
    {
        increase_max_hp(1); // adds a new head
    }
break;


        case "Sticky Finger":
            global.xp_attract_range += 16;
            with (obj_XP)
            {
                attract_range = global.xp_attract_range;
            }
        break;

        case "Big Boy Boots":
            with (obj_player)
            {
                dash_time += 2;
            }
        break;
    
    case "Magnet Core":
           global.recall_speed += 4;
        break;
    
        case "trigger finger":
           global.bullet_speed += 4;
        break;
    }
}
