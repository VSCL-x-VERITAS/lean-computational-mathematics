import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02UniformTransport
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization

/-! Draft exact-domain composition for the user-interpreted Eq1.2 model.
The existing scalar and kinematic content is retained, and the analytic
premises are characterized as necessary and sufficient. -/

open MeasureTheory

namespace NumStability

theorem leveque01_equation02_uniformTransportDomains (speed : ℝ) :
    IsRealHyperbolicMatrix (constantCoefficientScalarMatrix speed) ∧
    (∀ q x t, leveque01_equation01_constantLinearSystemAt
        (scalarAsOneComponentSystem q) (constantCoefficientScalarMatrix speed) x t ↔
      leveque01_equation02_scalarAdvectionAt q speed x t) ∧
    ∀ q : ℝ → ℝ → ℝ, IsUniformAdvection q speed →
      (IsLinearAdvectionSolution q speed ↔ Differentiable ℝ (fun x => q x 0)) ∧
      (IsRectangleConservationLawSolution q (fun state => speed * state) ↔
        ∀ a b, IntervalIntegrable (fun x => q x 0) volume a b) := by
  refine ⟨leveque01_scalarEquation_isHyperbolic speed,
    fun q x t => leveque01_equation02_isOneDimensionalSpecialization q speed x t, ?_⟩
  intro q h
  have heq := (isUniformAdvection_iff_eq_travelingWave q speed).mp h
  constructor
  · simpa only [← heq] using
      travelingWave_isLinearAdvectionSolution_iff (fun x => q x 0) speed
  · simpa only [smul_eq_mul, ← heq] using
      travelingWave_isRectangleConservationLawSolution_iff (fun x => q x 0) speed

end NumStability

#check NumStability.leveque01_equation02_uniformTransportDomains
#print axioms NumStability.leveque01_equation02_uniformTransportDomains
