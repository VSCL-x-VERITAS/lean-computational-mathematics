/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Order.Group.Abs
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Finite monotone conservative maps contract the L1 error

The finite-dimensional order and conservation argument applies to any
periodic scalar conservative scheme with a monotone update.
-/

namespace NumStability

/-- A pointwise monotone map preserving the total sum is nonexpansive
in the finite L1 norm. -/
theorem finiteMonotoneConservative_l1_contract
    {V : Type*} [Fintype V]
    (update : (V → ℝ) → V → ℝ)
    (hmono : ∀ u v, (∀ i, u i ≤ v i) → ∀ i, update u i ≤ update v i)
    (hconserve : ∀ u, ∑ i, update u i = ∑ i, u i)
    (u v : V → ℝ) :
    ∑ i, |update u i - update v i| ≤ ∑ i, |u i - v i| := by
  let upper : V → ℝ := fun i => max (u i) (v i)
  let lower : V → ℝ := fun i => min (u i) (v i)
  have hlu : ∀ i, update lower i ≤ update u i :=
    hmono lower u (fun i => min_le_left _ _)
  have hlv : ∀ i, update lower i ≤ update v i :=
    hmono lower v (fun i => min_le_right _ _)
  have huu : ∀ i, update u i ≤ update upper i :=
    hmono u upper (fun i => le_max_left _ _)
  have huv : ∀ i, update v i ≤ update upper i :=
    hmono v upper (fun i => le_max_right _ _)
  have hpoint (i : V) : |update u i - update v i| ≤
      update upper i - update lower i := by
    apply abs_le.mpr
    constructor <;> linarith [hlu i, hlv i, huu i, huv i]
  calc
    ∑ i, |update u i - update v i| ≤
        ∑ i, (update upper i - update lower i) :=
      Finset.sum_le_sum (fun i _ => hpoint i)
    _ = (∑ i, update upper i) - (∑ i, update lower i) := by
      simp only [Finset.sum_sub_distrib]
    _ = (∑ i, upper i) - (∑ i, lower i) := by
      rw [hconserve upper, hconserve lower]
    _ = ∑ i, |u i - v i| := by
      rw [← Finset.sum_sub_distrib]
      apply Finset.sum_congr rfl
      intro i _
      simpa only [abs_sub_comm] using max_sub_min_eq_abs (u i) (v i)

/-- The error of an approximate orbit of a monotone conservative update is bounded
by its initial error and the accumulated local defects of a comparison orbit. -/
theorem finiteMonotoneConservative_iterate_error
    {V : Type*} [Fintype V]
    (update : (V → ℝ) → V → ℝ)
    (hmono : ∀ u v, (∀ i, u i ≤ v i) → ∀ i, update u i ≤ update v i)
    (hconserve : ∀ u, ∑ i, update u i = ∑ i, u i)
    (approx exactState residual : ℕ → V → ℝ)
    (happrox : ∀ k i, approx (k + 1) i = update (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      update (exactState k) i + residual k i)
    (steps : ℕ) :
    (∑ i, |approx steps i - exactState steps i|) ≤
      (∑ i, |approx 0 i - exactState 0 i|) +
        ∑ k ∈ Finset.range steps, ∑ i, |residual k i| := by
  induction steps with
  | zero => simp
  | succ k ih =>
      have hstep :
          (∑ i, |approx (k + 1) i - exactState (k + 1) i|) ≤
            (∑ i, |approx k i - exactState k i|) +
              ∑ i, |residual k i| := by
        calc
          _ = ∑ i, |(update (approx k) i - update (exactState k) i) -
                residual k i| := by
              apply Finset.sum_congr rfl
              intro i _
              rw [happrox k i, hexact k i]
              congr 1
              ring
          _ ≤ ∑ i, (|update (approx k) i - update (exactState k) i| +
                |residual k i|) :=
              Finset.sum_le_sum (fun i _ => by
                simpa only [sub_eq_add_neg, abs_neg] using
                  (abs_add_le
                    (update (approx k) i - update (exactState k) i)
                    (-residual k i)))
          _ = (∑ i, |update (approx k) i - update (exactState k) i|) +
                ∑ i, |residual k i| := Finset.sum_add_distrib
          _ ≤ (∑ i, |approx k i - exactState k i|) +
                ∑ i, |residual k i| := by
              exact add_le_add
                (finiteMonotoneConservative_l1_contract update hmono hconserve
                  (approx k) (exactState k))
                (le_refl _)
      rw [Finset.sum_range_succ]
      linarith

/-- A uniform local defect yields a mean L1 error proportional to mesh width
over a fixed time horizon for a finite monotone conservative update. -/
theorem finiteMonotoneConservative_fixedHorizonMeanError
    {V : Type*} [Fintype V] [Nonempty V]
    (update : (V → ℝ) → V → ℝ)
    (hmono : ∀ u v, (∀ i, u i ≤ v i) → ∀ i, update u i ≤ update v i)
    (hconserve : ∀ u, ∑ i, update u i = ∑ i, u i)
    (timeStep width localBound horizon : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ localBound)
    (approx exactState residual : ℕ → V → ℝ)
    (happrox : ∀ k i, approx (k + 1) i = update (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      update (exactState k) i + residual k i)
    (hlocal : ∀ k i, |residual k i| ≤ timeStep * localBound * width)
    (steps : ℕ) (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i, |approx steps i - exactState steps i|) /
        (Fintype.card V : ℝ) ≤
      (∑ i, |approx 0 i - exactState 0 i|) /
        (Fintype.card V : ℝ) + horizon * localBound * width := by
  have hglobal := finiteMonotoneConservative_iterate_error
    update hmono hconserve approx exactState residual happrox hexact steps
  have hcard : (0 : ℝ) < Fintype.card V := by
    exact_mod_cast Fintype.card_pos
  have hlocalSum (k : ℕ) :
      (∑ i, |residual k i|) ≤
        (Fintype.card V : ℝ) * (timeStep * localBound * width) := by
    calc
      _ ≤ ∑ _i : V, timeStep * localBound * width :=
        Finset.sum_le_sum (fun i _ => hlocal k i)
      _ = _ := by simp
  have hsum :
      (∑ k ∈ Finset.range steps, ∑ i, |residual k i|) ≤
        (steps : ℝ) *
          ((Fintype.card V : ℝ) * (timeStep * localBound * width)) := by
    calc
      _ ≤ ∑ _k ∈ Finset.range steps,
          (Fintype.card V : ℝ) * (timeStep * localBound * width) :=
        Finset.sum_le_sum (fun k _ => hlocalSum k)
      _ = _ := by simp
  have hfactor : 0 ≤ (Fintype.card V : ℝ) * (localBound * width) :=
    mul_nonneg hcard.le (mul_nonneg hbound hwidth.le)
  have hscaled := mul_le_mul_of_nonneg_right hhorizon hfactor
  have htotal :
      (∑ i, |approx steps i - exactState steps i|) ≤
        (∑ i, |approx 0 i - exactState 0 i|) +
          (Fintype.card V : ℝ) * (horizon * localBound * width) := by
    nlinarith [hglobal, hsum, hscaled]
  apply (div_le_iff₀ hcard).2
  have hcancel :
      ((∑ i, |approx 0 i - exactState 0 i|) / (Fintype.card V : ℝ) +
        horizon * localBound * width) * (Fintype.card V : ℝ) =
      (∑ i, |approx 0 i - exactState 0 i|) +
        (Fintype.card V : ℝ) * (horizon * localBound * width) := by
    rw [add_mul, div_mul_cancel₀ _ (ne_of_gt hcard)]
    ring
  rw [hcancel]
  exact htotal

end NumStability
