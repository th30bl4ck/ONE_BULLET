'use strict';

/**
 * Pure-logic reimplementation of the new "liquid lead" behaviour added to
 * objects/obj_bullet/Create_0.gml, Step_0.gml and Destroy_0.gml in this PR.
 *
 * GameMaker Language (GML) has no headless test runner, so the relevant
 * algorithms are mirrored here 1:1 and exercised with plain Node tests.
 */

// Mirrors objects/obj_bullet/Create_0.gml (the new fields appended to it).
function createBullet() {
  return {
    has_liquid_lead: false,
    liquid_lead_pool: null,
    damage: 10,
    liquid_trail_timer: 0,
    liquid_trail_delay: 2,
  };
}

// Mirrors the block appended to the end of objects/obj_bullet/Step_0.gml:
//
//   if (has_liquid_lead) {
//       liquid_trail_timer--;
//       if (liquid_trail_timer <= 0) {
//           var p = instance_create_layer(x, y, "Instances", obj_creep_pool);
//           liquid_trail_timer = liquid_trail_delay;
//       }
//   }
//
// `spawnPoolFn(x, y)` stands in for `instance_create_layer(...)` and should
// return whatever "instance" was created (or any truthy sentinel).
function stepLiquidTrail(bullet, spawnPoolFn) {
  if (!bullet.has_liquid_lead) {
    return null;
  }

  bullet.liquid_trail_timer -= 1;

  if (bullet.liquid_trail_timer <= 0) {
    const pool = spawnPoolFn(bullet.x, bullet.y);
    bullet.liquid_trail_timer = bullet.liquid_trail_delay;
    return pool;
  }

  return null;
}

// Mirrors the new objects/obj_bullet/Destroy_0.gml file:
//
//   if (instance_exists(liquid_lead_pool)) {
//       liquid_lead_pool.follow_target = noone;
//   }
function destroyBullet(bullet) {
  const pool = bullet.liquid_lead_pool;
  if (pool && pool.exists) {
    pool.follow_target = null;
  }
}

module.exports = { createBullet, stepLiquidTrail, destroyBullet };