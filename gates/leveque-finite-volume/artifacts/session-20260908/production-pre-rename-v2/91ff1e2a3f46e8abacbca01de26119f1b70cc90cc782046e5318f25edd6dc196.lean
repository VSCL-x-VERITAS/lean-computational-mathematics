/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation05

/-!
# LeVeque Chapter 1, equation (1.5) correspondence

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24). The two displayed acoustic equations are exposed for independently supplied fields.
-/

namespace NumStability

/-- Classical equation-form correspondence for the two acoustic equations,
on independently supplied fields and a nonzero density. -/
theorem leveque01_equation05_linearAcousticsAt_iff
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) (_hdensity : density ≠ 0) :
    leveque01_equation05_linearAcousticsAt pressure velocity bulkModulus density x t ↔
      ∃ pt px ut ux : ℝ,
        HasDerivAt (fun τ => pressure x τ) pt t ∧
          HasDerivAt (fun ξ => pressure ξ t) px x ∧
            HasDerivAt (fun τ => velocity x τ) ut t ∧
              HasDerivAt (fun ξ => velocity ξ t) ux x ∧
                pt + bulkModulus * ux = 0 ∧ ut + density⁻¹ * px = 0 :=
  Iff.rfl

end NumStability
