# Lean Computational Mathematics

[![Lean CI](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/workflows/lean_action_ci.yml/badge.svg?branch=main)](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/workflows/lean_action_ci.yml)
[![Lean](https://img.shields.io/badge/Lean-4.29.0--rc3-blue)](lean-toolchain)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Lean Computational Mathematics is a Lean 4 library of formalized results in
computational mathematics and its mathematical foundations, developed from
books and research papers. It contains reusable mathematics for floating-point
error analysis, numerical stability, matrix algorithms, finite-volume methods,
hyperbolic partial differential equations, and high-dimensional probability,
together with source-correspondence modules.

> **Active development repository:**
> [`VSCL-x-VERITAS/lean-computational-mathematics`](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics).
> The [`AlexGeorgantzas` repository](https://github.com/AlexGeorgantzas/lean-numerical-stability)
> is the upstream project history; new development, branches, and pull requests for
> this continuation should target the VSCL-x-VERITAS repository.

The broader project name reflects these multiple source developments;
numerical stability remains in scope. The canonical repository slug is
`lean-computational-mathematics`. The
[migration report](docs/migrations/lean-computational-mathematics/README.md)
records the verified GitHub cutover state and package/import compatibility.
The [implementation report](docs/migrations/lean-computational-mathematics/implementation-report.md)
records the validated source revision, preserved interfaces and publication status.

The principal source developments currently cover:

- all 28 chapters of Nicholas J. Higham's *Accuracy and Stability of Numerical
  Algorithms* (2nd ed.), within a selected audited scope;
- Chapter 1 of Randall J. LeVeque's *Finite Volume Methods for Hyperbolic
  Problems*, backed by reusable PDE and finite-volume foundations;
- Chapters 1, 2, and 5 of Roman Vershynin's *High-Dimensional Probability*,
  backed by reusable scalar-probability and concentration modules; and
- a randomized numerical linear algebra case study based on work by Petros
  Drineas and Michael W. Mahoney.

Source coverage is deliberately not described as “the whole book.” Audits
distinguish formalized claims, corrected discrepancies, claims ready for more
work, and statements that are too narrative or underspecified to formalize
faithfully.

## Current repository status

The source-only figures below compare the clean publishing base
`718beac641a8094611dc249c3508a2f5415381a3` with the repaired integration tree
captured during the passing source-gate run on 2026-09-06, 08:19:11–08:26:38 UTC.
The capture preceded its commit; that exact repaired source is now published in
candidate `51c5540984780b0011f41739b9ddaf8e505b7c93`, including the explicit
public-instance name. These figures are not a build or full-interface-preservation claim.
Its normalized source-tree SHA-256 is
`915ed2d52ada797abca1e37d5d7c8f35bcbf3bad2f30c7a6b1c282b3cc32d819`.

On 2026-09-09 the audit evidence trees were retired to their gate-bound files:
18,205 working artifacts (1.30 GB) were removed and 7,151 evidence files kept,
taking the tracked tree from 41,651 files to 23,451. The source figures below are
unaffected, since no Lean module, build target or diagnostic baseline changed. See
`docs/architecture/reviews/2026-09-evidence-retirement.md`.

| Metric | Clean base | Migrated tree |
|---|---:|---:|
| Production Lean modules, including compatibility | 3,198 | **5,599** |
| Canonical implementation / aggregate modules | 2,401 | **2,401** |
| Retained old import forwarders | 797 | **3,198** |
| Nonblank Lean source lines | 1,475,097 | **1,503,619** |
| Direct imports | 31,987 | **47,223** |
| Internal / external direct imports | 20,049 / 11,938 | **32,152 / 15,071** |
| Import cycles / unresolved project imports | 0 / 0 | **0 / 0** |
| Classified modules | 3,198 / 3,198 | **5,599 / 5,599 (100%)** |
| Modules with module documentation | 3,198 / 3,198 | **5,599 / 5,599 (100%)** |
| Aggregate modules | 443 | **443** |
| Reusable / source / internal / upstream modules | 593 / 1,355 / 5 / 5 | **593 / 1,355 / 5 / 5** |
| Mixed or unclassified modules | 0 | **0** |
| Forbidden reusable-to-source import paths | 0 | **0** |

The additional files preserve existing import interfaces; they add no new
mathematical results. The migrated compatibility map contains all 3,198 old
paths, 2,401 unique canonical targets and 14,552 forwarding edges. The checks
found no canonical production imports of historical paths, no `sorry` or
`admit`, and no unreviewed project axiom declaration. Five attributed upstream
modules and 264 Apache-2.0-marked production files, including retained
forwarding notices, are covered by the provenance gate.

Canonical modules use `ComputationalMathematics`. The package remains
`numStability`, the test root remains `NumStabilityTest`, and authored
declarations remain in their existing `NumStability` namespaces. Release 0.2.0
removed the historical `NumStability` import paths; the namespace is unaffected. The
[validation record](docs/migrations/lean-computational-mathematics/validation.md)
records passing source, clean build/test/diagnostic, downstream and strict
compiled-comparison checks for the validated source revision. The
[live tier manifest](docs/architecture/tiers.json) and
[compatibility map](docs/architecture/COMPATIBILITY.md) describe the mapped tree.

The bounded 2026-08 repository-reorganization phase is accepted at checkpoint
[`C0008`](docs/architecture/phases/2026-08-repository-reorganization-completion/checkpoints/C0008-gates.md),
whose evidence commit is `897557779a2102aa0e23b0b2f63edeb35b06bc68`.
Current `main` contains later work, including the LeVeque, MatrixPowers,
PolynomialEvaluation, Higham Chapter 2, and high-dimensional-probability
developments. Bounded-phase completion is recorded; repository-wide completion
is not claimed. See the
[`active phase registry`](docs/architecture/phases/2026-08-repository-reorganization-completion/README.md)
and [`architecture process`](docs/architecture/PROCESS.md) for the distinction.

### CI status

Validated source commit [`51c5540984780b0011f41739b9ddaf8e505b7c93`](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/commit/51c5540984780b0011f41739b9ddaf8e505b7c93)
passed [clean CI run 34021942176](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176)
on 2026-09-06 at 12:45:10 UTC. All three libraries, `lake test`, warning/lint
enforcement and the independent 13-fixture consumer passed. Authenticated
compiled comparison preserved all 58,420 declarations and their signature/body
edges, with zero differences; seven representative axiom sets also matched.
Actual Git dependency resolution and all nine dependency pins were verified.

CI checks architecture, compatibility, provenance and source policy. Manual
`clean_project=true` builds fresh project artifacts; the recorded run skipped
project cache restore/save while using the permitted Mathlib cache. It captures
the compiled graph, axiom reports and canonical/old/mixed consumer build with
exact source/fixture/pin checks. Artifacts are retained for 14 days; ordinary
push/PR cache behavior is unchanged.

The badge tracks `main`. The validated source commit and any later documentation
publication commit are distinct; a run certifies its own SHA. The
[validation record](docs/migrations/lean-computational-mathematics/validation.md)
contains exact evidence, preserved attempt history and platform/scope limits.
The [implementation report](docs/migrations/lean-computational-mathematics/implementation-report.md)
records the implementation and separate publication verification.

## Floating-point model

The core library uses an
[abstract real-arithmetic model](ComputationalMathematics/FloatingPoint/Model.lean), not a
concrete IEEE-754 implementation. An `FPModel` supplies a nonnegative unit
roundoff `u` and rounded addition, subtraction, multiplication, division, and
square root. For the binary operations, the central relative-error law is

```text
fl(x ◦ y) = (x ◦ y)(1 + δ),    |δ| ≤ u.
```

Division carries a nonzero-denominator condition, square root a
nonnegative-input condition, and the model assumes `fl_add 0 x = x`.
Individual theorems state additional guards, such as bounds ensuring that
`γ(n)` is defined.

Results are parameterized by this model. The exact-arithmetic instance
`FPModel.exactWithUnitRoundoff` is useful for proving that an overly strong
claim cannot follow from the abstract assumptions alone. Exact algebra and
matrix norms come from Mathlib. New APIs use Mathlib's `Matrix` and norm
interfaces directly; older function-shaped matrix APIs remain available
through compatibility wrappers.

## Formalized source areas

### Higham: numerical stability

All 28 Higham chapter rows are terminal under the selected audit rules. In the
table, **Closed** means compiled at source strength, **Discrepancy** means the
printed claim has a compiled counterexample and a faithful correction, and
**Defer** records an imprecise source statement or external citation rather
than a Lean proof hole. Detailed evidence lives in the
[`source_coverage` ledgers](docs/source_coverage/) and the
[`PDF-first audit`](docs/source_coverage/AUDIT_ch01-28_PDF_FIRST_2026-07-21.md).

| Ch. | Topic | Audit result |
|---:|---|---|
| 1 | Principles of finite precision | Closed |
| 2 | Floating-point arithmetic | Closed |
| 3 | Basics (dot products, `γ(n)`) | Closed |
| 4 | Summation | Closed |
| 5 | Polynomials and Horner's method | Closed |
| 6 | Norms | Discrepancy |
| 7 | Perturbation theory for linear systems | Discrepancy |
| 8 | Triangular systems | Discrepancy · Defer |
| 9 | LU factorization and linear equations | Closed |
| 10 | Cholesky factorization | Discrepancy |
| 11 | Symmetric indefinite and skew-symmetric systems | Discrepancy |
| 12 | Iterative refinement | Closed · Defer |
| 13 | Block LU factorization | Closed |
| 14 | Matrix inversion | Closed · Discrepancy · Defer |
| 15 | Condition-number estimation | Discrepancy · Defer |
| 16 | The Sylvester equation | Closed · Defer |
| 17 | Stationary iterative methods | Closed |
| 18 | Matrix powers | Closed · Defer |
| 19 | QR factorization | Closed · Discrepancy · Defer |
| 20 | The least-squares problem | Discrepancy · Defer |
| 21 | Underdetermined systems | Discrepancy |
| 22 | Vandermonde systems | Discrepancy |
| 23 | Fast matrix multiplication | Closed · Defer |
| 24 | The FFT and applications | Closed |
| 25 | Nonlinear systems and Newton's method | Discrepancy · Defer |
| 26 | Automatic error analysis | Discrepancy · Defer |
| 27 | Software issues in floating point | Discrepancy · Defer |
| 28 | A gallery of test matrices | Discrepancy · Defer |

### LeVeque: hyperbolic PDEs and finite-volume methods

Fifteen reusable modules under
[`ComputationalMathematics/Analysis/PartialDifferentialEquations/`](ComputationalMathematics/Analysis/PartialDifferentialEquations/)
provide conservation-law residuals, constant-coefficient systems,
hyperbolicity, eigenmode waves, scalar advection, linear acoustics, integral
conservation, finite-volume cell averages and flux differences, Riemann data,
Riemann-interface adapters, and operator splitting.

The 30-module LeVeque source surface begins at
[`ComputationalMathematics.Source.LeVeque`](ComputationalMathematics/Source/LeVeque.lean); its
[`Chapter01` subtree](ComputationalMathematics/Source/LeVeque/Chapter01/) connects those foundations
to Chapter 1 equations and constructions. The chapter gate outcomes and the
per-claim faithfulness decisions are summarised in
[`docs/architecture/reviews/2026-09-faithfulness-outcomes.md`](docs/architecture/reviews/2026-09-faithfulness-outcomes.md);
the audit packages themselves were the working record of that campaign and were
retired from the tree on 2026-09-10, recoverable at `afb25bab1`. Book and
workflow limitations are kept under
[`ledgers/leveque-finite-volume/`](ledgers/leveque-finite-volume/).

### Vershynin: high-dimensional probability

[`ComputationalMathematics.HDP`](ComputationalMathematics/HDP.lean) is the current high-dimensional
probability entry point. Its semantic layer covers probability preliminaries,
limit theorems, independent sums, Hoeffding and Chernoff bounds, random-graph
degree laws, sub-Gaussian and sub-exponential variables, and metric-measure
concentration.

[`ComputationalMathematics.Source.Vershynin`](ComputationalMathematics/Source/Vershynin.lean) exposes
checked source contracts and frozen signatures for selected material in
Chapters 1, 2, and 5 of *High-Dimensional Probability*. Historical
`NumStability.HDP.Contracts` and `NumStability.HDP.ContractSignatures` paths
remain supported through the compatibility map.

### Drineas–Mahoney: randomized numerical linear algebra

The RandNLA case study separates reusable algorithms and analysis under
[`ComputationalMathematics/Algorithms/RandomizedLinearAlgebra/`](ComputationalMathematics/Algorithms/RandomizedLinearAlgebra/)
from source correspondence under
[`ComputationalMathematics/Source/DrineasMahoney/RandNLA2016/`](ComputationalMathematics/Source/DrineasMahoney/RandNLA2016/).
It covers sampling, matrix concentration, low-rank approximation,
least-squares sketching, and randomized preconditioning. Historical
`NumStability.Algorithms.RandNLA` imports remain available as compatibility
paths.

## Building

Install Git and [elan](https://github.com/leanprover/elan), then clone the
active repository and select the validated source commit for reproduction:

```bash
git clone https://github.com/VSCL-x-VERITAS/lean-computational-mathematics.git lean-computational-mathematics
cd lean-computational-mathematics
git checkout 51c5540984780b0011f41739b9ddaf8e505b7c93
lake exe cache get
lake build ComputationalMathematics NumStabilityTest
lake test
```

`lake build` selects the canonical library; the explicit command above also
includes the test library. `lake test` uses the `NumStabilityTest` driver.

The project pins Lean `4.29.0-rc3` in [`lean-toolchain`](lean-toolchain) and
Mathlib revision `e8ea1afc32790ce1d4e1a4e45cc412ba9388716b` in
[`lakefile.toml`](lakefile.toml).

To build one module, pass its Lean module name to Lake, for example:

```bash
lake build ComputationalMathematics.FloatingPoint.Model
lake build ComputationalMathematics.HDP.Scalar.SubGaussian
lake build ComputationalMathematics.Source.LeVeque
```

## Key entry points

Choose the narrowest import that supplies the declarations you need.

| Import | Purpose |
|---|---|
| `ComputationalMathematics.Core` | Small reusable foundation for the floating-point model and core error analysis |
| `ComputationalMathematics.FloatingPoint` | Reusable floating-point foundations and IEEE-facing utilities |
| `ComputationalMathematics.Analysis` | Broad historical analysis discovery surface; prefer a narrower family import |
| `ComputationalMathematics.Algorithms` | Broad historical algorithm discovery surface; prefer a canonical family import |
| `ComputationalMathematics.HDP` | High-dimensional-probability semantics, contracts, and signatures |
| `ComputationalMathematics.Source` | Complete canonical umbrella for book- and paper-specific correspondence |
| `ComputationalMathematics.Source.Higham` | Higham correspondence for Chapters 1–28 and cross-chapter bridges |
| `ComputationalMathematics.Source.LeVeque` | LeVeque Chapter 1 correspondence |
| `ComputationalMathematics.Source.Vershynin` | Vershynin Chapters 1, 2, and 5 source contracts |
| `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` | Narrow reusable finite-volume update and conservation results |
| `ComputationalMathematics.All` | Complete supported library surface |
| `ComputationalMathematics` | Complete-tree entry point forwarding to `ComputationalMathematics.All` |

See [`ARCHITECTURE.md`](ARCHITECTURE.md) for API tiers and dependency rules.
Historical imports and their canonical destinations are documented in
[`docs/architecture/COMPATIBILITY.md`](docs/architecture/COMPATIBILITY.md).

## Use as a dependency

For reproducing the validated source revision, retain package name
`numStability` and pin its commit:

```toml
[[require]]
name = "numStability"
git = "https://github.com/VSCL-x-VERITAS/lean-computational-mathematics"
rev = "51c5540984780b0011f41739b9ddaf8e505b7c93"
```

Pin a reviewed commit when reproducibility is required. The inherited
`v0.1.0` tag predates the current LeVeque/HDP work and the new module root;
consumers of that tag use its original `NumStability` imports, which release
0.2.0 removed from the current tree.

A minimal current reusable import is:

```lean
import ComputationalMathematics.FloatingPoint.Model

open NumStability

#check FPModel
#check FPModel.exactWithUnitRoundoff
```

The import root and declaration namespace are different interfaces:
`ComputationalMathematics.FloatingPoint.Model` still defines
`NumStability.FPModel`. The historical `NumStability` import paths were removed
in release 0.2.0; the old-path to canonical-path table is
[`docs/architecture/migrations/2026-09-forwarder-map.json`](docs/architecture/migrations/2026-09-forwarder-map.json).

## Repository layout

The map emphasizes supported entry points and semantic boundaries rather than
listing every theorem leaf.

```text
ComputationalMathematics.lean             canonical complete-tree entry point
ComputationalMathematics/
├── Core.lean                            small reusable foundation
├── All.lean                             complete supported tree
├── FloatingPoint.lean                   floating-point umbrella
├── FloatingPoint/                       model, operation laws, FMA, and IEEE utilities
├── Analysis.lean                        broad historical analysis aggregate
├── Analysis/
│   ├── Error/, Conditioning/, Perturbation/
│   ├── MatrixNorms/, SingularValues/, Probability/
│   └── PartialDifferentialEquations/    reusable PDE and finite-volume foundations
├── Algorithms.lean                      broad historical algorithm aggregate
├── Algorithms/
│   ├── Arithmetic/, Summation/, PolynomialEvaluation/
│   ├── LinearSystems/, MatrixEquations/, MatrixPowers/
│   └── RandomizedLinearAlgebra/
├── HDP.lean                              high-dimensional-probability entry point
├── HDP/                                  scalar probability, concentration, and old contract paths
├── Source.lean                           canonical source-correspondence entry point
├── Source/
│   ├── Higham/                           Chapters 1–28 and cross-chapter correspondence
│   ├── LeVeque/                          finite-volume methods, Chapter 1
│   ├── Vershynin/                        high-dimensional probability, Chapters 1, 2, and 5
│   └── DrineasMahoney/RandNLA2016/       randomized linear algebra case study
└── Upstream/Lindemann/                   attributed Mathlib adaptation and backports

NumStabilityTest.lean                     complete test-library entry point
NumStabilityTest/
├── Import/
│   └── Canonical/                        canonical and entry-point smoke tests
├── Reorganization/                       migration and declaration-placement tests
└── Worker/                               focused proof-audit and integration suites

ledgers/                                  source/workflow issues, limitations, and inconsistencies
docs/                                     architecture, source coverage, and benchmarks
tools/                                    architecture checks and benchmark tooling
experiments/                              C/Python reproductions of selected source examples
```

## Verification and contribution

For a source-only architecture check, run:

```bash
python tools/architecture/check_phase.py --all-phases
python tools/architecture/check_completion_phase.py
python tools/architecture/check_layout.py
python tools/architecture/check_tiers.py
python tools/architecture/check_placeholders.py
python tools/architecture/check_compatibility.py
python tools/architecture/check_provenance.py
python tools/architecture/generate_baseline.py --skip-declarations --strict-source --output-dir benchmark-results/architecture --name source-check
```

CI additionally compiles its Python tooling, runs the architecture and
diagnostic checker self-tests, builds `ComputationalMathematics`
and `NumStabilityTest`, runs the literal `lake test` driver, and checks the
reviewed warning and lint baselines. Those
baselines are review records and must not be regenerated merely to silence new
findings. [`CONTRIBUTING.md`](CONTRIBUTING.md) explains placement,
compatibility, testing, and licensing requirements. Architecture changes
follow [`docs/architecture/PROCESS.md`](docs/architecture/PROCESS.md).

## Documentation

- The [identity migration report](docs/migrations/lean-computational-mathematics/README.md)
  records the public name, interface mapping, GitHub cutover and validation.
- [`docs/README.md`](docs/README.md) maps current policy and retained evidence.
- [`ARCHITECTURE.md`](ARCHITECTURE.md) defines API tiers, dependency direction,
  and supported entry points.
- [`docs/architecture/NAMING.md`](docs/architecture/NAMING.md) defines canonical
  module names and placement.
- [`docs/architecture/COMPATIBILITY.md`](docs/architecture/COMPATIBILITY.md)
  records every supported historical import path.
- [`docs/source_coverage/`](docs/source_coverage/) contains Higham's concise
  chapter ledgers and PDF-first audits.
- [`CHANGELOG.md`](CHANGELOG.md) records release-facing changes.

## Roadmap

The companion source catalogue lists six candidates whose formalization status
is `not-started`: Greenbaum and Saad on iterative linear solvers, LeVeque on
finite differences, Krüger and Succi on lattice Boltzmann methods, and Kettner
et al. on robust geometric computation. The finite-difference source
collection currently contains only Chapters 1–4. A kinetic-models and
macroscopic-limits request still needs an authoritative source.

These are candidate source materials, not completed library coverage. The
[verified source inventory](docs/migrations/lean-computational-mathematics/source-scope.md)
records exact titles, editions, source identifiers, catalogue status and the
boundary between present developments and future work.

## References

- N. J. Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed.,
  SIAM, 2002.
- R. J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Cambridge
  University Press, 2002.
- R. Vershynin, *High-Dimensional Probability: An Introduction with
  Applications in Data Science*, Cambridge University Press.
- P. Drineas and M. W. Mahoney,
  [“RandNLA: Randomized Numerical Linear Algebra”](https://dl.acm.org/doi/10.1145/2842602),
  *Communications of the ACM* 59(6), 80–90, 2016.

## License and citation

Except where an individual file states otherwise, Lean Computational Mathematics is licensed
under the [MIT License](LICENSE). Files carrying an Apache-2.0 notice are
licensed under the [Apache License, Version 2.0](LICENSES/Apache-2.0.txt).
Third-party attribution is recorded in
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md), and citation metadata is
available in [`CITATION.cff`](CITATION.cff).
