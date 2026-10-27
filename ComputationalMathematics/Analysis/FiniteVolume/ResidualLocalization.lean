/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.EuclideanMeasures
import Mathlib.MeasureTheory.Function.LocallyIntegrable
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.MeasureTheory.Integral.Bochner.Set
import Mathlib.MeasureTheory.Measure.OpenPos

/-!
# Continuous residuals tested on Euclidean ball slabs

These transparent propositions specify an analytic support interface. They assert
no localization or integrability theorem. Applications to conservation laws also
require the derivative, geometric and integration bridges for their actual domains.
-/

set_option autoImplicit false

noncomputable section

open MeasureTheory Set

namespace NumStability.FiniteVolume.ResidualLocalization

/-- Finite-dimensional real Euclidean coordinate space. -/
abbrev Point (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- A positive-radius ball whose closure lies in the spatial domain.
Compactness follows from finite dimensionality; it is not an extra family guard. -/
def BallCompactlyContained {d : ℕ} (Ω : Set (Point d))
    (x : Point d) (ρ : ℝ) : Prop :=
  0 < ρ ∧ closure (Metric.ball x ρ) ⊆ Ω

/-- Spatial Lebesgue integration followed by oriented time Lebesgue integration. -/
def ballSlabIntegral {d : ℕ} (r : Point d × ℝ → ℝ)
    (x : Point d) (ρ a b : ℝ) : ℝ :=
  intervalIntegral
    (fun t => ∫ y in Metric.ball x ρ, r (y, t)
      ∂(EuclideanMeasure.spatialVolume d)) a b (volume : Measure ℝ)

/-- Vanishing-residual integral condition on the admissible spatial-ball and time-slab family. -/
def ZeroBallSlabFamily {d : ℕ} (Ω : Set (Point d)) (I : Set ℝ)
    (r : Point d × ℝ → ℝ) : Prop :=
  ∀ x ∈ Ω, ∀ ρ : ℝ, BallCompactlyContained Ω x ρ →
    ∀ a b : ℝ, a < b → Icc a b ⊆ I → ballSlabIntegral r x ρ a b = 0

/-- Integrability to be derived from continuity and compact containment. -/
def CompactBallSlabIntegrability : Prop :=
  ∀ (d : ℕ) (Ω : Set (Point d)) (I : Set ℝ) (r : Point d × ℝ → ℝ),
    IsOpen Ω → IsOpen I → ContinuousOn r (Ω ×ˢ I) →
    ∀ x ∈ Ω, ∀ ρ : ℝ, BallCompactlyContained Ω x ρ →
      ∀ a b : ℝ, a < b → Icc a b ⊆ I →
        IntegrableOn (fun z : ℝ × Point d => r (z.2, z.1))
          (Icc a b ×ˢ Metric.ball x ρ)
          ((volume : Measure ℝ).prod (EuclideanMeasure.spatialVolume d)) ∧
        (∀ t ∈ Icc a b, IntegrableOn (fun y => r (y, t))
          (Metric.ball x ρ) (EuclideanMeasure.spatialVolume d)) ∧
        IntervalIntegrable
          (fun t => ∫ y in Metric.ball x ρ, r (y, t)
            ∂(EuclideanMeasure.spatialVolume d)) volume a b

/-- Pointwise localization from the whole ball-slab zero-integral family. -/
def ContinuousResidualBallSlabLocalization : Prop :=
  ∀ (d : ℕ) (Ω : Set (Point d)) (I : Set ℝ) (r : Point d × ℝ → ℝ),
    IsOpen Ω → IsOpen I → ContinuousOn r (Ω ×ˢ I) →
    ZeroBallSlabFamily Ω I r →
    ∀ x ∈ Ω, ∀ t ∈ I, r (x, t) = 0

end NumStability.FiniteVolume.ResidualLocalization
