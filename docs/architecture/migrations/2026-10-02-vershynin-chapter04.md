# Vershynin Chapter 4 organization

Initial organization: `formalization-workflow-v6.3.7`, commit `8d33f231db99a35d56bd340a7c8c4934b2bdcbb0`; stage `chapter-4`.

This slice places source-independent matrix, covering, concentration, coding,
covariance, and clustering mathematics below `ComputationalMathematics.Analysis`,
`ComputationalMathematics.Algorithms`, and `ComputationalMathematics.HDP`.
The numbered 2018 source correspondences, corrected claims, and counterexamples
live below `ComputationalMathematics.Source.Vershynin.Chapter04`.

The package remains `numStability`, the public module root is
`ComputationalMathematics`, and authored `NumStability` declaration names are
preserved. The pinned Lean and Mathlib versions are unchanged.

## Module map and compatibility

| Unpublished module | Canonical module | Mathematical role |
|---|---|---|
| `Analysis.SingularValues.OrderedEndpoints` | `Analysis.SingularValues.ExtremeValues` | Leading and trailing singular values, operator norm, and pseudoinverse |
| `HDP.Vector.GaussianMixtureSourceRecovery` | `HDP.Vector.GaussianMixturePartitionRecovery` | Binary partition errors up to a global label swap |

Both names are relative to `ComputationalMathematics`. The old files were
untracked and absent from the admitted product base. The move changes no
previously published import. Each entire file moves byte for byte, preserving
namespace commands, modifiers, types, and proofs. All five direct consumers
use the canonical paths; no second mathematical producer or forwarding shim
is introduced.

`Analysis.SingularValues` exposes `ExtremeValues`. The operator-norm/largest-
singular-value and smallest-singular-value/pseudoinverse source contracts import
it directly. `HDP.Vector.GaussianMixtureCounterexample` and the Theorem 4.7.5
source contract import `GaussianMixturePartitionRecovery` directly.

## Classification review

The following previously unclassified modules carry source-independent
mathematics. Their declarations and direct imports were read before assigning
roles. None imports a numbered-source wrapper. The declaration-free eigenvalue
entry point is an aggregate; the other eighteen modules are reusable.

| Module, relative to `ComputationalMathematics` | Role | Rationale |
|---|---|---|
| `Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.RealSVD` | reusable | Existence of a rank-deficient real SVD from ordered right-Gram data |
| `Analysis.Eigenvalues` | aggregate | Import-only entry point for reusable ordered eigenvalue analysis |
| `Analysis.Eigenvalues.CourantFischer` | reusable | Finite real symmetric max-min eigenvalue theorem with attaining witnesses |
| `Analysis.Eigenvalues.OrderedSpectrum` | reusable | Completeness and multiplicity of the ordered Hermitian spectrum |
| `Analysis.OperatorNorms.RealComplexification` | reusable | Equality of a real matrix's Euclidean operator norm and its complexification norm |
| `Analysis.OperatorNorms.RealMatrix` | reusable | Attained vector and unit-sphere characterizations of the real matrix operator norm |
| `Analysis.SingularValues.ApproximateIsometries` | reusable | Gram deviation implies Euclidean distortion and extreme singular-value bounds |
| `Analysis.SingularValues.ApproximateIsometryConverse` | reusable | Extreme singular-value bounds imply Gram deviation control |
| `Analysis.SingularValues.ApproximateProjections` | reusable | Quantitative transpose duality for rectangular projections |
| `Analysis.SingularValues.CourantFischer` | reusable | Real rectangular singular-value max-min theorem through the right Gram matrix |
| `Analysis.SingularValues.Decay` | reusable | Singular-value bounds from Schatten norm information |
| `Analysis.SingularValues.EckartYoung` | reusable | Rank-cutoff and perturbation foundations for best low-rank approximation |
| `Analysis.SingularValues.ExtremeValues` | reusable | Extreme ordered singular values, operator norm, and pseudoinverse relations |
| `Analysis.SingularValues.InverseSVD` | reusable | Algebraic SVD inverse formula for nonzero singular values |
| `Analysis.SingularValues.Isometries` | reusable | Equivalent Gram, range, norm, and singular-value characterizations |
| `Analysis.SingularValues.OrderedDecay` | reusable | One-based Frobenius decay for the explicit ordered real spectrum |
| `Analysis.SingularValues.Projections` | reusable | Rectangular projection/isometry duality and orthogonal row/column selections |
| `Analysis.SingularValues.RealSVD` | reusable | Shared rank, ordering, orthonormality, and reconstruction certificate |
| `Analysis.SingularValues.Symmetric` | reusable | Signed SVD obtained from a complete real symmetric eigenbasis |

Exact tier records use actual Git introduction provenance, recorded separately
from the current role review. The current-tree role census includes newly
introduced files; a tracked-file-only scan does not establish their classification.

## Audit and validation boundaries

Completed mathematical acceptance is retained through its original proof and
audit receipts. Workflow updates, file relocation and metadata changes do not
request historical audit or compiler replay. Historical packets and judgments
remain available as their original provenance.

Unfinished rows complete their missing source, statement-review and proof stages.
Substantive changes to a source specification or mathematical target receive a
distinct affected revision with independent review; they do not erase the
accepted original. Counterexamples and corrected counterparts remain separately
named. A complete discrepancy correspondence also needs its fresh whole-parent
review and proof, rather than credit from a witness alone.

The selected source/API scope is checked for placeholders, duplicate live
producers, mixed modules, canonical placement, and direct or transitive
reusable-to-source imports. Repository debt is scanned separately. Campaign
gates, source pages, packets, audit outputs, trackers, and command transcripts
remain checkout-local and are excluded from product commits.

The initial focused Chapter 4, singular-value, and Gaussian-mixture-counterexample
build passed after the moves. Final closure also requires the full library build,
public-aggregate declaration lookup, standard-axiom check, layout/tier checks,
source inventory, per-row audits, and protected exact-commit publication.
