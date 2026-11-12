import test from 'node:test';
import assert from 'node:assert/strict';
import { lessons } from '../js/content.js';
import { parseProgram } from '../js/simulator.js';

const phase2Ids = ['g17-g19','g20-g21','g28','g40-g42','g43','g54-g59','g90-g91','m00-m01','m04','m06','controller-variants'];

test('Phase 2 code lessons are bilingual and identify their controller assumptions', () => {
  for (const id of phase2Ids) {
    const lesson = lessons.find(item => item.id === id);
    assert.ok(lesson, `missing lesson ${id}`);
    for (const field of ['title','objective','explanation','mistakes','controller']) {
      assert.ok(lesson[field]?.en && lesson[field]?.zh, `${id} missing bilingual ${field}`);
    }
    assert.ok(lesson.example, `${id} missing example`);
    assert.ok(lesson.practice?.prompt?.en && lesson.practice?.prompt?.zh && lesson.practice.answer, `${id} missing bilingual practice`);
  }
});

test('Phase 2 reference-only codes remain explicitly unsupported by the Phase 1 simulator', () => {
  for (const code of ['G18','G28','G40','G41','G42','G43','G55','G56','G57','G58','G59','M00','M01','M04','M06']) {
    const result = parseProgram(`${code} X1`);
    assert.ok(result.errors.some(error => error.includes(`unsupported ${code[0]}`)), `${code} was silently accepted`);
  }
});

test('G17/G19 concepts and universal position modes have separate catalog coverage', () => {
  for (const code of ['G17','G18','G19','G20','G21','G90','G91']) {
    assert.ok(lessons.some(lesson => lesson.category === 'gcode' && lesson.code?.includes(code)), `missing ${code}`);
  }
});
