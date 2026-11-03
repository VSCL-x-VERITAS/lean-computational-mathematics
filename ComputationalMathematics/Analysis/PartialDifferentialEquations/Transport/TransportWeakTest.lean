/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.FDeriv.Const
import Mathlib.MeasureTheory.Function.LocallyIntegrable
import Mathlib.MeasureTheory.Group.Integral
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.Topology.Algebra.Support
import Mathlib.Tactic.FunProp

/-!
# Compact C¹ tests for constant-speed transport

Bounded measurable profiles, translated at an arbitrary real speed, satisfy the
forward weak transport identity on the whole spatial line. Test functions are
globally `ContDiff ℝ 1` on `ℝ × ℝ`, with coordinates `(space, time)`, and have
compact support. Their values on the initial face are unrestricted.

The derivative convention is the Fréchet derivative evaluated at `(0, 1)` for
the time derivative and at `(1, 0)` for the spatial derivative. The auxiliary
directional formulation evaluates it at `(speed, 1)`.

These statements use global C¹ representatives. Extending tests specified only
as C¹ on the closed forward halfspace is a separate extension problem.
-/

noncomputable section

open Set MeasureTheory

namespace NumStability

private def transportCharacteristicCoordinates (speed : ℝ) :
    (ℝ × ℝ) ≃ₜ (ℝ × ℝ) where
  toEquiv :=
    { toFun := fun z => (z.2 + speed * z.1, z.1)
      invFun := fun z => (z.2, z.1 - speed * z.2)
      left_inv := by intro z; ext <;> simp
      right_inv := by intro z; ext <;> simp }
  continuous_toFun := by fun_prop
  continuous_invFun := by fun_prop

private theorem transport_integrable_bounded_mul_compact
    (q g : ℝ × ℝ → ℝ) (hq : Measurable q) (B : ℝ)
    (hbound : ∀ z, |q z| ≤ B) (hg : Continuous g)
    (hsupport : HasCompactSupport g) :
    Integrable (fun z => q z * g z) := by
  refine ((hg.integrable_of_hasCompactSupport hsupport).norm.const_mul B).mono'
    (hq.mul hg.measurable).aestronglyMeasurable ?_
  filter_upwards [] with z
  simpa only [Real.norm_eq_abs, abs_mul] using
    mul_le_mul_of_nonneg_right (hbound z) (abs_nonneg (g z))

private theorem transport_test_direction_continuous
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test) (v : ℝ × ℝ) :
    Continuous (fun z => fderiv ℝ test z v) := by
  exact (htest.continuous_fderiv_apply one_ne_zero).comp
    (continuous_id.prodMk continuous_const)

private theorem transport_test_curve_hasDerivAt
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (speed y t : ℝ) :
    HasDerivAt (fun τ => test (y + speed * τ, τ))
      (fderiv ℝ test (y + speed * t, t) (speed, 1)) t := by
  have hcurve : HasDerivAt (fun τ : ℝ => (y + speed * τ, τ)) (speed, 1) t := by
    simpa only [mul_one] using
      (((hasDerivAt_id t).const_mul speed).const_add y).prodMk (hasDerivAt_id t)
  exact HasFDerivAt.comp_hasDerivAt (f := fun τ : ℝ => (y + speed * τ, τ)) t
    (htest.differentiable one_ne_zero (y + speed * t, t)).hasFDerivAt hcurve

private theorem transport_test_curve_hasCompactSupport
    (test : ℝ × ℝ → ℝ) (hsupport : HasCompactSupport test) (speed y : ℝ) :
    HasCompactSupport (fun t => test (y + speed * t, t)) := by
  refine HasCompactSupport.of_support_subset_isCompact
    (hsupport.image continuous_snd) ?_
  intro t ht
  exact ⟨(y + speed * t, t), subset_tsupport test ht, rfl⟩

private theorem transport_test_curve_integral
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test) (speed y : ℝ) :
    (∫ t in Ioi (0 : ℝ), fderiv ℝ test (y + speed * t, t) (speed, 1)) =
      -test (y, 0) := by
  have hcurve : ContDiff ℝ 1 (fun t : ℝ => test (y + speed * t, t)) :=
    htest.comp (by fun_prop)
  have hderiv : (fun t => fderiv ℝ test (y + speed * t, t) (speed, 1)) =
      deriv (fun t : ℝ => test (y + speed * t, t)) := by
    funext t
    exact (transport_test_curve_hasDerivAt test htest speed y t).deriv.symm
  rw [hderiv]
  simpa using HasCompactSupport.integral_Ioi_deriv_eq hcurve
    (transport_test_curve_hasCompactSupport test hsupport speed y) 0

/-- The weak transport integrand is integrable on the entire spacetime plane.
In particular the forward spacetime integral in the weak identity is a genuine
integral of an integrable function. Coordinates here are `(space, time)`. -/
theorem travelingWave_weakTest_integrable
    (profile : ℝ → ℝ) (speed : ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test) :
    Integrable (fun z : ℝ × ℝ =>
      travelingWave profile speed z.1 z.2 * fderiv ℝ test z (speed, 1)) := by
  exact transport_integrable_bounded_mul_compact
    (fun z => profile (z.1 - speed * z.2))
    (fun z => fderiv ℝ test z (speed, 1))
    (hprofile.comp (by fun_prop)) B (fun z => hbound (z.1 - speed * z.2))
    (transport_test_direction_continuous test htest (speed, 1))
    (hsupport.fderiv_apply ℝ (speed, 1))

/-- The initial boundary term in the weak transport identity is integrable. -/
theorem travelingWave_weakTest_initial_integrable
    (profile : ℝ → ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ) (htest : Continuous test)
    (hsupport : HasCompactSupport test) :
    Integrable (fun x => profile x * test (x, 0)) := by
  have hslice : Continuous (fun x : ℝ => test (x, 0)) :=
    htest.comp (continuous_id.prodMk continuous_const)
  have hsliceSupport : HasCompactSupport (fun x : ℝ => test (x, 0)) := by
    refine HasCompactSupport.of_support_subset_isCompact
      (hsupport.image continuous_fst) ?_
    intro x hx
    exact ⟨(x, 0), subset_tsupport test hx, rfl⟩
  refine ((hslice.integrable_of_hasCompactSupport hsliceSupport).norm.const_mul B).mono'
    (hprofile.mul hslice.measurable).aestronglyMeasurable ?_
  filter_upwards [] with x
  simpa only [Real.norm_eq_abs, abs_mul] using
    mul_le_mul_of_nonneg_right (hbound x) (abs_nonneg (test (x, 0)))

/-- A bounded measurable transported profile satisfies the forward weak
transport identity, expressed as the derivative of the test along a
characteristic. Space is the whole real line and the initial boundary is kept. -/
theorem travelingWave_forward_weakTest_directional
    (profile : ℝ → ℝ) (speed : ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test) :
    (∫ t in Ici (0 : ℝ), ∫ x,
      travelingWave profile speed x t * fderiv ℝ test (x, t) (speed, 1)) +
      (∫ x, profile x * test (x, 0)) = 0 := by
  have hD := transport_test_direction_continuous test htest (speed, 1)
  have hDs : HasCompactSupport (fun z => fderiv ℝ test z (speed, 1)) :=
    hsupport.fderiv_apply ℝ (speed, 1)
  have hfull : Integrable (fun z : ℝ × ℝ =>
      profile z.2 * fderiv ℝ test (z.2 + speed * z.1, z.1) (speed, 1)) := by
    exact transport_integrable_bounded_mul_compact
      (fun z => profile z.2)
      (fun z => fderiv ℝ test (z.2 + speed * z.1, z.1) (speed, 1))
      (hprofile.comp measurable_snd) B (fun z => hbound z.2)
      (hD.comp (transportCharacteristicCoordinates speed).continuous)
      (hDs.comp_homeomorph (transportCharacteristicCoordinates speed))
  have hprod : Integrable (Function.uncurry (fun t y : ℝ =>
      profile y * fderiv ℝ test (y + speed * t, t) (speed, 1)))
      ((volume.restrict (Ioi (0 : ℝ))).prod volume) := by
    rw [Measure.restrict_prod_eq_prod_univ]
    exact hfull.integrableOn
  have htranslate (t : ℝ) :
      (∫ x, travelingWave profile speed x t * fderiv ℝ test (x, t) (speed, 1)) =
        ∫ y, profile y * fderiv ℝ test (y + speed * t, t) (speed, 1) := by
    simpa only [travelingWave, add_sub_cancel_right] using
      (integral_add_right_eq_self
        (fun x => profile (x - speed * t) * fderiv ℝ test (x, t) (speed, 1))
        (speed * t)).symm
  have hforward :
      (∫ t in Ioi (0 : ℝ), ∫ x,
        travelingWave profile speed x t * fderiv ℝ test (x, t) (speed, 1)) =
        -(∫ x, profile x * test (x, 0)) := by
    simp_rw [htranslate]
    rw [integral_integral_swap hprod]
    simp_rw [integral_const_mul,
      transport_test_curve_integral test htest hsupport speed, mul_neg]
    exact integral_neg _
  rw [integral_Ici_eq_integral_Ioi, hforward]
  exact neg_add_cancel _

/-- The test derivative along a characteristic is its time derivative plus
the speed times its spatial derivative. This is an identity of linear maps
and requires no extra smoothness assumption. -/
theorem transport_test_direction_eq
    (test : ℝ × ℝ → ℝ) (speed x t : ℝ) :
    fderiv ℝ test (x, t) (speed, 1) =
      fderiv ℝ test (x, t) (0, 1) +
        speed * fderiv ℝ test (x, t) (1, 0) := by
  have hv : (speed, (1 : ℝ)) = (0, 1) + speed • ((1 : ℝ), 0) := by
    ext <;> simp
  rw [hv, map_add, map_smul]
  rfl

/-- The usual forward weak transport identity for every compactly supported
global C¹ spacetime test, with both the whole spatial line and initial term. -/
theorem travelingWave_forward_weakTest
    (profile : ℝ → ℝ) (speed : ℝ) (hprofile : Measurable profile)
    (B : ℝ) (hbound : ∀ x, |profile x| ≤ B)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test)
    (hsupport : HasCompactSupport test) :
    (∫ t in Ici (0 : ℝ), ∫ x,
      travelingWave profile speed x t *
        (fderiv ℝ test (x, t) (0, 1) + speed * fderiv ℝ test (x, t) (1, 0))) +
      (∫ x, profile x * test (x, 0)) = 0 := by
  have hspace (t : ℝ) :
      (∫ x, travelingWave profile speed x t * fderiv ℝ test (x, t) (speed, 1)) =
        ∫ x, travelingWave profile speed x t *
          (fderiv ℝ test (x, t) (0, 1) + speed * fderiv ℝ test (x, t) (1, 0)) := by
    apply integral_congr_ae
    filter_upwards [] with x
    rw [transport_test_direction_eq test speed x t]
  simpa only [hspace] using
    travelingWave_forward_weakTest_directional profile speed hprofile B hbound
      test htest hsupport

end NumStability
