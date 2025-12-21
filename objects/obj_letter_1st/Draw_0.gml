
// draw the note sprite itself
draw_self();

// draw interaction hint
if (show_hint && !global.note_open) {
    draw_text(x, y - 16, "E");
}
