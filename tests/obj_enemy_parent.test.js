'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const {
  createEnemyParent,
  drawEnemyParent,
  stepEnemyParent,
  collideEnemyWithBullet,
} = require('./logic/enemyParent');
const { parseGmJson } = require('./helpers/gmJson');

const OBJ_DIR = path.join(__dirname, '..', 'objects', 'obj_enemy_parent');

describe('obj_enemy_parent/Create_0.gml', () => {
  test('sets the expected default stats', () => {
    const enemy = createEnemyParent(1.5);

    assert.equal(enemy.hp, 100);
    assert.equal(enemy.hsp, 0);
    assert.equal(enemy.vsp, 0);
    assert.equal(enemy.slowed, false);
    assert.equal(enemy.slow_timer, 0);
    assert.equal(enemy.slow_multiplier, 1);
  });

  test('derives base_speed from move_speed when base_speed does not already exist', () => {
    const enemy = createEnemyParent(2.5);
    assert.equal(enemy.base_speed, 2.5);
  });

  test('preserves an already-existing base_speed instead of overwriting it', () => {
    const enemy = createEnemyParent(2.5, 9.9);
    assert.equal(enemy.base_speed, 9.9);
  });
});

describe('obj_enemy_parent/Draw_0.gml', () => {
  test('draws normally when not slowed', () => {
    const enemy = { slowed: false };
    assert.equal(drawEnemyParent(enemy), 'normal');
  });

  test('draws tinted when slowed', () => {
    const enemy = { slowed: true };
    assert.equal(drawEnemyParent(enemy), 'tinted');
  });

  test('defaults to normal when "slowed" is undefined', () => {
    const enemy = {};
    assert.equal(drawEnemyParent(enemy), 'normal');
  });
});

describe('obj_enemy_parent/Step_0.gml', () => {
  test('counts down slow_timer and keeps slowed=true while timer is active', () => {
    const enemy = createEnemyParent(1);
    enemy.x = 0;
    enemy.y = 0;
    enemy.slow_timer = 3;
    enemy.slow_multiplier = 0.5;

    stepEnemyParent(enemy);

    assert.equal(enemy.slow_timer, 2);
    assert.equal(enemy.slowed, true);
    // slow_multiplier is untouched while the timer is still running.
    assert.equal(enemy.slow_multiplier, 0.5);
  });

  test('resets slowed and slow_multiplier once the timer expires', () => {
    const enemy = createEnemyParent(1);
    enemy.x = 0;
    enemy.y = 0;
    enemy.slow_timer = 0;
    enemy.slow_multiplier = 0.5;

    stepEnemyParent(enemy);

    assert.equal(enemy.slowed, false);
    assert.equal(enemy.slow_multiplier, 1);
  });

  test('applies hsp/vsp to position before friction is applied', () => {
    const enemy = createEnemyParent(1);
    enemy.x = 10;
    enemy.y = 20;
    enemy.hsp = 4;
    enemy.vsp = -2;

    stepEnemyParent(enemy);

    assert.equal(enemy.x, 14);
    assert.equal(enemy.y, 18);
    assert.equal(enemy.hsp, 4 * 0.85);
    assert.equal(enemy.vsp, -2 * 0.85);
  });

  test('regression: the shipped Step_0.gml destroys the instance every single step, regardless of hp', () => {
    const aliveEnemy = createEnemyParent(1);
    aliveEnemy.x = 0;
    aliveEnemy.y = 0;
    aliveEnemy.hp = 100;

    const result = stepEnemyParent(aliveEnemy);

    // This documents the (surprising) shipped behaviour: an unconditional
    // `{ instance_destroy(); }` block runs on every Step, independent of hp.
    assert.equal(result.destroyedUnconditionally, true);
    assert.equal(result.destroyedByHp, false);
  });

  test('also reports destroyedByHp=true when hp has dropped to zero or below', () => {
    const deadEnemy = createEnemyParent(1);
    deadEnemy.x = 0;
    deadEnemy.y = 0;
    deadEnemy.hp = 0;

    const result = stepEnemyParent(deadEnemy);

    assert.equal(result.destroyedUnconditionally, true);
    assert.equal(result.destroyedByHp, true);
  });
});

describe('obj_enemy_parent/Collision_obj_bullet.gml', () => {
  function makeEnemy(hp) {
    return { hp };
  }

  function makeBullet(state, damage) {
    return { state, damage, speed: 5, hspeed: 3, vspeed: 4 };
  }

  test('does nothing when the bullet is not in a moving state', () => {
    const enemy = makeEnemy(50);
    const bullet = makeBullet('stopped', 10);

    const result = collideEnemyWithBullet(enemy, bullet, {}, {});

    assert.equal(enemy.hp, 50);
    assert.deepEqual(result, {
      enemyDestroyed: false,
      bulletDestroyed: false,
      bulletStopped: false,
      explosionCreated: false,
      playerUpdated: false,
    });
  });

  test('non-piercing bullet: damages enemy, destroys bullet, and resets the player state', () => {
    const enemy = makeEnemy(50);
    const bullet = makeBullet('fired', 10);
    const player = { bullet_id: 'b1', bullet_pickup_shoot_delay: 20, can_shoot: true };

    const result = collideEnemyWithBullet(enemy, bullet, { bullet_pierce: false }, player);

    assert.equal(enemy.hp, 40);
    assert.equal(result.bulletDestroyed, true);
    assert.equal(result.bulletStopped, false);
    assert.equal(result.playerUpdated, true);
    assert.equal(player.bullet_id, null);
    assert.equal(player.bullet_pickup_shoot_timer, 20);
    assert.equal(player.can_shoot, false);
  });

  test('non-piercing bullet that kills the enemy also flags enemyDestroyed', () => {
    const enemy = makeEnemy(5);
    const bullet = makeBullet('fired', 10);

    const result = collideEnemyWithBullet(enemy, bullet, { bullet_pierce: false }, { bullet_pickup_shoot_delay: 0 });

    assert.equal(enemy.hp, -5);
    assert.equal(result.enemyDestroyed, true);
    assert.equal(result.bulletDestroyed, true);
  });

  test('piercing bullet that does NOT kill the enemy is stopped in place', () => {
    const enemy = makeEnemy(50);
    const bullet = makeBullet('fired', 10);

    const result = collideEnemyWithBullet(enemy, bullet, { bullet_pierce: true }, {});

    assert.equal(enemy.hp, 40);
    assert.equal(result.bulletStopped, true);
    assert.equal(bullet.state, 'stopped');
    assert.equal(bullet.speed, 0);
    assert.equal(result.bulletDestroyed, false);
  });

  test('regression: a piercing bullet that kills the enemy is NOT stopped and keeps its original state', () => {
    const enemy = makeEnemy(5);
    const bullet = makeBullet('fired', 10);

    const result = collideEnemyWithBullet(enemy, bullet, { bullet_pierce: true }, {});

    assert.equal(enemy.hp, -5);
    assert.equal(result.enemyDestroyed, true);
    // Because `enemy_will_die` was true, the `if (!enemy_will_die)` guard
    // skips the `other.state = "stopped"` assignment entirely.
    assert.equal(result.bulletStopped, false);
    assert.equal(bullet.state, 'fired');
  });

  test('creates an explosion when global.alexs_arsanal is enabled', () => {
    const enemy = makeEnemy(50);
    const bullet = makeBullet('fired', 10);

    const result = collideEnemyWithBullet(enemy, bullet, { alexs_arsanal: true }, {});

    assert.equal(result.explosionCreated, true);
  });

  test('does not create an explosion when global.alexs_arsanal is disabled', () => {
    const enemy = makeEnemy(50);
    const bullet = makeBullet('fired', 10);

    const result = collideEnemyWithBullet(enemy, bullet, { alexs_arsanal: false }, {});

    assert.equal(result.explosionCreated, false);
  });

  test('does not throw when globalState/player are omitted (missing globals default off)', () => {
    const enemy = makeEnemy(50);
    const bullet = makeBullet('fired', 10);

    assert.doesNotThrow(() => collideEnemyWithBullet(enemy, bullet, undefined, undefined));
  });

  test('a "recall" state bullet is also treated as moving', () => {
    const enemy = makeEnemy(50);
    const bullet = makeBullet('recall', 10);

    const result = collideEnemyWithBullet(enemy, bullet, { bullet_pierce: false }, {});

    assert.equal(enemy.hp, 40);
    assert.equal(result.bulletDestroyed, true);
  });
});

describe('obj_enemy_parent source files exist with expected behavior', () => {
  test('Create_0.gml sets default hp/hsp/vsp/slow fields', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Create_0.gml'), 'utf8');
    assert.match(source, /hp\s*=\s*100;/);
    assert.match(source, /slowed\s*=\s*false;/);
    assert.match(source, /slow_timer\s*=\s*0;/);
    assert.match(source, /slow_multiplier\s*=\s*1;/);
  });

  test('Draw_0.gml tints the sprite gray while slowed', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Draw_0.gml'), 'utf8');
    assert.match(source, /if \(slowed\)/);
    assert.match(source, /draw_sprite_ext\(/);
    assert.match(source, /c_gray/);
  });

  test('Step_0.gml decrements slow_timer and applies friction to hsp/vsp', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Step_0.gml'), 'utf8');
    assert.match(source, /slow_timer--;/);
    assert.match(source, /hsp \*= 0\.85;/);
    assert.match(source, /vsp \*= 0\.85;/);
  });

  test('Collision_obj_bullet.gml applies piercing/explosion/death logic', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Collision_obj_bullet.gml'), 'utf8');
    assert.match(source, /var bullet_pierces = global\.bullet_pierce;/);
    assert.match(source, /var enemy_will_die = hp <= other\.damage;/);
    assert.match(source, /instance_create_layer\(other\.x, other\.y, other\.layer, obj_explosion\)/);
  });
});

describe('obj_enemy_parent.yy', () => {
  test('parses as valid GameMaker JSON with no parent object (base parent)', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_parent.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.name, 'obj_enemy_parent');
    assert.equal(yy.parentObjectId, null);
  });

  test('declares a Draw event and a Collision event with obj_bullet', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_parent.yy'), 'utf8');
    const yy = parseGmJson(text);

    const drawEvents = yy.eventList.filter((event) => event.eventType === 8);
    assert.equal(drawEvents.length, 1);

    const bulletCollisions = yy.eventList.filter(
      (event) => event.eventType === 4 && event.collisionObjectId && event.collisionObjectId.name === 'obj_bullet',
    );
    assert.equal(bulletCollisions.length, 1);
  });
});