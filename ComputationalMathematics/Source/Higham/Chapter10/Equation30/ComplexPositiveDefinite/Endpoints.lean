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
# Chapter10 Equation30 ComplexPositiveDefinite Endpoints

Canonical destination for material split out of
`NumStability.Algorithms.HighamChapter10` by wave W03 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

open scoped BigOperators

namespace NumStability

/-- **Equation (10.30)**: complex matrices of the form `A = B + iC`, with
real SPD `B` and `C` supplied separately by hypotheses in downstream use. -/
noncomputable def higham10_30_complexPositiveDefiniteForm (n : ℕ)
    (B C : Fin n → Fin n → ℝ) : Fin n → Fin n → ℂ :=
  fun i j => (B i j : ℂ) + Complex.I * (C i j : ℂ)

end NumStability
