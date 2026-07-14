'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const { createBullet, stepLiquidTrail, destroyBullet } = require('./logic/bullet');
const { parseGmJson } = require('./helpers/gmJson');

const OBJ_DIR = path.join(__dirname, '..', 'objects', 'obj_bullet');

describe('obj_bullet/Create_0.gml - liquid lead defaults', () => {
  test('initializes liquid lead fields to their default (off) state', () => {
    const bullet = createBullet();

    assert.equal(bullet.has_liquid_lead, false);
    assert.equal(bullet.liquid_lead_pool, null);
    assert.equal(bullet.liquid_trail_timer, 0);
    assert.equal(bullet.liquid_trail_delay, 2);
  });

  test('sets base bullet damage to 10', () => {
    const bullet = createBullet();
    assert.equal(bullet.damage, 10);
  });
});

describe('obj_bullet/Step_0.gml - liquid trail spawning', () => {
  test('does nothing when has_liquid_lead is false', () => {
    const bullet = createBullet();
    bullet.x = 5;
    bullet.y = 7;

    let spawned = 0;
    const result = stepLiquidTrail(bullet, () => {
      spawned += 1;
      return { kind: 'pool' };
    });

    assert.equal(result, null);
    assert.equal(spawned, 0);
    assert.equal(bullet.liquid_trail_timer, 0);
  });

  test('spawns a pool as soon as the timer reaches zero and resets the timer', () => {
    const bullet = createBullet();
    bullet.has_liquid_lead = true;
    bullet.x = 100;
    bullet.y = 200;
    // liquid_trail_timer starts at 0, so the very first step should spawn.

    const spawnCalls = [];
    const pool = stepLiquidTrail(bullet, (x, y) => {
      spawnCalls.push({ x, y });
      return { kind: 'pool' };
    });

    assert.deepEqual(pool, { kind: 'pool' });
    assert.equal(spawnCalls.length, 1);
    assert.deepEqual(spawnCalls[0], { x: 100, y: 200 });
    assert.equal(bullet.liquid_trail_timer, bullet.liquid_trail_delay);
  });

  test('does not spawn again until the delay has elapsed', () => {
    const bullet = createBullet();
    bullet.has_liquid_lead = true;
    bullet.x = 0;
    bullet.y = 0;

    let spawnCount = 0;
    const spawnFn = () => {
      spawnCount += 1;
      return {};
    };

    // Step 1: timer 0 -> -1 <= 0, spawns, timer resets to delay (2)
    stepLiquidTrail(bullet, spawnFn);
    assert.equal(spawnCount, 1);
    assert.equal(bullet.liquid_trail_timer, 2);

    // Step 2: timer 2 -> 1, no spawn
    const step2 = stepLiquidTrail(bullet, spawnFn);
    assert.equal(step2, null);
    assert.equal(spawnCount, 1);
    assert.equal(bullet.liquid_trail_timer, 1);

    // Step 3: timer 1 -> 0 <= 0, spawns again, timer resets to delay
    const step3 = stepLiquidTrail(bullet, spawnFn);
    assert.notEqual(step3, null);
    assert.equal(spawnCount, 2);
    assert.equal(bullet.liquid_trail_timer, 2);
  });

  test('has_liquid_lead=false leaves an existing (nonzero) timer untouched', () => {
    const bullet = createBullet();
    bullet.has_liquid_lead = false;
    bullet.liquid_trail_timer = 5;

    stepLiquidTrail(bullet, () => ({}));

    assert.equal(bullet.liquid_trail_timer, 5);
  });
});

describe('obj_bullet/Destroy_0.gml - liquid lead pool cleanup', () => {
  test('clears follow_target on the pool when it still exists', () => {
    const bullet = createBullet();
    const pool = { exists: true, follow_target: 'some_bullet_id' };
    bullet.liquid_lead_pool = pool;

    destroyBullet(bullet);

    assert.equal(pool.follow_target, null);
  });

  test('does nothing when the pool no longer exists', () => {
    const bullet = createBullet();
    const pool = { exists: false, follow_target: 'some_bullet_id' };
    bullet.liquid_lead_pool = pool;

    destroyBullet(bullet);

    assert.equal(pool.follow_target, 'some_bullet_id');
  });

  test('does nothing (and does not throw) when there is no pool at all', () => {
    const bullet = createBullet();
    assert.doesNotThrow(() => destroyBullet(bullet));
  });
});

describe('obj_bullet/Create_0.gml and Step_0.gml source sanity', () => {
  test('Create_0.gml declares the new liquid lead fields', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Create_0.gml'), 'utf8');

    assert.match(source, /has_liquid_lead\s*=\s*false;/);
    assert.match(source, /liquid_lead_pool\s*=\s*noone;/);
    assert.match(source, /liquid_trail_timer\s*=\s*0;/);
    assert.match(source, /liquid_trail_delay\s*=\s*2;/);
  });

  test('Step_0.gml spawns obj_creep_pool via instance_create_layer', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Step_0.gml'), 'utf8');

    assert.match(source, /if \(has_liquid_lead\)/);
    assert.match(source, /instance_create_layer\(x, y, "Instances", obj_creep_pool\)/);
  });

  test('Destroy_0.gml exists and clears follow_target on the liquid lead pool', () => {
    const source = fs.readFileSync(path.join(OBJ_DIR, 'Destroy_0.gml'), 'utf8');

    assert.match(source, /instance_exists\(liquid_lead_pool\)/);
    assert.match(source, /liquid_lead_pool\.follow_target\s*=\s*noone;/);
  });
});

describe('obj_bullet.yy - event list', () => {
  test('parses as valid GameMaker JSON and declares a Destroy event', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_bullet.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.name, 'obj_bullet');

    // eventType 1 == Destroy in GameMaker's event enum.
    const destroyEvents = yy.eventList.filter((event) => event.eventType === 1);
    assert.equal(destroyEvents.length, 1);
  });

  test('still declares its original collision events alongside the new Destroy event', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_bullet.yy'), 'utf8');
    const yy = parseGmJson(text);

    const collisionTargets = yy.eventList
      .filter((event) => event.eventType === 4 && event.collisionObjectId)
      .map((event) => event.collisionObjectId.name);

    assert.ok(collisionTargets.includes('obj_wall'));
    assert.ok(collisionTargets.includes('obj_room1_changer_north'));
  });
});