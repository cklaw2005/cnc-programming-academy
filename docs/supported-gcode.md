# Supported Simulator Reference

## Profile

The simulator implements a deliberately small **Fanuc-style educational milling subset**. It is not a promise of compatibility with any Fanuc control version or machine builder. The selected profile is XY top view (G17) with metric internal display and optional inch input converted to millimetres.

## Supported words

| Word | Phase 1 interpretation |
| --- | --- |
| G00 | Rapid positioning to specified endpoint; rendered as a dashed amber endpoint connector. The connector is illustrative and does not represent or infer the machine's actual rapid path. |
| G01 | Straight feed move; rendered solid green. |
| G02/G03 | Circular interpolation in G17 XY only, center supplied by incremental I/J from block start. |
| G17 | XY plane selection. |
| G20/G21 | Inch/mm coordinate scaling; displayed coordinates are in millimetres. |
| G54 | Modal work coordinate label only; no real machine offset transform is performed. |
| G90/G91 | Absolute / incremental XY(Z) coordinate interpretation. |
| M03/M05 | Spindle state illustration only. |
| M08/M09 | Coolant state illustration only. |
| M30 | End state marker; not all machine reset/rewind behavior is modeled. |
| X/Y/Z/I/J/F/S | Numeric position, center offset, feed, and spindle-speed words. |
| N, parenthetical comments, semicolon comments | Ignored as line numbering/comment syntax. |

## Rejected or not modeled

G18/G19, G28, G40/G41/G42, G43, G55–G59, M00/M01/M04/M06, canned cycles including G71/G72/G76 and drilling cycles, tool tables, cutter/tool compensation, machine coordinate transforms, feed-per-revolution mode, macros, subprograms, probing, coolant variants, spindle override, stock/material removal, collision detection, machine kinematics, and physical I/O.

Phases 2–3 add bilingual **library lessons** and controller-scoped cycle references for several of these codes. The list above remains the parser boundary: a lesson or reference does not make its code executable in the simulator.

An unsupported or malformed word creates a line-specific diagnostic. Playback and stepping are disabled while diagnostics exist. Never infer safe behavior from a path preview.

## Arc constraints

Only G17 arcs with I/J center offsets are modeled. I/J are treated as incremental center offsets from the start point for this profile. The parser does not validate equal radii, sweep limits, machine arc tolerances, or controller-specific conventions. A mathematically plausible drawing is not proof that a control will accept or safely execute a block.
