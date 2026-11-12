# Curriculum Roadmap

## Phase 1 — Local fundamentals and basic simulator (implemented)

Dashboard, English/Simplified Chinese, fundamentals, G00/G01/G02/G03, M03/M05/M08/M09/M30, five guided exercises, basic assessment, locally saved progress, and a 2D educational milling toolpath view.

## Progressive video series (implemented as animated browser lessons)

1. CNC fundamentals: CNC overview; turning versus milling; axes; zero references; positioning modes; speed/feed/spindle rate.
2. G-code animation: G00/G01/G02/G03; plane selection; units; cutter compensation; G54; G90/G91.
3. M-code animation: M03/M04; M05; M06; M08/M09; M00/M01; M30.
4. Turning examples: facing, OD turning, boring, grooving, threading, drilling, wear compensation.
5. Milling examples: face/slot/pocket/contour milling, drilling cycles, tool length compensation.
6. Automotive examples: shafts, bearing seats, runout/concentricity, wear variation, SPC/Cpk, cycle-time optimization, troubleshooting.

Later video chapters are conceptual diagrams and are not evidence that Phase 1 simulator parses those codes, cycles, or process conditions.

## Platform phases

- Phase 2 (implemented): expanded bilingual G/M libraries, plane/unit/offset and compensation lessons, controller-specific reference notes. The simulator supported set did not expand.
- Phase 3 (implemented): dedicated bilingual CNC Turning and CNC Milling libraries, process-specific safety and troubleshooting context, animated turning/milling demonstrations, and reference-only verified SINUMERIK ISO canned-cycle formats. Turning references are scoped to ISO Turning 07/2021 G-code system A/B; milling drilling references are scoped to ISO Milling 07/2022. Neither is executable in the simulator.
- Phase 4 (implemented): automotive shaft/bearing-seat case studies, datum/runout interpretation, tool-wear variation, a bilingual Cpk calculator, SPC stability guidance, cycle-time review, and a symptom-led troubleshooting checklist.
- Phase 5 (implemented): advanced engineering lessons for macro/control-flow concepts, subprograms, DOE, PDCA, multi-objective optimization, and data quality; interactive factorial-effects and improvement activities; expanded bilingual 15-question assessment. The simulator still does not interpret macros. Local learning analytics now summarize completed lessons, quiz score trends, completion by curriculum area, and missed-topic review priorities; no learner data is transmitted.

Phase 4 and 5 remain future work. Every code/cycle example states its controller assumptions and links the matching manual; local machine-builder documentation remains necessary.

## Brief coverage continuation

The full brief also calls for dedicated engineering troubleshooting and tiered competency checks. These are implemented with an Engineering Troubleshooting library (alarm interpretation, program/modal-state triage, tool-life monitoring, machine-versus-process capability, and preventive maintenance) and Beginner/Intermediate/Advanced exam pools. Each exam includes a practical assignment with a self-review guide; programming examples remain educational.
