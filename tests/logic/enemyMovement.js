'use strict';

/**
 * Pure-logic helpers mirroring GML's `lengthdir_x` / `lengthdir_y` builtins
 * and the shared "slow effect" movement pattern introduced by this PR in
 * objects/obj_enemy_dasher/Step_0.gml and objects/obj_enemy_shooter/Step_0.gml:
 *
 *   var enemy_speed = move_speed;
 *   if (variable_instance_exists(id, "slowed") && slowed) {
 *       enemy_speed *= slow_multiplier;
 *   }
 *   ...
 *   x += lengthdir_x(enemy_speed, dir);
 *   y += lengthdir_y(move_speed, dir);   // <- note: NOT enemy_speed
 */

function degToRad(deg) {
  return (deg * Math.PI) / 180;
}

function lengthdirX(len, dir) {
  return len * Math.cos(degToRad(dir));
}

function lengthdirY(len, dir) {
  return -len * Math.sin(degToRad(dir));
}

// Mirrors:
//   var enemy_speed = move_speed;
//   if (variable_instance_exists(id, "slowed") && slowed) {
//       enemy_speed *= slow_multiplier;
//   }
function computeEnemySpeed(moveSpeed, slowed, slowMultiplier) {
  return slowed ? moveSpeed * slowMultiplier : moveSpeed;
}

/**
 * Mirrors the movement pattern shared by the dasher "chase"/anchor movement
 * and the shooter spacing movement: the X axis is scaled by the
 * slow-adjusted `enemy_speed`, while the Y axis still uses the raw,
 * unmodified `move_speed`. `sign` allows modelling the `x -=`/`y -=`
 * variant used in obj_enemy_shooter's "too close" branch.
 */
function stepAxisSlowedMovement(pos, moveSpeed, slowed, slowMultiplier, dir, sign = 1) {
  const enemy_speed = computeEnemySpeed(moveSpeed, slowed, slowMultiplier);
  return {
    x: pos.x + sign * lengthdirX(enemy_speed, dir),
    y: pos.y + sign * lengthdirY(moveSpeed, dir),
  };
}

module.exports = {
  degToRad,
  lengthdirX,
  lengthdirY,
  computeEnemySpeed,
  stepAxisSlowedMovement,
};