/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMeanErrorConvergence

/-!
# Physical error norms restricted to finite windows

Restricting an arbitrary grid array to a finite window gives an existing `lp`
element. No global norm membership is required, even at coarse mesh levels.
Errors differing by one throughout a window of positive physical mass cannot
both vanish in the physically weighted norm. This covers every exponent at
least one, including infinity.
-/

open Filter
open scoped Topology BigOperators ENNReal

namespace NumStability

/-- An arbitrary grid error restricted to a finite set, zero elsewhere. -/
noncomputable def finiteWindowLp (p : ENNReal) (window : Finset ℤ)
    (error : ℤ → Fin 1 → ℝ) : lp (fun _ : ℤ => Fin 1 → ℝ) p :=
  ∑ j ∈ window, lp.single p j (error j)

theorem finiteWindowLp_apply (p : ENNReal) (window : Finset ℤ)
    (error : ℤ → Fin 1 → ℝ) (j : ℤ) :
    finiteWindowLp p window error j = if j ∈ window then error j else 0 := by
  classical
  simp only [finiteWindowLp, lp.coeFn_sum, lp.coeFn_single, Finset.sum_apply,
    Finset.sum_pi_single]

/-- Restriction to a finite window cannot increase the existing global norm. -/
theorem finiteWindowLp_norm_le (p : ENNReal) [Fact (1 ≤ p)]
    (window : Finset ℤ) (error : lp (fun _ : ℤ => Fin 1 → ℝ) p) :
    ‖finiteWindowLp p window error‖ ≤ ‖error‖ := by
  classical
  by_cases hpinf : p = ∞
  · subst p
    apply lp.norm_le_of_forall_le (norm_nonneg error)
    intro j
    by_cases hj : j ∈ window
    · simpa [finiteWindowLp_apply, hj] using lp.norm_apply_le_norm ENNReal.top_ne_zero error j
    · simp [finiteWindowLp_apply, hj]
  · have hpr : 0 < p.toReal := (ENNReal.toReal_pos_iff_ne_top p).mpr hpinf
    apply (Real.rpow_le_rpow_iff (norm_nonneg _) (norm_nonneg _) hpr).mp
    rw [finiteWindowLp, lp.norm_sum_single hpr]
    exact lp.sum_rpow_le_norm_rpow hpr error window

/-- Only eventual global membership and equality are needed to pass global
error convergence to finite windows. Coarse arrays remain unrestricted. -/
theorem finiteWindowLp_tendsto_zero_of_eventually_represented
    (p : ENNReal) [Fact (1 ≤ p)] (width : ℕ → ℝ)
    (window : ℕ → Finset ℤ) (error : ℕ → ℤ → Fin 1 → ℝ)
    (representative : ℕ → lp (fun _ : ℤ => Fin 1 → ℝ) p)
    (hwidth : ∀ n, 0 ≤ width n)
    (heq : ∀ᶠ n in atTop, ∀ j, representative n j = error n j)
    (hlim : Tendsto (fun n => physicalLpGridWeight_s03 p width n *
      ‖representative n‖) atTop (𝓝 0)) :
    Tendsto (fun n => physicalLpGridWeight_s03 p width n *
      ‖finiteWindowLp p (window n) (error n)‖) atTop (𝓝 0) := by
  have hweight (n : ℕ) : 0 ≤ physicalLpGridWeight_s03 p width n :=
    Real.rpow_nonneg (hwidth n) _
  apply squeeze_zero' (Filter.Eventually.of_forall (fun n =>
      mul_nonneg (hweight n) (norm_nonneg _))) ?_ hlim
  filter_upwards [heq] with n hn
  have hfun : error n = (representative n : ℤ → Fin 1 → ℝ) := funext fun j => (hn j).symm
  rw [hfun]
  exact mul_le_mul_of_nonneg_left (finiteWindowLp_norm_le p (window n) (representative n))
    (hweight n)

/-- A positive physical mass of unit error separation prevents simultaneous
vanishing. The arrays can have infinite or undefined global norms. -/
theorem finiteWindowLp_not_both_tendsto_zero
    (p : ENNReal) [Fact (1 ≤ p)] (width : ℕ → ℝ)
    (window : ℕ → Finset ℤ) (error0 error1 : ℕ → ℤ → Fin 1 → ℝ) (mass : ℝ)
    (hwidth : ∀ n, 0 < width n) (hmasspos : 0 < mass)
    (hmass : ∀ᶠ n in atTop, mass ≤ width n * ((window n).card : ℝ))
    (hdifference : ∀ᶠ n in atTop, ∀ j ∈ window n,
      error0 n j - error1 n j = (fun _ : Fin 1 => (1 : ℝ))) :
    ¬ (Tendsto (fun n => physicalLpGridWeight_s03 p width n *
          ‖finiteWindowLp p (window n) (error0 n)‖) atTop (𝓝 0) ∧
       Tendsto (fun n => physicalLpGridWeight_s03 p width n *
          ‖finiteWindowLp p (window n) (error1 n)‖) atTop (𝓝 0)) := by
  classical
  rintro ⟨hlim0, hlim1⟩
  let e0 := fun n => finiteWindowLp p (window n) (error0 n)
  let e1 := fun n => finiteWindowLp p (window n) (error1 n)
  let weight := physicalLpGridWeight_s03 p width
  have hwpos (n : ℕ) : 0 < weight n := Real.rpow_pos_of_pos (hwidth n) _
  have hDpoint : ∀ᶠ n in atTop, ∀ j ∈ window n,
      (e0 n - e1 n) j = (fun _ : Fin 1 => (1 : ℝ)) := by
    filter_upwards [hdifference] with n hn
    intro j hj
    change finiteWindowLp p (window n) (error0 n) j -
      finiteWindowLp p (window n) (error1 n) j = _
    simpa only [finiteWindowLp_apply, if_pos hj] using hn j hj
  have hDlim : Tendsto (fun n => weight n * ‖e0 n - e1 n‖) atTop (𝓝 0) := by
    apply squeeze_zero (fun n => mul_nonneg (hwpos n).le (norm_nonneg _))
      (fun n => (mul_le_mul_of_nonneg_left (norm_sub_le (e0 n) (e1 n))
        (hwpos n).le).trans_eq (mul_add _ _ _))
    simpa only [zero_add] using hlim0.add hlim1
  by_cases hpinf : p = ∞
  · subst p
    have hweight (n : ℕ) : weight n = 1 := by
      simp [weight, physicalLpGridWeight_s03]
    have hnormlim : Tendsto (fun n => ‖e0 n - e1 n‖) atTop (𝓝 0) := by
      simpa only [hweight, one_mul] using hDlim
    have hlower : ∀ᶠ n in atTop, 1 ≤ ‖e0 n - e1 n‖ := by
      filter_upwards [hDpoint, hmass] with n hn hm
      have hw : (window n).Nonempty := by
        apply Finset.card_pos.mp
        by_contra hncard
        have hc : (window n).card = 0 := Nat.eq_zero_of_not_pos hncard
        rw [hc, Nat.cast_zero, mul_zero] at hm
        linarith
      obtain ⟨j, hj⟩ := hw
      have hh := lp.norm_apply_le_norm ENNReal.top_ne_zero (e0 n - e1 n) j
      rw [hn j hj] at hh
      simpa using hh
    have hbad : (1 : ℝ) ≤ 0 := ge_of_tendsto hnormlim hlower
    norm_num at hbad
  · let q : ℝ := p.toReal
    have hq : 0 < q := (ENNReal.toReal_pos_iff_ne_top p).mpr hpinf
    have hpowlim : Tendsto (fun n => (weight n * ‖e0 n - e1 n‖) ^ q)
        atTop (𝓝 0) := by
      simpa only [Real.zero_rpow hq.ne'] using hDlim.rpow_const (Or.inr hq.le)
    have hlower : ∀ᶠ n in atTop,
        mass ≤ (weight n * ‖e0 n - e1 n‖) ^ q := by
      filter_upwards [hDpoint, hmass] with n hn hm
      have hsum : (∑ j ∈ window n, ‖(e0 n - e1 n) j‖ ^ q) =
          ((window n).card : ℝ) := by
        calc
          (∑ j ∈ window n, ‖(e0 n - e1 n) j‖ ^ q) =
              ∑ _j ∈ window n, (1 : ℝ) := by
            apply Finset.sum_congr rfl
            intro j hj
            rw [hn j hj]
            simp
          _ = ((window n).card : ℝ) := by simp
      have hcard : ((window n).card : ℝ) ≤ ‖e0 n - e1 n‖ ^ q := by
        have hs := lp.sum_rpow_le_norm_rpow hq (e0 n - e1 n) (window n)
        rw [hsum] at hs
        exact hs
      have hid : (weight n * ‖e0 n - e1 n‖) ^ q =
          width n * ‖e0 n - e1 n‖ ^ q := by
        change ((width n) ^ (1 / q) * ‖e0 n - e1 n‖) ^ q =
          width n * ‖e0 n - e1 n‖ ^ q
        rw [Real.mul_rpow (Real.rpow_nonneg (hwidth n).le _) (norm_nonneg _),
          ← Real.rpow_mul (hwidth n).le]
        have hexp : (1 / q) * q = (1 : ℝ) := by field_simp [hq.ne']
        rw [hexp, Real.rpow_one]
      rw [hid]
      exact hm.trans (mul_le_mul_of_nonneg_left hcard (hwidth n).le)
    have hbad : mass ≤ 0 := ge_of_tendsto hpowlim hlower
    linarith

end NumStability
