function scr_shop(_cost)
{
    if (!variable_global_exists("coins")) {
        global.coins = 0;
    }

    if (global.coins >= _cost) {
        global.coins -= _cost;
        return true;
    }

    return false;
}
