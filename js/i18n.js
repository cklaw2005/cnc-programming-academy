export function nextLanguage(current) {
  return current === 'zh' ? 'en' : 'zh';
}

export function translate(value, language = 'en') {
  if (value && typeof value === 'object') return value[language] ?? value.en ?? '';
  return value ?? '';
}
