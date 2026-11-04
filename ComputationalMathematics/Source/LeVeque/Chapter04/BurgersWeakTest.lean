/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.TransportWeakTestOnHalfspace
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersKineticRepresentation
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Whole-line compact-test weak identity for the selected Burgers field

The ascending fan is a finite-velocity integral of actual transport steps;
the descending shock is an affine combination of the actual shock step and a
constant background. Parameter integrability justifies all Fubini exchanges.
Tests are C¹ only on the closed forward halfspace, may be nonzero at time zero,
and have compact support after indication on that halfspace.
-/

noncomputable section

open Set MeasureTheory Filter

namespace NumStability

private theorem burgers_test_initial_integrable
    (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    Integrable (fun x : ℝ => test (x, 0)) := by
  simpa using travelingWave_weakTestOnHalfspace_initial_integrable
    (fun _ => (1 : ℝ)) measurable_const 1 (by intro x; norm_num)
    test htest.continuousOn hsupport

/-- Joint velocity-spacetime integrability of the actual kinetic transport
weak integrand. No bound on the whole velocity line is assumed. -/
theorem leveque04_burgersKineticStep_test_integrable
    (left right : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    Integrable (fun w : ℝ × (ℝ × ℝ) =>
      leveque04_burgersKineticStep w.1 w.2.1 w.2.2 *
        forwardTestDerivative test (w.1, 1) w.2)
      ((volume.restrict (Ioc left right)).prod volume) := by
  let ν := volume.restrict (Ioc left right)
  have hconst : Integrable (fun _ : ℝ => (1 : ℝ)) ν :=
    integrableOn_const measure_Ioc_lt_top.ne
  have hid : Integrable (fun v : ℝ => v) ν :=
    (continuous_id.intervalIntegrable left right).1
  have hD : Integrable (fun w : ℝ × (ℝ × ℝ) =>
      forwardTestDerivative test (w.1, 1) w.2) (ν.prod volume) := by
    refine ((hconst.mul_prod (forwardTestDerivative_integrable test htest hsupport (0, 1))).add
      (hid.mul_prod (forwardTestDerivative_integrable test htest hsupport (1, 0)))).congr ?_
    filter_upwards [] with w
    rw [forwardTestDerivative_characteristic test w.1 w.2]
    simp
  apply hD.bdd_mul leveque04_burgersKineticStep_measurable.aestronglyMeasurable
  filter_upwards [] with w
  rw [Real.norm_eq_abs, abs_of_nonneg (leveque04_burgersKineticStep_bounds w.1 w.2.1 w.2.2).1]
  exact (leveque04_burgersKineticStep_bounds w.1 w.2.1 w.2.2).2

/-- The initial kinetic boundary integrand is jointly integrable in velocity
and space, including the chosen value at the initial jump. -/
theorem leveque04_burgersKineticStep_initialTest_integrable
    (left right : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    Integrable (fun w : ℝ × ℝ =>
      leveque04_burgersKineticStep w.1 w.2 0 * test (w.2, 0))
      ((volume.restrict (Ioc left right)).prod volume) := by
  have hconst : Integrable (fun _ : ℝ => (1 : ℝ))
      (volume.restrict (Ioc left right)) := integrableOn_const measure_Ioc_lt_top.ne
  have hbase := hconst.mul_prod (burgers_test_initial_integrable test htest hsupport)
  have hH : Measurable (fun w : ℝ × ℝ => leveque04_burgersKineticStep w.1 w.2 0) :=
    leveque04_burgersKineticStep_measurable.comp
      (measurable_fst.prodMk (measurable_snd.prodMk measurable_const))
  have htestplane : Integrable (fun w : ℝ × ℝ => test (w.2, 0))
      ((volume.restrict (Ioc left right)).prod volume) := by simpa using hbase
  apply htestplane.bdd_mul hH.aestronglyMeasurable
  filter_upwards [] with w
  rw [Real.norm_eq_abs, abs_of_nonneg (leveque04_burgersKineticStep_bounds w.1 w.2 0).1]
  exact (leveque04_burgersKineticStep_bounds w.1 w.2 0).2

private theorem burgers_step_weak_data
    (speed : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    Integrable (fun z : ℝ × ℝ => leveque04_burgersKineticStep speed z.1 z.2 *
      forwardTestDerivative test (speed, 1) z) ∧
    Integrable (fun x => leveque04_burgersKineticStep speed x 0 * test (x, 0)) ∧
    (∫ z : ℝ × ℝ, leveque04_burgersKineticStep speed z.1 z.2 *
      forwardTestDerivative test (speed, 1) z) +
      (∫ x, leveque04_burgersKineticStep speed x 0 * test (x, 0)) = 0 := by
  have hprofile : Measurable (riemannData (0 : ℝ) 1 1) := by
    simpa only [Function.comp_def, leveque04_burgersKineticStep, travelingWave, mul_zero,
      sub_zero, id_eq] using
      (leveque04_burgersKineticStep_measurable.comp
        ((measurable_const : Measurable (fun _ : ℝ => (0 : ℝ))).prodMk
          (measurable_id.prodMk (measurable_const : Measurable (fun _ : ℝ => (0 : ℝ))))))
  have hbound : ∀ x : ℝ, |riemannData (0 : ℝ) 1 1 x| ≤ 1 := by
    intro x
    simp only [riemannData, ite_self]
    split_ifs <;> norm_num
  refine ⟨?_, ?_, ?_⟩
  · exact forwardTestDerivative_mul_integrable
      (fun z => leveque04_burgersKineticStep speed z.1 z.2)
      (leveque04_burgersKineticStep_measurable.comp (measurable_const.prodMk measurable_id))
      1 (fun z => by
        rw [abs_of_nonneg (leveque04_burgersKineticStep_bounds speed z.1 z.2).1]
        exact (leveque04_burgersKineticStep_bounds speed z.1 z.2).2)
      test htest hsupport (speed, 1)
  · simpa [leveque04_burgersKineticStep, travelingWave] using
      travelingWave_weakTestOnHalfspace_initial_integrable
        (riemannData (0 : ℝ) 1 1) hprofile 1 hbound test htest.continuousOn hsupport
  · simpa [leveque04_burgersKineticStep, travelingWave] using
      travelingWave_forward_weakTestOnHalfspace_spacetime
        (riemannData (0 : ℝ) 1 1) speed hprofile 1 hbound test htest hsupport

private theorem burgers_constant_weak_data
    (state : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    Integrable (fun z : ℝ × ℝ => state * forwardTestDerivative test (state / 2, 1) z) ∧
    Integrable (fun x => state * test (x, 0)) ∧
    (∫ z : ℝ × ℝ, state * forwardTestDerivative test (state / 2, 1) z) +
      (∫ x, state * test (x, 0)) = 0 := by
  refine ⟨(forwardTestDerivative_integrable test htest hsupport _).const_mul state,
    (burgers_test_initial_integrable test htest hsupport).const_mul state, ?_⟩
  simpa [travelingWave] using travelingWave_forward_weakTestOnHalfspace_spacetime
    (fun _ => state) (state / 2) measurable_const |state| (by intro x; exact le_rfl)
    test htest hsupport

private theorem burgers_fan_weak_data
    (left right : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    let ν := volume.restrict (Ioc left right)
    Integrable (fun z : ℝ × ℝ => ∫ v, leveque04_burgersKineticStep v z.1 z.2 *
      forwardTestDerivative test (v, 1) z ∂ν) ∧
    Integrable (fun x => ∫ v, leveque04_burgersKineticStep v x 0 * test (x, 0) ∂ν) ∧
    (∫ z : ℝ × ℝ, ∫ v, leveque04_burgersKineticStep v z.1 z.2 *
      forwardTestDerivative test (v, 1) z ∂ν) +
      (∫ x, ∫ v, leveque04_burgersKineticStep v x 0 * test (x, 0) ∂ν) = 0 := by
  dsimp only
  let ν := volume.restrict (Ioc left right)
  have hF := leveque04_burgersKineticStep_test_integrable left right test htest hsupport
  have hI := leveque04_burgersKineticStep_initialTest_integrable left right test htest hsupport
  refine ⟨hF.integral_prod_right, hI.integral_prod_right, ?_⟩
  have hzero :
      (∫ v, ((∫ z : ℝ × ℝ, leveque04_burgersKineticStep v z.1 z.2 *
        forwardTestDerivative test (v, 1) z) +
        ∫ x, leveque04_burgersKineticStep v x 0 * test (x, 0)) ∂ν) = 0 := by
    apply integral_eq_zero_of_ae
    exact Eventually.of_forall (fun v => (burgers_step_weak_data v test htest hsupport).2.2)
  have hFswap :
      (∫ v, (∫ z : ℝ × ℝ, leveque04_burgersKineticStep v z.1 z.2 *
        forwardTestDerivative test (v, 1) z) ∂ν) =
        ∫ z : ℝ × ℝ, ∫ v, leveque04_burgersKineticStep v z.1 z.2 *
          forwardTestDerivative test (v, 1) z ∂ν := integral_integral_swap hF
  have hIswap :
      (∫ v, (∫ x, leveque04_burgersKineticStep v x 0 * test (x, 0)) ∂ν) =
        ∫ x, ∫ v, leveque04_burgersKineticStep v x 0 * test (x, 0) ∂ν :=
    integral_integral_swap hI
  rw [integral_add hF.integral_prod_left hI.integral_prod_left, hFswap, hIswap] at hzero
  exact hzero

private theorem burgers_fan_test_moment
    (left right : ℝ) (horder : left ≤ right) (test : ℝ × ℝ → ℝ) (z : ℝ × ℝ) :
    (∫ v in Ioc left right, leveque04_burgersKineticStep v z.1 z.2 *
      forwardTestDerivative test (v, 1) z) =
      (∫ v in left..right, leveque04_burgersKineticStep v z.1 z.2) *
          forwardTestDerivative test (0, 1) z +
        (∫ v in left..right, v * leveque04_burgersKineticStep v z.1 z.2) *
          forwardTestDerivative test (1, 0) z := by
  have hH := (leveque04_burgersKineticStep_intervalIntegrable z.1 z.2 left right).1
  have hV := (leveque04_burgersKineticStep_velocityMoment_intervalIntegrable z.1 z.2 left right).1
  calc
    _ = ∫ v in Ioc left right,
        leveque04_burgersKineticStep v z.1 z.2 * forwardTestDerivative test (0, 1) z +
          (v * leveque04_burgersKineticStep v z.1 z.2) * forwardTestDerivative test (1, 0) z := by
      apply integral_congr_ae
      filter_upwards [] with v
      rw [forwardTestDerivative_characteristic test v z]
      ring
    _ = _ := by
      rw [integral_add (hH.mul_const _) (hV.mul_const _), integral_mul_const, integral_mul_const,
        intervalIntegral.integral_of_le horder, intervalIntegral.integral_of_le horder]

/-- Analytic integrability and the actual Burgers weak identity on the
spacetime plane, with zero-extended forward test derivatives. -/
theorem leveque04_burgersSelectedField_weakTest_spacetime
    (left right : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    Integrable (fun z : ℝ × ℝ =>
      leveque04_burgersSelectedField left right z.1 z.2 * forwardTestDerivative test (0, 1) z +
        (leveque04_burgersSelectedField left right z.1 z.2 ^ 2 / 2) *
          forwardTestDerivative test (1, 0) z) ∧
    Integrable (fun x => riemannData left right right x * test (x, 0)) ∧
    (∫ z : ℝ × ℝ,
      leveque04_burgersSelectedField left right z.1 z.2 * forwardTestDerivative test (0, 1) z +
        (leveque04_burgersSelectedField left right z.1 z.2 ^ 2 / 2) *
          forwardTestDerivative test (1, 0) z) +
      (∫ x, riemannData left right right x * test (x, 0)) = 0 := by
  classical
  have hB := burgers_constant_weak_data left test htest hsupport
  by_cases horder : left ≤ right
  · have hF := burgers_fan_weak_data left right test htest hsupport
    have heq (z : ℝ × ℝ) :
        leveque04_burgersSelectedField left right z.1 z.2 * forwardTestDerivative test (0, 1) z +
          (leveque04_burgersSelectedField left right z.1 z.2 ^ 2 / 2) *
            forwardTestDerivative test (1, 0) z =
          left * forwardTestDerivative test (left / 2, 1) z +
            ∫ v in Ioc left right, leveque04_burgersKineticStep v z.1 z.2 *
              forwardTestDerivative test (v, 1) z := by
      by_cases hz : z ∈ forwardSpacetimeHalfspace
      · rw [leveque04_burgersSelectedField_rarefaction_kinetic_flux left right z.1 z.2 horder hz.2,
          leveque04_burgersSelectedField_rarefaction_kinetic left right z.1 z.2 horder hz.2,
          forwardTestDerivative_characteristic test (left / 2) z,
          burgers_fan_test_moment left right horder test z]
        ring
      · simp [forwardTestDerivative, hz]
    have heqI (x : ℝ) : riemannData left right right x * test (x, 0) =
        left * test (x, 0) +
          ∫ v in Ioc left right, leveque04_burgersKineticStep v x 0 * test (x, 0) := by
      have hi := leveque04_burgersSelectedField_rarefaction_kinetic left right x 0 horder le_rfl
      rw [leveque04_burgersSelectedField_initial] at hi
      rw [hi, integral_mul_const, intervalIntegral.integral_of_le horder]
      ring
    have heqF := funext heq
    have heqIF := funext heqI
    refine ⟨?_, ?_, ?_⟩
    · rw [heqF]
      exact hB.1.add hF.1
    · rw [heqIF]
      exact hB.2.1.add hF.2.1
    · rw [heqF, heqIF, integral_add hB.1 hF.1, integral_add hB.2.1 hF.2.1]
      linarith [hB.2.2, hF.2.2]
  · have hshock : right < left := lt_of_not_ge horder
    let speed := (left + right) / 2
    let amplitude := right - left
    have hH := burgers_step_weak_data speed test htest hsupport
    have heq (z : ℝ × ℝ) :
        leveque04_burgersSelectedField left right z.1 z.2 * forwardTestDerivative test (0, 1) z +
          (leveque04_burgersSelectedField left right z.1 z.2 ^ 2 / 2) *
            forwardTestDerivative test (1, 0) z =
          left * forwardTestDerivative test (left / 2, 1) z + amplitude *
            (leveque04_burgersKineticStep speed z.1 z.2 * forwardTestDerivative test (speed, 1) z) := by
      rw [leveque04_burgersSelectedField_shock_kinetic_flux left right z.1 z.2 hshock,
        leveque04_burgersSelectedField_shock_kinetic left right z.1 z.2 hshock,
        forwardTestDerivative_characteristic test (left / 2) z,
        forwardTestDerivative_characteristic test speed z]
      dsimp [speed, amplitude]
      ring
    have heqI (x : ℝ) : riemannData left right right x * test (x, 0) =
        left * test (x, 0) + amplitude * (leveque04_burgersKineticStep speed x 0 * test (x, 0)) := by
      have hi := leveque04_burgersSelectedField_shock_kinetic left right x 0 hshock
      rw [leveque04_burgersSelectedField_initial] at hi
      rw [hi]
      dsimp [speed, amplitude]
      ring
    have heqF := funext heq
    have heqIF := funext heqI
    refine ⟨?_, ?_, ?_⟩
    · rw [heqF]
      exact hB.1.add (hH.1.const_mul amplitude)
    · rw [heqIF]
      exact hB.2.1.add (hH.2.1.const_mul amplitude)
    · rw [heqF, heqIF, integral_add hB.1 (hH.1.const_mul amplitude),
        integral_add hB.2.1 (hH.2.1.const_mul amplitude),
        integral_const_mul amplitude (fun z : ℝ × ℝ =>
          leveque04_burgersKineticStep speed z.1 z.2 * forwardTestDerivative test (speed, 1) z),
        integral_const_mul amplitude (fun x : ℝ => leveque04_burgersKineticStep speed x 0 * test (x, 0))]
      linear_combination hB.2.2 + amplitude * hH.2.2

/-- The corrected whole-real-line forward weak Burgers identity for every
compact C¹ test on the closed forward halfspace, including its initial value. -/
theorem leveque04_burgersSelectedField_weakTest
    (left right : ℝ) (test : ℝ × ℝ → ℝ)
    (htest : ContDiffOn ℝ 1 test forwardSpacetimeHalfspace)
    (hsupport : HasCompactSupport (forwardSpacetimeHalfspace.indicator test)) :
    (∫ t in Ici (0 : ℝ), ∫ x,
      leveque04_burgersSelectedField left right x t * fderiv ℝ test (x, t) (0, 1) +
        (leveque04_burgersSelectedField left right x t ^ 2 / 2) * fderiv ℝ test (x, t) (1, 0)) +
      (∫ x, riemannData left right right x * test (x, 0)) = 0 := by
  have h := leveque04_burgersSelectedField_weakTest_spacetime left right test htest hsupport
  rw [← forwardTestDerivative_spacetimeIntegral_pair
    (fun z => leveque04_burgersSelectedField left right z.1 z.2)
    (fun z => leveque04_burgersSelectedField left right z.1 z.2 ^ 2 / 2) test h.1]
  exact h.2.2

end NumStability
