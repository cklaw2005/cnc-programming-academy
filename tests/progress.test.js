import test from 'node:test';
import assert from 'node:assert/strict';
import { loadProgress, saveProgress, scoreQuiz } from '../js/progress.js';

function store(seed = null) { let value = seed; return { getItem: () => value, setItem: (_, next) => { value = next; }, value: () => value }; }
test('saves and reloads language and completed lessons', () => { const s = store(); const p = { language: 'zh', completed: ['g00'], scores: [], history: [] }; saveProgress(p, s); assert.deepEqual(loadProgress(s), p); });
test('falls back safely when persisted JSON is corrupt', () => { assert.deepEqual(loadProgress(store('{bad')), { language: 'en', completed: [], scores: [], history: [] }); });
test('scores deterministic assessment at the 80 percent pass mark', () => { const qs = [{ answer: 1 }, { answer: 2 }, { answer: 0 }, { answer: 1 }, { answer: 2 }]; assert.equal(scoreQuiz([1,2,0,1,0], qs).passed, true); assert.equal(scoreQuiz([1,2,0,0,0], qs).passed, false); });
