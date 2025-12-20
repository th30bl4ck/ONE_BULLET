if (!variable_global_exists("coins")) {
    global.coins = 0;
}

global.coins += 1;
instance_destroy();
