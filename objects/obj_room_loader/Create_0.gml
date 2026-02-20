var TW = 25; // your tile width
var TH = 40; // your tile height

// Load CSV strings (from Included Files)
var floor_csv = scr_load_text_file("out_room/floor.csv");
var walls_csv = scr_load_text_file("out_room/walls.csv");

show_debug_message("floor exists: " + string(file_exists("out_room/floor.csv")));
show_debug_message("walls exists: " + string(file_exists("out_room/walls.csv")));

show_debug_message("floor len: " + string(string_length(floor_csv)));
show_debug_message("walls len: " + string(string_length(walls_csv)));

show_debug_message("floor first line: " + string_copy(floor_csv, 1, 80));
show_debug_message("walls first line: " + string_copy(walls_csv, 1, 80));

if (floor_csv == "" || walls_csv == "")
{
    show_debug_message("CSV load failed. Check Included Files paths.");
    exit;
}

// Parse to grids
var floor_grid = scr_csv_to_grid(floor_csv);
var walls_grid = scr_csv_to_grid(walls_csv);

// Get tilemap IDs
var floor_layer_id = layer_get_id("Layer_Floor");
var walls_layer_id = layer_get_id("Layer_Walls");

var floor_map = layer_tilemap_get_id(floor_layer_id);
var walls_map = layer_tilemap_get_id(walls_layer_id);

tilemap_clear(floor_map, -1);
tilemap_clear(walls_map, -1);

// Paint tiles
scr_paint_tilemap(floor_map, floor_grid, TW, TH);
scr_paint_tilemap(walls_map, walls_grid, TW, TH);

show_debug_message("Room imported from CSV ✅");