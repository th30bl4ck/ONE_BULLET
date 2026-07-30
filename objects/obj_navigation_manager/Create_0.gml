if (instance_number(obj_navigation_manager) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;

if (!variable_global_exists("nav_cell_size")) global.nav_cell_size = 32;
if (!variable_global_exists("nav_blocker_objects")) global.nav_blocker_objects = [obj_wall];
global.nav_grid = noone;
global.nav_grid_room = noone;
global.nav_grid_cell_size = global.nav_cell_size;
global.nav_grid_cols = 0;
global.nav_grid_rows = 0;

scr_nav_build_for_room();
