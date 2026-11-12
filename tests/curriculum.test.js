import test from 'node:test';
import assert from 'node:assert/strict';
import { parseProgram } from '../js/simulator.js';
import { processLessons } from '../js/process-content.js';
import { automotiveLessons } from '../js/automotive-content.js';
import { advancedLessons } from '../js/advanced-content.js';
import { troubleshootingLessons } from '../js/troubleshooting-content.js';

const allLessons = [...processLessons, ...automotiveLessons, ...advancedLessons, ...troubleshootingLessons];

test('Phase 3–5 lessons contain bilingual teaching fields and safety guidance', () => {
  for (const lesson of allLessons) {
    for (const field of ['title','objective','explanation','mistakes','controller','safety']) {
      assert.ok(lesson[field]?.en && lesson[field]?.zh, `${lesson.id} missing bilingual ${field}`);
    }
    assert.ok(lesson.example, `${lesson.id} missing example`);
    assert.ok(lesson.videoId, `${lesson.id} missing linked animation`);
  }
});

test('controller-specific cycle examples link primary manuals and stay outside simulator support', () => {
  const cycles = processLessons.filter(lesson => /^(turn|mill)-cycle-/.test(lesson.id));
  assert.equal(cycles.length, 5);
  for (const lesson of cycles) {
    assert.ok(lesson.references?.some(reference => reference.url.startsWith('https://')));
    assert.match(lesson.controller.en, /SINUMERIK/);
    assert.ok(parseProgram(lesson.example).errors.length > 0, `${lesson.id} unexpectedly parsed`);
  }
  assert.ok(parseProgram('#100=1\nIF [#100 EQ 1] GOTO 10').errors.length > 0);
});

test('automotive capability and troubleshooting activities are available', () => {
  assert.equal(automotiveLessons.find(item => item.id === 'auto-spc-cpk')?.activity?.type, 'capability');
  assert.equal(automotiveLessons.find(item => item.id === 'auto-troubleshoot')?.activity?.type, 'troubleshoot');
});

test('advanced DOE and PDCA lessons include interactive activities', () => {
  assert.equal(advancedLessons.find(item => item.id === 'adv-doe')?.activity?.type, 'doe');
  assert.equal(advancedLessons.find(item => item.id === 'adv-pdca')?.activity?.type, 'pdca');
});

test('dedicated troubleshooting curriculum covers alarms, tool life, and maintenance', () => {
  for (const id of ['troubleshoot-alarm','troubleshoot-tool-life','troubleshoot-machine-study','troubleshoot-preventive-maintenance']) {
    assert.ok(troubleshootingLessons.some(item => item.id === id), `missing ${id}`);
  }
});
