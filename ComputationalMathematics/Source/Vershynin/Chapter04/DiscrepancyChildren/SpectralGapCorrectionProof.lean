import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapChildren
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.BalancedMean

/-!
# Exact indexed spectral gaps of the loopless mean

These source-model results support the separately specified analyst-derived
children of the printed stochastic-block claims.
-/

noncomputable section

set_option maxHeartbeats 1000000
set_option backward.isDefEq.respectTransparency false

open Matrix MeasureTheory
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- The corrected lower bound, attainment and singleton/zero-crossing corners, with ordered multiplicities retained. -/
theorem spectral_gap_correction_child_proved : HDP04SBMSpectralGapCorrectionChildTarget := by
  classical
  intro k hk θ c hc hpq
  dsimp only
  let hM := BalancedMean.mean_hermitian c (θ.p : ℝ) (θ.q : ℝ)
  let hB := BalancedMean.block_hermitian c (θ.p : ℝ) (θ.q : ℝ)
  let f := NumStability.hermitianOrderedEigenvalue hM
  let e0 : Fin (2*k) := ⟨0, by omega⟩
  let e1 : Fin (2*k) := ⟨1, by omega⟩
  let μ : ℝ := min (((θ.p : ℝ) - θ.q)/2) (θ.q : ℝ)
  obtain ⟨h0, h1, hbulk⟩ := BalancedMean.balanced_mean_ordered hk θ c hc hpq
  change f e0 = _ at h0
  change f e1 = _ at h1
  change ∀ j : Fin (2*k), 2 ≤ j.val → f j = -(θ.p : ℝ) at hbulk
  have hkR : (0 : ℝ) < k := by exact_mod_cast hk
  have hq : (0 : ℝ) ≤ θ.q := θ.q.coe_nonneg
  have hpqR : (θ.q : ℝ) < θ.p := hpq
  have hd0 : |f e1 - f e0| = 2 * (k : ℝ) * (θ.q : ℝ) := by
    rw [h1, h0, abs_of_nonpos]
    · ring
    · nlinarith [mul_nonneg hkR.le hq]
  have hdbulk (j : Fin (2*k)) (hj : 2 ≤ j.val) :
      |f e1 - f j| = (k : ℝ) * ((θ.p : ℝ) - θ.q) := by
    rw [h1, hbulk j hj, abs_of_nonneg]
    · ring
    · nlinarith [mul_pos hkR (sub_pos.mpr hpqR)]
  have hindex (j : Fin (2*k)) (hj : j ≠ e1) : j = e0 ∨ 2 ≤ j.val := by
    by_cases h : j.val = 0
    · exact Or.inl (Fin.ext h)
    · right
      have hne : j.val ≠ 1 := by
        intro hv
        exact hj (Fin.ext hv)
      omega
  have hlower (j : Fin (2*k)) (hj : j ≠ e1) :
      μ * ((2*k : ℕ) : ℝ) ≤ |f e1 - f j| := by
    rcases hindex j hj with rfl | hj2
    · rw [hd0]
      have h := mul_le_mul_of_nonneg_right
        (min_le_right (((θ.p : ℝ)-θ.q)/2) (θ.q : ℝ))
        (show (0 : ℝ) ≤ ((2*k : ℕ) : ℝ) by positivity)
      dsimp [μ]
      push_cast at h ⊢
      nlinarith
    · rw [hdbulk j hj2]
      have h := mul_le_mul_of_nonneg_right
        (min_le_left (((θ.p : ℝ)-θ.q)/2) (θ.q : ℝ))
        (show (0 : ℝ) ≤ ((2*k : ℕ) : ℝ) by positivity)
      dsimp [μ]
      push_cast at h ⊢
      nlinarith
  refine ⟨FinStochasticBlock.adjacency_expectation c θ, hB, hM,
    BalancedMean.block_mean_ordered_shift c (θ.p : ℝ) (θ.q : ℝ), h0, h1, hbulk, hlower, ?_, ?_, ?_, ?_⟩
  · intro hk2
    by_cases hm : ((θ.p : ℝ) - θ.q)/2 ≤ (θ.q : ℝ)
    · let e2 : Fin (2*k) := ⟨2, by omega⟩
      refine ⟨e2, by simp [e2], ?_⟩
      change |f e1 - f e2| = μ * ((2*k : ℕ) : ℝ)
      rw [hdbulk e2 (by simp [e2])]
      dsimp [μ]
      rw [min_eq_left hm]
      push_cast; ring
    · refine ⟨e0, by simp [e0], ?_⟩
      change |f e1 - f e0| = μ * ((2*k : ℕ) : ℝ)
      rw [hd0]
      dsimp [μ]
      rw [min_eq_right (le_of_not_ge hm)]
      push_cast; ring
  · intro hk1 j hj
    have hj0 : j = e0 := by
      rcases hindex j hj with h | h
      · exact h
      · have hbound := j.isLt
        omega
    change |f e1 - f j| = _
    rw [hj0, hd0, hk1]; norm_num
  · intro hq0
    refine ⟨e0, by simp [e0], ?_⟩
    change |f e1 - f e0| = 0
    rw [hd0, hq0]; simp
  · intro hqpos j hj
    have hqR : (0 : ℝ) < θ.q := hqpos
    have hμ : 0 < μ := lt_min (half_pos (sub_pos.mpr hpqR)) hqR
    exact lt_of_lt_of_le (mul_pos hμ (by positivity)) (hlower j hj)

end NumStability.HDP.Contract.DiscrepancyChildren
