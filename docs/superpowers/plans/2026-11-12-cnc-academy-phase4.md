# Automotive Manufacturing Phase 4 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Add automotive machining case studies, GD&T/SPC/Cpk learning activities, and a guided troubleshooting aid in the existing academy.

**Architecture:** Add bilingual content in a dedicated module and use the existing lesson detail/progress/video framework. Extend the practice panel with two focused interactive widgets: a Cpk calculator with data-validity caveats and a symptom-led troubleshooting checklist.

**Tech Stack:** Existing vanilla JavaScript ES modules, HTML/CSS, browser DOM.

**Spec:** Phase 4 in docs/curriculum-roadmap.md and the user’s CNC academy request.

## Global Constraints

- Preserve existing application behavior and simulator support.
- Keep examples educational and label dimensions/process figures as illustrative.
- Cpk depends on stable, approximately normal process data and appropriate sampling/measurement; it is not an acceptance decision by itself.
- GD&T interpretation must follow the drawing and specified standard/edition; do not invent tolerances or datums.
- No dependencies or machine-ready programs.

## Review Focus

- Capability calculation uses Cp=(USL-LSL)/(6s); Cpu=(USL-mean)/(3s); Cpl=(mean-LSL)/(3s); Cpk=min(Cpu,Cpl).
- Invalid/missing numeric inputs produce a clear error, not NaN.
- Control limits and specification limits stay conceptually distinct.
- Troubleshooting shows checks in a diagnostic order and does not prescribe unverified offset changes.
- Activities support English and Simplified Chinese.

---

### Task 1: Add automotive case studies and activities

**Files:**
- Create: js/automotive-content.js
- Modify: js/app.js, index.html, js/video.js

- [ ] Add lessons for shaft/bearing seat machining, runout/datum interpretation, tool wear variation, SPC/Cpk, cycle-time optimization, and machining troubleshooting.
- [ ] Add a Cpk calculator and troubleshooting selector in the lesson activity panel.
- [ ] Add an automotive navigation page and connect lessons to the existing animated chapter.

### Task 2: Update documentation and inspect changes

**Files:**
- Modify: docs/controller-notes.md, docs/curriculum-roadmap.md, README.md, docs/validation-results.md

- [ ] Link NIST/ASME official references and explain Phase 4 boundaries.
- [ ] Record implementation limitations and verification performed.