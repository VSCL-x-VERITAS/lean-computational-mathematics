/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassIntervalTarget
import Mathlib.Tactic

/-!
# Conserved mass between two Lagrangian particles
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- A zero moving-section mass rate makes that mass constant from the initial
time; the initial mass is the difference of the two particle labels. -/
theorem lagrangianMassInterval : lagrangianMassIntervalTarget := by
  intro initialDensity referenceLocation particlePosition currentDensity
    leftInitial rightInitial time hleft ht hintegrable hpositive hinitialPosition
    hinitialDensity _ _ _ hmassRate
  let movingMass : ℝ → ℝ := fun s =>
    ∫ x in
      (particlePosition (lagrangianMassLabel initialDensity referenceLocation leftInitial) s)..
      (particlePosition (lagrangianMassLabel initialDensity referenceLocation rightInitial) s),
      currentDensity x s
  have hcontinuous : ContinuousOn movingMass (Set.Icc 0 time) := by
    intro s hs
    exact (hmassRate s hs).continuousAt.continuousWithinAt
  have hrightDeriv : ∀ s ∈ Set.Ico 0 time,
      HasDerivWithinAt movingMass 0 (Set.Ici s) s := by
    intro s hs
    exact (hmassRate s ⟨hs.1, hs.2.le⟩).hasDerivWithinAt
  have hconstant : movingMass time = movingMass 0 :=
    (constant_of_has_deriv_right_zero hcontinuous hrightDeriv) time ⟨ht, le_refl time⟩
  have hinitialMass : movingMass 0 = ∫ x in leftInitial..rightInitial, initialDensity x := by
    simp [movingMass, hinitialPosition, hinitialDensity]
  have hlabelMass :
      lagrangianMassLabel initialDensity referenceLocation rightInitial -
        lagrangianMassLabel initialDensity referenceLocation leftInitial =
      ∫ x in leftInitial..rightInitial, initialDensity x := by
    have hadd := intervalIntegral.integral_add_adjacent_intervals
      (hintegrable referenceLocation leftInitial) (hintegrable leftInitial rightInitial)
    dsimp [lagrangianMassLabel]
    linarith
  have hlabelOrder :
      lagrangianMassLabel initialDensity referenceLocation leftInitial ≤
        lagrangianMassLabel initialDensity referenceLocation rightInitial :=
    (lagrangianMassLabelInjective initialDensity referenceLocation
      hintegrable hpositive).1.monotone hleft
  refine ⟨hlabelOrder, ?_⟩
  change lagrangianMassLabel initialDensity referenceLocation rightInitial -
      lagrangianMassLabel initialDensity referenceLocation leftInitial = movingMass time
  rw [hconstant, hinitialMass]
  exact hlabelMass

end NumStability.Leveque02Tracer
