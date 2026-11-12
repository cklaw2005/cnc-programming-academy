# CNC Programming Academy

A locally hosted, bilingual CNC training academy covering programming fundamentals through advanced engineering, with a bounded educational toolpath simulator, seven animated training chapters, tiered assessments, local progress, and engineering troubleshooting.

## Open in Microsoft Edge

1. In File Explorer, right-click `start-academy.ps1` and choose **Run with PowerShell**. If Windows blocks local scripts, open PowerShell in this folder and run `.\start-academy.ps1`.
2. The launcher serves only this folder at `http://127.0.0.1:8765/` and opens Microsoft Edge. Keep the PowerShell window open during training; press Ctrl+C there to stop.
3. Use **中文** / **EN** in the upper right to change interface and lesson language.

The site has no build step, paid/cloud dependency, or runtime package dependency. The small PowerShell launcher provides the local HTTP origin required by browser JavaScript modules. Browser speech synthesis is used for narration where available; voice choice and availability depend on the installed browser and operating system. Progress is kept in that browser's local storage.

## Platform features

- Fundamentals lessons: CNC introduction, lathe/mill distinction, axes and coordinates, machine/workpiece zero, G90/G91, speed/feed/spindle rate.
- G-code lessons: G00, G01, G02, G03.
- M-code lessons: M03, M05, M08, M09, M30.
- Fanuc-style milling subset simulator with 2D XY path, rapid/cut distinction, coordinates and modal state, line tracking, controls, and diagnostics.
- Five guided exercises, basic scored assessment (80% pass), local progress, printable internal training record.
- Video-training studio with seven progressive chapters and animated diagrams. Narration uses browser text-to-speech. Later chapters are conceptual demonstrations and do not imply simulator support for their codes or operations.
- Phase 2 G/M-code library lessons covering plane selection, units, reference return, cutter/tool-length compensation, work offsets, positioning modes, optional stops, reverse spindle direction, and tool changes, with controller caveats and primary manual references.
- Phase 3 CNC Turning and CNC Milling libraries with bilingual process lessons, operation safety notes, progress tracking, and animated examples. Reference-only SINUMERIK ISO cycle cards document G71/G72/G76 (ISO Turning 07/2021, G-code system A/B) and G81/G83 (ISO Milling 07/2022); each links the relevant official Siemens manual. These canned cycles remain unsupported in the simulator.
- Phase 4 automotive case studies covering shaft and bearing seats, GD&T datum/runout interpretation, tool wear, SPC and capability. Includes an interactive Cp/Cpk calculator and symptom-led troubleshooting checklist with explicit process stability and measurement caveats.
- Phase 5 Advanced Engineering library with controller-scoped macro/control-flow and subprogram lessons, interactive DOE effects and PDCA activities, optimization/data-quality lessons, expanded animated chapter, and a 18-question bilingual bank split across Beginner, Intermediate, and Advanced assessments. Each tier includes a practical assignment and review guide. Macro interpretation remains outside the simulator. Local learning analytics show lesson completion, quiz score trends, and review priorities from browser-stored progress only.
- Engineering Troubleshooting library covering controller-specific alarms, modal/program triage, tool life monitoring, machine versus process capability, and preventive maintenance.

## Tests

Install no test dependencies. With Node.js available, run from this folder:

```powershell
node --test
```

See [validation results](docs/validation-results.md): the automated suite passes; manual browser review remains outstanding because the browser-use policy blocks local file URLs.

## Safety and accuracy limits

This is original educational content and a simulator, not a CNC controller. It cannot connect to machine equipment and does not provide full collision checking, stock removal, material behavior, machine kinematics, or machine-safe verification. It must not be used to generate or approve production files. Phase 2 expanded the lesson library; the simulator remains at the Phase 1 supported-code boundary. See [supported G-code reference](docs/supported-gcode.md) and [controller notes](docs/controller-notes.md) before using the simulator. Confirm all code and setup against the actual controller and machine manuals before any real-world application.

## Video studio limits

The video studio renders original vector-style diagrams with captions and segment-based narration synchronized to the selected segment. Video chapter scripts are currently English-only; the interface and Phase 1 text lessons are bilingual, but Chinese video captions and narration still need translation. Speech synthesis requires a browser voice and may not be available offline on every computer. These are interactive animated lessons, not exported MP4s or recordings of actual machines. Operation-specific demonstrations are illustrative only.

## Standalone movie

The project also includes a narrated 1080p MP4 overview, `videos/standalone/CNC-Programming-Essentials.mp4`, with burned-in captions and a separate narration transcript. It introduces coordinates and work offsets, G90/G91, G00/G01, G02/G03, common M-codes, turning versus milling, automotive dimensional quality, and safe prove-out. The diagrams are original vector-style training illustrations, not machine footage or a production simulation.

To regenerate the movie on Windows, run `.\videos\render-cnc-essentials.ps1` from the project folder. This requires FFmpeg, PowerShell, and an installed Windows speech voice. The renderer source is `videos/render-cnc-essentials.ps1`.

## Project files

- `js/content.js` — bilingual fundamentals/G/M lessons and activities.
- `js/process-content.js` — bilingual turning/milling process lessons and controller-scoped cycle references.
- `js/automotive-content.js` — automotive process cases, references, and interactive activity data.
- `js/advanced-content.js` — advanced engineering lessons, references, and activities.
- `js/analytics.js` — derived local-only learning progress summaries.
- `js/i18n.js` — bilingual value selection and language toggling helpers.
- `js/troubleshooting-content.js` — engineering troubleshooting and maintenance lessons.
- `js/simulator.js` — supported subset parser and modal interpretation.
- `js/progress.js` — local progress and quiz scoring.
- `js/video.js` — video chapter content.
- `js/app.js`, `styles.css`, `index.html` — interface and diagrams.
- `docs/curriculum-roadmap.md` — progressive curriculum.
- `docs/supported-gcode.md` — simulator semantics and exclusions.
- `docs/controller-notes.md` — Phase 2/3 controller-specific distinctions and source manuals.
- `examples/` — illustrative programs.
