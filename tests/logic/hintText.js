'use strict';

/**
 * Mirrors the hint text formatting added to objects/obj_alexs_arsanal/Draw_0.gml:
 *
 *   draw_text(x, y - 16, "E - " + string(item_cost) + " coins");
 */
function formatHintText(itemCost) {
  return `E - ${itemCost} coins`;
}

module.exports = { formatHintText };