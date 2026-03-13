
if (!variable_instance_exists(id, "player_health")) exit;

if (array_length(player_health.frames) != player_health.max || array_length(player_health.segments) != player_health.max)
{
    player_health_resize_buffers(player_health.max);
}


var count = max_hp;

var head_w  = sprite_get_width(spr_healthbar);
var padding = 6;
var spacing = head_w + padding;

var total_w = count * spacing - padding;
var start_x = display_get_gui_width() - total_w - 30;
var bar_y   = 40;

count = max_hp;

head_w  = sprite_get_width(spr_healthbar);
padding = 6;
spacing = head_w + padding;

total_w = count * spacing - padding;
start_x = display_get_gui_width() - total_w - 30;
bar_y   = 40;


var base_slots = 5;


var bonus_slots = max(0, count - base_slots);


base_slots = min(base_slots, count);

var draw_pos = 0;


for (var i = 0; i < bonus_slots; i++)
{
    var idx = base_slots + i;

    draw_sprite(
        spr_healthbar,
        floor(player_health.frames[idx]),
        start_x + draw_pos * spacing,
        bar_y
    );

    draw_pos++;
}


for (var i = 0; i < base_slots; i++)
{
    draw_sprite(
        spr_healthbar,
        floor(player_health.frames[i]),
        start_x + draw_pos * spacing,
        bar_y
    );

    draw_pos++;
}