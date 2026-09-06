import Mathlib.Algebra.BigOperators.Field
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.BackSubstitution
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.ForwardSubstitution
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LU.LUSolve
import ComputationalMathematics.Analysis.MatrixSpectral
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.Analysis.SubtractionFold
import ComputationalMathematics.Analysis.Summation.ErrorBounds
import ComputationalMathematics.FloatingPoint.Model
import ComputationalMathematics.Source.Higham.Chapter06.Lemma06.Core.Results
import ComputationalMathematics.Source.Higham.Chapter06.Lemma06.OperatorTwoNormBound.Bridge
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

/-!
# Chapter14 Section03 ResidualOperatorTwoNorm Bridge

Canonical destination for material split out of
`NumStability.Algorithms.Ch10Ch14Lemma66Op2Bridge` by wave W03 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

open scoped BigOperators

namespace NumStability

namespace Lemma66Op2Bridge

/-- **Higham Ch.14, §14.3.4 residual-lift step.**  A residual matrix `E`
componentwise dominated by a square matrix `B` (`|E| ≤ |B|` entrywise) obeys the
2-norm bound `‖E‖₂ ≤ √n · ‖B‖₂` — the `‖G‖₂ ≤ …√n…` move that yields
`‖X̂A − I‖₂ ≤ dₙ u ‖A‖₂ ‖X̂‖₂`.  This applies `Lemma66.lemma66_c_op2_le` directly
to `E` and `B`. -/
theorem lemma66c_ch14_residual_op2_le_sqrt_card {n : ℕ} (hn : 0 < n)
    (E B : CMatrix n n) (h : ∀ i j, ‖E i j‖ ≤ ‖B i j‖) :
    complexMatrixOp2 E ≤ Real.sqrt (n : ℝ) * complexMatrixOp2 B := by
  refine (Lemma66.lemma66_c_op2_le hn E B h).trans ?_
  have hrank : (complexMatrixRank B : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast lemma66c_rank_le_card B
  exact mul_le_mul_of_nonneg_right (Real.sqrt_le_sqrt hrank) (complexMatrixOp2_nonneg B)

end Lemma66Op2Bridge
end NumStability
