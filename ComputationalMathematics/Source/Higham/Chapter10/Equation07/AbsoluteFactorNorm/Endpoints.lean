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
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LU.LUSolve
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.BackSubstitution
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.ForwardSubstitution
import ComputationalMathematics.Analysis.MatrixNorms.EntrywiseAbsolute.Basic
import ComputationalMathematics.Analysis.MatrixSpectral
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.Analysis.SubtractionFold
import ComputationalMathematics.Analysis.Summation.ErrorBounds
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

/-!
# Chapter10 Equation07 AbsoluteFactorNorm Endpoints

Canonical destination for material split out of
`NumStability.Algorithms.HighamChapter10` by wave W03 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

open scoped BigOperators

namespace NumStability

/-- **Equation (10.7), key inequality in certificate form** (Higham §10.1,
p. 198): `‖|R̂ᵀ||R̂|‖₂ ≤ n c²` whenever `‖R̂‖₂ ≤ c`, the analogue of
`‖|Rᵀ||R|‖₂ ≤ n ‖A‖₂` from Lemma 6.6. -/
theorem higham10_7_absRT_absR_opNorm2Le (n : ℕ)
    (R : Fin n → Fin n → ℝ) (c : ℝ) (hc : 0 ≤ c) (h : opNorm2Le R c) :
    opNorm2Le
      (matMul n (fun i j => |R j i|) (fun i j => |R i j|))
      ((n : ℝ) * c ^ 2) := by
  have hprod := opNorm2Le_matMul n _ _ _ _
    (mul_nonneg (Real.sqrt_nonneg _) hc)
    (opNorm2Le_abs_transpose_of_opNorm2Le n R c hc h)
    (opNorm2Le_abs_of_opNorm2Le n R c hc h)
  have heq : Real.sqrt n * c * (Real.sqrt n * c) = (n : ℝ) * c ^ 2 := by
    have hs : Real.sqrt n * Real.sqrt n = (n : ℝ) :=
      Real.mul_self_sqrt (Nat.cast_nonneg n)
    nlinarith [hs]
  rwa [heq] at hprod

end NumStability
