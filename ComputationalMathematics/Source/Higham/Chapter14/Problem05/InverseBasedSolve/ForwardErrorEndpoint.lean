import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.Asymptotics.Lemmas
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
import ComputationalMathematics.Source.Higham.Chapter14.Section01.InverseErrorAnalysis.ForwardErrorEndpoint

/-!
# Chapter14 Problem05 InverseBasedSolve ForwardErrorEndpoint

Canonical destination for material split out of
`NumStability.Algorithms.Ch14ForwardErrorEndpoint` by wave W08 of the August 2026 repository reorganization.
Declaration names, statements and proofs are unchanged; only the
module they live in has changed. The historical module still
resolves and re-exports this one.
-/

open scoped BigOperators Topology
open NumStability

namespace NumStability

namespace Ch14Ext

/-- The full higher-order term displayed by the right-inverse Problem 14.5
endpoint, scalarized in u with all matrix/vector data fixed. -/
noncomputable def ch14ext_problem14_5_right_quadraticRemainder (n : ℕ)
    (A A_inv X : Fin n → Fin n → ℝ) (b : Fin n → ℝ)
    (i : Fin n) (u : ℝ) : ℝ :=
  u ^ 2 *
    (ch14ext_gammaQuadraticCoefficientScalar (n + 1) u *
        matMulVec n (absMatrix n A_inv)
          (matMulVec n (absMatrix n A)
            (matMulVec n (absMatrix n A_inv) (absVec n b))) i +
      ch14ext_gammaUnitCoefficientScalar (n + 1) u *
        matMulVec n (absMatrix n A_inv)
          (matMulVec n (absMatrix n A)
            (matMulVec n
              (ch14ext_rightResidualEnvelopeRemainder n A A_inv X)
              (absVec n b))) i)

/-- At the model unit roundoff, the scalarized right-inverse Problem 14.5
remainder is definitionally the endpoint theorem's higher-order term. -/
theorem ch14ext_problem14_5_right_quadraticRemainder_at_fp (n : ℕ)
    (fp : FPModel) (A A_inv X : Fin n → Fin n → ℝ)
    (b : Fin n → ℝ) (i : Fin n) :
    ch14ext_problem14_5_right_quadraticRemainder
        n A A_inv X b i fp.u =
      fp.u ^ 2 *
        (ch14ext_gammaQuadraticCoefficient fp (n + 1) *
            matMulVec n (absMatrix n A_inv)
              (matMulVec n (absMatrix n A)
                (matMulVec n (absMatrix n A_inv) (absVec n b))) i +
          ch14ext_gammaUnitCoefficient fp (n + 1) *
            matMulVec n (absMatrix n A_inv)
              (matMulVec n (absMatrix n A)
                (matMulVec n
                  (ch14ext_rightResidualEnvelopeRemainder n A A_inv X)
                  (absVec n b))) i) := by
  rfl

/-- The full higher-order term displayed by the left-inverse Problem 14.5
endpoint, scalarized in u with all matrix/vector data fixed. -/
noncomputable def ch14ext_problem14_5_left_quadraticRemainder (n : ℕ)
    (A A_inv Y : Fin n → Fin n → ℝ) (x : Fin n → ℝ)
    (i : Fin n) (u : ℝ) : ℝ :=
  u ^ 2 *
    (ch14ext_gammaQuadraticCoefficientScalar (n + 1) u *
        matMulVec n (absMatrix n A_inv)
          (matMulVec n (absMatrix n A) (absVec n x)) i +
      ch14ext_gammaUnitCoefficientScalar (n + 1) u *
        matMulVec n
          (ch14ext_leftResidualEnvelopeRemainder n A A_inv Y)
          (matMulVec n (absMatrix n A) (absVec n x)) i)

/-- At the model unit roundoff, the scalarized left-inverse Problem 14.5
remainder is definitionally the endpoint theorem's higher-order term. -/
theorem ch14ext_problem14_5_left_quadraticRemainder_at_fp (n : ℕ)
    (fp : FPModel) (A A_inv Y : Fin n → Fin n → ℝ)
    (x : Fin n → ℝ) (i : Fin n) :
    ch14ext_problem14_5_left_quadraticRemainder
        n A A_inv Y x i fp.u =
      fp.u ^ 2 *
        (ch14ext_gammaQuadraticCoefficient fp (n + 1) *
            matMulVec n (absMatrix n A_inv)
              (matMulVec n (absMatrix n A) (absVec n x)) i +
          ch14ext_gammaUnitCoefficient fp (n + 1) *
            matMulVec n
              (ch14ext_leftResidualEnvelopeRemainder n A A_inv Y)
              (matMulVec n (absMatrix n A) (absVec n x)) i) := by
  rfl

end Ch14Ext
end NumStability
