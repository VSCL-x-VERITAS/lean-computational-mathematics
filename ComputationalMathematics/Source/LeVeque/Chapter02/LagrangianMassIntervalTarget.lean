/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelInjective
import Mathlib.Analysis.Calculus.MeanValue

/-!
# Proof-free target: conserved mass between Lagrangian particle labels

The mass of a material interval has zero time derivative under conservation.
The initial density and label definition then identify its constant value
with the difference of its endpoint mass labels.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- For ordered initial particles, zero material-interval mass rate and the
initial density imply that their later mass is their label difference. -/
def lagrangianMassIntervalTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition currentDensity : ℝ → ℝ → ℝ)
    (leftInitial rightInitial time : ℝ),
    leftInitial ≤ rightInitial →
    0 ≤ time →
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    (∀ x : ℝ, currentDensity x 0 = initialDensity x) →
    (∀ τ ∈ Set.Icc 0 time,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation leftInitial) τ ≤
        particlePosition (lagrangianMassLabel initialDensity referenceLocation rightInitial) τ) →
    (∀ τ ∈ Set.Icc 0 time,
      ∀ x ∈ Set.Icc
        (particlePosition (lagrangianMassLabel initialDensity referenceLocation leftInitial) τ)
        (particlePosition (lagrangianMassLabel initialDensity referenceLocation rightInitial) τ),
        0 < currentDensity x τ) →
    (∀ τ ∈ Set.Icc 0 time,
      IntervalIntegrable (fun x => currentDensity x τ) volume
        (particlePosition (lagrangianMassLabel initialDensity referenceLocation leftInitial) τ)
        (particlePosition (lagrangianMassLabel initialDensity referenceLocation rightInitial) τ)) →
    (∀ τ ∈ Set.Icc 0 time,
      HasDerivAt
        (fun s => ∫ x in
          (particlePosition (lagrangianMassLabel initialDensity referenceLocation leftInitial) s)..
          (particlePosition (lagrangianMassLabel initialDensity referenceLocation rightInitial) s),
          currentDensity x s)
        0 τ) →
    (lagrangianMassLabel initialDensity referenceLocation leftInitial ≤
      lagrangianMassLabel initialDensity referenceLocation rightInitial) ∧
    (lagrangianMassLabel initialDensity referenceLocation rightInitial -
      lagrangianMassLabel initialDensity referenceLocation leftInitial =
      ∫ x in
        (particlePosition (lagrangianMassLabel initialDensity referenceLocation leftInitial) time)..
        (particlePosition (lagrangianMassLabel initialDensity referenceLocation rightInitial) time),
        currentDensity x time)

end NumStability.Leveque02Tracer
