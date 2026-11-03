/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineKernel

/-!
# Whole-line Crank–Nicolson convolutions on bounded data

Translation and reflection preserve the actual kernel sums. Absolute comparison
then gives the convolution sums and uniform bounds for every bounded integer
array. The specified update is identified with its solved step-kernel sum;
no inverse or uniqueness property is assumed here.
-/

namespace NumStability

private def cnWholeLineReflection (observation : ℤ) : ℤ ≃ ℤ where
  toFun := fun site => observation - site
  invFun := fun site => observation - site
  left_inv := by intro site; simp
  right_inv := by intro site; simp

theorem summable_cnWholeLineResolventKernel_translate (observation : ℤ) :
    Summable (fun site : ℤ => cnWholeLineResolventKernel (observation - site)) :=
  ((cnWholeLineReflection observation).summable_iff (f := cnWholeLineResolventKernel)).mpr
    summable_cnWholeLineResolventKernel

theorem summable_abs_cnWholeLineResolventKernel_translate (observation : ℤ) :
    Summable (fun site : ℤ => |cnWholeLineResolventKernel (observation - site)|) :=
  ((cnWholeLineReflection observation).summable_iff
    (f := fun offset => |cnWholeLineResolventKernel offset|)).mpr
      summable_abs_cnWholeLineResolventKernel

theorem summable_cnWholeLineStepKernel_translate (observation : ℤ) :
    Summable (fun site : ℤ => cnWholeLineStepKernel (observation - site)) :=
  ((cnWholeLineReflection observation).summable_iff (f := cnWholeLineStepKernel)).mpr
    summable_cnWholeLineStepKernel

theorem summable_abs_cnWholeLineStepKernel_translate (observation : ℤ) :
    Summable (fun site : ℤ => |cnWholeLineStepKernel (observation - site)|) :=
  ((cnWholeLineReflection observation).summable_iff
    (f := fun offset => |cnWholeLineStepKernel offset|)).mpr summable_abs_cnWholeLineStepKernel

theorem tsum_abs_cnWholeLineResolventKernel_translate (observation : ℤ) :
    (∑' site : ℤ, |cnWholeLineResolventKernel (observation - site)|) =
      ∑' offset : ℤ, |cnWholeLineResolventKernel offset| :=
  (cnWholeLineReflection observation).tsum_eq (fun offset => |cnWholeLineResolventKernel offset|)

private theorem summable_abs_kernel_mul_bounded (kernel data : ℤ → ℝ)
    (hkernel : Summable (fun site => |kernel site|))
    (hdata : IsBoundedWholeLineData data) :
    Summable (fun site => |kernel site * data site|) := by
  obtain ⟨bound, _, hbound⟩ := hdata
  apply (hkernel.mul_right bound).of_norm_bounded
  intro site
  rw [Real.norm_eq_abs, abs_abs, abs_mul]
  exact mul_le_mul_of_nonneg_left (hbound site) (abs_nonneg _)

theorem summable_abs_cnWholeLineResolvent_integrand (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (observation : ℤ) :
    Summable (fun site : ℤ =>
      |cnWholeLineResolventKernel (observation - site) * data site|) :=
  summable_abs_kernel_mul_bounded _ data
    (summable_abs_cnWholeLineResolventKernel_translate observation) hdata

theorem summable_cnWholeLineResolvent_integrand (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (observation : ℤ) :
    Summable (fun site : ℤ =>
      cnWholeLineResolventKernel (observation - site) * data site) := by
  apply Summable.of_norm
  simpa only [Real.norm_eq_abs] using
    summable_abs_cnWholeLineResolvent_integrand data hdata observation

theorem summable_abs_cnWholeLineStep_integrand (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (observation : ℤ) :
    Summable (fun site : ℤ => |cnWholeLineStepKernel (observation - site) * data site|) :=
  summable_abs_kernel_mul_bounded _ data
    (summable_abs_cnWholeLineStepKernel_translate observation) hdata

theorem summable_cnWholeLineStep_integrand (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (observation : ℤ) :
    Summable (fun site : ℤ => cnWholeLineStepKernel (observation - site) * data site) := by
  apply Summable.of_norm
  simpa only [Real.norm_eq_abs] using
    summable_abs_cnWholeLineStep_integrand data hdata observation

/-- The same finite kernel mass controls every observation. Its exact value
is unnecessary for bounded solvability. -/
theorem abs_cnWholeLineResolvent_le (data : ℤ → ℝ) (bound : ℝ)
    (hbound : ∀ site : ℤ, |data site| ≤ bound) (observation : ℤ) :
    |cnWholeLineResolvent data observation| ≤
      (∑' offset : ℤ, |cnWholeLineResolventKernel offset|) * bound := by
  have hmajorant := (summable_abs_cnWholeLineResolventKernel_translate observation).mul_right bound
  have h := tsum_of_norm_bounded hmajorant.hasSum (fun site =>
    show ‖cnWholeLineResolventKernel (observation - site) * data site‖ ≤
      |cnWholeLineResolventKernel (observation - site)| * bound by
      rw [Real.norm_eq_abs, abs_mul]
      exact mul_le_mul_of_nonneg_left (hbound site) (abs_nonneg _))
  rw [tsum_mul_right, tsum_abs_cnWholeLineResolventKernel_translate] at h
  exact h

theorem isBoundedWholeLineData_cnWholeLineResolvent (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) :
    IsBoundedWholeLineData (cnWholeLineResolvent data) := by
  obtain ⟨bound, hnonneg, hbound⟩ := hdata
  refine ⟨(∑' offset : ℤ, |cnWholeLineResolventKernel offset|) * bound,
    mul_nonneg (tsum_nonneg (fun _ => abs_nonneg _)) hnonneg, ?_⟩
  exact abs_cnWholeLineResolvent_le data bound hbound

theorem abs_cnWholeLineUpdate_le (data : ℤ → ℝ) (bound : ℝ)
    (hbound : ∀ site : ℤ, |data site| ≤ bound) (observation : ℤ) :
    |cnWholeLineUpdate data observation| ≤
      (2 * (∑' offset : ℤ, |cnWholeLineResolventKernel offset|) + 1) * bound := by
  calc
    |cnWholeLineUpdate data observation| ≤
        |2 * cnWholeLineResolvent data observation| + |data observation| :=
      abs_sub _ _
    _ = 2 * |cnWholeLineResolvent data observation| + |data observation| := by
      rw [abs_mul]; norm_num
    _ ≤ 2 * ((∑' offset : ℤ, |cnWholeLineResolventKernel offset|) * bound) + bound :=
      add_le_add (mul_le_mul_of_nonneg_left
        (abs_cnWholeLineResolvent_le data bound hbound observation) (by norm_num))
        (hbound observation)
    _ = _ := by ring

theorem isBoundedWholeLineData_cnWholeLineUpdate (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) :
    IsBoundedWholeLineData (cnWholeLineUpdate data) := by
  obtain ⟨bound, hnonneg, hbound⟩ := hdata
  refine ⟨(2 * (∑' offset : ℤ, |cnWholeLineResolventKernel offset|) + 1) * bound,
    mul_nonneg (add_nonneg (mul_nonneg (by norm_num)
      (tsum_nonneg (fun _ => abs_nonneg _))) zero_le_one) hnonneg, ?_⟩
  exact abs_cnWholeLineUpdate_le data bound hbound

/-- The actual `2R f - f` definition agrees with convolution by the actual
step kernel, with both infinite sums justified on the full bounded class. -/
theorem cnWholeLineUpdate_eq_tsum_stepKernel (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (observation : ℤ) :
    cnWholeLineUpdate data observation =
      ∑' site : ℤ, cnWholeLineStepKernel (observation - site) * data site := by
  have hpoint : (fun site : ℤ => cnWholeLineStepKernel (observation - site) * data site) =
      fun site : ℤ => 2 * (cnWholeLineResolventKernel (observation - site) * data site) -
        (if site = observation then data observation else 0) := by
    funext site
    by_cases hsite : site = observation
    · subst site
      simp [cnWholeLineStepKernel]
    · have hoffset : observation - site ≠ 0 := sub_ne_zero.mpr (Ne.symm hsite)
      simp only [cnWholeLineStepKernel, if_neg hoffset, if_neg hsite, sub_zero]
      ring
  rw [hpoint, ((summable_cnWholeLineResolvent_integrand data hdata observation).mul_left
    (2 : ℝ)).tsum_sub (hasSum_ite_eq observation (data observation)).summable,
    tsum_mul_left, tsum_ite_eq]
  rfl

end NumStability
