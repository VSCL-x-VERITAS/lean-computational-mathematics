import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Orthogonal
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import ComputationalMathematics.Algorithms.LU.GaussianElimination
import ComputationalMathematics.Algorithms.LU.GrowthFactor
import ComputationalMathematics.Algorithms.LU.LUSolve
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.BackSubstitution
import ComputationalMathematics.Algorithms.LinearSystems.Triangular.ForwardSubstitution
import ComputationalMathematics.Algorithms.MatMul
import ComputationalMathematics.Algorithms.MatVec
import ComputationalMathematics.Algorithms.TestMatrices.UpperTriangularStress
import ComputationalMathematics.Analysis.Error.RoundingProducts.Core
import ComputationalMathematics.Analysis.ForwardError
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.MatrixNorms.HadamardDeterminant
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Wedin
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.FloatingPoint.Model

/-!
# NumStability Algorithms MatrixInversion LUFactors Methods MatrixInversion

Canonical destination for material split out of
`NumStability.Algorithms.MatrixInversion` by wave W08 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

open scoped BigOperators

namespace NumStability

/-- Computed inverse produced by Method A after an LU factorization: each
column solves `L_hat y = e_j`, then `U_hat x = y`. -/
noncomputable def methodAComputedInverse (fp : FPModel) (n : ℕ)
    (L_hat U_hat : Fin n → Fin n → ℝ) : Fin n → Fin n → ℝ :=
  fun i j =>
    let b_j : Fin n → ℝ := fun k => if k = j then 1 else 0
    let y_hat := fl_forwardSub fp n L_hat b_j
    fl_backSub fp n U_hat y_hat i

end NumStability
