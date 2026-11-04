/- SPDX-License-Identifier: MIT -/
import ComputationalMathematics.Source.LeVeque.Chapter04.DiffusionRefinementObservations
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PositiveThreePointInfluence
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.EssentialIntervalLocality
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAveragePositivity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ExpandingGridDomains
import Mathlib.Tactic

/-!
# LeVeque Chapter 4: influence of explicit diffusion steps

Positive stencil weights give responses to localized data; locality bounds the numerical dependence domains.
-/

open Set Metric Filter
open scoped Topology
namespace NumStability

/-- The actual conservative flux update, with its spatially varying weights. -/
theorem leveque04_diffusionStep_eq_weighted (dt h : ℝ) (a : ℤ → ℝ) (hh : 0 < h) :
    leveque04_explicitDiffusionStep dt h a =
      weightedThreePointStep (fun i => dt / h ^ 2 * a i)
        (fun i => 1 - dt / h ^ 2 * (a i + a (i + 1)))
        (fun i => dt / h ^ 2 * a (i + 1)) := by
  funext u i
  rw [leveque04_equation11 dt h a u i hh]
  dsimp [weightedThreePointStep]
  ring

theorem leveque04_diffusionIterate_zero (dt h : ℝ) (a : ℤ → ℝ) (hh : 0 < h) (n : ℕ) :
    (leveque04_explicitDiffusionStep dt h a)^[n] (fun _ => 0) = (fun _ => 0) := by
  rw [leveque04_diffusionStep_eq_weighted dt h a hh, ← centeredStencilEvolution_const]
  exact weightedThreePointEvolution_zero _ _ _ n

/-- Strict positive path response of the actual update, without a uniform lower
bound on its face coefficients. -/
theorem leveque04_diffusionIterate_pos
    (dt h : ℝ) (a : ℤ → ℝ) (hdt : 0 < dt) (hh : 0 < h)
    (ha : ∀ i, 0 < a i)
    (hc : ∀ i, 0 < 1 - dt / h ^ 2 * (a i + a (i + 1)))
    (u : ℤ → ℝ) (hu : ∀ i, 0 ≤ u i) (j : ℤ) (hj : 0 < u j)
    (n : ℕ) (hjn : j ∈ Icc (-(n : ℤ)) (n : ℤ)) :
    0 < ((leveque04_explicitDiffusionStep dt h a)^[n] u) 0 := by
  rw [leveque04_diffusionStep_eq_weighted dt h a hh, ← centeredStencilEvolution_const]
  apply weightedThreePointEvolution_pos_of_mem_interval _ _ _
    (fun i => mul_pos (div_pos hdt (sq_pos_of_pos hh)) (ha i)) hc
    (fun i => mul_pos (div_pos hdt (sq_pos_of_pos hh)) (ha (i + 1))) u hu j hj n 0
  simpa using hjn

/-- Bounded continuous, nonnegative localized data, with exact unit value. -/
theorem leveque04_diffusionRefinement_localProfile (x ε : ℝ) (hε : 0 < ε) :
    ∃ f : ℝ → ℝ, leveque04_diffusionRefinementData f ∧
      (∀ y, 0 ≤ f y) ∧ f x = 1 ∧ (∀ y, y ∉ ball x ε → f y = 0) := by
  let bump : ContDiffBump x := ⟨ε / 2, ε, half_pos hε, half_lt_self hε⟩
  refine ⟨bump, ⟨(bump.contDiff (n := 1)).continuous, ⟨1, ?_⟩⟩,
    (fun y => bump.nonneg), ?_, ?_⟩
  · intro y
    rw [abs_of_nonneg bump.nonneg]
    exact bump.le_one
  · exact bump.one_of_mem_closedBall (mem_closedBall_self bump.rIn_pos.le)
  · intro y hy
    apply Function.notMem_support.mp
    simpa only [bump.support_eq, bump] using hy

theorem leveque04_diffusion_gridSite_pointEssential
    (X dt h : ℝ) (a : ℤ → ℝ) (hdt : 0 < dt) (hh : 0 < h)
    (ha : ∀ i, 0 < a i)
    (hc : ∀ i, 0 < 1 - dt / h ^ 2 * (a i + a (i + 1)))
    (n : ℕ) (j : ℤ) (hjn : j ∈ Icc (-(n : ℤ)) (n : ℤ)) :
    leveque04_diffusionRefinementSite X h j ∈
      leveque04_diffusionPointNumericalDomain X dt h a n := by
  intro ε hε
  obtain ⟨f, hf, hnonneg, hone, hout⟩ := leveque04_diffusionRefinement_localProfile
    (leveque04_diffusionRefinementSite X h j) ε hε
  refine ⟨(fun _ => 0), f, ⟨continuous_const, ⟨0, by simp⟩⟩, hf, ?_, ?_⟩
  · intro y hy
    exact (hout y hy).symm
  · have hp := leveque04_diffusionIterate_pos dt h a hdt hh ha hc
      (leveque04_diffusionPointInitial X h f) (fun i => hnonneg _) j
      (by simpa only [leveque04_diffusionPointInitial, hone] using zero_lt_one) n hjn
    have hz : leveque04_diffusionPointInitial X h (fun _ => 0) = (fun _ => 0) := rfl
    simpa only [leveque04_diffusionPointObservation, hz,
      leveque04_diffusionIterate_zero dt h a hh n, Pi.zero_apply] using ne_of_lt hp

theorem leveque04_diffusion_gridSite_cellEssential
    (X dt h : ℝ) (a : ℤ → ℝ) (hdt : 0 < dt) (hh : 0 < h)
    (ha : ∀ i, 0 < a i)
    (hc : ∀ i, 0 < 1 - dt / h ^ 2 * (a i + a (i + 1)))
    (n : ℕ) (j : ℤ) (hjn : j ∈ Icc (-(n : ℤ)) (n : ℤ)) :
    leveque04_diffusionRefinementSite X h j ∈
      leveque04_diffusionCellAverageNumericalDomain X dt h a n := by
  intro ε hε
  obtain ⟨f, hf, hnonneg, hone, hout⟩ := leveque04_diffusionRefinement_localProfile
    (leveque04_diffusionRefinementSite X h j) ε hε
  refine ⟨(fun _ => 0), f, ⟨continuous_const, ⟨0, by simp⟩⟩, hf, ?_, ?_⟩
  · intro y hy
    exact (hout y hy).symm
  · have hn : ∀ i, 0 ≤ leveque04_diffusionCellAverageInitial X h f i := by
      intro i
      apply oneDimensionalCellAverage_nonneg _ _ _ (by linarith)
      exact fun y _ => hnonneg y
    have hj : 0 < leveque04_diffusionCellAverageInitial X h f j := by
      apply oneDimensionalCellAverage_pos_of_continuous_of_pos _ _ _
        (leveque04_diffusionRefinementSite X h j) (by linarith) hf.1.continuousOn
        (fun y _ => hnonneg y) (by constructor <;> linarith)
      rw [hone]; norm_num
    have hp := leveque04_diffusionIterate_pos dt h a hdt hh ha hc
      (leveque04_diffusionCellAverageInitial X h f) hn j hj n hjn
    have hz : leveque04_diffusionCellAverageInitial X h (fun _ => 0) = (fun _ => 0) := by
      funext i
      simp [leveque04_diffusionCellAverageInitial, oneDimensionalCellAverage]
    simpa only [leveque04_diffusionCellAverageObservation, hz,
      leveque04_diffusionIterate_zero dt h a hh n, Pi.zero_apply] using ne_of_lt hp

theorem leveque04_diffusionStep_local (dt h : ℝ) (a : ℤ → ℝ) (hh : 0 < h)
    (u v : ℤ → ℝ) (i : ℤ)
    (heq : ∀ j ∈ Icc (i - (1 : ℤ)) (i + (1 : ℤ)), u j = v j) :
    leveque04_explicitDiffusionStep dt h a u i = leveque04_explicitDiffusionStep dt h a v i := by
  rw [leveque04_equation11 dt h a u i hh, leveque04_equation11 dt h a v i hh,
    heq (i - 1) (by constructor <;> omega), heq i (by constructor <;> omega),
    heq (i + 1) (by constructor <;> omega)]

theorem leveque04_diffusionPointDomain_subset (X dt h : ℝ) (a : ℤ → ℝ)
    (hh : 0 < h) (n : ℕ) :
    leveque04_diffusionPointNumericalDomain X dt h a n ⊆
      Icc (X - (n : ℝ) * h) (X + (n : ℝ) * h) := by
  apply essentialPointOnClass_subset_interval _ _ _ _
  intro f g _ _ heq
  apply iterate_eq_of_centeredStencil_locality _ 1
    (leveque04_diffusionStep_local dt h a hh) _ _ n 0
  intro j hj
  apply heq
  simp only [Nat.cast_one, mul_one, zero_sub, zero_add, mem_Icc] at hj
  have hl : -(n : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj.1
  have hr : (j : ℝ) ≤ (n : ℝ) := by exact_mod_cast hj.2
  change X + (j : ℝ) * h ∈ _
  constructor <;> nlinarith [mul_le_mul_of_nonneg_right hl hh.le,
    mul_le_mul_of_nonneg_right hr hh.le]

theorem leveque04_diffusionCellDomain_subset (X dt h : ℝ) (a : ℤ → ℝ)
    (hh : 0 < h) (n : ℕ) :
    leveque04_diffusionCellAverageNumericalDomain X dt h a n ⊆
      Icc (X - ((n : ℝ) * h + h / 2)) (X + ((n : ℝ) * h + h / 2)) := by
  apply essentialPointOnClass_subset_interval _ _ _ _
  intro f g _ _ heq
  apply iterate_eq_of_centeredStencil_locality _ 1
    (leveque04_diffusionStep_local dt h a hh) _ _ n 0
  intro j hj
  simp only [Nat.cast_one, mul_one, zero_sub, zero_add, mem_Icc] at hj
  have hl : -(n : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj.1
  have hr : (j : ℝ) ≤ (n : ℝ) := by exact_mod_cast hj.2
  unfold leveque04_diffusionCellAverageInitial oneDimensionalCellAverage
  congr 1
  apply intervalIntegral.integral_congr
  intro y hy
  rw [uIcc_of_le (by linarith : leveque04_diffusionRefinementSite X h j - h / 2 ≤
    leveque04_diffusionRefinementSite X h j + h / 2)] at hy
  apply heq
  dsimp [leveque04_diffusionRefinementSite] at hy
  constructor <;> nlinarith [hy.1, hy.2, mul_le_mul_of_nonneg_right hl hh.le,
    mul_le_mul_of_nonneg_right hr hh.le]

end NumStability
