/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineConvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineUniqueness
import Lean.Elab.Tactic.Omega

/-!
# The actual bounded whole-line CN inverse and step

Absolute convergence justifies collecting the three convolution sums. The
proved Green recurrence gives the forward inverse; bounded injectivity gives
the reverse inverse and uniqueness of the actual Crank–Nicolson step.
-/

namespace NumStability

theorem cnWholeLineImplicitOperator_resolvent_apply (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (i : ℤ) :
    cnWholeLineImplicitOperator (cnWholeLineResolvent data) i = data i := by
  have hcenter := summable_cnWholeLineResolvent_integrand data hdata i
  have hleft := summable_cnWholeLineResolvent_integrand data hdata (i - 1)
  have hright := summable_cnWholeLineResolvent_integrand data hdata (i + 1)
  calc
    cnWholeLineImplicitOperator (cnWholeLineResolvent data) i =
        (5 / 2 : ℝ) * (∑' j : ℤ, cnWholeLineResolventKernel (i - j) * data j) -
          (3 / 4 : ℝ) *
            ((∑' j : ℤ, cnWholeLineResolventKernel ((i - 1) - j) * data j) +
              ∑' j : ℤ, cnWholeLineResolventKernel ((i + 1) - j) * data j) := rfl
    _ = ∑' j : ℤ,
        ((5 / 2 : ℝ) * (cnWholeLineResolventKernel (i - j) * data j) -
          (3 / 4 : ℝ) * (cnWholeLineResolventKernel ((i - 1) - j) * data j +
            cnWholeLineResolventKernel ((i + 1) - j) * data j)) := by
      rw [(hcenter.mul_left (5 / 2 : ℝ)).tsum_sub
          ((hleft.add hright).mul_left (3 / 4 : ℝ)),
        tsum_mul_left, tsum_mul_left, hleft.tsum_add hright]
    _ = ∑' j : ℤ, (if i - j = 0 then (1 : ℝ) else 0) * data j := by
      apply tsum_congr
      intro j
      have hleftIndex : (i - 1) - j = (i - j) - 1 := by omega
      have hrightIndex : (i + 1) - j = (i - j) + 1 := by omega
      rw [hleftIndex, hrightIndex, ← cnWholeLineResolventKernel_green (i - j)]
      ring
    _ = data i := by
      have heq : (fun j : ℤ => (if i - j = 0 then (1 : ℝ) else 0) * data j) =
          fun j : ℤ => if j = i then data i else 0 := by
        funext j
        by_cases hj : j = i
        · subst j
          simp
        · have hoffset : i - j ≠ 0 := sub_ne_zero.mpr (Ne.symm hj)
          simp only [if_neg hoffset, if_neg hj, zero_mul]
      rw [heq, tsum_ite_eq]

theorem cnWholeLineImplicitOperator_resolvent (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) :
    cnWholeLineImplicitOperator (cnWholeLineResolvent data) = data := by
  funext i
  exact cnWholeLineImplicitOperator_resolvent_apply data hdata i

theorem cnWholeLineResolvent_implicitOperator (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) :
    cnWholeLineResolvent (cnWholeLineImplicitOperator data) = data := by
  apply cnWholeLineImplicitOperator_injective_on_bounded
    (isBoundedWholeLineData_cnWholeLineResolvent _
      (isBoundedWholeLineData_cnWholeLineImplicitOperator hdata)) hdata
  exact cnWholeLineImplicitOperator_resolvent _
    (isBoundedWholeLineData_cnWholeLineImplicitOperator hdata)

theorem cnWholeLineImplicitOperator_update (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) :
    cnWholeLineImplicitOperator (cnWholeLineUpdate data) = cnWholeLineOldDataOperator data := by
  funext i
  have hi := cnWholeLineImplicitOperator_resolvent_apply data hdata i
  dsimp [cnWholeLineImplicitOperator] at hi
  dsimp [cnWholeLineImplicitOperator, cnWholeLineUpdate, cnWholeLineOldDataOperator]
  linarith

theorem isCNWholeLineStep_update (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) : IsCNWholeLineStep data (cnWholeLineUpdate data) :=
  (isCNWholeLineStep_iff_operators _ _).mpr (cnWholeLineImplicitOperator_update data hdata)

theorem eq_cnWholeLineUpdate_of_isCNWholeLineStep (before after : ℤ → ℝ)
    (hbefore : IsBoundedWholeLineData before) (hafter : IsBoundedWholeLineData after)
    (hstep : IsCNWholeLineStep before after) : after = cnWholeLineUpdate before := by
  apply cnWholeLineImplicitOperator_injective_on_bounded hafter
    (isBoundedWholeLineData_cnWholeLineUpdate before hbefore)
  rw [(isCNWholeLineStep_iff_operators before after).mp hstep,
    cnWholeLineImplicitOperator_update before hbefore]

end NumStability
