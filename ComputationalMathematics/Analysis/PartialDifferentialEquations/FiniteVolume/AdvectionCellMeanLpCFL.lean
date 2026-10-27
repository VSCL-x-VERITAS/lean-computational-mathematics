/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionMissedConeWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCellMeanErrorConvergence

/-!
# Cell-mean norm convergence requires the advection CFL bound

Exact physical cell means initialize the supplied radius-local updates. If
their actual cell-mean errors converge in the existing physical grid norm
for every fixed smooth compactly supported scalar profile valued in `[0, 1]`,
the characteristic speed satisfies the stencil bound. The result covers
both speed signs and every exponent at least one, including infinity.

The proof uses two fixed profiles, a cutoff and zero, on a positive-length
physical window. Their numerical values agree while their transported means
differ; the two actual error norms therefore cannot both vanish.
-/

open Set Filter
open scoped Topology BigOperators ENNReal

namespace NumStability

/-- Physical cell-mean norm convergence of radius-local scalar-advection
updates forces the fixed-ratio Courant bound. Initialization and references
are the same normalized cell integrals used by the convergence predicate. -/
theorem advectionRefinement_courant_le_of_cellMeanLpConvergence :
  ∀ (p : ENNReal) [Fact (1 ≤ p)]
    (speed origin T ratio : ℝ) (radius : ℕ)
    (update : ℕ → ℕ → (ℤ → Fin 1 → ℝ) → ℤ → Fin 1 → ℝ),
    0 < T → 0 < ratio →
    (∀ n k (left right : ℤ → Fin 1 → ℝ) (i : ℤ),
      (∀ j ∈ Icc (i - (radius : ℤ)) (i + (radius : ℤ)), left j = right j) →
      update n k left i = update n k right i) →
    let width : ℕ → ℝ := fixedRatioRefinementCellWidth T ratio
    let dt : ℕ → ℝ := fun n => T / ((n + 1 : ℕ) : ℝ)
    let steps : ℕ → ℕ := fun n => n + 1
    (∀ profile : ℝ → ℝ,
      ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) profile → HasCompactSupport profile →
      (∀ x, 0 ≤ profile x ∧ profile x ≤ 1) →
      IsPhysicalCellMeanLpConvergent_s03 p
        (fun x t (_ : Fin 1) => travelingWave profile speed x t)
        origin T width dt steps
        (fun n k => centeredStencilEvolution (update n)
          (fun j : ℤ => oneDimensionalCellAverage
            (fun x (_ : Fin 1) => profile x)
            (origin + (j : ℝ) * width n)
            (origin + ((j : ℝ) + 1) * width n)) k)) →
    |speed| * ratio ≤ (radius : ℝ) := by
  classical
  intro p hp speed origin T ratio radius update hT hratio hlocal
  dsimp only
  intro hconv
  by_contra hnot
  have hmiss : (radius : ℝ) < |speed| * ratio := lt_of_not_ge hnot
  let h : ℕ → ℝ := fixedRatioRefinementCellWidth T ratio
  let z : ℝ → ℝ := fun _ => 0
  let initial := fun (n : ℕ) (profile : ℝ → ℝ) (j : ℤ) =>
    oneDimensionalCellAverage (fun x (_ : Fin 1) => profile x)
      (origin + (j : ℝ) * h n) (origin + ((j : ℝ) + 1) * h n)
  let trajectory := fun (n : ℕ) (profile : ℝ → ℝ) =>
    centeredStencilEvolution (update n) (initial n profile)
  let reference := fun (profile : ℝ → ℝ) (n : ℕ) (j : ℤ) =>
    oneDimensionalCellAverage
      (fun x (_ : Fin 1) => travelingWave profile speed x T)
      (origin + (j : ℝ) * h n) (origin + ((j : ℝ) + 1) * h n)
  let gap : ℝ := |speed| * T - (radius : ℝ) * T / ratio
  have hgap : 0 < gap := by
    have hr := (div_lt_iff₀ hratio).mpr hmiss
    have hm := mul_lt_mul_of_pos_right hr hT
    have hid : ((radius : ℝ) / ratio) * T = (radius : ℝ) * T / ratio := by ring
    rw [hid] at hm
    exact sub_pos.mpr hm
  obtain ⟨cutoff, _hrIn, _hrOut, hsmall, hwindow⟩ :=
    exists_advection_missedCone_cellAverage_window speed origin T ratio radius hT hratio hmiss
  let f : ℝ → ℝ := cutoff
  have hzcompact : HasCompactSupport z := by
    simpa only [z] using (HasCompactSupport.zero : HasCompactSupport (0 : ℝ → ℝ))
  have hzrange : ∀ x, 0 ≤ z x ∧ z x ≤ 1 := by intro x; simp [z]
  have hfrange : ∀ x, 0 ≤ f x ∧ f x ≤ 1 := by
    intro x
    exact ⟨cutoff.nonneg, cutoff.le_one⟩
  have hcz := hconv z (by simpa only [z] using
    (contDiff_const : ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (fun _ : ℝ => (0 : ℝ))))
    hzcompact hzrange
  have hcf := hconv f cutoff.contDiff cutoff.hasCompactSupport hfrange
  rcases hcz with ⟨_horizon0, hmesh, _hwlim0, _hdtlim0, hint0, e0, he0, hlim0⟩
  rcases hcf with ⟨_horizon1, _hmesh1, _hwlim1, _hdtlim1, hint1, e1, he1, hlim1⟩
  change ∀ n j, e0 n j = trajectory n z (n + 1) j - reference z n j at he0
  change ∀ n j, e1 n j = trajectory n f (n + 1) j - reference f n j at he1
  let W := fun n => translatedMeshWindow
    (origin - gap / 16) (origin + gap / 16) origin (h n)
  have hhpos (n : ℕ) : 0 < h n := (hmesh n).1
  have hDpoint : ∀ᶠ n : ℕ in atTop, ∀ j ∈ W n,
      (e0 n - e1 n) j = (fun _ : Fin 1 => (1 : ℝ)) := by
    filter_upwards [hsmall] with n hn
    intro j hj
    obtain ⟨hcone, hmean0, hmean1⟩ := hwindow n hn j hj
    have hnum : trajectory n z (n + 1) j = trajectory n f (n + 1) j := by
      apply centeredStencilEvolution_locality (update n) radius (hlocal n)
        (initial n z) (initial n f) (n + 1) j
      intro ell hell
      have hlo : (j : ℝ) - ((n + 1 : ℕ) : ℝ) * (radius : ℝ) ≤ (ell : ℝ) := by
        exact_mod_cast hell.1
      have hhi : (ell : ℝ) ≤ (j : ℝ) + ((n + 1 : ℕ) : ℝ) * (radius : ℝ) := by
        exact_mod_cast hell.2
      have hml := mul_le_mul_of_nonneg_right hlo (hhpos n).le
      have hmr := mul_le_mul_of_nonneg_right hhi (hhpos n).le
      dsimp [initial]
      unfold oneDimensionalCellAverage
      congr 1
      apply intervalIntegral.integral_congr
      intro x hx
      rw [uIcc_of_le (by nlinarith [hhpos n] :
        origin + (ell : ℝ) * h n ≤ origin + ((ell : ℝ) + 1) * h n)] at hx
      funext i
      apply hcone
      constructor <;> nlinarith [hx.1, hx.2, hml, hmr]
    have hr0 : reference z n j = (fun _ : Fin 1 => (0 : ℝ)) := by
      funext i
      dsimp [reference]
      rw [oneDimensionalCellAverage_apply _ _ _
        (hint0 (origin + (j : ℝ) * h n) (origin + ((j : ℝ) + 1) * h n)) i]
      exact hmean0
    have hr1 : reference f n j = (fun _ : Fin 1 => (1 : ℝ)) := by
      funext i
      dsimp [reference]
      rw [oneDimensionalCellAverage_apply _ _ _
        (hint1 (origin + (j : ℝ) * h n) (origin + ((j : ℝ) + 1) * h n)) i]
      exact hmean1
    change e0 n j - e1 n j = (fun _ : Fin 1 => (1 : ℝ))
    rw [he0 n j, he1 n j, hr0, hr1, hnum]
    funext i
    simp only [Pi.sub_apply]
    ring
  let weight := physicalLpGridWeight_s03 p h
  have hwpos (n : ℕ) : 0 < weight n :=
    Real.rpow_pos_of_pos (hhpos n) _
  change Tendsto (fun n => weight n * ‖e0 n‖) atTop (𝓝 0) at hlim0
  change Tendsto (fun n => weight n * ‖e1 n‖) atTop (𝓝 0) at hlim1
  have hDlim : Tendsto (fun n => weight n * ‖e0 n - e1 n‖) atTop (𝓝 0) := by
    apply squeeze_zero (fun n => mul_nonneg (hwpos n).le (norm_nonneg _))
      (fun n => (mul_le_mul_of_nonneg_left (norm_sub_le (e0 n) (e1 n))
        (hwpos n).le).trans_eq (mul_add _ _ _))
    simpa only [zero_add] using hlim0.add hlim1
  have hab : origin - gap / 16 < origin + gap / 16 := by linarith
  have hhalf : ((origin + gap / 16) - (origin - gap / 16)) / 2 = gap / 16 := by ring
  have hmass : ∀ᶠ n : ℕ in atTop,
      gap / 16 ≤ h n * ((W n).card : ℝ) := by
    filter_upwards [hsmall] with n hn
    have hm := translatedMeshWindow_half_length_le
      (origin - gap / 16) (origin + gap / 16) origin (h n) hab (hhpos n)
      (by rw [hhalf]; exact hn)
    rw [hhalf] at hm
    exact hm
  by_cases hpinf : p = ∞
  · subst p
    have hweight (n : ℕ) : weight n = 1 := by
      simp [weight, physicalLpGridWeight_s03]
    have hnormlim : Tendsto (fun n => ‖e0 n - e1 n‖) atTop (𝓝 0) := by
      simpa only [hweight, one_mul] using hDlim
    have hlower : ∀ᶠ n : ℕ in atTop, 1 ≤ ‖e0 n - e1 n‖ := by
      filter_upwards [hDpoint, hmass] with n hn hm
      have hw : (W n).Nonempty := by
        apply Finset.card_pos.mp
        by_contra hncard
        have hc : (W n).card = 0 := Nat.eq_zero_of_not_pos hncard
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
    have hlower : ∀ᶠ n : ℕ in atTop,
        gap / 16 ≤ (weight n * ‖e0 n - e1 n‖) ^ q := by
      filter_upwards [hDpoint, hmass] with n hn hm
      have hsum : (∑ j ∈ W n, ‖(e0 n - e1 n) j‖ ^ q) = ((W n).card : ℝ) := by
        calc
          (∑ j ∈ W n, ‖(e0 n - e1 n) j‖ ^ q) = ∑ _j ∈ W n, (1 : ℝ) := by
            apply Finset.sum_congr rfl
            intro j hj
            rw [hn j hj]
            simp
          _ = ((W n).card : ℝ) := by simp
      have hcard : ((W n).card : ℝ) ≤ ‖e0 n - e1 n‖ ^ q := by
        have hs := lp.sum_rpow_le_norm_rpow hq (e0 n - e1 n) (W n)
        rw [hsum] at hs
        exact hs
      have hid : (weight n * ‖e0 n - e1 n‖) ^ q = h n * ‖e0 n - e1 n‖ ^ q := by
        change ((h n) ^ (1 / q) * ‖e0 n - e1 n‖) ^ q = h n * ‖e0 n - e1 n‖ ^ q
        rw [Real.mul_rpow (Real.rpow_nonneg (hhpos n).le _) (norm_nonneg _),
          ← Real.rpow_mul (hhpos n).le]
        have hexp : (1 / q) * q = (1 : ℝ) := by field_simp [hq.ne']
        rw [hexp, Real.rpow_one]
      rw [hid]
      exact hm.trans (mul_le_mul_of_nonneg_left hcard (hhpos n).le)
    have hbad : gap / 16 ≤ 0 := ge_of_tendsto hpowlim hlower
    linarith

end NumStability
