var hp_now = hp;
var hp_max = max_hp;

var count = hp_max;

var head_w  = sprite_get_width(spr_healthbar);
var padding = 6;
var spacing = head_w + padding;

var total_w = count * spacing - padding;
var start_x = display_get_gui_width() - total_w - 30;
var bar_y   = 40;

var frames = sprite_get_number(spr_healthbar); 
var frame_full  = 0;           // FIRST frame
var frame_empty = frames - 1;  // LAST frame

for (var i = 0; i < count; i++)
{
    var frame = (i < hp_now) ? frame_full : frame_empty;

    draw_sprite(spr_healthbar, frame, start_x + i * spacing, bar_y);
}

