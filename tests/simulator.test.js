import test from 'node:test';
import assert from 'node:assert/strict';
import { parseProgram, stepProgram, resetProgram } from '../js/simulator.js';

test('parses rapid, linear and arc movement with modal state', () => {
  const result = parseProgram('G21 G17 G90\nG00 X0 Y0\nG01 X10 Y0 F100\nG03 X10 Y10 I0 J5');
  assert.deepEqual(result.errors, []);
  const moves = result.blocks.filter(block => block.path);
  assert.equal(result.blocks[0].state.units, 'mm');
  assert.equal(result.blocks[0].state.plane, 'G17');
  assert.equal(result.blocks[0].state.distance, 'G90');
  assert.equal(moves[0].motion, 'rapid');
  assert.equal(moves[1].motion, 'cut');
  assert.equal(moves[2].path.kind, 'arc');
  assert.equal(result.finalState.x, 10);
  assert.equal(result.finalState.y, 10);
});

test('reports spindle and coolant modal states', () => {
  const result = parseProgram('M03 S800 M08\nM09 M05');
  assert.equal(result.blocks[0].state.spindle, 'M03 clockwise');
  assert.equal(result.blocks[0].state.coolant, true);
  assert.equal(result.blocks[1].state.spindle, 'off');
  assert.equal(result.blocks[1].state.coolant, false);
});

test('G91 increments from the previous endpoint and G20 scales coordinates', () => {
  const result = parseProgram('G20 G91\nG01 X1 Y-0.5 F4');
  assert.equal(result.finalState.x, 25.4);
  assert.equal(result.finalState.y, -12.7);
});

test('rejects unsupported commands and malformed numeric words with line numbers', () => {
  const result = parseProgram('G71 X1\nG01 Xbad');
  assert.equal(result.errors.length, 2);
  assert.match(result.errors[0], /Line 1.*G71/);
  assert.match(result.errors[1], /Line 2.*XBAD/);
});

test('flags conflicting modal commands and duplicate axis words', () => {
  const result = parseProgram('G00 G01 X1 X2\nM03 M05');
  assert.equal(result.errors.length, 3);
  assert.ok(result.errors.some(error => /conflicting G codes/.test(error)));
  assert.ok(result.errors.some(error => /duplicate X word/.test(error)));
  assert.ok(result.errors.some(error => /conflicting M codes/.test(error)));
});

test('single stepping stops at the program boundary and reset returns to start', () => {
  const parsed = parseProgram('G00 X5\nG01 X8 F50');
  const once = stepProgram(parsed, 0);
  assert.equal(once.index, 1);
  const done = stepProgram(parsed, 2);
  assert.equal(done.index, 2);
  assert.equal(done.done, true);
  assert.equal(resetProgram(), 0);
  assert.deepEqual(parsed.blocks.find(block => block.path).start, { x: 0, y: 0, z: 0 });
});
