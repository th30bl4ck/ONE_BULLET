'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const { parseGmJson } = require('./helpers/gmJson');

const OBJ_DIR = path.join(__dirname, '..', 'objects', 'obj_bandage_man_kyle');

describe('obj_bandage_man_kyle.yy', () => {
  test('parses as valid GameMaker JSON and is parented under the npc_obj folder', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_bandage_man_kyle.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.name, 'obj_bandage_man_kyle');
    assert.equal(yy.parent.name, 'npc_obj');
    assert.equal(yy.parent.path, 'folders/Objects/npc_obj.yy');
  });

  test('has no parent object, no events and is assigned its own sprite', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_bandage_man_kyle.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.parentObjectId, null);
    assert.deepEqual(yy.eventList, []);
    assert.equal(yy.spriteId.name, 'spr_bandage_man_kyle');
  });

  test('is not solid and is visible and non-persistent, matching other NPC-style objects', () => {
    const text = fs.readFileSync(path.join(OBJ_DIR, 'obj_bandage_man_kyle.yy'), 'utf8');
    const yy = parseGmJson(text);

    assert.equal(yy.solid, false);
    assert.equal(yy.visible, true);
    assert.equal(yy.persistent, false);
  });
});