/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# Superposition for constant-coefficient linear systems

Pointwise classical solutions of the same homogeneous system are closed under
addition. No global regularity is needed beyond the derivatives in each
pointwise solution witness.
-/

namespace NumStability

/-- Two pointwise solutions of `qₜ + A qₓ = 0` add to another solution. -/
theorem constantCoefficientSystem_add_at {ι : Type*} [Fintype ι]
    (q₁ q₂ : ℝ → ℝ → (ι → ℝ)) (A : Matrix ι ι ℝ) (x t : ℝ)
    (h₁ : IsConstantCoefficientLinearSystemSolutionAt q₁ A x t)
    (h₂ : IsConstantCoefficientLinearSystemSolutionAt q₂ A x t) :
    IsConstantCoefficientLinearSystemSolutionAt
      (fun ξ τ => q₁ ξ τ + q₂ ξ τ) A x t := by
  rcases h₁ with ⟨q₁t, q₁x, h₁t, h₁x, h₁zero⟩
  rcases h₂ with ⟨q₂t, q₂x, h₂t, h₂x, h₂zero⟩
  refine ⟨q₁t + q₂t, q₁x + q₂x, ?_, ?_, ?_⟩
  · simpa only using h₁t.add h₂t
  · simpa only using h₁x.add h₂x
  · rw [Matrix.mulVec_add]
    calc
      q₁t + q₂t + (A.mulVec q₁x + A.mulVec q₂x) =
          (q₁t + A.mulVec q₁x) + (q₂t + A.mulVec q₂x) := by abel
      _ = 0 := by rw [h₁zero, h₂zero, add_zero]

end NumStability
