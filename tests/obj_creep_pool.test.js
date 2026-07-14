'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const { createCreepPool, stepCreepPool, computeFadeAlpha } = require('./logic/creepPool');
const { parseGmJson } = require('./helpers/gmJson');

const OBJ_DIR = path.join(__dirname, '..', 'objects', 'obj_creep_pool');

describe('obj_creep_pool/Create_0.gml', () => {
  test('derives life_max from room_speed and sets default stats', () => {
    const pool = createCreepPool(60);

    assert.equal(pool.life_max, 120);
    assert.equal(pool.life, 120);
    assert.equal(pool.radius, 40);
    assert.equal(pool.damage, 0.5);
    assert.equal(pool.slow_amount, 0.5);
  });

  test('scales life_max with a different room_speed', () => {
    const pool = createCreepPool(30);
    assert.equal(pool.life_max, 60);
    assert.equal(pool.life, 60);
  });
});

describe('obj_creep_pool/Step_0.gml', () => {
  test('decrements life every step and signals destruction once it reaches zero', () => {
    const pool = createCreepPool(1); // life_max = 2

    const destroyedAfterFirstStep = stepCreepPool(pool, []);
    assert.equal(pool.life, 1);
    assert.equal(destroyedAfterFirstStep, false);

    const destroyedAfterSecondStep = stepCreepPool(pool, []);
    assert.equal(pool.life, 0);
    assert.equal(destroyedAfterSecondStep, true);
  });

  test('damages and slows an enemy that is inside the pool radius', () => {
    const pool = createCreepPool(60, 100, 100);
    const enemy = { x: 105, y: 100, hp: 50, slowed: false, slow_timer: 0, slow_multiplier: 1 };

    stepCreepPool(pool, [enemy]);

    assert.equal(enemy.hp, 49.5);
    assert.equal(enemy.slowed, true);
    assert.equal(enemy.slow_timer, 10);
    assert.equal(enemy.slow_multiplier, 0.5);
  });

  test('leaves an enemy outside the pool radius untouched', () => {
    const pool = createCreepPool(60, 0, 0);
    const enemy = { x: 1000, y: 1000, hp: 50, slowed: false, slow_timer: 0, slow_multiplier: 1 };

    stepCreepPool(pool, [enemy]);

    assert.equal(enemy.hp, 50);
    assert.equal(enemy.slowed, false);
    assert.equal(enemy.slow_timer, 0);
    assert.equal(enemy.slow_multiplier, 1);
  });

  test('boundary: an enemy exactly at the radius distance is NOT affected (strict "<")', () => {
    const pool = createCreepPool(60, 0, 0);
    // pool.radius is 40, so place the enemy exactly 40 units away.
    const enemy = { x: 40, y: 0, hp: 50, slowed: false, slow_timer: 0, slow_multiplier: 1 };

    stepCreepPool(pool, [enemy]);

    assert.equal(enemy.hp, 50);
    assert.equal(enemy.slowed, false);
  });

  test('only affects enemies that are actually within range out of a group', () => {
    const pool = createCreepPool(60, 0, 0);
    const near = { x: 10, y: 0, hp: 50, slowed: false, slow_timer: 0, slow_multiplier: 1 };
    const far = { x: 500, y: 0, hp: 50, slowed: false, slow_timer: 0, slow_multiplier: 1 };

    stepCreepPool(pool, [near, far]);

    assert.equal(near.hp, 49.5);
    assert.equal(near.slowed, true);
    assert.equal(far.hp, 50);
    assert.equal(far.slowed, false);
  });
});

describe('obj_creep_pool/Draw_0.gml - fade alpha', () => {
  test('is fully opaque (relative to its 0.6 cap) at full life', () => {
    const pool = createCreepPool(60);
    const { fade, alpha } = computeFadeAlpha(pool);

    assert.equal(fade, 1);
    assert.equal(alpha, 0.6);
  });

  test('fades linearly with remaining life', () => {
    const pool = createCreepPool(60);
    pool.life = pool.life_max / 2;

    const { fade, alpha } = computeFadeAlpha(pool);

    assert.equal(fade, 0.5);
    assert.equal(alpha, 0.3);
  });

  test('is fully transparent once life has run out', () => {
    const pool = createCreepPool(60);
    pool.life = 0;

    const { fade, alpha } = computeFadeAlpha(pool);

    assert.equal(fade, 0);
    assert.equal(alpha, 0);
  });
});

describe('obj_creep_pool source files exist with expected behavior', () => {
  test('Create_0.gml sets the expected defaults', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Create_0.gml'), 'utf8');
    assert.match(source, /life_max\s*=\s*room_speed\s*\*\s*2;/);
    assert.match(source, /radius\s*=\s*40;/);
    assert.match(source, /damage\s*=\s*0\.5;/);
    assert.match(source, /slow_amount\s*=\s*0\.5;/);
  });

  test('Step_0.gml applies slow/damage to obj_enemy_parent instances in range', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Step_0.gml'), 'utf8');
    assert.match(source, /with \(obj_enemy_parent\)/);
    assert.match(source, /point_distance\(x, y, other\.x, other\.y\) < other\.radius/);
    assert.match(source, /slow_multiplier\s*=\s*other\.slow_amount;/);
  });
});

describe('obj_creep_pool.yy', () => {
  test('parses as valid GameMaker JSON and is parented under shop_objects', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_creep_pool.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.name, 'obj_creep_pool');
    assert.equal(yy.parent.name, 'shop_objects');
    assert.equal(yy.spriteId, null);
  });

  test('declares Create, Step and Draw events', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_creep_pool.yy'), 'utf8');
    const yy = parseGmJson(text);

    const eventTypes = yy.eventList.map((event) => event.eventType).sort();
    assert.deepEqual(eventTypes, [0, 3, 8]);
  });
});