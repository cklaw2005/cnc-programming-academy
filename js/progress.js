const KEY = 'cnc-academy-progress-v1';
export function loadProgress(storage = globalThis.localStorage) {
  try {
    const data = JSON.parse(storage?.getItem(KEY) || '{}');
    return { language: data.language === 'zh' ? 'zh' : 'en', completed: Array.isArray(data.completed) ? data.completed : [], scores: Array.isArray(data.scores) ? data.scores : [], history: Array.isArray(data.history) ? data.history : [] };
  } catch { return { language: 'en', completed: [], scores: [], history: [] }; }
}
export function saveProgress(progress, storage = globalThis.localStorage) {
  try { storage?.setItem(KEY, JSON.stringify(progress)); return true; } catch { return false; }
}
export function scoreQuiz(answers, questions) {
  const correct = questions.reduce((n, q, i) => n + (answers[i] === q.answer ? 1 : 0), 0);
  const percent = questions.length ? Math.round(correct / questions.length * 100) : 0;
  return { correct, total: questions.length, percent, passed: percent >= 80 };
}
