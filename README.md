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

## Source coverage at a glance

| Source | Published material | Coverage status |
|---|---|---|
| Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed. | Selected material across Chapters 1–28 | All 28 chapter rows terminal under the selected audit rules; proofs, discrepancies and deferrals are distinguished below |
| LeVeque, *Finite Volume Methods for Hyperbolic Problems* | Chapters 1–3 and accepted Chapter 4 results | Chapters 2 and 3 have complete audited scopes; Chapter 4 has 116/139 resolved obligations, with 23 unfinished |
| Eymard, Gallouët and Herbin, *Finite Volume Methods*, January 2019 manuscript | Chapter 1 introduction and supporting finite-volume models | 3/46 obligations accepted; 43 unfinished; compiled candidate targets are included |
| Vershynin, *High-Dimensional Probability* | Selected Chapters 1–2 results and Chapter 3 contracts | Chapter 1 remains active; Chapter 2 has a complete recorded scope including discrepancies and a weaker result; Chapter 3 has no completed chapter gate |
| Drineas and Mahoney, “RandNLA: Randomized Numerical Linear Algebra” | Selected sampling, sketching, low-rank and preconditioning results | A source-linked case study; no complete-paper coverage claim |

The detailed sections below link the source modules and coverage records.
A proof-free contract or a definition of a target proposition records a
statement to be proved. Accepted source results require their own proof and
source-faithfulness evidence. Source audits distinguish accepted proofs, reuse,
corrected source discrepancies, weaker results and unfinished work. The chapter
scopes above do not imply whole-book formalization.

## Current repository status

The October 26, 2026 snapshot is published commit
[`d23b546e`](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/commit/d23b546e518c9451979708f51e0d81d1b3a11454),
which includes the LeVeque Chapter 4 and Eymard Chapter 1 publications.
The measurements below come from a strict source scan of that revision and the
[tier manifest](docs/architecture/tiers.json). Local campaigns and unpublished
branches are excluded.

| Snapshot metric | Value |
|---|---:|
| Production Lean modules | 4,291 |
| Reusable / source / aggregate / internal / upstream | 1,018 / 2,806 / 457 / 5 / 5 |
| Classified modules | 4,291 / 4,291 (100%) |
| Mixed or unclassified modules | 0 |
| Nonblank Lean source lines | 1,632,038 |
| Direct imports | 35,464 |
| Import cycles / unresolved project imports | 0 / 0 |
| Forbidden reusable-to-source import paths | 0 |
| Test Lean modules (including the root) | 154 |
| Reviewed warning baseline | 336 diagnostics |
| Reviewed lint baseline | 4,014 findings |
| Tracked files / size | 4,993 / 111.4 MB |

Module counts measure files, not theorems or accepted source claims. Warning
and lint counts are reviewed baselines enforced by CI. Tracked size sums Git
blob bytes in the snapshot, excluding history, dependencies and build artifacts.

The exact snapshot's [main push CI](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/40370404457)
passed architecture and provenance checks, the library and test builds,
`lake test`, and warning/lint enforcement. The badge tracks later `main` runs;
a successful run certifies its own commit. CI also checks source placeholders,
documentation links and Python tooling. Its optional clean-project job captures
a compiled dependency graph, representative axioms and a downstream consumer;
see the [validation record](docs/migrations/lean-computational-mathematics/validation.md)
for the separately verified identity-migration revision and its scope.

Release 0.2.0 removed the historical `NumStability` import forwarders. Canonical
imports use `ComputationalMathematics`; the package remains `numStability`, the
test root `NumStabilityTest`, and declaration namespaces `NumStability`.
Historical measurements and compatibility decisions are retained in the
[migration reports](docs/migrations/lean-computational-mathematics/README.md),
[architecture phase records](docs/architecture/phases/2026-08-repository-reorganization-completion/README.md)
and [changelog](CHANGELOG.md).

## Mathematical coverage

The following map covers the current library's main mathematical families.
Links lead to implementations or source correspondence; the source status above
and each declaration's hypotheses determine the strength of a particular result.
Directory presence alone is not a chapter-completion claim.

| Area | Material available | Where to start |
|---|---|---|
| Floating-point arithmetic | Abstract rounding models, operation laws, unit roundoff, fused multiply-add, finite-format and IEEE-facing examples, underflow and special-value analysis | [FloatingPoint](ComputationalMathematics/FloatingPoint/), [floating-point analysis](ComputationalMathematics/Analysis/FloatingPointArithmetic/) |
| Error, stability and conditioning | Forward, backward and mixed error, normwise and componentwise perturbations, first-order bounds and problem-dependent stability | [error measures](ComputationalMathematics/Analysis/Error/), [conditioning](ComputationalMathematics/Analysis/Conditioning/), [perturbations](ComputationalMathematics/Analysis/Perturbation/) |
| Arithmetic and summation algorithms | Dot products, matrix-vector/matrix-matrix products, pairwise and compensated summation, accumulation and rounding-error bounds | [arithmetic](ComputationalMathematics/Algorithms/Arithmetic/), [summation](ComputationalMathematics/Algorithms/Summation/), [matrix multiplication](ComputationalMathematics/Algorithms/MatMul.lean) |
| Polynomial and elementary numerical evaluation | Horner and polynomial evaluation, divided differences and Vandermonde systems, quadrature, FFT/convolution, nonlinear systems and automatic error analysis | [polynomial evaluation](ComputationalMathematics/Algorithms/PolynomialEvaluation/), [quadrature](ComputationalMathematics/Algorithms/Quadrature.lean), Higham [Chapters 22–26](ComputationalMathematics/Source/Higham/) |
| Linear systems and least squares | Triangular solves, LU/block LU, Cholesky, symmetric-indefinite factorizations, Householder/Givens/Gram–Schmidt QR, least squares, minimum-norm underdetermined systems, stationary iteration and iterative refinement | [linear-system algorithms](ComputationalMathematics/Algorithms/LinearSystems/) |
| Matrix equations, inverses and estimation | Sylvester/Lyapunov equations, matrix inversion, one-/two-/p-norm estimation and associated conditioning/error analysis | [matrix equations](ComputationalMathematics/Algorithms/MatrixEquations/), [inversion](ComputationalMathematics/Algorithms/MatrixInversion/), [norm estimation](ComputationalMathematics/Algorithms/NormEstimation/) |
| Matrix and operator analysis | Vector/matrix/operator norms, singular values, Schur/Jordan forms, numerical radius, pseudospectra, matrix powers and semiconvergence | [matrix norms](ComputationalMathematics/Analysis/MatrixNorms/), [singular values](ComputationalMathematics/Analysis/SingularValues/), [linear operators](ComputationalMathematics/Analysis/LinearOperators/) |
| Positive operators and functional calculus | Finite C*-matrix algebras, matrix inequalities and continuous functional calculus | [C*-matrices](ComputationalMathematics/Analysis/CStarMatrices/), [functional calculus](ComputationalMathematics/Analysis/FunctionalCalculus/), [matrix inequalities](ComputationalMathematics/Analysis/MatrixInequalities/) |
| Conservation laws and hyperbolic PDEs | Scalar advection, acoustics, elasticity and Euler models, characteristics, Riemann problems, weak/integral balance, entropy and boundary models | [PDE foundations](ComputationalMathematics/Analysis/PartialDifferentialEquations/), [LeVeque correspondence](ComputationalMathematics/Source/LeVeque/) |
| Finite-volume and difference schemes | Cell averages, conservative flux updates, upwind, Godunov, Lax–Friedrichs, Lax–Wendroff/Richtmyer and wave-propagation results; CFL restrictions, consistency, accuracy and stability; explicit and Crank–Nicolson diffusion | [finite-volume analysis](ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/), [LeVeque Chapter 4](ComputationalMathematics/Source/LeVeque/Chapter04/) |
| Control-volume geometry and models | Cells/faces, planar geometry, reconstruction, interfaces, transport and diffusion definitions; Chapter 1 candidate contracts alongside three accepted proofs | [geometric models](ComputationalMathematics/Analysis/FiniteVolume/), [Eymard checkpoint](docs/formalization/eymard-chapter-01.md) |
| Scalar probability and concentration | Distribution and moment models, independent sums and limit theorems, Gaussian/Poisson/Bernoulli/binomial laws, tail/MGF bounds, Hoeffding/Chernoff, Khintchine, sub-Gaussian/sub-exponential and Orlicz-norm analysis | [scalar probability](ComputationalMathematics/HDP/Scalar/), [Gaussian and Haar analysis](ComputationalMathematics/Analysis/Probability/) |
| Random vectors and convex geometry | Covariance and principal components, isotropy, Gaussian and independent-coordinate vectors, spherical/ball laws, norm concentration and small-ball models, convex bodies and linear images | [random vectors](ComputationalMathematics/HDP/Vector/), [convex geometry](ComputationalMathematics/HDP/Convex/) |
| Random graphs and optimization | Random-graph degree concentration, Max-Cut, random cuts/hyperplane rounding, semidefinite programs and relaxations, Grothendieck bounds | [graph results](ComputationalMathematics/HDP/Graph/), [optimization](ComputationalMathematics/HDP/Optimization/), [independent-sum applications](ComputationalMathematics/HDP/Scalar/IndependentSums/) |
| Kernels and tensors | Positive-semidefinite, Gaussian and polynomial kernels, feature maps, Moore–Aronszajn, finite/rank-one tensors and analytic power-series features | [kernels](ComputationalMathematics/HDP/Kernel/), [tensors](ComputationalMathematics/HDP/Tensor/) |
| Randomized numerical linear algebra | Elementwise/row sampling, matrix concentration, spectral/Gram approximation, subspace embeddings, least-squares sketching, low-rank approximation and randomized preconditioning | [reusable RandNLA](ComputationalMathematics/Algorithms/RandomizedLinearAlgebra/), [paper correspondence](ComputationalMathematics/Source/DrineasMahoney/RandNLA2016/) |
| Supporting analysis and examples | Taylor/derivative estimates, integration and differentiation, sample variance, asymptotics, equidistribution/leading digits, special functions and test matrices | [calculus](ComputationalMathematics/Analysis/Calculus/), [integration](ComputationalMathematics/MeasureTheory/Integral/), [statistics](ComputationalMathematics/Analysis/Statistics/), [leading digits](ComputationalMathematics/Analysis/LeadingDigits/), [test matrices](ComputationalMathematics/Analysis/TestMatrices/) |

Small supporting extensions also live under [Logic](ComputationalMathematics/Logic/)
and [Topology](ComputationalMathematics/Topology/). Five attributed
[upstream adaptations](ComputationalMathematics/Upstream/Lindemann/) support the
source developments; licensing and provenance are recorded in
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

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

Reusable modules under
[`ComputationalMathematics/Analysis/PartialDifferentialEquations/`](ComputationalMathematics/Analysis/PartialDifferentialEquations/)
provide conservation-law residuals, constant-coefficient systems,
hyperbolicity, eigenmode waves, scalar advection, linear acoustics, integral
conservation, finite-volume cell averages and flux differences, Riemann data,
Riemann-interface adapters, and operator splitting.

The LeVeque source surface begins at
[`ComputationalMathematics.Source.LeVeque`](ComputationalMathematics/Source/LeVeque.lean); its
[`Chapter01` subtree](ComputationalMathematics/Source/LeVeque/Chapter01/) connects those foundations
to Chapter 1 equations and constructions. Chapter 1 gate outcomes and
per-claim faithfulness decisions are summarised in
[`docs/architecture/reviews/2026-09-faithfulness-outcomes.md`](docs/architecture/reviews/2026-09-faithfulness-outcomes.md);
its audit packages were the working record of that campaign and were
retired from the tree on 2026-09-10, recoverable at `afb25bab1`. Book and
workflow limitations are recorded in the campaign's local issue ledgers, which
are working files kept inside a checkout rather than committed.

The [Chapter 2 development](ComputationalMathematics/Source/LeVeque/Chapter02/)
and [Chapter 3 development](ComputationalMathematics/Source/LeVeque/Chapter03/)
are available through their
[`Chapter02`](ComputationalMathematics/Source/LeVeque/Chapter02.lean) and
[`Chapter03`](ComputationalMathematics/Source/LeVeque/Chapter03.lean) imports.
Both independently reviewed, PDF-pinned inventories have certified PASS gates:

| Audited scope | Inventory rows | Proved | Reused | Printed-source discrepancies | Complete | Remaining / skipped / deferred |
|---|---:|---:|---:|---:|---:|---:|
| Chapter 2 | 209 | 20 | 179 | 10 | 209/209 (100%) | 0 / 0 / 0 |
| Chapter 3 | 110 | 97 | 11 | 2 | 110/110 (100%) | 0 / 0 / 0 |

Chapter 3 binds 296 distinct compiled Lean declarations across its 110 rows.
All 110 rows passed blind and round-trip statement checks; 108 passed direct
source comparison and the two printed-source discrepancies correctly failed
that comparison. The printed third `r¹` in equation (3.35) and the printed
`B₁ = 1` sign in Exercise 3.2 have formal witnesses and separately named
corrections. The chapter's declaration, axiom, organization, focused-build and
full-build gates passed. Its periodic initial-boundary-value equivalence uses
an explicit compatible classical solution model; a weak-solution trace
interpretation is outside that theorem.

Chapter 2 covers selected tracer, advection, diffusion, reaction, acoustics,
elasticity, and Eulerian/Lagrangian coordinate claims. Chapter 3 covers
characteristics, eigenmode waves, Riemann problems, acoustic waves, boundary
conditions, and selected exercises.
These are completions of the audited chapter scopes, not a claim that the whole
book is formalized. Inventories, audit packages, and gates remain checkout-local
rather than tracked in this repository.

The accepted portion of [Chapter 4](ComputationalMathematics/Source/LeVeque/Chapter04/)
is available through
[`Chapter04`](ComputationalMathematics/Source/LeVeque/Chapter04.lean).
The October 26, 2026 acceptance record contains 99 proved rows, 11 reused rows,
and 6 recorded source discrepancies out of 139 obligations. The remaining 23
rows are unfinished; Chapter 4 has no complete chapter-gate PASS.
This publication includes accepted correspondence and its mathematical
dependencies, while unfinished campaign files remain outside product Git.

The scalar large-step result is the adopted convergence/CFL domain obstruction
for arbitrary fixed two-point fluxes, using exact cell means and actual numerical
updates. It does not assert the book's unqualified norm-instability wording.
Its precise statement is
[`LocalizedScalarCFLConvergenceObstruction`](ComputationalMathematics/Source/LeVeque/Chapter04/LocalizedScalarCFLConvergenceObstruction.lean).

### Eymard–Gallouët–Herbin: finite-volume foundations

The [Chapter 1 entry point](ComputationalMathematics/Source/Eymard/Chapter01.lean)
contains three accepted proofs: introductory local conservativity, Section 2.2
cell unknowns and conservative exchange. The frozen inventory has **46
obligations: 3 accepted (6.5%), 43 remaining, none skipped or deferred**.

The publication also includes 69 compiled mathematical modules with geometric,
transport, diffusion and reconstruction definitions and transparent candidate
target propositions. In particular, a `...Target` definition is not a proof;
the Lax–Wendroff convergence target remains unfinished. The
[coverage and continuation document](docs/formalization/eymard-chapter-01.md)
explains the accepted scope and links the separate archive containing the sealed
inventory, original audits/receipts, source consultations and partial work.
Chapter 1 is not complete.

### Vershynin: high-dimensional probability

[`ComputationalMathematics.HDP`](ComputationalMathematics/HDP.lean) is the current high-dimensional
probability entry point. Its semantic layer covers probability preliminaries,
limit theorems, independent sums, Hoeffding and Chernoff bounds, random-graph
degree laws, and sub-Gaussian and sub-exponential variables. It also exposes
vector probability and covariance, isotropy and norm concentration, convex
bodies, finite-graph Max-Cut and randomized rounding, semidefinite and
Grothendieck foundations, kernels, and finite tensors. These reusable families
support the source development; their presence does not establish completion
of additional book chapters.

[`ComputationalMathematics.Source.Vershynin`](ComputationalMathematics/Source/Vershynin.lean) exposes
checked source contracts and frozen signatures for selected material in
Chapters 1–3 of *High-Dimensional Probability*. Chapter 3's presence here is
source-contract coverage, not a completed chapter gate. Historical
`NumStability.HDP.Contracts` and `NumStability.HDP.ContractSignatures` import
paths were removed in release 0.2.0; the
[compatibility map](docs/architecture/migrations/COMPATIBILITY-0.1.x.md)
records their canonical destinations.

The tracked coverage reports distinguish the chapter states:

| Chapter | Recorded scope and status |
|---|---|
| [1](docs/vershynin-hdp/chapter01/coverage.md) | Active: 37/45 formalized objects, including three source discrepancies; 8 remain. Three skipped rows and one deferred row are outside that denominator. |
| [2](docs/vershynin-hdp/chapter02/coverage.md) | PASS under its recorded rules: 119/119 objects, comprising 116 proved, two discrepancies and one weaker result; 12 skipped rows reported separately. |
| [3](ComputationalMathematics/Source/Vershynin/Chapter03/) | Source contracts and signatures are present; a completed chapter gate is not claimed. |

### Drineas–Mahoney: randomized numerical linear algebra

The RandNLA case study separates reusable algorithms and analysis under
[`ComputationalMathematics/Algorithms/RandomizedLinearAlgebra/`](ComputationalMathematics/Algorithms/RandomizedLinearAlgebra/)
from source correspondence under
[`ComputationalMathematics/Source/DrineasMahoney/RandNLA2016/`](ComputationalMathematics/Source/DrineasMahoney/RandNLA2016/).
It covers sampling, matrix concentration, low-rank approximation,
least-squares sketching, and randomized preconditioning. Historical
`NumStability.Algorithms.RandNLA` imports were removed in release 0.2.0; their
canonical destinations are recorded in the
[compatibility map](docs/architecture/migrations/COMPATIBILITY-0.1.x.md).

## Building

Install Git and [elan](https://github.com/leanprover/elan), then clone the
active repository to build current `main`:

```bash
git clone https://github.com/VSCL-x-VERITAS/lean-computational-mathematics.git lean-computational-mathematics
cd lean-computational-mathematics
lake exe cache get
lake build ComputationalMathematics NumStabilityTest
lake test
```

`lake build` selects the canonical library; the explicit command above also
includes the test library. `lake test` uses the `NumStabilityTest` driver.
For the reproducible snapshot measured above, run
`git checkout d23b546e518c9451979708f51e0d81d1b3a11454` before the Lake commands.

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
| `ComputationalMathematics.Algorithms.LinearSystems` | Linear-system factorization and solver families |
| `ComputationalMathematics.Analysis.LinearOperators` | Reusable matrix/operator analysis |
| `ComputationalMathematics.Algorithms.RandomizedLinearAlgebra` | Reusable randomized sampling, sketching and preconditioning |
| `ComputationalMathematics.HDP.Scalar` | Scalar probability and concentration |
| `ComputationalMathematics.HDP.Vector` | Random-vector probability and geometry |
| `ComputationalMathematics.HDP.Graph` | Finite-graph optimization and randomized rounding |
| `ComputationalMathematics.HDP.Optimization` | Semidefinite and Grothendieck foundations |
| `ComputationalMathematics.HDP.Kernel` | Positive-semidefinite kernels and feature maps |
| `ComputationalMathematics.HDP.Tensor` | Finite tensors and analytic features |
| `ComputationalMathematics.HDP` | High-dimensional-probability semantics, contracts, and signatures |
| `ComputationalMathematics.Source` | Complete canonical umbrella for book- and paper-specific correspondence |
| `ComputationalMathematics.Source.Higham` | Higham correspondence for Chapters 1–28 and cross-chapter bridges |
| `ComputationalMathematics.Source.LeVeque` | LeVeque Chapters 1–3 and accepted Chapter 4 correspondence |
| `ComputationalMathematics.Source.LeVeque.Chapter02` | Audited Chapter 2 proofs, models, and proof-free target contracts |
| `ComputationalMathematics.Source.LeVeque.Chapter03` | Audited Chapter 3 characteristics, Riemann problems, and boundary results |
| `ComputationalMathematics.Source.LeVeque.Chapter04` | Accepted Chapter 4 schemes, CFL, accuracy, stability and discrepancy results; chapter unfinished |
| `ComputationalMathematics.Source.Eymard.Chapter01` | Three accepted proofs and compiled candidate definitions/targets; chapter unfinished |
| `ComputationalMathematics.Source.Vershynin` | Vershynin Chapters 1–3 source contracts; Chapter 3 gate not claimed complete |
| `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference` | Narrow reusable finite-volume update and conservation results |
| `ComputationalMathematics.All` | Complete supported library surface |
| `ComputationalMathematics` | Complete-tree entry point forwarding to `ComputationalMathematics.All` |

See [`ARCHITECTURE.md`](ARCHITECTURE.md) for API tiers and dependency rules.
Historical imports and the canonical destinations they resolved to before
release 0.2.0 removed them are documented in
[`COMPATIBILITY-0.1.x.md`](docs/architecture/migrations/COMPATIBILITY-0.1.x.md) and, machine-readable, in
[`2026-09-forwarder-map.json`](docs/architecture/migrations/2026-09-forwarder-map.json).

## Use as a dependency

Retain the package name `numStability` and pin a revision:

```toml
[[require]]
name = "numStability"
git = "https://github.com/VSCL-x-VERITAS/lean-computational-mathematics"
rev = "d23b546e518c9451979708f51e0d81d1b3a11454"
```

Update the revision deliberately when consuming newer results. The inherited
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
│   ├── MatrixNorms/, SingularValues/, LinearOperators/, CStarMatrices/
│   ├── Calculus/, Probability/, Statistics/, FiniteVolume/
│   └── PartialDifferentialEquations/    reusable PDE and finite-volume foundations
├── Algorithms.lean                      broad historical algorithm aggregate
├── Algorithms/
│   ├── Arithmetic/, Summation/, PolynomialEvaluation/
│   ├── LinearSystems/, MatrixEquations/, MatrixPowers/
│   └── RandomizedLinearAlgebra/
├── HDP.lean                              high-dimensional-probability entry point
├── HDP/                                  scalar/vector probability, concentration, graphs, kernels
├── Source.lean                           canonical source-correspondence entry point
├── Source/
│   ├── Higham/                           Chapters 1–28 and cross-chapter correspondence
│   ├── LeVeque/                          Chapters 1–3 and accepted Chapter 4 results
│   ├── Eymard/                           partial Chapter 1 proofs and candidate targets
│   ├── Vershynin/                        high-dimensional probability, Chapters 1–3 contracts
│   └── DrineasMahoney/RandNLA2016/       randomized linear algebra case study
├── Logic/, MeasureTheory/, Topology/     supporting foundational extensions
└── Upstream/Lindemann/                   attributed Mathlib adaptation and backports

NumStabilityTest.lean                     complete test-library entry point
NumStabilityTest/
├── Import/
│   ├── HDPCheckpointSync/               canonical HDP contract and signature checks
│   └── ProjectIdentity/Canonical/       identity fixtures the clean-project consumer builds
└── Reorganization/                      private-name placement checks

docs/                                     architecture, source coverage, and benchmarks
tools/                                    architecture checks and benchmark tooling
experiments/                              C/Python reproductions of selected source examples
```

## Verification and contribution

For a source-only architecture check, run:

```bash
python tools/architecture/check_layout.py
python tools/architecture/check_tiers.py
python tools/architecture/check_placeholders.py
python tools/architecture/check_provenance.py
python tools/architecture/check_links.py
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

The lint driver's [declaration-specific exceptions](scripts/nolints.json)
retain the intentional admissibility argument of `physicalSectionMass`: it
restricts the physical domain although the integral value does not depend on
the proof. Keeping this exception outside the model preserves the exact source
bytes used by its audited consumers. Other declarations and linters remain
subject to the reviewed baseline.

## Documentation

- The [identity migration report](docs/migrations/lean-computational-mathematics/README.md)
  records the public name, interface mapping, GitHub cutover and validation.
- [`docs/README.md`](docs/README.md) maps current policy and retained evidence.
- The [Eymard Chapter 1 checkpoint](docs/formalization/eymard-chapter-01.md) records accepted scope and restoration instructions.
- The Vershynin [Chapter 1](docs/vershynin-hdp/chapter01/coverage.md) and [Chapter 2](docs/vershynin-hdp/chapter02/coverage.md) reports record the audited scopes.
- [`ARCHITECTURE.md`](ARCHITECTURE.md) defines API tiers, dependency direction,
  and supported entry points.
- [`docs/architecture/NAMING.md`](docs/architecture/NAMING.md) defines canonical
  module names and placement.
- [`COMPATIBILITY-0.1.x.md`](docs/architecture/migrations/COMPATIBILITY-0.1.x.md)
  records every historical import path the 0.1.x series supported.
- [`docs/source_coverage/`](docs/source_coverage/) contains Higham's concise
  chapter ledgers and PDF-first audits.
- [`CHANGELOG.md`](CHANGELOG.md) records release-facing changes.

## Roadmap

The tracked [publication policies](.formalization-policy/publication/) cover
LeVeque, Eymard, Vershynin, the Fountoulakis random-automata paper, a Higham recheck,
Bhatia's matrix analysis, and Nocedal's numerical optimization. The Nocedal
policy disables automatic publication. These policies configure how candidate
work may be published; they do not certify completed chapters or add source
coverage to the library.

The [source inventory from the September identity migration](docs/migrations/lean-computational-mathematics/source-scope.md)
records exact titles, editions, source identifiers, and the companion catalogue
as observed on September 6, 2026. Its prospective sources include Greenbaum and
Saad on iterative linear solvers, LeVeque on finite differences, Krüger and
Succi on lattice Boltzmann methods, and Kettner et al. on robust geometric
computation. Its catalogue statuses and source-collection limits describe that
historical snapshot. The current published source areas are listed above.

## References

- N. J. Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed.,
  SIAM, 2002.
- R. J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Cambridge
  University Press, 2002.
- R. Eymard, T. Gallouët and R. Herbin, [*Finite Volume Methods*](https://raphaeleh.github.io/PUBLI/bookevol.pdf), January 2019 manuscript.
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
