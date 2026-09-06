# Verified source scope and provenance

The publishing baseline is clean remote `main` at
`718beac641a8094611dc249c3508a2f5415381a3`, not the older dirty checkout used
for the initial Stage A inventory. Source surfaces below are already tracked
on that baseline. The rename does not constitute a new source-faithfulness
audit or promote candidate material to completed formalization.

## Present source surfaces

Counts include an existing named umbrella, except rows explicitly labelled as
a directory. They count modules, not theorems or accepted source claims.

| Baseline surface | Tracked modules | Canonical cohort in approved map | Meaning / evidence |
|---|---:|---:|---|
| `NumStability` production tree | 3,198 | 2,401 | Remaining 797 are pre-existing compatibility modules; all old imports are retained |
| `NumStabilityTest` tree | 5,790 | Test root retained | Existing compiled import, reorganization and worker suites; additional migration fixtures are counted separately |
| `NumStability.Source.Higham` | 1,447 | 1,393 | Selected source correspondence across Chapters 1–28, including 54 older compatibility paths |
| `NumStability.HDP` | 83 | 14 | Probability aggregates and APIs; 69 previous forwarding modules remain old imports |
| `NumStability.Source.Vershynin` | 100 | 100 | Selected Chapters 1, 2 and 5, including contracts and signatures |
| `NumStability.Source.LeVeque` | 30 | 30 | Chapter 1 correspondence |
| `NumStability/Source/DrineasMahoney/` directory | 28 | 28 | RandNLA2016 source leaves; no `DrineasMahoney.lean` umbrella exists at the baseline |
| `NumStability/Analysis/PartialDifferentialEquations/` directory | 15 | 15 | Reusable PDE/finite-volume support; no umbrella of this directory name exists at the baseline |

Canonical cohort entries move under `ComputationalMathematics` according to
the exact module map; pre-existing compatibility suffixes do not acquire
invented canonical modules. The root source aggregate imports the existing
Higham, LeVeque, Vershynin and individual Drineas–Mahoney source leaves.

The LeVeque Chapter 1 gate records **47 rows: 1 PROVED, 23 READY and 23
SKIPPED**. Twenty-six completed faithfulness manifests are retained, but a
completed audit can reject a claim; that count is not a claim of 26 accepted
proofs. The source surface is not a complete executable CFD solver. The
external faithfulness runtime and source PDFs are not part of this checkout.

Higham's retained July PDF-first audit is tied to revision
`2bb76d004b7dddd0e6dfb61f84c0be8e6816fa19`. Its terminal selected-core result
is historical evidence under its stated source-strength/discrepancy/defer
rules. It does not certify every problem or every current module.

## Catalogue discovery

No authoritative candidate-book catalogue is tracked in this Lean repository.
The catalogue was verified in the sibling private `formalization-collaboration`
repository through its README and `books/README.md`, then `books/catalog.json`
and the referenced book records. The observed catalogue SHA-256 remains
`5ddc5ddd096c20949e325de2794aa90c7a34a84b9998bea8dcab9bd0d281c3e1` on
2026-09-06 UTC; the companion starting HEAD was
`38065bb3dbcc0efe198fabe9cece819f6c3dfad1` with pre-existing changes. The
following locators refer to that companion, not files promised in a public
clone. No source corpus or companion file was changed.

| Source ID | Exact title / edition | Area | Recorded status / evidence locator |
|---|---|---|---|
| `higham-accuracy-stability` | Nicholas J. Higham, *Accuracy and Stability of Numerical Algorithms*, second edition, SIAM 2002 | Floating-point error, conditioning and stability | `maintenance`; `books/higham-accuracy-stability/book.json` |
| `vershynin-hdp` | Roman Vershynin, *High-Dimensional Probability*, first edition (2018) | Probability, concentration and random matrices | `active`, source corpus complete; `books/vershynin-hdp/book.json`; partial formalization |
| `leveque-finite-volume` | Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, first printed 2002; supplied PDF copyright 2004 | Conservation laws and hyperbolic PDEs | `active`; `books/candidates/leveque-finite-volume/book.json`; its `formalization.state = not-started` conflicts with the tracked Chapter 1 work and remains a companion issue |
| `greenbaum-iterative-methods` | Anne Greenbaum, *Iterative Methods for Solving Linear Systems*, 1997 | Iterative linear solvers | `candidate`, source complete, `not-started`; corresponding `books/candidates/<id>/book.json` |
| `kettner-robust-geometry-paper` | Lutz Kettner, Kurt Mehlhorn, Sylvain Pion, Stefan Schirra, Chee Yap, *Classroom Examples of Robustness Problems in Geometric Computations*, journal version, Computational Geometry 40 (2008), 61–78 | Robust geometric computation | `candidate`, source complete, `not-started`; corresponding book record and supplied PDF front matter |
| `kruger-lattice-boltzmann` | Timm Krüger et al., *The Lattice Boltzmann Method: Principles and Practice*, 2017 | Computational fluid dynamics | `candidate`, source complete, `not-started`; corresponding book record |
| `leveque-finite-difference` | Randall J. LeVeque, *Finite Difference Methods for Ordinary and Partial Differential Equations: Steady-State and Time-Dependent Problems*, 2007 | ODE/PDE discretization | `candidate`, **source only Chapters 1–4**, `not-started`; corresponding book record and PDF title page |
| `saad-iterative-methods` | Yousef Saad, *Iterative Methods for Sparse Linear Systems*, second edition (2003) | Sparse iterative solvers | `candidate`, source complete, `not-started`; corresponding book record |
| `succi-lattice-boltzmann` | Sauro Succi, *The Lattice Boltzmann Equation for Complex States of Flowing Matter*, first edition (2018) | Kinetic/lattice Boltzmann methods | `candidate`, source complete, `not-started`; corresponding book record |
| `kinetic-models-and-macroscopic-limits` | No authoritative source supplied | Prospective kinetic theory | `needs-source` request in `books/catalog.json`; no coverage claim |
| `RandNLA2016` (module locator) | Petros Drineas and Michael W. Mahoney, *RandNLA: Randomized Numerical Linear Algebra*, CACM 59(6), 80–90, 2016 | Randomized numerical linear algebra | Tracked case study; this locator is not a companion catalogue source ID |

## Names and evidence preserved

`NumStability.FPModel`, `gamma`, numerical stability predicates, backward-error
results and source-specific declarations retain their names and statements.
LeVeque's `leveque01_equation03_advectedProfile`, conservative flux-difference
mathematics and the HDP probability statements are not rewritten as branding.

All `gates/**`, `ledgers/**` and dated `docs/source_coverage/AUDIT_*.md` remain
unchanged. Current chapter-navigation notes point to the module migration;
historical source paths and build commands remain evidence of their original
snapshot. Bibliographic titles, authors, editions, theorem numbers, source IDs
and coverage statuses are preserved.
