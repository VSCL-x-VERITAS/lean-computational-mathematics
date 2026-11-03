/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineConvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.CrankNicolsonWholeLineUniqueness

/-!
# Actual coordinate response of the fixed whole-line CN update

Arbitrary real coordinate perturbations stay bounded. Their actual response is
the perturbation amplitude times the solved step kernel, which vanishes exactly
at the observation site. The influence statement covers the full bounded class.
-/

namespace NumStability

theorem isBoundedWholeLineData_cnWholeLinePerturb (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (site : ℤ) (amplitude : ℝ) :
    IsBoundedWholeLineData (cnWholeLinePerturb data site amplitude) := by
  obtain ⟨bound, hnonneg, hbound⟩ := hdata
  refine ⟨bound + |amplitude|, add_nonneg hnonneg (abs_nonneg _), ?_⟩
  intro j
  by_cases hj : j = site
  · subst j
    simp only [cnWholeLinePerturb, Function.update_self]
    have htriangle : |data site + amplitude| ≤ |data site| + |amplitude| := by
      simpa only [Real.norm_eq_abs] using norm_add_le (data site) amplitude
    exact htriangle.trans (add_le_add (hbound site) (le_refl |amplitude|))
  · simp only [cnWholeLinePerturb, Function.update_of_ne hj]
    exact (hbound j).trans (le_add_of_nonneg_right (abs_nonneg _))

theorem cnWholeLineUpdate_perturb (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (observation site : ℤ) (amplitude : ℝ) :
    cnWholeLineUpdate (cnWholeLinePerturb data site amplitude) observation =
      cnWholeLineUpdate data observation + amplitude * cnWholeLineStepKernel (observation - site) := by
  have hperturb := isBoundedWholeLineData_cnWholeLinePerturb data hdata site amplitude
  rw [cnWholeLineUpdate_eq_tsum_stepKernel _ hperturb,
    cnWholeLineUpdate_eq_tsum_stepKernel data hdata]
  have heq :
      (fun j : ℤ => cnWholeLineStepKernel (observation - j) *
        cnWholeLinePerturb data site amplitude j) =
      fun j : ℤ => cnWholeLineStepKernel (observation - j) * data j +
        if j = site then amplitude * cnWholeLineStepKernel (observation - site) else 0 := by
    funext j
    by_cases hj : j = site
    · subst j
      simp [cnWholeLinePerturb]
      ring
    · simp only [cnWholeLinePerturb, Function.update_of_ne hj, if_neg hj, add_zero]
  rw [heq, (summable_cnWholeLineStep_integrand data hdata observation).tsum_add
    (hasSum_ite_eq site (amplitude * cnWholeLineStepKernel (observation - site))).summable,
    tsum_ite_eq]

theorem cnWholeLineUpdate_perturb_ne_iff (data : ℤ → ℝ)
    (hdata : IsBoundedWholeLineData data) (observation site : ℤ) (amplitude : ℝ)
    (hamplitude : amplitude ≠ 0) :
    cnWholeLineUpdate (cnWholeLinePerturb data site amplitude) observation ≠
        cnWholeLineUpdate data observation ↔ observation ≠ site := by
  rw [cnWholeLineUpdate_perturb data hdata observation site amplitude]
  constructor
  · intro hchange heq
    subst observation
    simp only [sub_self, cnWholeLineStepKernel_zero, mul_zero, add_zero, ne_eq, not_true_eq_false]
      at hchange
  · intro hne heq
    have hkernel : cnWholeLineStepKernel (observation - site) ≠ 0 :=
      ne_of_gt (cnWholeLineStepKernel_pos_of_ne_zero _ (sub_ne_zero.mpr hne))
    have hproduct : amplitude * cnWholeLineStepKernel (observation - site) = 0 := by
      linarith
    exact mul_ne_zero hamplitude hkernel hproduct

theorem cnWholeLineCoordinateInfluences_iff (observation site : ℤ) :
    CNWholeLineCoordinateInfluences observation site ↔ observation ≠ site := by
  constructor
  · rintro ⟨first, second, hfirst, _, hagree, hchange⟩ heq
    subst observation
    let amplitude := second site - first site
    have hperturb : cnWholeLinePerturb first site amplitude = second := by
      funext j
      by_cases hj : j = site
      · subst j
        simp only [cnWholeLinePerturb, Function.update_self, amplitude]
        ring
      · simp only [cnWholeLinePerturb, Function.update_of_ne hj]
        exact hagree j hj
    have hresponse := cnWholeLineUpdate_perturb first hfirst site site amplitude
    rw [hperturb] at hresponse
    simp only [sub_self, cnWholeLineStepKernel_zero, mul_zero, add_zero] at hresponse
    exact hchange hresponse.symm
  · intro hne
    let first : ℤ → ℝ := fun _ => 0
    let second := cnWholeLinePerturb first site 1
    have hfirst : IsBoundedWholeLineData first := isBoundedWholeLineData_zero
    refine ⟨first, second, hfirst,
      isBoundedWholeLineData_cnWholeLinePerturb first hfirst site 1, ?_, ?_⟩
    · intro j hj
      simp only [second, cnWholeLinePerturb, Function.update_of_ne hj]
    · exact Ne.symm ((cnWholeLineUpdate_perturb_ne_iff first hfirst observation site 1
        one_ne_zero).mpr hne)

end NumStability
