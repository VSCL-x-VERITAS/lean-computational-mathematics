import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization
import Mathlib.Data.Real.Sqrt

/-! A draft composition of existing mathematical producers. Source correspondence
and the interpretation of the left-mode profile class are not asserted here. -/
open MeasureTheory

namespace NumStability.LeftModeDomainsDraft

theorem leftMode_solutionDomains
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    0 < Real.sqrt (bulkModulus / density) ∧
      IsLinearAdvectionSolution
        (linearAcousticsLeftInvariant system.pressure system.velocity
          density (Real.sqrt (bulkModulus / density)))
        (-Real.sqrt (bulkModulus / density)) ∧
      ∀ profile : ℝ → ℝ,
        (∀ x t, travelingWave profile (-Real.sqrt (bulkModulus / density)) x t =
          profile (x + Real.sqrt (bulkModulus / density) * t)) ∧
        (∀ x t, travelingWave profile (-Real.sqrt (bulkModulus / density))
          (x - Real.sqrt (bulkModulus / density) * t) t = profile x) ∧
        (IsLinearAdvectionSolution
          (travelingWave profile (-Real.sqrt (bulkModulus / density)))
          (-Real.sqrt (bulkModulus / density)) ↔ Differentiable ℝ profile) ∧
        (IsRectangleConservationLawSolution
          (travelingWave profile (-Real.sqrt (bulkModulus / density)))
          (fun state => -Real.sqrt (bulkModulus / density) * state) ↔
          ∀ a b, IntervalIntegrable profile volume a b) := by
  have hratio : 0 < bulkModulus / density := div_pos hbulkModulus hdensity
  have hmaterial : bulkModulus =
      density * (Real.sqrt (bulkModulus / density)) ^ 2 := by
    rw [Real.sq_sqrt hratio.le]
    field_simp [system.density_ne_zero]
  refine ⟨Real.sqrt_pos.2 hratio, ?_, ?_⟩
  · intro x t
    exact linearAcousticsLeftInvariant_isLinearAdvectionSolutionAt
      system.pressure system.velocity bulkModulus density
      (Real.sqrt (bulkModulus / density)) x t system.density_ne_zero
      hmaterial (system.satisfies x t)
  · intro profile
    refine ⟨?_, ?_, travelingWave_isLinearAdvectionSolution_iff profile _, ?_⟩
    · intro x t
      simp [travelingWave]
    · intro x t
      simpa only [neg_mul, sub_eq_add_neg] using
        travelingWave_at_translated_point profile (-Real.sqrt (bulkModulus / density)) x t
    · simpa only [smul_eq_mul] using
        travelingWave_isRectangleConservationLawSolution_iff profile
          (-Real.sqrt (bulkModulus / density))

end NumStability.LeftModeDomainsDraft

#check NumStability.LeftModeDomainsDraft.leftMode_solutionDomains
#print axioms NumStability.LeftModeDomainsDraft.leftMode_solutionDomains
