var line_height = 40;

// starting Y so the text block is vertically centered at the object
var start_y = y - (array_length(text_lines) * line_height) * 0.3;

// draw each line centered on X
for (var i = 0; i < array_length(text_lines); i++) {
    draw_set_halign(fa_center);
    draw_text(x, start_y + i * line_height, text_lines[i]);
}
