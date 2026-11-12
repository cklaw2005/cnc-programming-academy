# CNC Academy Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local bilingual CNC learning site for Phase 1, including fundamentals, basic G/M lessons, educational milling simulation, exercises, assessments, and saved progress.

**Architecture:** Native HTML/CSS/ES modules; structured bilingual course data; isolated supported-subset parser/interpreter; responsive canvas UI; versioned localStorage records; animated chapter video module with browser speech; Node built-in test runner.

**Tech Stack:** HTML, CSS, modern JavaScript modules, Canvas 2D, Node.js test runner (tests only).

**Spec:** `docs/architecture-and-phase1-plan.md`

## Global Constraints

- Run locally in Microsoft Edge or Chrome.
- Keep video topic demonstrations clearly separate from supported simulator instructions.
- No paid software, subscriptions, or cloud services.
- Support English and Simplified Chinese.
- Save learning progress locally.
- Educational simulator, not a production CNC controller.
- Clearly label Fanuc-style controller assumptions and reject unsupported instructions.

## Review Focus

- Unknown words and commands must produce visible errors; test unsupported-code rejection.
- Incremental coordinates and arc centers must resolve correctly; test G90/G91 and I/J arcs.
- Changing language must preserve current progress; test language toggle with saved state.
- Clearing or corrupting local storage must not prevent app startup; test invalid persisted JSON fallback.
- Animation must not execute beyond the parsed program or desynchronize single-step; test stepping/reset boundaries.

---

### Task 1: Static shell and bilingual course content

**Files:** `index.html`, `styles.css`, `js/app.js`, `js/content.js`

- [ ] Create responsive application shell with sidebar navigation, dashboard cards, language toggle, lessons, simulator area, and accessible controls.
- [ ] Add bilingual fundamentals and G/M lesson copy plus five illustrative guided programs.
- [ ] Manually inspect at desktop and narrow viewport widths.

### Task 2: Simulator core

**Files:** `js/simulator.js`, `tests/simulator.test.js`

- [ ] Test supported commands, modal changes, coordinate modes, rapid/feed distinctions, I/J arc endpoints, and line-numbered errors.
- [ ] Implement `parseProgram(source)` returning `{ blocks, errors, finalState }`; reject every unrecognized executable word.
- [ ] Test reset and single-step execution boundaries.

### Task 3: Simulator interface and lesson activities

**Files:** `js/app.js`, `js/simulator.js`, `styles.css`

- [ ] Render parsed paths to canvas with axes, rapid/cutting styles, coordinates, active modal state, and current block.
- [ ] Wire play, pause, resume, reset, step, speed, example selection, and line highlighting.
- [ ] Add guided exercise reveal/check behavior and concise lesson knowledge checks.

### Task 4: Local progress and assessment

**Files:** `js/progress.js`, `js/app.js`, `tests/progress.test.js`

- [ ] Test lesson completion, quiz scoring, language persistence, corrupted storage fallback, and history.
- [ ] Implement versioned localStorage persistence and deterministic 80% pass threshold.
- [ ] Add printable training record labeled internal training record, not accredited certification.

### Task 5: Documentation and validation

**Files:** `README.md`, `start-academy.ps1`, `docs/curriculum-roadmap.md`, `docs/supported-gcode.md`, `examples/*.nc`

- [ ] Document curriculum phases, subset semantics, controller-specific behavior, limitations, and Edge opening instructions.
- [ ] Include progressive video chapters and explain that later-topic diagrams are conceptual and use browser-dependent speech voices.
- [ ] Run `node --test` and perform browser checks in Edge or Chrome.
- [ ] Report verified results and remaining limits; do not start Phase 2.
