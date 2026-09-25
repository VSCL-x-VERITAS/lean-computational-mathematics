/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelModel

/-!
# Proof-free target for one-to-one initial mass labeling
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- A positive, locally integrable initial density makes the mass label
strictly increasing and hence one-to-one for every reference location. -/
def lagrangianMassLabelInjectiveTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ),
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
      StrictMono (lagrangianMassLabel initialDensity referenceLocation) ∧
      Function.Injective (lagrangianMassLabel initialDensity referenceLocation)

end NumStability.Leveque02Tracer
