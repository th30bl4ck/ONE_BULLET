'use strict';

const { test, describe } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const { formatHintText } = require('./logic/hintText');

const FILE_PATH = path.join(__dirname, '..', 'objects', 'obj_alexs_arsanal', 'Draw_0.gml');

describe('obj_alexs_arsanal/Draw_0.gml - hint text formatting', () => {
  test('formats the hint text with the item cost interpolated', () => {
    assert.equal(formatHintText(5), 'E - 5 coins');
  });

  test('formats correctly for a different item cost', () => {
    assert.equal(formatHintText(120), 'E - 120 coins');
  });

  test('formats correctly for a zero cost (boundary/edge case)', () => {
    assert.equal(formatHintText(0), 'E - 0 coins');
  });
});

describe('obj_alexs_arsanal/Draw_0.gml source sanity', () => {
  test('draws the hint text only when show_hint is true', () => {
    const source = fs.readFileSync(FILE_PATH, 'utf8');
    assert.match(source, /if \(show_hint\)/);
    assert.match(source, /draw_text\(x, y - 16, "E - " \+ string\(item_cost\) \+ " coins"\);/);
  });

  test('ends with a trailing newline', () => {
    const source = fs.readFileSync(FILE_PATH, 'utf8');
    assert.ok(source.endsWith('\n'));
  });
});