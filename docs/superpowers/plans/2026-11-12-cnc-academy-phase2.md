# CNC Academy Phase 2 Implementation Plan

> **For agentic workers:** Execute this plan natively, task by task. Tests are run with Node's built-in runner; no dependency installation is needed.

**Goal:** Extend the existing academy with bilingual G/M-code library lessons, deeper work-coordinate and compensation instruction, and controller-specific reference notes.

**Architecture:** Add structured lesson records to `content.js`, render controller caveats and primary-source links in the existing lesson view, and expand automated content/parser boundary checks. Keep the Phase 1 simulator profile unchanged.

**Tech Stack:** Existing HTML/CSS/JavaScript modules and Node built-in tests.

**Spec:** `docs/curriculum-roadmap.md` (Phase 2), with original requirements in the pasted project brief.

## Global Constraints

- Preserve the current app and Phase 1 behavior.
- Support English and Simplified Chinese.
- Do not imply that an educational lesson makes an instruction supported by the simulator.
- Identify controller and version assumptions; confirm real machine behavior against its manual.
- No production controller connection or machine-safe verification.

## Review Focus

- Phase 2 lessons might look executable in the visualizer; tests pin advanced codes as unsupported by its Phase 1 profile.
- A shared G-code label can behave differently across controls; test that controller caveats and source references are present.
- Every new lesson must remain bilingual; test both language fields for every Phase 2 record.
- Existing Phase 1 examples must remain accepted; retain the current test suite as regression coverage.

---

### Task 1: Add tests for the Phase 2 lesson inventory

**Files:** `tests/content.test.js`, `tests/simulator.test.js`

- [x] Assert that every Phase 2 code has a bilingual lesson record and required fields.
- [x] Assert that G28, G40/G41/G42, G43, G55–G59, M00/M01/M04/M06 still produce unsupported diagnostics in the Phase 1 simulator.
- [x] Run the tests and verify they fail before implementation.

### Task 2: Add bilingual controller-aware lesson content

**Files:** `js/content.js`, `docs/controller-notes.md`

- [x] Add plane, unit, reference-return, cutter compensation, tool-length compensation, work-offset, positioning-mode, spindle-direction, stop, and tool-change lessons.
- [x] Add a controller-variant lesson using official Siemens manual examples, with model/version and dialect stated.
- [x] Preserve the parser's Phase 1 supported set.

### Task 3: Render references in the existing lesson view

**Files:** `js/app.js`, `styles.css`

- [x] Display each lesson's controller assumption and, when present, source links.
- [x] Keep unsafe-to-simulate lessons marked as instructional reference content; do not automatically load their sample snippets into the simulator.

### Task 4: Verify and document

**Files:** `docs/supported-gcode.md`, `docs/curriculum-roadmap.md`, `README.md`, `docs/validation-results.md`

- [x] Update catalog scope and source attribution.
- [x] Run all automated tests, JavaScript syntax checks, and DOM route smoke checks.
- [x] Record manual browser limits and stop before Phase 3.
