function scr_get_combo_xp_multiplier(_combo) {
    if (_combo >= 15) return 1.75;
    if (_combo >= 10) return 1.5;
    if (_combo >= 5)  return 1.25;
    if (_combo >= 3)  return 1.1;
    return 1;
}