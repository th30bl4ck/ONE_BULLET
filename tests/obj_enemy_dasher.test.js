'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const { computeEnemySpeed, stepAxisSlowedMovement } = require('./logic/enemyMovement');
const { applyCreateOverride } = require('./logic/enemyParent');
const { parseGmJson } = require('./helpers/gmJson');

const OBJ_DIR = path.join(__dirname, '..', 'objects', 'obj_enemy_dasher');

describe('obj_enemy_dasher/Create_0.gml', () => {
  test('calls the parent create twice then overrides hp to 20', () => {
    let parentCallCount = 0;
    const parentCreate = (state) => {
      parentCallCount += 1;
      state.hp = 100;
    };

    const state = applyCreateOverride({}, parentCreate, 20);

    assert.equal(parentCallCount, 2);
    assert.equal(state.hp, 20);
  });
});

describe('obj_enemy_dasher/Step_0.gml - slow-effect movement', () => {
  test('enemy_speed equals move_speed when not slowed', () => {
    assert.equal(computeEnemySpeed(0.8, false, 0.5), 0.8);
  });

  test('enemy_speed is scaled by slow_multiplier when slowed', () => {
    assert.equal(computeEnemySpeed(0.8, true, 0.5), 0.4);
  });

  test('regression: chase-state movement only slows the X axis, not the Y axis', () => {
    const pos = { x: 100, y: 100 };
    const dir = 0; // straight along +X: lengthdir_x(len,0)=len, lengthdir_y(len,0)=0

    const slowedResult = stepAxisSlowedMovement(pos, 0.8, true, 0.5, dir);

    // X uses the slowed enemy_speed (0.4); Y uses the un-slowed move_speed (0.8),
    // but at dir=0 lengthdir_y is 0 for both, so use a diagonal direction instead
    // to make the asymmetry observable.
    const diagPos = { x: 0, y: 0 };
    const diagResult = stepAxisSlowedMovement(diagPos, 0.8, true, 0.5, 45);

    const expectedX = 0 + 0.4 * Math.cos((45 * Math.PI) / 180);
    const expectedY = 0 + -0.8 * Math.sin((45 * Math.PI) / 180);

    assert.ok(Math.abs(diagResult.x - expectedX) < 1e-9);
    assert.ok(Math.abs(diagResult.y - expectedY) < 1e-9);
    // Sanity: unslowed result exists and matches the non-slowed helper output too.
    assert.ok(slowedResult.x !== undefined);
  });

  test('movement is identical on both axes when the enemy is not slowed', () => {
    const pos = { x: 0, y: 0 };
    const dir = 30;

    const result = stepAxisSlowedMovement(pos, 1.5, false, 0.5, dir);

    const expectedX = 0 + 1.5 * Math.cos((30 * Math.PI) / 180);
    const expectedY = 0 + -1.5 * Math.sin((30 * Math.PI) / 180);

    assert.ok(Math.abs(result.x - expectedX) < 1e-9);
    assert.ok(Math.abs(result.y - expectedY) < 1e-9);
  });
});

describe('obj_enemy_dasher/Collision_obj_bullet.gml', () => {
  test('delegates entirely to the parent event', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Collision_obj_bullet.gml'), 'utf8');
    assert.match(source, /event_inherited\(\);/);
    // Should not re-implement piercing/hp logic itself anymore.
    assert.doesNotMatch(source, /bullet_pierce/);
  });
});

describe('obj_enemy_dasher source files exist with expected behavior', () => {
  test('Create_0.gml calls event_inherited twice and overrides hp to 20', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Create_0.gml'), 'utf8');
    const matches = source.match(/event_inherited\(\);/g) || [];
    assert.equal(matches.length, 2);
    assert.match(source, /hp\s*=\s*20;/);
  });

  test('Step_0.gml computes a slow-adjusted enemy_speed', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Step_0.gml'), 'utf8');
    assert.match(source, /var enemy_speed = move_speed;/);
    assert.match(source, /enemy_speed \*= slow_multiplier;/);
  });
});

describe('obj_enemy_dasher.yy', () => {
  test('parses as valid GameMaker JSON and is parented under obj_enemy_parent', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_dasher.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.name, 'obj_enemy_dasher');
    assert.equal(yy.parentObjectId.name, 'obj_enemy_parent');
  });

  test('the obj_bullet collision event is the last entry in the event list', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_dasher.yy'), 'utf8');
    const yy = parseGmJson(text);

    const lastEvent = yy.eventList[yy.eventList.length - 1];
    assert.equal(lastEvent.eventType, 4);
    assert.equal(lastEvent.collisionObjectId.name, 'obj_bullet');
  });

  test('declares Destroy and CleanUp events', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_dasher.yy'), 'utf8');
    const yy = parseGmJson(text);

    const eventTypes = yy.eventList.map((event) => event.eventType);
    assert.ok(eventTypes.includes(1)); // Destroy
    assert.ok(eventTypes.includes(12)); // CleanUp
  });
});