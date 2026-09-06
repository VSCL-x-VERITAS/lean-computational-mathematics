/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# Integral and differential forms of one-dimensional conservation laws

The integral formulation records the time derivative of every oriented cell
integral.  A separate theorem derives the classical pointwise residual under
explicit differentiation-under-the-integral and spatial smoothness hypotheses.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The integral conservation law: the rate of change of the state between
any two endpoints is the incoming flux minus the outgoing flux. -/
def IsIntegralConservationLawSolution
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ)) : Prop :=
  ∀ a b t,
    IntervalIntegrable (fun x => q x t) volume a b ∧
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (flux (q a t) - flux (q b t)) t

/-- A continuous function whose integral on every oriented interval is zero
vanishes pointwise. -/
theorem continuous_eq_zero_of_intervalIntegral_eq_zero
    {ι : Type*} [Fintype ι]
    (g : ℝ → (ι → ℝ)) (hcontinuous : Continuous g)
    (hintegral : ∀ a b, ∫ x in a..b, g x = 0) :
    ∀ x, g x = 0 := by
  intro x
  have hderiv := intervalIntegral.integral_hasDerivAt_right
    (hcontinuous.intervalIntegrable 0 x)
    hcontinuous.aestronglyMeasurable.stronglyMeasurableAtFilter
    hcontinuous.continuousAt
  have hzeroDerivative : HasDerivAt (fun _ : ℝ => 0) (g x) x :=
    hderiv.congr_of_eventuallyEq
      (Filter.Eventually.of_forall fun b => (hintegral 0 b).symm)
  exact hzeroDerivative.unique (hasDerivAt_const x 0)

/-- Under explicit classical smoothness and interchange hypotheses, the
integral balance implies the differential conservation-law residual. -/
theorem integralConservationLaw_implies_pointwise
    {ι : Type*} [Fintype ι]
    (q : ℝ → ℝ → (ι → ℝ))
    (flux : (ι → ℝ) → (ι → ℝ))
    (qt fluxx : ℝ → (ι → ℝ)) (t : ℝ)
    (hintegralLaw : IsIntegralConservationLawSolution q flux)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hfluxx : ∀ x,
      HasDerivAt (fun ξ => flux (q ξ t)) (fluxx x) x)
    (hqtIntegrable : ∀ a b, IntervalIntegrable qt volume a b)
    (hfluxxIntegrable : ∀ a b, IntervalIntegrable fluxx volume a b)
    (hinterchange : ∀ a b,
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (∫ x in a..b, qt x) t)
    (hresidualContinuous : Continuous fun x => qt x + fluxx x) :
    ∀ x, IsConservationLawSolutionAt q flux x t := by
  have hqtIntegral (a b : ℝ) :
      ∫ x in a..b, qt x = flux (q a t) - flux (q b t) :=
    (hinterchange a b).unique (hintegralLaw a b t).2
  have hfluxxIntegral (a b : ℝ) :
      ∫ x in a..b, fluxx x = flux (q b t) - flux (q a t) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun x _ => hfluxx x) (hfluxxIntegrable a b)
  have hresidualIntegral (a b : ℝ) :
      ∫ x in a..b, (qt x + fluxx x) = 0 := by
    rw [intervalIntegral.integral_add
      (hqtIntegrable a b) (hfluxxIntegrable a b),
      hqtIntegral a b, hfluxxIntegral a b]
    abel
  have hpointwise := continuous_eq_zero_of_intervalIntegral_eq_zero
    (fun x => qt x + fluxx x) hresidualContinuous hresidualIntegral
  intro x
  exact ⟨qt x, fluxx x, hqt x, hfluxx x, hpointwise x⟩

end NumStability
