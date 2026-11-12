import test from 'node:test';
import assert from 'node:assert/strict';
import { chapters, allVideoTopics } from '../js/video.js';
import { exercises, quiz } from '../js/content.js';

test('video curriculum has seven chapters including advanced engineering topics', () => {
  assert.equal(chapters.length, 7);
  for (const id of ['v-intro','v-axes','v-zero','v-absolute','v-feed','v-g00','v-g01','v-g02','v-g03','v-m03','v-m05','v-m08','v-m30']) {
    assert.ok(allVideoTopics.some(topic => topic.id === id), `missing ${id}`);
  }
  assert.ok(allVideoTopics.some(topic => topic.title.includes('M08 / M09')));
  for (const id of ['v-turn-cycle-g71','v-turn-cycle-g72','v-turn-cycle-g76','v-mill-cycle-g81','v-mill-cycle-g83','v-auto-cpk','v-auto-troubleshoot','v-adv-doe','v-adv-pdca']) {
    assert.ok(allVideoTopics.some(topic => topic.id === id), `missing ${id}`);
  }
});

test('each video topic includes interpretation, purpose, motion, mistake and safety copy', () => {
  for (const topic of allVideoTopics) {
    for (const field of ['code','move','why','mistake','safety']) assert.ok(topic[field], `${topic.id} missing ${field}`);
  }
});

test('academy contains five guided simulator exercises and a bilingual assessment bank', () => {
  assert.equal(exercises.length, 5);
  assert.ok(exercises.every(exercise => exercise.code && exercise.prompt.en && exercise.prompt.zh && exercise.answer));
  assert.equal(quiz.length, 18);
  assert.ok(quiz.every(question => question.explain.en && question.explain.zh && question.q.en && question.q.zh));
});
