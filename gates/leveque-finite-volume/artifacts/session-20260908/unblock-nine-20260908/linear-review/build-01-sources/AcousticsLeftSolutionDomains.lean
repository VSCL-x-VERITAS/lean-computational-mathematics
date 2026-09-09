/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import Mathlib.Data.Real.Sqrt

/-!
# LeVeque Chapter 1: the left acoustic mode and profile domains

The selected passage is printed page 2 (raw PDF page 24), with the scalar
translated-profile discussion on printed page 1. It names the invariant `w₂`
and then writes `q₂` for the translated profile; that printed switch is retained
as a source ambiguity. The given acoustic system and the independent profile
below are separate inputs.

Under the user's goal to unblock the remaining rows, the coordinator selected
Q3: positive physical material parameters, arbitrary geometric profiles,
differentiable classical profiles, and locally interval-integrable rectangle
profiles. These details are coordinator-selected conventions, not a literal
detailed user answer or explicit hypotheses printed in the passage. The record
is `unblock-nine-20260908/selected-interpretations.json` in the session artifacts.
Fresh independent auditing is required; this theorem does not assert acceptance.
-/

open MeasureTheory

namespace NumStability

/-- The actual left invariant and the independently specified profile domains,
under the explicitly selected physical and analytic conventions. -/
theorem leveque01_acousticsLeftSolutionDomains
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

end NumStability
