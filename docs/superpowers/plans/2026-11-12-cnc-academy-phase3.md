# CNC Turning and Milling Phase 3 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Add bilingual turning and milling lesson libraries and verified SINUMERIK ISO cycle references while preserving the existing simulator and features.

**Architecture:** Keep the simulator parser unchanged. Add process lessons in a dedicated content module, route them through two new library pages, and extend existing animated video curriculum with corresponding demos. Store cycle examples with explicit manual edition/dialect attribution and source links.

**Tech Stack:** Existing vanilla JavaScript ES modules, HTML/CSS, Node built-ins.

**Spec:** User CNC Programming Academy request and Phase 3 continuation roadmap.

## Global Constraints

- Preserve existing functionality and source behavior.
- Provide English and Simplified Chinese lesson copy.
- Label reference cycle syntax as SINUMERIK ISO Turning G-code system A/B (07/2021) or SINUMERIK ISO Milling (07/2022) only.
- Cycle examples are documentation references, not simulator inputs or production programs.
- Do not add dependencies or change simulator-supported codes.

## Review Focus

- Repeated G-code cycle numbers can mean different operations by dialect; label G-code system A/B and contrast G-code system C.
- Modal cycle examples require G80 cancellation and clear-plane reasoning.
- Turns and mills use different axes/tool/workpiece motion.
- All lessons need bilingual fields and accurate safety/measurement cautions.
- Existing navigation/search/progress/video aliases must work after adding pages.

---

### Task 1: Add process lesson content and controller references

**Files:**
- Create: js/process-content.js
- Modify: docs/controller-notes.md, docs/supported-gcode.md

- [ ] Add bilingual topics for turning operations (facing, external turning, boring, grooving, threading, drilling, wear compensation) and milling operations (face, slot, pocket, contour, drilling cycles, length compensation).
- [ ] Include reference-only G71/G72/G76 turning cycle catalog and G81/G83 drilling catalog, manual edition/dialect, citations, caveats.
- [ ] Explain G-code system C mapping differences in controller notes.

### Task 2: Add pages and connect lessons to animation

**Files:**
- Modify: index.html, js/app.js, js/video.js, styles.css

- [ ] Add CNC Turning and CNC Milling nav labels in English and Chinese.
- [ ] Render new content with existing lesson/detail layout, search, completion records, and guided practice.
- [ ] Link relevant process lessons to existing animated turning/milling topics and add explicit cycle animation topics.

### Task 3: Update project documentation and inspect regressions

**Files:**
- Modify: README.md, docs/curriculum-roadmap.md, docs/validation-results.md

- [ ] Mark Phase 3 implemented and define limitations.
- [ ] Confirm existing simulator files and supported-code list are unchanged.
- [ ] Manually review source/content consistency and file diffs.