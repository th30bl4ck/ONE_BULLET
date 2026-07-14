'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const { parseGmJson } = require('./helpers/gmJson');

const ROOT_DIR = path.join(__dirname, '..');
const RESOURCE_ORDER_PATH = path.join(ROOT_DIR, 'ONE BULLET.resource_order');
const YYP_PATH = path.join(ROOT_DIR, 'ONE BULLET.yyp');

describe('helpers/gmJson.parseGmJson', () => {
  test('strips trailing commas before objects/arrays close and parses successfully', () => {
    const text = '{"a":1,"b":[1,2,3,],"c":{"d":true,},}';
    const parsed = parseGmJson(text);
    assert.deepEqual(parsed, { a: 1, b: [1, 2, 3], c: { d: true } });
  });

  test('regression: throws on genuinely malformed JSON that is not just a trailing-comma issue', () => {
    const text = '{"a":1, "b": }';
    assert.throws(() => parseGmJson(text), SyntaxError);
  });
});

describe('ONE BULLET.resource_order', () => {
  test('parses as valid GameMaker JSON', () => {
    const text = fs.readFileSync(RESOURCE_ORDER_PATH, 'utf8');
    assert.doesNotThrow(() => parseGmJson(text));
  });

  test('declares the new npc_obj and portals folders', () => {
    const text = fs.readFileSync(RESOURCE_ORDER_PATH, 'utf8');
    const data = parseGmJson(text);

    const npcFolder = data.FolderOrderSettings.find((f) => f.name === 'npc_obj');
    const portalsFolder = data.FolderOrderSettings.find((f) => f.name === 'portals');

    assert.ok(npcFolder, 'expected npc_obj folder to be present');
    assert.equal(npcFolder.path, 'folders/Objects/npc_obj.yy');

    assert.ok(portalsFolder, 'expected portals folder to be present');
    assert.equal(portalsFolder.path, 'folders/Objects/portals.yy');
  });

  test('declares obj_creep_pool with the correct order and path', () => {
    const text = fs.readFileSync(RESOURCE_ORDER_PATH, 'utf8');
    const data = parseGmJson(text);

    const entry = data.ResourceOrderSettings.find((r) => r.name === 'obj_creep_pool');
    assert.ok(entry, 'expected obj_creep_pool to be present');
    assert.equal(entry.order, 6);
    assert.equal(entry.path, 'objects/obj_creep_pool/obj_creep_pool.yy');
  });

  test('declares the other new objects introduced by this PR', () => {
    const text = fs.readFileSync(RESOURCE_ORDER_PATH, 'utf8');
    const data = parseGmJson(text);

    const names = data.ResourceOrderSettings.map((r) => r.name);

    for (const expected of [
      'obj_f_f_f_in_shop',
      'obj_liquid_lead',
      'obj_music_controller',
      'obj_normal_room_music',
      'obj_portal_particle',
      'obj_portal_wave',
      'obj_shop_music_trigger',
    ]) {
      assert.ok(names.includes(expected), `expected ${expected} to be present in ResourceOrderSettings`);
    }
  });

  test('no longer declares obj_exorsizm in ResourceOrderSettings', () => {
    const text = fs.readFileSync(RESOURCE_ORDER_PATH, 'utf8');
    const data = parseGmJson(text);

    const names = data.ResourceOrderSettings.map((r) => r.name);
    assert.ok(!names.includes('obj_exorsizm'));
  });
});

describe('ONE BULLET.yyp', () => {
  test('parses as valid GameMaker JSON', () => {
    const text = fs.readFileSync(YYP_PATH, 'utf8');
    assert.doesNotThrow(() => parseGmJson(text));
  });

  test('registers the new obj_bandage_man_kyle and obj_creep_pool resources', () => {
    const text = fs.readFileSync(YYP_PATH, 'utf8');
    const yyp = parseGmJson(text);

    const resourceNames = yyp.resources.map((r) => r.id.name);
    assert.ok(resourceNames.includes('obj_bandage_man_kyle'));
    assert.ok(resourceNames.includes('obj_creep_pool'));

    const bandageEntry = yyp.resources.find((r) => r.id.name === 'obj_bandage_man_kyle');
    assert.equal(bandageEntry.id.path, 'objects/obj_bandage_man_kyle/obj_bandage_man_kyle.yy');

    const creepPoolEntry = yyp.resources.find((r) => r.id.name === 'obj_creep_pool');
    assert.equal(creepPoolEntry.id.path, 'objects/obj_creep_pool/obj_creep_pool.yy');
  });

  test('declares the new npc_obj and portals GMFolder entries', () => {
    const text = fs.readFileSync(YYP_PATH, 'utf8');
    const yyp = parseGmJson(text);

    const npcFolder = yyp.Folders.find((f) => f.name === 'npc_obj');
    const portalsFolder = yyp.Folders.find((f) => f.name === 'portals');

    assert.ok(npcFolder);
    assert.equal(npcFolder.resourceType, 'GMFolder');
    assert.equal(npcFolder.folderPath, 'folders/Objects/npc_obj.yy');

    assert.ok(portalsFolder);
    assert.equal(portalsFolder.resourceType, 'GMFolder');
    assert.equal(portalsFolder.folderPath, 'folders/Objects/portals.yy');
  });

  test('registers the new sound and sprite resources for this PR', () => {
    const text = fs.readFileSync(YYP_PATH, 'utf8');
    const yyp = parseGmJson(text);

    const resourceNames = yyp.resources.map((r) => r.id.name);

    for (const expected of [
      'snd_music_combat',
      'snd_music_general',
      'snd_music_shop',
      'snd_splitter_die',
      'snd_splitter_walk',
      'spr_bandage_man_kyle',
      'spr_boss_idle',
      'spr_hand_of_greed',
      'spr_liquid_lead_creep',
      'spr_portal',
      'player_idle',
    ]) {
      assert.ok(resourceNames.includes(expected), `expected resource ${expected} to be present`);
    }
  });
});