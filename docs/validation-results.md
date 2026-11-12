# Phase 1 Validation Results

Date: 2026-11-12

## Automated checks

- `node --test`: **12 passed, 0 failed**. Coverage includes supported motion, G90/G91 coordinate calculation, inch-to-mm scaling, arc modal state, spindle/coolant state, unsupported/malformed commands, conflicting modal words, stepping/reset boundaries, local progress and corrupt storage, quiz threshold, video curriculum coverage, and the five guided exercises.
- `node --check` on all five JavaScript modules: **passed**.
- PowerShell parser check for `start-academy.ps1`: **passed**.
- DOM integration smoke using a lightweight browser-DOM stub: dashboard, language toggle, simulator, video, exam, and records routes **rendered without runtime errors**.

## Manual browser check

Not completed. The managed environment rejected local socket binding, so Edge/Chrome could not reach the temporary localhost server (`net::ERR_CONNECTION_REFUSED` / timeout). The app includes `start-academy.ps1` for the user’s local Windows environment; its HTTP listener itself cannot be exercised from this sandbox.

## Limits

The DOM smoke is not a substitute for visual browser testing. Inspect desktop and mobile layout, browser text-to-speech voice availability, animation timing, printing, and local-storage behavior in Edge or Chrome when running the local launcher. Video chapter scripts are English-only at this stage. No production machine, controller, or physical process was tested.

## Phase 2 update

- `node --test`: **15 passed, 0 failed**, including bilingual Phase 2 lesson coverage and checks that catalog-only instructions remain rejected by the Phase 1 simulator.
- JavaScript syntax checks: **passed** for all application modules.
- DOM lesson smoke: G28 controller note, official manual link, and Simplified Chinese rendering **passed**.
- Manual Edge/Chrome visual testing remains blocked in this sandbox because local socket binding is unavailable.

## Phase 3 review note (2026-11-12)

Added bilingual turning and milling process content plus SINUMERIK ISO Turning 07/2021 G-code system A/B cycle references (G71/G72/G76) and SINUMERIK ISO Milling 07/2022 drilling-cycle references (G81/G83). Added dedicated navigation and linked animation topics. The simulator parser and supported-code boundary were intentionally left unchanged. Node syntax checks passed for js/app.js, js/process-content.js, and js/video.js. The project test suite and browser session were not run in this continuation.

## Phase 4 review note (2026-11-12)

Added bilingual automotive cases, a user-input Cp/Cpk calculator, datum-selection activity, structured symptom checklist, and explicit video segments for capability and troubleshooting. Documented NIST and ASME references. The simulator was not changed. Node syntax checks passed for js/app.js, js/automotive-content.js, js/process-content.js, and js/video.js. Browser review and the project test suite were not run for this phase.

## Phase 5 review note (2026-11-12)

Added advanced controller-scoped lessons, DOE effect and PDCA activities, an additional animated chapter, and 10 assessment items (15 total). Simulator parsing was not modified. Node syntax checks passed for js/app.js, js/advanced-content.js, js/automotive-content.js, js/process-content.js, js/video.js, and js/content.js. Browser review and project test suite were not run for this phase.

## Local learning analytics review note (2026-11-12)

Added a dedicated local analytics page with safe derived completion counts, up to ten quiz scores as an accessible SVG trend, completion by curriculum area, and review links based on accumulated missed topics. No data is transmitted. Node syntax checks passed for js/app.js, js/analytics.js, js/advanced-content.js, and js/content.js. Browser review and project test suite were not run for this addition.

## Troubleshooting and tiered assessment continuation (2026-11-12)

Added a dedicated Engineering Troubleshooting area and Beginner/Intermediate/Advanced question pools (19 questions total) with self-review practical assignments. Node syntax checks passed for js/app.js, js/troubleshooting-content.js, js/analytics.js, and js/content.js. The assessment bank contains 18 questions split into Beginner (5), Intermediate (6), and Advanced (7). Browser review and project test suite were not run.

## Full validation pass (2026-11-12)

Ran `node --test`: 24 tests passed, 0 failed. Coverage includes parser/modal states/stepping, local progress/scoring, bilingual curriculum content, controller-scoped cycle boundaries, automotive and DOE/PDCA activities, assessment pools and practical assignments, analytics aggregation, and all seven animated curriculum chapters.

Browser validation could not be performed: the browser-use URL policy rejected the local `file:` URL and permits only HTTP(S). No workaround was attempted. Node syntax checks had passed for the changed JavaScript modules.

## Final automated test run (2026-11-12)

`node --test`: 26 passed, 0 failed. Added direct tests for the app’s English/Simplified Chinese toggle and translation fallback; `js/app.js`, `js/i18n.js`, and `js/assessment.js` passed syntax checks. Browser manual testing remains blocked by the browser URL policy for local `file:` URLs, as documented above.
