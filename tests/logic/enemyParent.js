'use strict';

/**
 * Pure-logic reimplementation of the changes made in this PR to
 * objects/obj_enemy_parent (Create_0.gml, Draw_0.gml, Step_0.gml,
 * Collision_obj_bullet.gml), plus the shared "call parent create twice then
 * override hp" pattern used by obj_enemy_dasher/Create_0.gml and
 * obj_enemy_shooter/Create_0.gml.
 */

// Mirrors objects/obj_enemy_parent/Create_0.gml
function createEnemyParent(moveSpeed, existingBaseSpeed) {
  const state = {
    hp: 100,
    hsp: 0,
    vsp: 0,
    slowed: false,
    slow_timer: 0,
    slow_multiplier: 1,
  };

  // if (!variable_instance_exists(id, "base_speed")) { base_speed = move_speed; }
  state.base_speed = existingBaseSpeed !== undefined ? existingBaseSpeed : moveSpeed;

  return state;
}

// Mirrors objects/obj_enemy_parent/Draw_0.gml
function drawEnemyParent(enemy) {
  const slowed = enemy.slowed === undefined ? false : enemy.slowed;
  return slowed ? 'tinted' : 'normal';
}

// Mirrors objects/obj_enemy_parent/Step_0.gml:
//
//   if (slow_timer > 0) { slow_timer--; slowed = true; }
//   else { slowed = false; slow_multiplier = 1; }
//
//   x += hsp; y += vsp;
//   hsp *= 0.85; vsp *= 0.85;
//   { instance_destroy(); }
//
//   if (hp <= 0) { instance_destroy(); }
function stepEnemyParent(enemy) {
  if (enemy.slow_timer > 0) {
    enemy.slow_timer -= 1;
    enemy.slowed = true;
  } else {
    enemy.slowed = false;
    enemy.slow_multiplier = 1;
  }

  enemy.x += enemy.hsp;
  enemy.y += enemy.vsp;

  enemy.hsp *= 0.85;
  enemy.vsp *= 0.85;

  // NOTE: the shipped Step_0.gml added an unconditional
  // `{ instance_destroy(); }` block right after the friction update,
  // independent of `hp`. This helper mirrors that literally so a test can
  // document/guard the current (surprising) behaviour.
  const destroyedUnconditionally = true;

  const destroyedByHp = enemy.hp <= 0;

  return { destroyedUnconditionally, destroyedByHp };
}

// Mirrors objects/obj_enemy_parent/Collision_obj_bullet.gml
function collideEnemyWithBullet(enemy, bullet, globalState, player) {
  const bullet_pierces = !!(globalState && globalState.bullet_pierce);
  const bullet_moving = bullet.state === 'fired' || bullet.state === 'recall';

  const result = {
    enemyDestroyed: false,
    bulletDestroyed: false,
    bulletStopped: false,
    explosionCreated: false,
    playerUpdated: false,
  };

  if (!bullet_moving) {
    return result;
  }

  const enemy_will_die = enemy.hp <= bullet.damage;

  enemy.hp -= bullet.damage;

  if (globalState && globalState.alexs_arsanal) {
    result.explosionCreated = true;
  }

  if (bullet_pierces) {
    if (!enemy_will_die) {
      bullet.speed = 0;
      bullet.hspeed = 0;
      bullet.vspeed = 0;
      bullet.state = 'stopped';
      result.bulletStopped = true;
    }
  } else {
    if (player) {
      player.bullet_id = null;
      player.bullet_pickup_shoot_timer = player.bullet_pickup_shoot_delay;
      player.can_shoot = false;
      result.playerUpdated = true;
    }

    result.bulletDestroyed = true;
  }

  if (enemy.hp <= 0) {
    result.enemyDestroyed = true;
  }

  return result;
}

// Mirrors the shared pattern in obj_enemy_dasher/Create_0.gml and
// obj_enemy_shooter/Create_0.gml:
//
//   event_inherited();
//   event_inherited();
//   hp = <override>;
function applyCreateOverride(state, parentCreateFn, overrideHp) {
  parentCreateFn(state);
  parentCreateFn(state);
  state.hp = overrideHp;
  return state;
}

module.exports = {
  createEnemyParent,
  drawEnemyParent,
  stepEnemyParent,
  collideEnemyWithBullet,
  applyCreateOverride,
};