import test from 'node:test';
import assert from 'node:assert/strict';
import { assessmentPools, assessmentAssignments } from '../js/assessment.js';

test('assessment pools provide beginner, intermediate, and advanced questions', () => {
  assert.deepEqual(Object.keys(assessmentPools), ['beginner','intermediate','advanced']);
  assert.deepEqual(Object.values(assessmentPools).map(pool => pool.length), [5,6,7]);
  for (const pool of Object.values(assessmentPools)) {
    assert.ok(pool.every(question => question.q.en && question.q.zh && question.explain.en && question.explain.zh));
  }
});

test('each assessment level includes a practical assignment and review guide', () => {
  for (const level of ['beginner','intermediate','advanced']) {
    assert.ok(assessmentAssignments[level]?.title.en && assessmentAssignments[level]?.title.zh);
    assert.ok(assessmentAssignments[level]?.prompt.en && assessmentAssignments[level]?.prompt.zh);
    assert.ok(assessmentAssignments[level]?.model && assessmentAssignments[level]?.rubric.en && assessmentAssignments[level]?.rubric.zh);
  }
});
