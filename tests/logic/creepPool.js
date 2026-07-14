'use strict';

/**
 * Pure-logic reimplementation of the new objects/obj_creep_pool object
 * introduced in this PR (Create_0.gml, Step_0.gml, Draw_0.gml).
 */

// Mirrors objects/obj_creep_pool/Create_0.gml
function createCreepPool(roomSpeed, x = 0, y = 0) {
  const life_max = roomSpeed * 2;
  return {
    x,
    y,
    life_max,
    life: life_max,
    radius: 40,
    damage: 0.5,
    slow_amount: 0.5,
  };
}

// Mirrors objects/obj_creep_pool/Step_0.gml:
//
//   life--;
//   with (obj_enemy_parent) {
//       if (point_distance(x, y, other.x, other.y) < other.radius) {
//           hp -= other.damage;
//           slowed = true;
//           slow_timer = 10;
//           slow_multiplier = other.slow_amount;
//       }
//   }
//   if (life <= 0) { instance_destroy(); }
//
// Returns `true` when the pool should be destroyed this step.
function stepCreepPool(pool, enemies) {
  pool.life -= 1;

  for (const enemy of enemies) {
    const dist = Math.hypot(enemy.x - pool.x, enemy.y - pool.y);
    if (dist < pool.radius) {
      enemy.hp -= pool.damage;
      enemy.slowed = true;
      enemy.slow_timer = 10;
      enemy.slow_multiplier = pool.slow_amount;
    }
  }

  return pool.life <= 0;
}

// Mirrors objects/obj_creep_pool/Draw_0.gml:
//
//   var fade = life / life_max;
//   draw_set_alpha(fade * 0.6);
function computeFadeAlpha(pool) {
  const fade = pool.life / pool.life_max;
  return { fade, alpha: fade * 0.6 };
}

module.exports = { createCreepPool, stepCreepPool, computeFadeAlpha };