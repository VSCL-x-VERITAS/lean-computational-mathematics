/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLine
import Mathlib.Tactic.NormNum
import Lean.Elab.Tactic.Omega
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# The fixed whole-line Crank–Nicolson kernels

Values, positivity, absolute summability and the Green recurrence of the
specified coefficient-`3/4` geometric kernel. The solved-step kernel has zero
at the origin and is strictly positive at every other integer. None of these
facts assumes a convolution inverse or a bounded solution of the CN step.
-/

namespace NumStability

@[simp]
theorem cnWholeLineResolventKernel_zero :
    cnWholeLineResolventKernel 0 = 1 / 2 := by
  norm_num [cnWholeLineResolventKernel]

@[simp]
theorem cnWholeLineResolventKernel_one :
    cnWholeLineResolventKernel 1 = 1 / 6 := by
  norm_num [cnWholeLineResolventKernel]

@[simp]
theorem cnWholeLineResolventKernel_neg (offset : ℤ) :
    cnWholeLineResolventKernel (-offset) = cnWholeLineResolventKernel offset := by
  simp only [cnWholeLineResolventKernel, Int.natAbs_neg]

@[simp]
theorem cnWholeLineResolventKernel_neg_one :
    cnWholeLineResolventKernel (-1) = 1 / 6 := by
  rw [cnWholeLineResolventKernel_neg, cnWholeLineResolventKernel_one]

theorem cnWholeLineResolventKernel_pos (offset : ℤ) :
    0 < cnWholeLineResolventKernel offset := by
  unfold cnWholeLineResolventKernel
  positivity

theorem cnWholeLineResolventKernel_nonneg (offset : ℤ) :
    0 ≤ cnWholeLineResolventKernel offset :=
  (cnWholeLineResolventKernel_pos offset).le

@[simp]
theorem cnWholeLineStepKernel_zero : cnWholeLineStepKernel 0 = 0 := by
  norm_num [cnWholeLineStepKernel, cnWholeLineResolventKernel]
  all_goals exact sub_self (1 : ℝ)

theorem cnWholeLineStepKernel_eq_of_ne_zero (offset : ℤ) (hoffset : offset ≠ 0) :
    cnWholeLineStepKernel offset = (1 / 3 : ℝ) ^ offset.natAbs := by
  simp only [cnWholeLineStepKernel, cnWholeLineResolventKernel, if_neg hoffset]
  ring

theorem cnWholeLineStepKernel_pos_of_ne_zero (offset : ℤ) (hoffset : offset ≠ 0) :
    0 < cnWholeLineStepKernel offset := by
  rw [cnWholeLineStepKernel_eq_of_ne_zero offset hoffset]
  positivity

theorem cnWholeLineStepKernel_nonneg (offset : ℤ) :
    0 ≤ cnWholeLineStepKernel offset := by
  by_cases hoffset : offset = 0
  · subst offset
    simp only [cnWholeLineStepKernel_zero, le_refl]
  · exact (cnWholeLineStepKernel_pos_of_ne_zero offset hoffset).le

theorem cnWholeLineStepKernel_le_two_mul_resolventKernel (offset : ℤ) :
    cnWholeLineStepKernel offset ≤ 2 * cnWholeLineResolventKernel offset := by
  unfold cnWholeLineStepKernel
  apply sub_le_self
  by_cases hoffset : offset = 0 <;> simp [hoffset]

/-- Raw summability over all integers, with the negative tail included. -/
theorem summable_cnWholeLineResolventKernel : Summable cnWholeLineResolventKernel := by
  have hgeometric : Summable (fun n : ℕ => (1 / 3 : ℝ) ^ n) :=
    summable_geometric_of_abs_lt_one (by norm_num)
  apply Summable.of_nat_of_neg_add_one
  · simpa only [cnWholeLineResolventKernel, Int.natAbs_natCast] using
      hgeometric.mul_left (1 / 2 : ℝ)
  · change Summable (fun n : ℕ => cnWholeLineResolventKernel (-((n : ℤ) + 1)))
    have htail : Summable (fun n : ℕ =>
        (1 / 2 : ℝ) * ((1 / 3 : ℝ) ^ n * (1 / 3 : ℝ))) :=
      (hgeometric.mul_right (1 / 3 : ℝ)).mul_left (1 / 2 : ℝ)
    simpa only [cnWholeLineResolventKernel, Int.natAbs_neg,
      ← Int.natCast_add_one, Int.natAbs_natCast, pow_succ] using htail

theorem summable_abs_cnWholeLineResolventKernel :
    Summable (fun offset : ℤ => |cnWholeLineResolventKernel offset|) := by
  apply summable_cnWholeLineResolventKernel.congr
  intro offset
  exact (abs_of_nonneg (cnWholeLineResolventKernel_nonneg offset)).symm

/-- The actual step kernel is dominated by twice the geometric resolvent. -/
theorem summable_cnWholeLineStepKernel : Summable cnWholeLineStepKernel := by
  apply (summable_cnWholeLineResolventKernel.mul_left (2 : ℝ)).of_norm_bounded
  intro offset
  rw [Real.norm_of_nonneg (cnWholeLineStepKernel_nonneg offset)]
  exact cnWholeLineStepKernel_le_two_mul_resolventKernel offset

theorem summable_abs_cnWholeLineStepKernel :
    Summable (fun offset : ℤ => |cnWholeLineStepKernel offset|) := by
  apply summable_cnWholeLineStepKernel.congr
  intro offset
  exact (abs_of_nonneg (cnWholeLineStepKernel_nonneg offset)).symm

private theorem cnWholeLineResolventKernel_green_nat_succ (n : ℕ) :
    (5 / 2 : ℝ) * cnWholeLineResolventKernel ((n + 1 : ℕ) : ℤ) -
      (3 / 4 : ℝ) *
        (cnWholeLineResolventKernel (((n + 1 : ℕ) : ℤ) - 1) +
          cnWholeLineResolventKernel (((n + 1 : ℕ) : ℤ) + 1)) = 0 := by
  have hleft : ((n + 1 : ℕ) : ℤ) - 1 = (n : ℤ) := by omega
  have hright : ((n + 1 : ℕ) : ℤ) + 1 = ((n + 2 : ℕ) : ℤ) := by omega
  rw [hleft, hright]
  simp only [cnWholeLineResolventKernel, Int.natAbs_natCast, pow_succ]
  ring

/-- The geometric kernel is the actual all-integer Green recurrence for the
specified implicit three-point operator. This is not an inverse premise. -/
theorem cnWholeLineResolventKernel_green (offset : ℤ) :
    (5 / 2 : ℝ) * cnWholeLineResolventKernel offset -
      (3 / 4 : ℝ) *
        (cnWholeLineResolventKernel (offset - 1) +
          cnWholeLineResolventKernel (offset + 1)) =
      if offset = 0 then 1 else 0 := by
  cases offset with
  | ofNat n =>
      cases n with
      | zero => norm_num; rfl
      | succ n =>
          have hoffset : Int.ofNat (n + 1) ≠ 0 :=
            Int.ofNat_ne_zero.mpr (Nat.succ_ne_zero n)
          change (5 / 2 : ℝ) * cnWholeLineResolventKernel ((n + 1 : ℕ) : ℤ) -
            (3 / 4 : ℝ) *
              (cnWholeLineResolventKernel (((n + 1 : ℕ) : ℤ) - 1) +
                cnWholeLineResolventKernel (((n + 1 : ℕ) : ℤ) + 1)) = _
          rw [if_neg hoffset]
          exact cnWholeLineResolventKernel_green_nat_succ n
  | negSucc n =>
      have hoffset : Int.negSucc n = -((n + 1 : ℕ) : ℤ) := by omega
      rw [hoffset]
      have hleft : -((n + 1 : ℕ) : ℤ) - 1 = -(((n + 1 : ℕ) : ℤ) + 1) := by omega
      have hright : -((n + 1 : ℕ) : ℤ) + 1 = -(((n + 1 : ℕ) : ℤ) - 1) := by omega
      rw [hleft, hright]
      simp only [cnWholeLineResolventKernel_neg]
      rw [if_neg (by omega : -((n + 1 : ℕ) : ℤ) ≠ 0)]
      rw [add_comm
        (cnWholeLineResolventKernel (((n + 1 : ℕ) : ℤ) + 1))
        (cnWholeLineResolventKernel (((n + 1 : ℕ) : ℤ) - 1))]
      exact cnWholeLineResolventKernel_green_nat_succ n

end NumStability
