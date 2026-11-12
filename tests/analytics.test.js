import test from 'node:test';
import assert from 'node:assert/strict';
import { deriveAnalytics } from '../js/analytics.js';

test('derives category completion, valid score trend, and unique missed topics locally', () => {
  const lessons = [
    { id:'a', category:'fundamentals' },
    { id:'b', category:'fundamentals' },
    { id:'c', category:'automotive' }
  ];
  const progress = {
    completed:['a','a','unknown'],
    scores:[
      { percent:80, correct:4, total:5, date:'2026-01-01T00:00:00.000Z', missed:['coordinates','coordinates'] },
      { percent:120, correct:6, total:5, missed:['ignored'] },
      { percent:60, correct:3, total:5, missed:['coordinates','motion'] },
      null
    ]
  };
  const result = deriveAnalytics(lessons, progress);
  assert.equal(result.completed, 1);
  assert.equal(result.totalLessons, 3);
  assert.deepEqual(result.categories, [
    { category:'fundamentals', total:2, completed:1 },
    { category:'automotive', total:1, completed:0 }
  ]);
  assert.deepEqual(result.attempts.map(attempt => attempt.percent), [80,60]);
  assert.deepEqual(result.topicMisses, [{ topic:'coordinates', count:2 }, { topic:'motion', count:1 }]);
});

test('empty or malformed local history returns empty analytics without throwing', () => {
  const result = deriveAnalytics([], { completed:null, scores:'invalid' });
  assert.deepEqual(result, { categories:[], attempts:[], topicMisses:[], completed:0, totalLessons:0 });
});
