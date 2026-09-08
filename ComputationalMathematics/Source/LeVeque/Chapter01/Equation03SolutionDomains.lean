/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization

/-!
# Translated profiles with explicit solution domains

Every real profile has unchanged shape and constant characteristic values.
The translated field is a classical solution exactly for differentiable
profiles and a rectangle conservation solution exactly for locally interval
integrable profiles.

This source correspondence for Chapter 1 equations (1.2)-(1.3) uses the
interpretation explicitly adopted by the user on 2026-09-08. The original
source leaves the nonsmooth profile class unspecified. The convention and
source ambiguity are recorded separately in
`user-transport-interpretation-20260908.json` in the Chapter 1 session
artifacts; this theorem does not assert that the convention is explicit in
the printed source.
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
