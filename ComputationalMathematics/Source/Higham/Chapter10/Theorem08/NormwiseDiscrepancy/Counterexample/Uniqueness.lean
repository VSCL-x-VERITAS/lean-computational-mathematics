import Mathlib.Algebra.BigOperators.Field
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.Cholesky.CholeskyDemmel
import ComputationalMathematics.Algorithms.Cholesky.CholeskyFl
import ComputationalMathematics.Algorithms.Cholesky.CholeskyNonsym
import ComputationalMathematics.Algorithms.Cholesky.CholeskySpec
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.ErrorAnalysis.Certificates
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.Perturbation.Basic
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.Basic
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.KahanMatrix
import ComputationalMathematics.Algorithms.LinearSystems.Cholesky.PositiveSemidefinite.ScaledStage
import ComputationalMathematics.Analysis.MatrixNorms.EntrywiseAbsolute.Basic
import ComputationalMathematics.Analysis.MatrixNorms.SpectralExtrema.Basic
import ComputationalMathematics.Analysis.MatrixSpectral
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter09.Problems
import ComputationalMathematics.Source.Higham.Chapter09.Section01
import ComputationalMathematics.Source.Higham.Chapter09.Section02
import ComputationalMathematics.Source.Higham.Chapter09.Section03
import ComputationalMathematics.Source.Higham.Chapter09.Section04
import ComputationalMathematics.Source.Higham.Chapter09.Section05
import ComputationalMathematics.Source.Higham.Chapter09.Section06
import ComputationalMathematics.Source.Higham.Chapter09.Section08
import ComputationalMathematics.Source.Higham.Chapter09.Section10
import ComputationalMathematics.Source.Higham.Chapter09.Section11
import ComputationalMathematics.Source.Higham.Chapter10.Equation07.AbsoluteFactorNorm.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Equation29.Mathias.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Equation30.ComplexPositiveDefinite.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Lemma11.PivotSequenceStability.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Lemma13.KahanSharpness.CompletePivotingBound
import ComputationalMathematics.Source.Higham.Chapter10.Lemma13.KahanSharpness.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Problem01.PositiveSemidefiniteEntries.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Problem04.UnpivotedGrowth.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Problem08.LeadingMinorsCounterexample.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Section01.Factorization.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Section01.Factorization.ExistenceUniqueness.Results
import ComputationalMathematics.Source.Higham.Chapter10.Section02.ErrorAnalysis.Basic
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Existence
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.SchurComplement
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.Termination
import ComputationalMathematics.Source.Higham.Chapter10.Section03.PositiveSemidefinite.WNormBound
import ComputationalMathematics.Source.Higham.Chapter10.Section04.PositiveDefiniteSymmetricPart.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem06.RoundedCholesky.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem07.FailureVacuity.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem08.ComponentwisePerturbation.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem08.NormwiseDiscrepancy.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem08.NormwiseDiscrepancy.LiteralSource
import ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.Endpoints
import ComputationalMathematics.Source.Higham.Chapter10.Theorem14.CompletePivotedPSD.PsdErrorAnalysis

/-!
# Uniqueness

Canonical destination for 1 declaration(s) relocated from
`NumStability.Algorithms.Ch10Theorem108Source` during wave R04. Declaration names, kinds, signatures and
visibilities are unchanged; authored-private declarations keep their
names and change only their mangled module owner, per the reviewed
B0008 private-normalization map.
-/

/-!
# Ch10Theorem108Source (compatibility module)

Historical path, retained so existing imports of `NumStability.Algorithms.Ch10Theorem108Source`
keep resolving. Most of its declarations moved unchanged to the
canonical modules imported above.

The declarations still defined below are private declarations and
their users. Lean mangles a private name to
`_private.<module>.<n>.<name>`, so relocating one renames it and
breaks the frozen declaration graph; anything referring to one must
therefore stay with it. This module is a declaration-bearing facade,
not a pure import shim.
-/

open scoped BigOperators Matrix.Norms.L2Operator

noncomputable section

namespace NumStability

/-- The displayed perturbed factor is not merely a witness: it is the unique
positive-diagonal Cholesky factor required by the source. -/
theorem higham10_8_counterRhat_unique
    (S : Fin 2 → Fin 2 → ℝ)
    (hS : CholeskyFactSpec 2 higham10_8_counterAplus S) :
    ∀ i j : Fin 2, S i j = higham10_8_counterRhat i j :=
  higham10_1_cholesky_uniqueness 2 higham10_8_counterAplus S
    higham10_8_counterRhat hS higham10_8_counterRhat_cholesky

end NumStability

end
