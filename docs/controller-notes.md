# Phase 2 Controller Notes

Phase 2 adds instruction-oriented lessons; it does **not** add these instructions to the Phase 1 simulator. The selected simulator remains a narrow Fanuc-style milling teaching profile. A code number alone is not a compatibility statement.

## Reference examples from official Siemens manuals

- The SINUMERIK 802D ISO Dialect M function table lists plane selection, inch/metric input, G28 reference point, cutter-radius compensation, positive tool-length offset, and a model-specific set of zero offsets. This is one manual and dialect; it is not universal Siemens behavior.
- A SINUMERIK 802D sl / 840D ISO milling manual describes G28 with a programmed intermediate position followed by reference return for the documented family, and gives restrictions involving compensation. Do not transfer that sequence to another control without checking its own manual.
- A SINUMERIK 828D programming manual documents a model-specific distinction for the 5th/6th settable zero offsets. This demonstrates why neighboring controller families and versions need separate verification.
- A SINUMERIK 808D ADVANCED ISO-dialect manual states that non-specific M functions are defined by the machine manufacturer and describes M08/M09 as examples. The machine-tool builder's documentation remains necessary for actual behavior.

## Primary sources

- [SINUMERIK 802D ISO Dialect M manual (2001), G function list](https://cache.industry.siemens.com/dl/files/185/67599185/att_112653/v1/802D_ISF_0901_en.pdf)
- [SINUMERIK 802D sl / 840D ISO Milling manual (2007), reference return](https://support.industry.siemens.com/cs/attachments/28755188/PGM_0407_en.pdf)
- [SINUMERIK 828D Programming Manual Fundamentals (2013), settable zero offsets](https://cache.industry.siemens.com/dl/files/554/74475554/att_56792/v1/PGsl_0313_en_en-US.pdf)
- [SINUMERIK 808D ADVANCED ISO Dialects manual (2018), machine-defined M functions](https://cache.industry.siemens.com/dl/files/974/109759974/att_959772/v1/808D_ADV_ISO_dialects_op_man_0718_en-US.pdf?download=true)

The official FANUC America training and product pages describe G-code training and ISO-format programming software, but are not a substitute for the exact FANUC control-series programming manual or machine-tool builder manual. The academy therefore labels its introductory examples “Fanuc-style” and avoids asserting universal FANUC compatibility.

## Training boundaries

G28, G40/G41/G42, G43, G55–G59, M00/M01/M04/M06 and non-G17 planes are catalog-only in Phase 2. G54 in the simulator remains a displayed label without a physical coordinate transform. Compensation, tool tables, reference-return trajectories, tool changes, optional-stop configuration, and machine-specific M-code timing are not modeled.

## Phase 3 cycle references and process lessons

The turning and milling libraries add process lessons and animated cycle concepts. The cycle reference cards are intentionally controller-scoped and are never sent to the simulator:

- SINUMERIK ISO Turning Programming Manual 07/2021, G-code system A/B: G71 longitudinal stock removal, G72 transverse/face stock removal, and G76 multiple thread cutting. The same manual documents different cycle meanings in G-code system C (G73 longitudinal roughing, G72 finishing, G78 multiple threading). The selected system must be confirmed on the actual control.
- SINUMERIK ISO Milling Programming Manual 07/2022: G81 preboring/drilling and G83 deep-hole drilling with chip removal. G80 cancels modal drilling cycles in the documented ISO mode. Check return plane and cycle behavior against the machine configuration.

These syntax patterns are incomplete reference formats, not complete NC programs. They omit setup-specific datums, tool data, clearances, stock, workholding, machine options, and validated process parameters. The educational simulator still rejects canned cycles and remains a Fanuc-style G17 milling teaching subset.

Primary sources:

- [SINUMERIK 828D/840D sl ISO Turning Programming Manual (07/2021)](https://support.industry.siemens.com/cs/attachments/109801227/ONE_840Dsl_828D_iso_turning_progr_man_0721_en-US.pdf)
- [SINUMERIK 828D/840D sl ISO Milling Programming Manual (07/2022)](https://support.industry.siemens.com/cs/attachments/109813913/ONE_iso_milling_progr_man_0722_en-US.pdf)

## Phase 4 automotive quality learning

Automotive case studies use illustrative process scenarios. GD&T content is conceptual and must follow the released product definition and its governing standard/edition. The academy specifically avoids treating runout, size, cylindricity, and concentricity as interchangeable characteristics. [ASME Y14.5](https://www.asme.org/codes-standards/find-codes-standards/dimensioning-and-tolerancing) is the authoritative standard referenced for GD&T principles.

The Cpk practice calculates Cp, Cpu, Cpl, and Cpk from entered LSL, USL, mean, and sample standard deviation. Its training note requires stability, adequate representative data, appropriate distribution assumptions, and measurement-system adequacy. NIST states that capability compares an in-control process with specification limits, and that stability should be established first. Control limits are distinct from specification limits. Consult the customer control plan and quality system for actual acceptance and reaction rules.

Primary references:

- [NIST Engineering Statistics Handbook — What is Process Capability?](https://www.itl.nist.gov/div898/handbook/pmc/section1/pmc16.htm)
- [NIST Engineering Statistics Handbook — Assessing Process Stability](https://www.itl.nist.gov/div898/handbook/ppc/section4/ppc45.htm)
- [ASME Y14.5 — Dimensioning and Tolerancing](https://www.asme.org/codes-standards/find-codes-standards/dimensioning-and-tolerancing)

## Phase 5 advanced programming and improvement references

Macro/control-flow syntax is presented only as a named-control reference. The [SINUMERIK ISO Dialects Function Manual 07/2021](https://support.industry.siemens.com/cs/attachments/109801254/ONE_840Dsl_828D_iso_dialects_fct_man_0721_en-US.pdf) lists selected Siemens language commands available in its documented ISO dialect mode. This does not make them universal G-code syntax or simulator-supported features. Check control family, software, active mode, options, and machine-builder implementation.

The DOE lesson uses an illustrative two-factor response table. NIST lists planning objectives, variables, design, execution, assumption checks, analysis, and result use as core DOE steps; check the measurement system and process conditions before real trials. See [NIST DOE steps](https://itl.nist.gov/div898/handbook/pri/section1/pri13.htm) and [DOE fundamentals](https://www.itl.nist.gov/div898/handbook/pmd/section3/pmd31.htm). [ASQ’s PDCA guidance](https://asq.org/quality-resources/pdca-cycle) describes planning a change, testing it at small scale, checking evidence, and acting on what was learned. These methods do not replace machine safety review, customer approval, or controlled validation.
