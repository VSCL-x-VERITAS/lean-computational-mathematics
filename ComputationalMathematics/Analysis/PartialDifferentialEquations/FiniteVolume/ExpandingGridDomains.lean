/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointPhysicalDomain
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity

/-!
# Expanding physical grid windows

At a fixed physical time, `dt / dx → 0` makes a radius-one stencil window
expand without bound. Vanishing grid spacing also makes its actual lattice
sites meet every neighborhood eventually. These are geometric support facts;
they do not assert essential influence for an arbitrary numerical operator,
stability, or convergence to a PDE solution.
-/

open Set Filter Metric
open scoped Topology

namespace NumStability

/-- A quadratic upper bound for positive time steps implies `dt / dx → 0`.
The bound is needed only eventually, not on discarded coarse meshes. -/
theorem dt_div_dx_tendsto_zero_of_quadratic_bound
    (dt width : ℕ → ℝ) (C : ℝ)
    (hdt : ∀ n, 0 < dt n) (hw : ∀ n, 0 < width n)
    (hwidth : Tendsto width atTop (𝓝 0))
    (hbound : ∀ᶠ n in atTop, dt n ≤ C * width n ^ 2) :
    Tendsto (fun n => dt n / width n) atTop (𝓝 0) := by
  have hupper : ∀ᶠ n in atTop, dt n / width n ≤ C * width n := by
    filter_upwards [hbound] with n hn
    apply (div_le_iff₀ (hw n)).mpr
    nlinarith
  apply squeeze_zero' (Eventually.of_forall (fun n => (div_pos (hdt n) (hw n)).le)) hupper
  simpa using hwidth.const_mul C

/-- Exact observation at a positive fixed time converts a vanishing time/space
ratio into an unbounded physical stencil radius. -/
theorem stencilRadius_tendsto_atTop_of_dt_div_dx
    (T : ℝ) (dt width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hT : 0 < T) (hdt : ∀ n, 0 < dt n) (hw : ∀ n, 0 < width n)
    (hclock : ∀ n, (steps n : ℝ) * dt n = T)
    (hratio : Tendsto (fun n => dt n / width n) atTop (𝓝 0)) :
    Tendsto (fun n => (steps n : ℝ) * width n) atTop atTop := by
  have hpositive : Tendsto (fun n => dt n / width n) atTop (𝓝[>] 0) :=
    tendsto_nhdsWithin_iff.mpr
      ⟨hratio, Eventually.of_forall (fun n => div_pos (hdt n) (hw n))⟩
  have hinverse := hpositive.inv_tendsto_nhdsGT_zero.atTop_mul_const hT
  have heq (n : ℕ) : (dt n / width n)⁻¹ * T = (steps n : ℝ) * width n := by
    rw [inv_div, div_mul_eq_mul_div]
    apply (div_eq_iff (hdt n).ne').mpr
    rw [← hclock n]
    ring
  change Tendsto (fun n => (dt n / width n)⁻¹ * T) atTop atTop at hinverse
  simpa only [heq] using hinverse

/-- Every fixed point eventually belongs to an interval whose radius tends to infinity. -/
theorem eventually_mem_expandingGridEnvelope
    (X x : ℝ) (radius : ℕ → ℝ) (hradius : Tendsto radius atTop atTop) :
    ∀ᶠ n in atTop, x ∈ Icc (X - radius n) (X + radius n) := by
  filter_upwards [hradius.eventually (eventually_ge_atTop |x - X|)] with n hn
  constructor <;> linarith [neg_abs_le (x - X), le_abs_self (x - X)]

/-- Whole-line limiting dependence forces any containing centered envelope to
grow without bound. This applies to an actual method's influence set as well as
to a structural support set, provided the displayed containment is proved. -/
theorem wholeLineLimitingDomain_forces_radius_tendsto_atTop
    (X : ℝ) (radius : ℕ → ℝ) (domains : ℕ → Set ℝ)
    (hcontained : ∀ n, domains n ⊆ Icc (X - radius n) (X + radius n))
    (hfull : numericalLimitingDomain domains = univ) :
    Tendsto radius atTop atTop := by
  apply Filter.tendsto_atTop.2
  intro b
  have hx : X + b + 1 ∈ numericalLimitingDomain domains := by
    rw [hfull]
    trivial
  filter_upwards [hx (1 / 2) (by norm_num)] with n hn
  obtain ⟨y, hy, hnear⟩ := hn
  have hupper := (hcontained n hy).2
  rw [mem_ball, Real.dist_eq] at hnear
  have hlower := (abs_lt.mp hnear).1
  linarith

/-- With an exact positive observation time, an unbounded radius forces the
time step to vanish relative to the spatial spacing. -/
theorem dt_div_dx_tendsto_zero_of_stencilRadius
    (T : ℝ) (dt width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hT : 0 < T)
    (hclock : ∀ n, (steps n : ℝ) * dt n = T)
    (hradius : Tendsto (fun n => (steps n : ℝ) * width n) atTop atTop) :
    Tendsto (fun n => dt n / width n) atTop (𝓝 0) := by
  have heq (n : ℕ) : T / ((steps n : ℝ) * width n) = dt n / width n := by
    have hs : (steps n : ℝ) ≠ 0 := by
      intro hz
      have ht := hclock n
      rw [hz, zero_mul] at ht
      linarith
    rw [← hclock n]
    field_simp
  simpa only [heq] using
    (tendsto_const_nhds.div_atTop hradius :
      Tendsto (fun n => T / ((steps n : ℝ) * width n)) atTop (𝓝 0))

/-- Actual grid sites, rather than merely their interval hull, eventually meet
each neighborhood when the spacing vanishes and the window radius diverges. -/
theorem expandingGridSites_eventually_meet_ball
    (X x ε : ℝ) (width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hε : 0 < ε) (hw : ∀ n, 0 < width n)
    (hwidth : Tendsto width atTop (𝓝 0))
    (hradius : Tendsto (fun n => (steps n : ℝ) * width n) atTop atTop) :
    ∀ᶠ n in atTop, ∃ y ∈ threePointPhysicalGridSites X (width n) (steps n),
      y ∈ ball x ε := by
  classical
  have hsmall : ∀ᶠ n in atTop, width n < min ε 1 :=
    hwidth.eventually (gt_mem_nhds (lt_min hε zero_lt_one))
  filter_upwards [hsmall, hradius.eventually (eventually_ge_atTop (|x - X| + 1))]
    with n hn hlarge
  let j : ℤ := ⌊(x - X) / width n⌋
  have hleft : (j : ℝ) * width n ≤ x - X :=
    (le_div_iff₀ (hw n)).mp (Int.floor_le _)
  have hright : x - X < ((j : ℝ) + 1) * width n :=
    (div_lt_iff₀ (hw n)).mp (Int.lt_floor_add_one _)
  have hjlower : -(steps n : ℝ) ≤ (j : ℝ) := by
    by_contra! hbad
    have hmul := mul_lt_mul_of_pos_right hbad (hw n)
    nlinarith [neg_abs_le (x - X), (lt_min_iff.mp hn).2]
  have hjupper : (j : ℝ) ≤ (steps n : ℝ) := by
    by_contra! hbad
    have hmul := mul_lt_mul_of_pos_right hbad (hw n)
    nlinarith [le_abs_self (x - X)]
  have hj : j ∈ Finset.Icc (-(steps n : ℤ)) (steps n : ℤ) := by
    apply Finset.mem_Icc.mpr
    constructor
    · exact_mod_cast hjlower
    · exact_mod_cast hjupper
  refine ⟨X + (j : ℝ) * width n, ?_, ?_⟩
  · exact Finset.mem_image.mpr ⟨j, hj, rfl⟩
  · rw [mem_ball, Real.dist_eq]
    have heq : X + (j : ℝ) * width n - x = -((x - X) - (j : ℝ) * width n) := by ring
    rw [heq, abs_neg, abs_of_nonneg (by linarith)]
    nlinarith [(lt_min_iff.mp hn).1]

/-- The eventual neighborhood limit of expanding, increasingly fine grid sites
is the whole real line. This does not identify it with functional influence. -/
theorem expandingGridSites_numericalLimitingDomain
    (X : ℝ) (width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hw : ∀ n, 0 < width n) (hwidth : Tendsto width atTop (𝓝 0))
    (hradius : Tendsto (fun n => (steps n : ℝ) * width n) atTop atTop) :
    numericalLimitingDomain
      (fun n => (↑(threePointPhysicalGridSites X (width n) (steps n)) : Set ℝ)) = univ := by
  apply Set.eq_univ_of_forall
  intro x ε hε
  exact expandingGridSites_eventually_meet_ball X x ε width steps hε hw hwidth hradius

/-- A quadratic time-step bound gives whole-line limiting geometric coverage
at any positive fixed horizon. Actual operator influence remains a separate question. -/
theorem quadraticRefinement_gridSites_limitingDomain
    (X T C : ℝ) (dt width : ℕ → ℝ) (steps : ℕ → ℕ)
    (hT : 0 < T) (hdt : ∀ n, 0 < dt n) (hw : ∀ n, 0 < width n)
    (hclock : ∀ n, (steps n : ℝ) * dt n = T)
    (hwidth : Tendsto width atTop (𝓝 0))
    (hbound : ∀ᶠ n in atTop, dt n ≤ C * width n ^ 2) :
    numericalLimitingDomain
      (fun n => (↑(threePointPhysicalGridSites X (width n) (steps n)) : Set ℝ)) = univ := by
  apply expandingGridSites_numericalLimitingDomain X width steps hw hwidth
  exact stencilRadius_tendsto_atTop_of_dt_div_dx T dt width steps hT hdt hw hclock
    (dt_div_dx_tendsto_zero_of_quadratic_bound dt width C hdt hw hwidth hbound)

end NumStability
