if (active && array_length(dialogue_lines) > 0)
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var box_h = gui_h * 0.30;

    var box_x1 = 0;
    var box_y1 = gui_h - box_h;
    var box_x2 = gui_w;
    var box_y2 = gui_h;

    // Background
    draw_set_color(make_color_rgb(60,60,60));
    draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);

    // Thick green border
    draw_set_color(c_green);

    for (var i = 0; i < 8; i++)
    {
        draw_rectangle(
            box_x1 + i,
            box_y1 + i,
            box_x2 - i,
            box_y2 - i,
            true
        );
    }

    // Portrait
    draw_sprite(
        spr_shopkeeper_face,
        0,
        box_x2 - 140,
        box_y1 + 20
    );

    // Typewriter text
    var shown_text = string_copy(
        dialogue_lines[line_index],
        1,
        floor(text_pos)
    );

    draw_set_color(c_white);

    draw_text_ext(
        box_x1 + 30,
        box_y1 + 30,
        shown_text,
        24,
        450
    );
}