# Advanced Engineering Phase 5 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Extend the academy with advanced controller-scoped macro lessons, process optimization and DOE/PDCA activities, and a larger bilingual knowledge assessment.

**Architecture:** Add advanced topics to a dedicated module and route them through the existing lesson detail and progress system. Extend activity widgets for a small factorial response exercise and PDCA decision prompt. Expand the existing quiz content without changing its scoring engine or simulator.

**Tech Stack:** Existing vanilla JavaScript ES modules and browser DOM.

**Spec:** Phase 5 in docs/curriculum-roadmap.md and the CNC Academy user request.

## Global Constraints

- Preserve existing application behavior, quiz scoring, and simulator boundary.
- State controller and dialect assumptions for every macro syntax example.
- No macro example is accepted as a production program; do not add macro interpretation to the simulator.
- DOE values are illustrative; use approved change control, safe limits, measurement adequacy, and design review in real experiments.
- All new lessons and questions are bilingual.

## Review Focus

- Siemens ISO dialect command availability is version/mode specific.
- DOE main effects and interaction arithmetic use the stated high-minus-low convention.
- PDCA activities do not replace required change-control and validation.
- Larger quiz retains existing answer/feedback/scoring data shape.
- Advanced category navigation, progress, language toggle, and video aliases remain connected.

---

### Task 1: Add advanced lessons and learning activities

**Files:**
- Create: js/advanced-content.js
- Modify: js/app.js, index.html, js/video.js, js/content.js

- [ ] Add bilingual macro/subprogram, optimization, DOE, and PDCA lessons with official source links.
- [ ] Add editable two-factor response activity and PDCA decision activity.
- [ ] Add advanced topic animation and expand the assessment bank with bilingual questions.

### Task 2: Update project documentation and inspect changes

**Files:**
- Modify: docs/controller-notes.md, docs/curriculum-roadmap.md, README.md, docs/validation-results.md

- [ ] Document controller boundaries and NIST/ASQ references.
- [ ] Record syntax checks and explicitly note browser/test status.