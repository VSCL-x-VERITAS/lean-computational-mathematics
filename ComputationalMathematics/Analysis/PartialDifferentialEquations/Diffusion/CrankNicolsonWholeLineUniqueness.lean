/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLine
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# Bounded uniqueness for the fixed whole-line implicit operator

A bounded solution of the homogeneous three-point recurrence gains the factor
`3/5` in its uniform bound at every iteration. The geometric limit forces it
to vanish, without assuming that a supremum is attained.
-/

namespace NumStability

open Filter
open scoped Topology

theorem isBoundedWholeLineData_zero : IsBoundedWholeLineData (fun _ : ℤ => 0) :=
  ⟨0, le_refl 0, fun _ => by simp⟩

theorem IsBoundedWholeLineData.sub {first second : ℤ → ℝ}
    (hfirst : IsBoundedWholeLineData first) (hsecond : IsBoundedWholeLineData second) :
    IsBoundedWholeLineData (fun i => first i - second i) := by
  obtain ⟨firstBound, hfirstBound, hfirst⟩ := hfirst
  obtain ⟨secondBound, hsecondBound, hsecond⟩ := hsecond
  refine ⟨firstBound + secondBound, add_nonneg hfirstBound hsecondBound, ?_⟩
  intro i
  have htriangle : |first i - second i| ≤ |first i| + |second i| := by
    simpa only [Real.norm_eq_abs] using norm_sub_le (first i) (second i)
  exact htriangle.trans (add_le_add (hfirst i) (hsecond i))

theorem isBoundedWholeLineData_cnWholeLineImplicitOperator {data : ℤ → ℝ}
    (hdata : IsBoundedWholeLineData data) :
    IsBoundedWholeLineData (cnWholeLineImplicitOperator data) := by
  obtain ⟨bound, hbound, hdata⟩ := hdata
  refine ⟨4 * bound, mul_nonneg (by norm_num) hbound, ?_⟩
  intro i
  obtain ⟨hleftLow, hleftHigh⟩ := abs_le.mp (hdata (i - 1))
  obtain ⟨hrightLow, hrightHigh⟩ := abs_le.mp (hdata (i + 1))
  obtain ⟨hcenterLow, hcenterHigh⟩ := abs_le.mp (hdata i)
  apply abs_le.mpr
  constructor <;> dsimp [cnWholeLineImplicitOperator] <;> linarith

theorem cnWholeLineImplicitOperator_sub (first second : ℤ → ℝ) :
    cnWholeLineImplicitOperator (fun i => first i - second i) =
      fun i => cnWholeLineImplicitOperator first i - cnWholeLineImplicitOperator second i := by
  funext i
  dsimp [cnWholeLineImplicitOperator]
  ring

theorem cnWholeLineImplicitOperator_const_mul (scalar : ℝ) (data : ℤ → ℝ) :
    cnWholeLineImplicitOperator (fun i => scalar * data i) =
      fun i => scalar * cnWholeLineImplicitOperator data i := by
  funext i
  dsimp [cnWholeLineImplicitOperator]
  ring

/-- The bounded kernel of the actual implicit operator is trivial. -/
theorem eq_zero_of_cnWholeLineImplicitOperator_eq_zero {data : ℤ → ℝ}
    (hdata : IsBoundedWholeLineData data)
    (hzero : cnWholeLineImplicitOperator data = fun _ => 0) : data = fun _ => 0 := by
  obtain ⟨bound, _, hbound⟩ := hdata
  have hcontract (currentBound : ℝ) (hcurrent : ∀ i, |data i| ≤ currentBound) :
      ∀ i, |data i| ≤ (3 / 5 : ℝ) * currentBound := by
    intro i
    have hi := congrFun hzero i
    dsimp [cnWholeLineImplicitOperator] at hi
    obtain ⟨hleftLow, hleftHigh⟩ := abs_le.mp (hcurrent (i - 1))
    obtain ⟨hrightLow, hrightHigh⟩ := abs_le.mp (hcurrent (i + 1))
    apply abs_le.mpr
    constructor <;> linarith
  have hdecay : ∀ n : ℕ, ∀ i, |data i| ≤ bound * (3 / 5 : ℝ) ^ n := by
    intro n
    induction n with
    | zero => simpa using hbound
    | succ n ih =>
        intro i
        calc
          |data i| ≤ (3 / 5 : ℝ) * (bound * (3 / 5 : ℝ) ^ n) := hcontract _ ih i
          _ = bound * (3 / 5 : ℝ) ^ (n + 1) := by rw [pow_succ]; ring
  have hpow : Tendsto (fun n : ℕ => (3 / 5 : ℝ) ^ n) atTop (𝓝 0) :=
    tendsto_pow_atTop_nhds_zero_of_abs_lt_one (by norm_num)
  have hlimit : Tendsto (fun n : ℕ => bound * (3 / 5 : ℝ) ^ n) atTop (𝓝 0) := by
    simpa using hpow.const_mul bound
  funext i
  have hle : |data i| ≤ 0 := ge_of_tendsto' hlimit (fun n => hdecay n i)
  exact abs_eq_zero.mp (le_antisymm hle (abs_nonneg _))

theorem cnWholeLineImplicitOperator_injective_on_bounded {first second : ℤ → ℝ}
    (hfirst : IsBoundedWholeLineData first) (hsecond : IsBoundedWholeLineData second)
    (heq : cnWholeLineImplicitOperator first = cnWholeLineImplicitOperator second) :
    first = second := by
  have hzero : cnWholeLineImplicitOperator (fun i => first i - second i) = fun _ => 0 := by
    rw [cnWholeLineImplicitOperator_sub, heq]
    funext i
    exact sub_self _
  have hdifference := eq_zero_of_cnWholeLineImplicitOperator_eq_zero (hfirst.sub hsecond) hzero
  funext i
  have hi := congrFun hdifference i
  linarith

/-- The actual CN recurrence is the equality of the two specified operators. -/
theorem isCNWholeLineStep_iff_operators (before after : ℤ → ℝ) :
    IsCNWholeLineStep before after ↔
      cnWholeLineImplicitOperator after = cnWholeLineOldDataOperator before := by
  constructor
  · intro hstep
    funext i
    have hi := hstep i
    dsimp [cnWholeLineSecondDifference] at hi
    dsimp [cnWholeLineImplicitOperator, cnWholeLineOldDataOperator]
    linarith
  · intro heq i
    have hi := congrFun heq i
    dsimp [cnWholeLineImplicitOperator, cnWholeLineOldDataOperator] at hi
    dsimp [cnWholeLineSecondDifference]
    linarith

end NumStability
