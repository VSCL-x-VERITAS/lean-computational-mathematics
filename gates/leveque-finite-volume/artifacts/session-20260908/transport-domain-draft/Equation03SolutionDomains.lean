import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization

/-!
Provisional exact-domain composition for Chapter 1 equation (1.3).
This draft records the analytic domains of the chosen Lean predicates.
Identification with the exhaustive intended source scope is unresolved and
awaits the explicitly requested interpretation choice and independent audit.
-/

open MeasureTheory

namespace NumStability

theorem leveque01_equation03_solutionDomains (profile : ℝ → ℝ) (speed : ℝ) :
    (∀ x, travelingWave profile speed x 0 = profile x) ∧
    (∀ x t, travelingWave profile speed (x + speed * t) t = profile x) ∧
    (∀ x t, HasDerivAt
      (fun τ => travelingWave profile speed (x + speed * τ) τ) 0 t) ∧
    (IsLinearAdvectionSolution (travelingWave profile speed) speed ↔
      Differentiable ℝ profile) ∧
    (IsRectangleConservationLawSolution (travelingWave profile speed)
      (fun state => speed * state) ↔
      ∀ a b, IntervalIntegrable profile volume a b) := by
  refine ⟨travelingWave_zero profile speed,
    travelingWave_at_translated_point profile speed,
    travelingWave_hasDerivAt_characteristic profile speed,
    travelingWave_isLinearAdvectionSolution_iff profile speed, ?_⟩
  simpa only [smul_eq_mul] using
    travelingWave_isRectangleConservationLawSolution_iff profile speed

end NumStability

#check NumStability.leveque01_equation03_solutionDomains
#print axioms NumStability.leveque01_equation03_solutionDomains
