import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

open MeasureTheory

namespace NumStability

/-- Translation along a characteristic preserves every profile, without regularity. -/
theorem travelingWave_characteristic_translate {E : Type*} (profile : ℝ → E)
    (speed x t h : ℝ) :
    travelingWave profile speed (x + speed * h) (t + h) =
      travelingWave profile speed x t := by
  unfold travelingWave
  congr 1
  ring

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The restriction to each characteristic is constant, even for nonsmooth profiles. -/
theorem travelingWave_hasDerivAt_characteristic (profile : ℝ → E)
    (speed x t : ℝ) :
    HasDerivAt (fun τ => travelingWave profile speed (x + speed * τ) τ) 0 t := by
  simpa only [travelingWave_at_translated_point] using hasDerivAt_const t (profile x)

/-- Classical solvability on the whole plane requires precisely differentiability
of the profile, because the spatial section at time zero is the profile itself. -/
theorem travelingWave_isLinearAdvectionSolution_iff (profile : ℝ → E) (speed : ℝ) :
    IsLinearAdvectionSolution (travelingWave profile speed) speed ↔
      Differentiable ℝ profile := by
  constructor
  · intro h x
    obtain ⟨qt, qx, _, hx, _⟩ := h x 0
    simpa only [travelingWave_zero] using hx.differentiableAt
  · exact travelingWave_isLinearAdvectionSolution speed

/-- The full rectangle solution property requires precisely interval integrability
of the profile. This includes discontinuous profiles and every real speed. -/
theorem travelingWave_isRectangleConservationLawSolution_iff
    (profile : ℝ → E) (speed : ℝ) :
    IsRectangleConservationLawSolution (travelingWave profile speed)
      (fun state => speed • state) ↔
      ∀ a b, IntervalIntegrable profile volume a b := by
  constructor
  · intro h a b
    simpa only [travelingWave_zero] using h.1 a b 0
  · intro h
    exact travelingWave_isRectangleConservationLawSolution profile h speed

/-- The translated profile has its stated initial trace, transports its full shape,
and satisfies the classical or rectangle conservation law on the respective
explicit regularity domains. Characteristic transport itself is unconditional. -/
theorem leveque01_equation03_transportSolution (profile : ℝ → ℝ) (speed : ℝ) :
    (∀ x, travelingWave profile speed x 0 = profile x) ∧
    (∀ x t, travelingWave profile speed (x + speed * t) t = profile x) ∧
    (∀ x t, HasDerivAt
      (fun τ => travelingWave profile speed (x + speed * τ) τ) 0 t) ∧
    (Differentiable ℝ profile →
      IsLinearAdvectionSolution (travelingWave profile speed) speed) ∧
    ((∀ a b, IntervalIntegrable profile volume a b) →
      IsRectangleConservationLawSolution (travelingWave profile speed)
        (fun state => speed * state)) := by
  refine ⟨travelingWave_zero profile speed,
    travelingWave_at_translated_point profile speed,
    travelingWave_hasDerivAt_characteristic profile speed,
    travelingWave_isLinearAdvectionSolution speed, ?_⟩
  intro h
  exact travelingWave_isRectangleConservationLawSolution profile h speed

end NumStability

#check NumStability.travelingWave_characteristic_translate
#print axioms NumStability.travelingWave_characteristic_translate
#check NumStability.travelingWave_hasDerivAt_characteristic
#print axioms NumStability.travelingWave_hasDerivAt_characteristic
#check NumStability.travelingWave_isLinearAdvectionSolution_iff
#print axioms NumStability.travelingWave_isLinearAdvectionSolution_iff
#check NumStability.travelingWave_isRectangleConservationLawSolution_iff
#print axioms NumStability.travelingWave_isRectangleConservationLawSolution_iff
#check NumStability.leveque01_equation03_transportSolution
#print axioms NumStability.leveque01_equation03_transportSolution
