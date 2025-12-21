function open_levelup_menu()
{
    if (global.levelup_active) return;

    var upgrades = [
        "Move Speed +1",
        "Heal 1 HP",
        "Max HP +1",
        "Sticky Finger"
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
    switch (choice)
    {
        case "Move Speed +1":
            with (obj_player) { move_speed += 1; }
        break;

        case "Heal 1 HP":
            with (obj_player)
            {
                hp = min(max_hp, hp + 1);
                hp_display = hp;
            }
        break;

        case "Max HP +1":
            with (obj_player)
            {
                max_hp += 1;
                hp = max_hp;
                hp_display = hp;
            }
        break;

        case "Sticky Finger":
            global.xp_attract_range += 16;
            with (obj_XP)
            {
                attract_range = global.xp_attract_range;
            }
        break;
    }
}
