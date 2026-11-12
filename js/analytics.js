export function deriveAnalytics(lessons, progress) {
  const completedIds = new Set(Array.isArray(progress?.completed) ? progress.completed.filter(id => typeof id === 'string') : []);
  const categories = new Map();
  for (const lesson of lessons) {
    const category = lesson.category || 'other';
    const item = categories.get(category) || { category, total: 0, completed: 0 };
    item.total++;
    if (completedIds.has(lesson.id)) item.completed++;
    categories.set(category, item);
  }

  const attempts = (Array.isArray(progress?.scores) ? progress.scores : [])
    .filter(score => Number.isFinite(score?.percent) && score.percent >= 0 && score.percent <= 100)
    .map((score, index) => ({
      percent: score.percent,
      correct: Number.isFinite(score.correct) ? score.correct : null,
      total: Number.isFinite(score.total) ? score.total : null,
      date: typeof score.date === 'string' && Number.isFinite(Date.parse(score.date)) ? score.date : null,
      index
    }));

  const topicMisses = new Map();
  for (const score of Array.isArray(progress?.scores) ? progress.scores : []) {
    if (!Number.isFinite(score?.percent) || score.percent < 0 || score.percent > 100) continue;
    const missed = Array.isArray(score?.missed) ? new Set(score.missed.filter(topic => typeof topic === 'string')) : new Set();
    for (const topic of missed) topicMisses.set(topic, (topicMisses.get(topic) || 0) + 1);
  }

  return {
    categories: [...categories.values()],
    attempts,
    topicMisses: [...topicMisses.entries()]
      .map(([topic, count]) => ({ topic, count }))
      .sort((a, b) => b.count - a.count || a.topic.localeCompare(b.topic)),
    completed: lessons.filter(lesson => completedIds.has(lesson.id)).length,
    totalLessons: lessons.length
  };
}
