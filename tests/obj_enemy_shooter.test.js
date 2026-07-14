'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const { computeEnemySpeed, stepAxisSlowedMovement } = require('./logic/enemyMovement');
const { applyCreateOverride } = require('./logic/enemyParent');
const { parseGmJson } = require('./helpers/gmJson');

const OBJ_DIR = path.join(__dirname, '..', 'objects', 'obj_enemy_shooter');

describe('obj_enemy_shooter/Create_0.gml', () => {
  test('calls the parent create twice then overrides hp to 15', () => {
    let parentCallCount = 0;
    const parentCreate = (state) => {
      parentCallCount += 1;
      state.hp = 100;
    };

    const state = applyCreateOverride({}, parentCreate, 15);

    assert.equal(parentCallCount, 2);
    assert.equal(state.hp, 15);
  });
});

describe('obj_enemy_shooter/Step_0.gml - slow-effect spacing movement', () => {
  test('enemy_speed is unaffected when not slowed', () => {
    assert.equal(computeEnemySpeed(0.6, false, 0.5), 0.6);
  });

  test('enemy_speed is scaled down by slow_multiplier when slowed', () => {
    assert.equal(computeEnemySpeed(0.6, true, 0.25), 0.15);
  });

  test('regression: the "too far" (+=) branch only slows the X axis, not the Y axis', () => {
    const pos = { x: 0, y: 0 };
    const dir = 60;

    const result = stepAxisSlowedMovement(pos, 0.6, true, 0.5, dir, 1);

    const expectedX = 0 + 0.3 * Math.cos((60 * Math.PI) / 180); // slowed enemy_speed
    const expectedY = 0 + -0.6 * Math.sin((60 * Math.PI) / 180); // un-slowed move_speed

    assert.ok(Math.abs(result.x - expectedX) < 1e-9);
    assert.ok(Math.abs(result.y - expectedY) < 1e-9);
  });

  test('regression: the "too close" (-=) branch also only slows the X axis, not the Y axis', () => {
    const pos = { x: 100, y: 100 };
    const dir = 60;

    const result = stepAxisSlowedMovement(pos, 0.6, true, 0.5, dir, -1);

    const expectedX = 100 - 0.3 * Math.cos((60 * Math.PI) / 180);
    const expectedY = 100 - -0.6 * Math.sin((60 * Math.PI) / 180);

    assert.ok(Math.abs(result.x - expectedX) < 1e-9);
    assert.ok(Math.abs(result.y - expectedY) < 1e-9);
  });

  test('both axes move identically when not slowed', () => {
    const pos = { x: 0, y: 0 };
    const dir = 15;

    const result = stepAxisSlowedMovement(pos, 1.2, false, 0.5, dir, 1);

    const expectedX = 0 + 1.2 * Math.cos((15 * Math.PI) / 180);
    const expectedY = 0 + -1.2 * Math.sin((15 * Math.PI) / 180);

    assert.ok(Math.abs(result.x - expectedX) < 1e-9);
    assert.ok(Math.abs(result.y - expectedY) < 1e-9);
  });
});

describe('obj_enemy_shooter/Collision_obj_bullet.gml', () => {
  test('delegates entirely to the parent event', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Collision_obj_bullet.gml'), 'utf8');
    assert.match(source, /event_inherited\(\);/);
    assert.doesNotMatch(source, /bullet_pierce/);
  });
});

describe('obj_enemy_shooter source files exist with expected behavior', () => {
  test('Create_0.gml calls event_inherited twice and overrides hp to 15', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Create_0.gml'), 'utf8');
    const matches = source.match(/event_inherited\(\);/g) || [];
    assert.equal(matches.length, 2);
    assert.match(source, /hp\s*=\s*15;/);
  });

  test('Step_0.gml computes a slow-adjusted enemy_speed and applies it to spacing movement', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Step_0.gml'), 'utf8');
    assert.match(source, /var enemy_speed = move_speed;/);
    assert.match(source, /enemy_speed \*= slow_multiplier;/);
    assert.match(source, /x \+= lengthdir_x\(enemy_speed, dir\);/);
    assert.match(source, /x -= lengthdir_x\(enemy_speed, dir\);/);
  });
});

describe('obj_enemy_shooter.yy', () => {
  test('parses as valid GameMaker JSON and is parented under obj_enemy_parent', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_shooter.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.name, 'obj_enemy_shooter');
    assert.equal(yy.parentObjectId.name, 'obj_enemy_parent');
  });

  test('the obj_bullet collision event is the last entry in the event list', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_shooter.yy'), 'utf8');
    const yy = parseGmJson(text);

    const lastEvent = yy.eventList[yy.eventList.length - 1];
    assert.equal(lastEvent.eventType, 4);
    assert.equal(lastEvent.collisionObjectId.name, 'obj_bullet');
  });

  test('declares Draw, Destroy and CleanUp events', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_enemy_shooter.yy'), 'utf8');
    const yy = parseGmJson(text);

    const eventTypes = yy.eventList.map((event) => event.eventType);
    assert.ok(eventTypes.includes(8)); // Draw
    assert.ok(eventTypes.includes(1)); // Destroy
    assert.ok(eventTypes.includes(12)); // CleanUp
  });
});