/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import Mathlib.Analysis.Normed.Operator.NNNorm

/-!
# Two-sided unitary invariance of the operator and Frobenius norms

Bhatia, Matrix Analysis, Section I.2, printed page 7 (PDF page 19), with the
finite complex Hilbert setting, adjoint and unitary definitions from printed
pages 1–5 (PDF pages 13–17).

The Frobenius quantity is the square root of the full singular-square sum:
the singular values are the real eigenvalues of the positive square root of
the Gram operator. Root existence and positivity are proved mathematics used
in this closed definition. The operator norm is the canonical continuous
linear-map norm supplied by finite dimension. The two unitaries are chosen
independently, and the ambient Hilbert space may have dimension zero.
-/

set_option autoImplicit false
open scoped BigOperators
universe u
namespace NumStability.Bhatia.Chapter01.Targets
noncomputable def unitaryInvariancePositiveRootChoice : Prop := by
  classical
  exact ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let F : (H →ₗ[ℂ] H) → ℝ := fun B =>
      let G := (LinearMap.adjoint B).comp B
      let P := NumStability.positiveSquareRoot G
        (LinearMap.isPositive_adjoint_comp_self B)
      let hs : P.IsPositive := NumStability.positiveSquareRoot_isPositive G
        (LinearMap.isPositive_adjoint_comp_self B)
      let s : Fin (Module.finrank ℂ H) → ℝ := hs.isSymmetric.eigenvalues rfl
      Real.sqrt (∑ i : Fin (Module.finrank ℂ H), s i ^ 2)
    ∀ (A U V : H →ₗ[ℂ] H),
      U ∈ unitary (H →ₗ[ℂ] H) → V ∈ unitary (H →ₗ[ℂ] H) →
      ‖A.toContinuousLinearMap‖ = ‖(U.comp (A.comp V)).toContinuousLinearMap‖ ∧
        F A = F (U.comp (A.comp V))
end NumStability.Bhatia.Chapter01.Targets
