/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Lp.BoundedPairing
import ComputationalMathematics.Analysis.Normed.Module.PowerBoundedEigenvalue
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LpUpwind
import Mathlib.Tactic

/-!
# Necessity of CFL for upwind in the physical one-norm

An alternating bounded coefficient functional detects the growing mode even
though an alternating sequence itself is not in ℓ¹. This gives necessity of
CFL under eventual uniform power bounds. Combining necessity with contraction
gives a criterion on positive whole-line meshes at every fixed final time.
-/

namespace NumStability

noncomputable section

private theorem alternatingCoefficient_norm_le (i : ℤ) : ‖(-1 : ℝ) ^ i‖ ≤ 1 := by
  simp only [Real.norm_eq_abs, abs_neg_one_zpow, le_refl]

private def alternatingPairing : lp (fun _ : ℤ => ℝ) 1 →L[ℝ] ℝ :=
  lpOnePairing (fun i => (-1 : ℝ) ^ i) alternatingCoefficient_norm_le

private theorem alternatingPairing_upwindStep (courant : ℝ)
    (u : lp (fun _ : ℤ => ℝ) 1) :
    alternatingPairing (lpUpwindStep courant u) =
      (1 - 2 * |courant|) * alternatingPairing u := by
  have hshift : alternatingPairing
      (lpReindex (upwindIndexEquiv courant) u) =
        -1 * alternatingPairing u := by
    apply lpOnePairing_reindex
    intro i
    by_cases hc : 0 ≤ courant
    · simp only [upwindIndexEquiv, hc, if_true, Equiv.addRight_symm_apply]
      simp only [neg_neg]
      rw [zpow_add₀ (show (-1 : ℝ) ≠ 0 by norm_num), zpow_one]
      ring
    · simp only [upwindIndexEquiv, hc, if_false, Equiv.addRight_symm_apply]
      change (-1 : ℝ) ^ (i - 1) = -1 * (-1 : ℝ) ^ i
      rw [zpow_sub₀ (show (-1 : ℝ) ≠ 0 by norm_num), zpow_one]
      ring
  rw [lpUpwindStep, lpReindexAverage_apply, map_add, map_smul, map_smul, hshift]
  simp only [smul_eq_mul]
  ring

private theorem alternatingPairing_single_zero :
    alternatingPairing (lp.single 1 (0 : ℤ) (1 : ℝ)) = 1 := by
  rw [alternatingPairing, lpOnePairing_apply]
  simp [lp.single_apply, Pi.single_apply, mul_ite]

/-- Eventual uniform ℓ¹ power bounds require the absolute Courant number to be at most one. -/
theorem lpUpwindStep_cfl_of_eventually_l1_power_bounded (courant : ℝ)
    (hstable : ∃ bound : ℝ, ∃ start : ℕ, ∀ n ≥ start,
      ∀ u : lp (fun _ : ℤ => ℝ) 1,
        ‖((lpUpwindStep courant).toLinearMap ^ n) u‖ ≤ bound * ‖u‖) :
    |courant| ≤ 1 := by
  obtain ⟨bound,start,hbound⟩ := hstable
  let test : lp (fun _ : ℤ => ℝ) 1 := lp.single 1 (0 : ℤ) (1 : ℝ)
  let R : ℝ →ₗ[ℝ] ℝ := (1 - 2 * |courant|) • LinearMap.id
  have htest : alternatingPairing test = 1 :=
    alternatingPairing_single_zero
  have hnorm : ‖test‖ = 1 := by
    change ‖(lp.single 1 (0 : ℤ) (1 : ℝ) : lp (fun _ : ℤ => ℝ) 1)‖ = 1
    rw [lp.norm_single (by norm_num), norm_one]
  have hsem : Function.Semiconj alternatingPairing
      (lpUpwindStep courant) R := by
    intro u
    simpa [R] using alternatingPairing_upwindStep courant u
  have hpow (n : ℕ) : (R ^ n) (alternatingPairing test) =
      alternatingPairing (((lpUpwindStep courant).toLinearMap ^ n) test) := by
    simpa only [Module.End.pow_apply] using (hsem.iterate_right n test).symm
  have heigen : R 1 = (1 - 2 * |courant|) • (1 : ℝ) := by simp [R]
  have heigbound : abs (1 - 2 * |courant|) ≤ 1 := by
    apply abs_eigenvalue_le_one_of_eventually_bounded_orbit R
      (1 - 2 * |courant|) 1 (by norm_num) heigen
    refine ⟨bound,start,?_⟩
    intro n hn
    calc
      ‖(R ^ n) 1‖ = ‖alternatingPairing
          (((lpUpwindStep courant).toLinearMap ^ n) test)‖ := by rw [← htest, hpow]
      _ ≤ ‖((lpUpwindStep courant).toLinearMap ^ n) test‖ :=
        lp_one_weighted_tsum_norm_le (fun i => (-1 : ℝ) ^ i)
          alternatingCoefficient_norm_le _
      _ ≤ bound * ‖test‖ := hbound n hn test
      _ = bound * ‖(1 : ℝ)‖ := by rw [hnorm]; simp
  have hlow := (abs_le.mp heigbound).1
  linarith

/-- Uniform one-norm bounds up to every fixed positive final time, on
positive uniform whole-line meshes with a fixed time/space ratio.
The physical one-norm is cell width times the lp-one sequence norm. -/
def IsLpUpwindOneNormRefinementStable (speed ratio : ℝ) : Prop :=
  ∀ finalTime : ℝ, 0 < finalTime → ∃ bound : ℝ, 0 ≤ bound ∧ ∃ start : ℕ,
    ∀ n : ℕ, start ≤ n → 0 < n → ∀ k : ℕ, k ≤ n →
      ∀ u : lp (fun _ : ℤ => ℝ) 1,
        (finalTime / (ratio * (n : ℝ))) *
            ‖((lpUpwindStep
              (speed * (finalTime / (n : ℝ)) /
                (finalTime / (ratio * (n : ℝ))))).toLinearMap ^ k) u‖ ≤
          bound * ((finalTime / (ratio * (n : ℝ))) * ‖u‖)

private theorem fixedRatioCourant_identity
    (speed finalTime ratio : ℝ) (n : ℕ)
    (hT : 0 < finalTime) (hr : 0 < ratio) (hn : 0 < n) :
    speed * (finalTime / (n : ℝ)) / (finalTime / (ratio * (n : ℝ))) = speed * ratio := by
  field_simp [hT.ne',hr.ne',Nat.cast_ne_zero.mpr hn.ne']

/-- Physical ℓ¹ refinement stability of positive-speed upwind is equivalent to CFL. -/
theorem lpUpwindOneNormRefinementStable_iff_cfl
    (speed ratio : ℝ) (hs : 0 < speed) (hr : 0 < ratio) :
    IsLpUpwindOneNormRefinementStable speed ratio ↔
      0 ≤ speed * ratio ∧ speed * ratio ≤ 1 := by
  constructor
  · intro hstable
    obtain ⟨bound,_hbound,start,hpower⟩ := hstable 1 (by norm_num)
    have huniform : ∃ bound : ℝ, ∃ start : ℕ, ∀ n ≥ start,
        ∀ u : lp (fun _ : ℤ => ℝ) 1,
          ‖((lpUpwindStep (speed * ratio)).toLinearMap ^ n) u‖ ≤ bound * ‖u‖ := by
      refine ⟨bound,max start 1,?_⟩
      intro n hn u
      have hn0 : 0 < n := lt_of_lt_of_le Nat.zero_lt_one ((le_max_right start 1).trans hn)
      have hmesh := hpower n ((le_max_left start 1).trans hn) hn0 n le_rfl u
      rw [fixedRatioCourant_identity speed 1 ratio n (by norm_num) hr hn0] at hmesh
      have hw : 0 < (1 : ℝ) / (ratio * (n : ℝ)) :=
        div_pos (by norm_num) (mul_pos hr (Nat.cast_pos.mpr hn0))
      apply (mul_le_mul_iff_right₀ hw).mp
      calc
        _ ≤ bound * ((1 / (ratio * (n : ℝ))) * ‖u‖) := hmesh
        _ = (1 / (ratio * (n : ℝ))) * (bound * ‖u‖) := by ring
    have hc := lpUpwindStep_cfl_of_eventually_l1_power_bounded (speed * ratio) huniform
    exact ⟨(mul_pos hs hr).le,(le_abs_self _).trans hc⟩
  · intro hc finalTime hT
    refine ⟨1,zero_le_one,1,?_⟩
    intro n _hn hn0 k _hk u
    have habs : |speed * ratio| ≤ 1 := by
      rw [abs_of_pos (mul_pos hs hr)]
      exact hc.2
    have hiter := lpUpwindStep_iterate_error habs u (fun _ => 0) k ‖u‖ 0
      (by simp) (by intro j _hj; simp)
    have hnorm : ‖((lpUpwindStep (speed * ratio)).toLinearMap ^ k) u‖ ≤ ‖u‖ := by
      simpa only [Module.End.pow_apply,sub_zero,mul_zero,add_zero] using hiter
    rw [fixedRatioCourant_identity speed finalTime ratio n hT hr hn0,one_mul]
    exact mul_le_mul_of_nonneg_left hnorm
      (div_nonneg hT.le (mul_nonneg hr.le (Nat.cast_nonneg n)))


end
end NumStability
