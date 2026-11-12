# CNC Programming Academy: Architecture and Phase 1 Plan

## Project architecture

- **Static browser app:** HTML, CSS, and native JavaScript modules. No build step, login, cloud service, or runtime dependency.
- **Curriculum data:** Bilingual lesson records and examples kept separate from rendering logic.
- **Simulator core:** A documented, intentionally narrow Fanuc-style milling subset parser and modal interpreter, independent from the canvas renderer.
- **Interface:** Responsive dashboard, lesson/library navigation, bilingual labels, canvas toolpath, playback controls, exercises, and assessments.
- **Video training:** A separate chapter/topic module renders original vector machine diagrams, synchronized captions, browser-speech narration, and segment controls; it does not generate or export machine footage.
- **Local records:** Versioned `localStorage` state for language, lesson completion, and scores. No account or server synchronization.
- **Validation:** Node's built-in test runner for parser, motion, and local learning behaviors; manual browser review in Edge or Chrome.

## Phase 1 scope

Deliver dashboard, English/Simplified Chinese fundamentals, G00/G01/G02/G03 lessons, M03/M05/M08/M09/M30 lessons, a 2D educational milling simulator, five guided exercises, a basic scored assessment, local progress, README, curriculum roadmap, supported-code reference, and sample programs.

The supported simulator profile is explicitly **Fanuc-style educational milling subset**: G20/G21, G17, G90/G91, G54, G00, G01, G02/G03 with I/J center offsets, F, S, M03/M05/M08/M09/M30, and line-number/comment syntax. Unsupported words/codes produce visible line-specific errors. No canned cycles, cutter compensation, tool changes, machine coordinates, lathe cycles, macros, physical-machine connection, collision detection, or production-safety claim.

The video studio covers topics across the six progressive chapters as conceptual illustrations, including topics beyond the simulator subset. Each such video states its process/controller limits. The browser's available voices and playback are operating-system dependent.

## Phase 1 plan

1. Establish static app shell, navigation, language toggle, and responsive visual system.
2. Add bilingual structured fundamentals, G/M lesson library, five guided exercises, and sample programs.
3. Implement parser/interpreter and canvas playback with rapid/cutting distinctions, modal display, current line, pause/resume/reset/step/speed.
4. Add quiz scoring, local progress/history, and printable internal training record.
5. Document opening instructions, curriculum roadmap, supported subset, examples, known limitations, and validation.
6. Run automated tests and manual browser checks for language toggle, progress, quiz, simulator controls, unsupported input, and responsive layout.

## Phase 1 acceptance checks

- All Phase 1 content is usable in English and Simplified Chinese.
- Five guided programs can be loaded and visualized; unsupported or malformed blocks are reported instead of ignored.
- Parser behavior, modal state, coordinate modes, stepping/reset, local saving, language selection, and scoring are automated test targets.
- Every simulator view is marked educational only; results are not described as machine-safe or production ready.
- Phase 2 remains out of scope pending user review.
