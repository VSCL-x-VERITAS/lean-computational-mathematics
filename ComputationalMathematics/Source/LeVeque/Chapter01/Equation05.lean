/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# LeVeque Chapter 1, Equation (1.5)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), equation (1.5).
-/

namespace NumStability

/-- Equation (1.5), as a pointwise pressure--velocity residual. -/
abbrev leveque01_equation05_linearAcousticsAt
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) : Prop :=
  IsLinearAcousticsSolutionAt
    pressure velocity bulkModulus density x t

/-- Equation (1.5): a proof-carrying acoustic field has nonzero density and
satisfies both displayed equations globally. -/
theorem leveque01_equation05_linearAcoustics
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density) :
    density ≠ 0 ∧
      ∀ x t, ∃ pt px ut ux : ℝ,
        HasDerivAt (fun τ => system.pressure x τ) pt t ∧
          HasDerivAt (fun ξ => system.pressure ξ t) px x ∧
            HasDerivAt (fun τ => system.velocity x τ) ut t ∧
              HasDerivAt (fun ξ => system.velocity ξ t) ux x ∧
                pt + bulkModulus * ux = 0 ∧
                  ut + density⁻¹ * px = 0 := by
  refine ⟨system.density_ne_zero, ?_⟩
  intro x t
  exact system.satisfies x t

end NumStability
