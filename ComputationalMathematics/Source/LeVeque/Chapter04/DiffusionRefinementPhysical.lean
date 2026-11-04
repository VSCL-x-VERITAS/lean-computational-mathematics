/- SPDX-License-Identifier: MIT -/
import ComputationalMathematics.Source.LeVeque.Chapter04.DiffusionRefinementPhysicalTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.DiffusionRefinementInfluence
import Mathlib.Analysis.SpecificLimits.Basic

/-!
# LeVeque Chapter 4: physical diffusion refinement

The results separate necessary time-step scaling from constructive quadratic refinement for bounded positive conductivity.
-/

open Set Metric Filter
open scoped Topology
namespace NumStability

/-- Necessity uses actual locality alone, with the complete half-cell padding
for finite-volume initialization. No positivity or numerical CFL is needed here. -/
theorem leveque04_diffusionRefinement_necessary
    (X T : ℝ) (dt h : ℕ → ℝ) (a : ℕ → ℤ → ℝ) (steps : ℕ → ℕ)
    (hT : 0 < T) (hh : ∀ k, 0 < h k) (hwidth : Tendsto h atTop (𝓝 0))
    (hclock : ∀ k, (steps k : ℝ) * dt k = T)
    (hfull : numericalLimitingDomain
        (fun k => leveque04_diffusionPointNumericalDomain X (dt k) (h k) (a k) (steps k)) = univ ∨
      numericalLimitingDomain
        (fun k => leveque04_diffusionCellAverageNumericalDomain X (dt k) (h k) (a k) (steps k)) = univ) :
    Tendsto (fun k => dt k / h k) atTop (𝓝 0) := by
  apply dt_div_dx_tendsto_zero_of_stencilRadius T dt h steps hT hclock
  rcases hfull with hp | hc
  · exact wholeLineLimitingDomain_forces_radius_tendsto_atTop X _ _
      (fun k => leveque04_diffusionPointDomain_subset X (dt k) (h k) (a k) (hh k) (steps k)) hp
  · have hlarge := wholeLineLimitingDomain_forces_radius_tendsto_atTop X _ _
      (fun k => leveque04_diffusionCellDomain_subset X (dt k) (h k) (a k) (hh k) (steps k)) hc
    have hhalf : Tendsto (fun k => h k / 2) atTop (𝓝 0) := by
      simpa using hwidth.div_const 2
    apply Filter.tendsto_atTop.2
    intro b
    filter_upwards [hlarge.eventually (eventually_ge_atTop (b + 1)),
      hhalf.eventually (gt_mem_nhds (by norm_num : (0 : ℝ) < 1))] with k hk hsmall
    linarith

/-- A fixed bounded positive physical conductivity admits an exactly aligned
quadratic family with strictly positive stencil weights. The construction
requires no uniform lower bound and makes no assertion about PDE solutions. -/
theorem leveque04_diffusionRefinement_positiveQuadraticFamily
    (β : ℝ → ℝ) (X T : ℝ) (hβ : ∀ x, 0 < β x)
    (hbounded : ∃ M : ℝ, ∀ x, |β x| ≤ M) (hT : 0 < T) :
    ∃ (dt h : ℕ → ℝ) (steps : ℕ → ℕ) (C : ℝ),
      (∀ k, 0 < dt k) ∧ (∀ k, 0 < h k) ∧
      Tendsto dt atTop (𝓝 0) ∧ Tendsto h atTop (𝓝 0) ∧
      (∀ k, (steps k : ℝ) * dt k = T) ∧ 0 < C ∧
      (∀ k, dt k = C * h k ^ 2) ∧
      (∀ k i, 0 < leveque04_diffusionRefinementExactFaces β X (h k) i) ∧
      (∀ k i, 0 < 1 - dt k / h k ^ 2 *
        (leveque04_diffusionRefinementExactFaces β X (h k) i +
         leveque04_diffusionRefinementExactFaces β X (h k) (i + 1))) := by
  obtain ⟨M, hM⟩ := hbounded
  have hMpos : 0 < M := lt_of_lt_of_le (hβ 0) (le_trans (le_abs_self _) (hM 0))
  obtain ⟨m, hm⟩ := exists_nat_gt (2 * M * T)
  have hmpos : 0 < (m : ℝ) := lt_trans (by positivity) hm
  let h : ℕ → ℝ := fun k => 1 / ((k : ℝ) + 1)
  let C : ℝ := T / (m : ℝ)
  let dt : ℕ → ℝ := fun k => C * h k ^ 2
  let steps : ℕ → ℕ := fun k => m * (k + 1) ^ 2
  have hh : ∀ k, 0 < h k := fun k => one_div_pos.mpr (by positivity)
  have hC : 0 < C := div_pos hT hmpos
  have hdt : ∀ k, 0 < dt k := fun k => mul_pos hC (sq_pos_of_pos (hh k))
  have hwidth : Tendsto h atTop (𝓝 0) := tendsto_one_div_add_atTop_nhds_zero_nat
  have htend : Tendsto dt atTop (𝓝 0) := by
    simpa only [mul_zero, zero_pow (by decide : 2 ≠ 0)] using (hwidth.pow 2).const_mul C
  have hclock : ∀ k, (steps k : ℝ) * dt k = T := by
    intro k
    have hk : (k : ℝ) + 1 ≠ 0 := by positivity
    dsimp [steps, dt, C, h]
    push_cast
    field_simp [hmpos.ne', hk]
  have hratio : ∀ k, dt k / h k ^ 2 = C := by
    intro k
    dsimp [dt]
    exact mul_div_cancel_right₀ C (pow_ne_zero 2 (hh k).ne')
  have hsmall : C * (2 * M) < 1 := by
    have := (div_lt_one hmpos).mpr hm
    dsimp [C]
    convert this using 1
    ring
  refine ⟨dt, h, steps, C, hdt, hh, htend, hwidth, hclock, hC, (fun _ => rfl), ?_, ?_⟩
  · intro k i
    exact hβ _
  · intro k i
    rw [hratio]
    have ha : leveque04_diffusionRefinementExactFaces β X (h k) i ≤ M :=
      le_trans (le_abs_self _) (hM _)
    have hb : leveque04_diffusionRefinementExactFaces β X (h k) (i + 1) ≤ M :=
      le_trans (le_abs_self _) (hM _)
    have hp := mul_le_mul_of_nonneg_left (add_le_add ha hb) hC.le
    linarith

/-- The same constructed family works for both physical initializations. This
is derived proof support; the source target asks for the two families separately. -/
theorem leveque04_diffusionRefinement_exists_both
    (β : ℝ → ℝ) (X T : ℝ) (hβ : ∀ x, 0 < β x)
    (hbounded : ∃ M : ℝ, ∀ x, |β x| ≤ M) (hT : 0 < T) :
    ∃ (dt h : ℕ → ℝ) (steps : ℕ → ℕ),
      (∀ k, 0 < dt k) ∧ (∀ k, 0 < h k) ∧
      Tendsto dt atTop (𝓝 0) ∧ Tendsto h atTop (𝓝 0) ∧
      (∀ k, (steps k : ℝ) * dt k = T) ∧
      (∃ C : ℝ, 0 < C ∧ ∀ᶠ k in atTop, dt k ≤ C * h k ^ 2) ∧
      numericalLimitingDomain (fun k => leveque04_diffusionPointNumericalDomain
        X (dt k) (h k) (leveque04_diffusionRefinementExactFaces β X (h k)) (steps k)) = univ ∧
      numericalLimitingDomain (fun k => leveque04_diffusionCellAverageNumericalDomain
        X (dt k) (h k) (leveque04_diffusionRefinementExactFaces β X (h k)) (steps k)) = univ := by
  obtain ⟨dt, h, steps, C, hdt, hh, htend, hwidth, hclock, hC, heq, ha, hc⟩ :=
    leveque04_diffusionRefinement_positiveQuadraticFamily β X T hβ hbounded hT
  have hbound : ∀ᶠ k in atTop, dt k ≤ C * h k ^ 2 :=
    Eventually.of_forall (fun k => (heq k).le)
  have hg := quadraticRefinement_gridSites_limitingDomain X T C dt h steps hT hdt hh hclock hwidth hbound
  have hmono {A B : ℕ → Set ℝ} (hab : ∀ k, A k ⊆ B k) :
      numericalLimitingDomain A ⊆ numericalLimitingDomain B := by
    intro x hx ε hε
    filter_upwards [hx ε hε] with k hk
    obtain ⟨y, hy, hball⟩ := hk
    exact ⟨y, hab k hy, hball⟩
  have hpoint : ∀ k, (↑(threePointPhysicalGridSites X (h k) (steps k)) : Set ℝ) ⊆
      leveque04_diffusionPointNumericalDomain X (dt k) (h k)
        (leveque04_diffusionRefinementExactFaces β X (h k)) (steps k) := by
    intro k y hy
    obtain ⟨j, hj, rfl⟩ := Finset.mem_image.mp hy
    exact leveque04_diffusion_gridSite_pointEssential X (dt k) (h k) _ (hdt k) (hh k)
      (ha k) (hc k) (steps k) j (Finset.mem_Icc.mp hj)
  have hcell : ∀ k, (↑(threePointPhysicalGridSites X (h k) (steps k)) : Set ℝ) ⊆
      leveque04_diffusionCellAverageNumericalDomain X (dt k) (h k)
        (leveque04_diffusionRefinementExactFaces β X (h k)) (steps k) := by
    intro k y hy
    obtain ⟨j, hj, rfl⟩ := Finset.mem_image.mp hy
    exact leveque04_diffusion_gridSite_cellEssential X (dt k) (h k) _ (hdt k) (hh k)
      (ha k) (hc k) (steps k) j (Finset.mem_Icc.mp hj)
  refine ⟨dt, h, steps, hdt, hh, htend, hwidth, hclock, ⟨C, hC, hbound⟩, ?_, ?_⟩
  · exact Set.eq_univ_of_subset (hmono hpoint) hg
  · exact Set.eq_univ_of_subset (hmono hcell) hg

/-- The exact independently reviewed owner-qualified diffusion refinement target. -/
theorem leveque04_diffusionRefinementPhysical : Leveque04DiffusionRefinementPhysicalTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro β X T dt h steps _hcont _hβ _hbounded hT _hdt hh _htend hwidth hclock hfull
    exact leveque04_diffusionRefinement_necessary X T dt h _ steps hT hh hwidth hclock hfull
  · intro β X T _hcont hβ hbounded hT
    obtain ⟨dt, h, steps, hdt, hh, htend, hwidth, hclock, hbound, hp, _hc⟩ :=
      leveque04_diffusionRefinement_exists_both β X T hβ hbounded hT
    exact ⟨dt, h, steps, hdt, hh, htend, hwidth, hclock, hbound, hp⟩
  · intro β X T _hcont hβ hbounded hT
    obtain ⟨dt, h, steps, hdt, hh, htend, hwidth, hclock, hbound, _hp, hc⟩ :=
      leveque04_diffusionRefinement_exists_both β X T hβ hbounded hT
    exact ⟨dt, h, steps, hdt, hh, htend, hwidth, hclock, hbound, hc⟩

end NumStability
