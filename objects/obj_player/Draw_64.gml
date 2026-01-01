
if (!is_array(hp_frames)) hp_frames = [];
if (array_length(hp_frames) != max_hp)
{
    var old = hp_frames;
    hp_frames = array_create(max_hp, 0);

    var keep = min(array_length(old), max_hp);
    for (var k = 0; k < keep; k++) hp_frames[k] = old[k];

   
}


var count = max_hp;

var head_w  = sprite_get_width(spr_healthbar);
var padding = 6;
var spacing = head_w + padding;

var total_w = count * spacing - padding;
var start_x = display_get_gui_width() - total_w - 30;
var bar_y   = 40;

for (var i = 0; i < count; i++)
{
    draw_sprite(spr_healthbar, floor(hp_frames[i]), start_x + i * spacing, bar_y);
}

