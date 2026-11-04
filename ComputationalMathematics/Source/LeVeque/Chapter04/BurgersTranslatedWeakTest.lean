/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersWeakTest
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersSelectedRegularity

/-!
# Actual translated Burgers fields against global compact C1 tests

Spatial translation preserves the genuine pair weak identity and its analytic
integrability. Tests can be nonzero on the initial time face.
-/

noncomputable section
open Set MeasureTheory Filter

namespace NumStability

/-- Indication on the forward halfspace preserves compact support of an
ordinary global compact test. No condition on its value at time zero is used. -/
theorem globalTest_forward_hasCompactSupport
    (test : ℝ × ℝ → ℝ) (hsupport : HasCompactSupport test) :
    HasCompactSupport (forwardSpacetimeHalfspace.indicator test) := by
  classical
  apply HasCompactSupport.of_support_subset_isCompact hsupport
  intro z hz
  apply subset_tsupport test
  by_contra hzero
  have hzero' : test z = 0 := not_not.mp hzero
  exact hz (by simp [hzero'])

/-- Derivatives vanish outside the actual test support, including above a
specified open time slab. This is derived from support, not a weak-law premise. -/
theorem globalTest_fderiv_zero_above_slab
    (test : ℝ × ℝ → ℝ) (horizon : ℝ)
    (hslab : tsupport test ⊆ {z : ℝ × ℝ | z.2 < horizon})
    (z : ℝ × ℝ) (hz : horizon ≤ z.2) (v : ℝ × ℝ) :
    fderiv ℝ test z v = 0 := by
  have hout : z ∉ tsupport test := fun h => (not_lt_of_ge hz) (hslab h)
  rw [fderiv_of_notMem_tsupport ℝ hout]
  rfl

/-- Analytic integrability and the actual weak identity for every translated
selected pair, tested by every ordinary global compact C1 function. -/
theorem leveque04_burgersTranslatedField_weakTest_spacetime
    (left right center : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiff ℝ 1 test) (hsupport : HasCompactSupport test) :
    Integrable (fun z : ℝ × ℝ =>
      leveque04_burgersSelectedField left right (z.1 - center) z.2 *
          forwardTestDerivative test (0, 1) z +
        (leveque04_burgersSelectedField left right (z.1 - center) z.2 ^ 2 / 2) *
          forwardTestDerivative test (1, 0) z) ∧
    Integrable (fun x => riemannData left right right (x - center) * test (x, 0)) ∧
    (∫ z : ℝ × ℝ,
      leveque04_burgersSelectedField left right (z.1 - center) z.2 *
          forwardTestDerivative test (0, 1) z +
        (leveque04_burgersSelectedField left right (z.1 - center) z.2 ^ 2 / 2) *
          forwardTestDerivative test (1, 0) z) +
      (∫ x, riemannData left right right (x - center) * test (x, 0)) = 0 := by
  let q : ℝ × ℝ → ℝ := fun z => leveque04_burgersSelectedField left right (z.1 - center) z.2
  let bound := max |left| |right|
  have hq : Measurable q :=
    (leveque04_burgersSelectedField_measurable left right).comp
      ((measurable_fst.sub_const center).prodMk measurable_snd)
  have hbound (z : ℝ × ℝ) : |q z| ≤ bound :=
    leveque04_burgersSelectedField_abs_le_max left right (z.1 - center) z.2
  have hfluxbound (z : ℝ × ℝ) : |q z ^ 2 / 2| ≤ bound ^ 2 / 2 := by
    rw [abs_of_nonneg (div_nonneg (sq_nonneg _) (by norm_num))]
    have hu := abs_le.mp (hbound z)
    have hp := mul_nonneg (show 0 ≤ bound + q z by linarith)
      (show 0 ≤ bound - q z by linarith)
    nlinarith
  have hs := globalTest_forward_hasCompactSupport test hsupport
  have hint : Integrable (fun z : ℝ × ℝ => q z * forwardTestDerivative test (0, 1) z +
      (q z ^ 2 / 2) * forwardTestDerivative test (1, 0) z) :=
    (forwardTestDerivative_mul_integrable q hq bound hbound test htest.contDiffOn hs (0, 1)).add
      (forwardTestDerivative_mul_integrable (fun z => q z ^ 2 / 2)
        ((hq.pow_const 2).div_const 2) (bound ^ 2 / 2) hfluxbound
        test htest.contDiffOn hs (1, 0))
  have hprofile : Measurable (fun x => riemannData left right right (x - center)) := by
    simpa only [Function.comp_def, q, id_eq, leveque04_burgersSelectedField_initial] using
      hq.comp (measurable_id.prodMk (measurable_const : Measurable (fun _ : ℝ => (0 : ℝ))))
  have hinitial : Integrable (fun x => riemannData left right right (x - center) * test (x, 0)) :=
    travelingWave_weakTest_initial_integrable _ hprofile bound
      (fun x => by simpa only [q, leveque04_burgersSelectedField_initial] using hbound (x, 0))
      test htest.continuous hsupport
  refine ⟨hint, hinitial, ?_⟩
  let shifted : ℝ × ℝ → ℝ := fun z => test (z + (center, 0))
  have hshifted : ContDiff ℝ 1 shifted := htest.comp (contDiff_id.add contDiff_const)
  have hshiftSupport : HasCompactSupport shifted :=
    hsupport.comp_homeomorph (Homeomorph.addRight (center, (0 : ℝ)))
  have hderiv (x t : ℝ) (v : ℝ × ℝ) :
      fderiv ℝ shifted (x, t) v = fderiv ℝ test (x + center, t) v := by
    simpa only [shifted, Prod.mk_add_mk, add_zero] using
      congrArg (fun f : (ℝ × ℝ) →L[ℝ] ℝ => f v)
        (fderiv_comp_add_right (𝕜 := ℝ) (f := test) (x := (x, t)) (center, 0))
  have hpair := leveque04_burgersSelectedField_weakTest left right shifted hshifted.contDiffOn
    (globalTest_forward_hasCompactSupport shifted hshiftSupport)
  have htranslate (t : ℝ) :
      (∫ x, q (x, t) * fderiv ℝ test (x, t) (0, 1) +
        (q (x, t) ^ 2 / 2) * fderiv ℝ test (x, t) (1, 0)) =
      ∫ x, leveque04_burgersSelectedField left right x t * fderiv ℝ shifted (x, t) (0, 1) +
        (leveque04_burgersSelectedField left right x t ^ 2 / 2) *
          fderiv ℝ shifted (x, t) (1, 0) := by
    calc
      _ = ∫ x, q (x + center, t) * fderiv ℝ test (x + center, t) (0, 1) +
          (q (x + center, t) ^ 2 / 2) * fderiv ℝ test (x + center, t) (1, 0) :=
        (integral_add_right_eq_self (fun x => q (x, t) * fderiv ℝ test (x, t) (0, 1) +
          (q (x, t) ^ 2 / 2) * fderiv ℝ test (x, t) (1, 0)) center).symm
      _ = _ := by simp only [q, add_sub_cancel_right, hderiv]
  have htranslateInitial :
      (∫ x, riemannData left right right (x - center) * test (x, 0)) =
        ∫ x, riemannData left right right x * shifted (x, 0) := by
    simpa only [shifted, Prod.mk_add_mk, add_zero, add_sub_cancel_right] using
      (integral_add_right_eq_self
        (fun x => riemannData left right right (x - center) * test (x, 0)) center).symm
  rw [forwardTestDerivative_spacetimeIntegral_pair q (fun z => q z ^ 2 / 2) test hint]
  simp_rw [htranslate]
  rw [htranslateInitial]
  exact hpair

end NumStability
