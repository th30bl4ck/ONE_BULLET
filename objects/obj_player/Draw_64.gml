var head_w  = sprite_get_width(spr_healthbar);
var padding = 6;
var spacing = head_w + padding;

var count = min(max_hp, array_length(hp_segments));
var total_w = count * spacing - padding;
var start_x = display_get_gui_width() - total_w - 30;
var bar_y = 40;

for (var i = 0; i < count; i++)
{
    draw_sprite(
        spr_healthbar,
        floor(hp_segments[i]),
        start_x + i * spacing,
        bar_y
    );
}
