/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02UniformTransport
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization

/-!
# Uniform transport with explicit solution domains

The scalar equation is hyperbolic and is the one-component constant linear
system. For a uniformly translated field, the classical and rectangle
conservation predicates are characterized by differentiability and local
interval integrability of the initial profile.

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
