function open_levelup_menu()
{
    if (global.levelup_active) return;

    var can_offer_medkit = false;
    if (variable_global_exists("player_health") && is_struct(global.player_health))
    {
        can_offer_medkit = global.player_health.current < global.player_health.max;
    }

    if (instance_exists(obj_player))
    {
        var player = instance_find(obj_player, 0);
        if (variable_instance_exists(player, "hp") && variable_instance_exists(player, "max_hp"))
        {
            can_offer_medkit = player.hp < player.max_hp;
        }
    }

    var upgrades = [
        "Rollershoes",
        "Stim",
        "Sticky Finger",
        "Big Boy Boots",
        "Magnet Core",
        "Trigger Finger",
        "Long Barrel"
    ];

    if (can_offer_medkit)
    {
        array_push(upgrades, "Medkit");
    }

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
     if (!instance_exists(obj_player)) return;
     if (!variable_global_exists("upgrade_counts"))
    {
        global.upgrade_counts = ds_map_create();
    }

    if (!variable_global_exists("xp_attract_range")) global.xp_attract_range = 64;
    if (!variable_global_exists("player_move_speed_bonus")) global.player_move_speed_bonus = 0;
    if (!variable_global_exists("player_dash_time_bonus")) global.player_dash_time_bonus = 0;
    if (!variable_global_exists("recall_speed")) global.recall_speed = 6;
    if (!variable_global_exists("player_bullet_speed")) global.player_bullet_speed = 10;
    if (!variable_global_exists("bullet_max_distance")) global.bullet_max_distance = 300;

    if (choice == "Medkit")
    {
        var can_use_medkit = false;
        if (variable_global_exists("player_health") && is_struct(global.player_health))
        {
            can_use_medkit = global.player_health.current < global.player_health.max;
        }

        var player = instance_find(obj_player, 0);
        if (variable_instance_exists(player, "hp") && variable_instance_exists(player, "max_hp"))
        {
            can_use_medkit = player.hp < player.max_hp;
        }

        if (!can_use_medkit) return;
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
        case "Rollershoes":
            global.player_move_speed_bonus += 1;
            with (obj_player) { move_speed = 3 + global.player_move_speed_bonus + global.JS_bonus; }
        break;

        case "Medkit":
        with (obj_player)
        {
        heal_hp(1);
        }
        break;


        case "Stim":
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
            global.player_dash_time_bonus += 2;
            with (obj_player)
            {
                dash_time = 8 + global.player_dash_time_bonus;
            }
        break;
    
        case "Magnet Core":
           global.recall_speed += 4;
        break;
    
        case "Trigger Finger":
           global.player_bullet_speed += 2;
        break;
        
        case "Long Barrel":
            global.bullet_max_distance += 150;
        break;
    }
}
