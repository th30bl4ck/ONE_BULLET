'use strict';

/**
 * GameMaker's `.yy`, `.yyp` and `.resource_order` files are JSON-like, but
 * GameMaker itself writes a trailing comma after the last element of every
 * object/array, which is not valid per the JSON spec and makes
 * `JSON.parse()` throw. This helper strips those trailing commas so the
 * project files can be parsed and asserted on directly in tests.
 */
function parseGmJson(text) {
  const withoutTrailingCommas = text.replace(/,(\s*[}\]])/g, '$1');
  return JSON.parse(withoutTrailingCommas);
}

module.exports = { parseGmJson };