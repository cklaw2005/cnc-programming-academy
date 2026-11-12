# Local Learning Analytics Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Add useful local learning analytics from lesson completion and quiz history without collecting or transmitting learner data.

**Architecture:** Derive aggregate analytics from existing local progress, scores, and lesson catalog in a pure helper. Add a dedicated analytics page with a score trend SVG, category completion, and missed-topic review links. Add navigation and a dashboard entry point.

**Tech Stack:** Existing vanilla JavaScript ES modules, browser localStorage, inline SVG.

**Spec:** Remaining learning analytics item from docs/curriculum-roadmap.md.

## Global Constraints

- Preserve current local progress storage and quiz scoring.
- Use only recorded lesson completion and quiz attempts; do not imply time-on-task or competency certification.
- Escape labels and validate stored score values before rendering.
- No network transmission, dependencies, or simulator changes.

## Review Focus

- Empty histories show an informative state.
- Malformed/out-of-range locally stored values do not break the chart.
- Recommendations map to relevant lesson-library pages.
- English and Simplified Chinese UI strings remain complete.
- Analytics remain explicitly internal and non-accredited.

---

### Task 1: Derive local analytics and add the page

**Files:**
- Create: js/analytics.js
- Modify: js/app.js, index.html, styles.css

- [ ] Add safe derived summary for category completion, score trend, and missed topics.
- [ ] Add a responsive accessible SVG trend chart and review links.
- [ ] Add analytics navigation and dashboard access in English and Simplified Chinese.

### Task 2: Update project documentation and inspect changes

**Files:**
- Modify: docs/curriculum-roadmap.md, README.md, docs/validation-results.md

- [ ] Mark learning analytics implemented with exact data/limitations.
- [ ] Record syntax and browser/test verification status.