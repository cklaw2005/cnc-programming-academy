import test from 'node:test';
import assert from 'node:assert/strict';
import { nextLanguage, translate } from '../js/i18n.js';

test('language toggle alternates between English and Simplified Chinese', () => {
  assert.equal(nextLanguage('en'), 'zh');
  assert.equal(nextLanguage('zh'), 'en');
});

test('translation helper selects a locale and safely falls back to plain text', () => {
  assert.equal(translate({ en:'Tool path', zh:'刀具路径' }, 'en'), 'Tool path');
  assert.equal(translate({ en:'Tool path', zh:'刀具路径' }, 'zh'), '刀具路径');
  assert.equal(translate('G-code', 'zh'), 'G-code');
  assert.equal(translate({ en:'Only English' }, 'zh'), 'Only English');
});
