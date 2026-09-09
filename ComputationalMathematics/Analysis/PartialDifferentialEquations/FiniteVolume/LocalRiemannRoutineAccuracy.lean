/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutine

/-!
# Certified accuracy of information routines

A supplied routine is certified against a physical reference for every admitted
ordered problem on its finite time horizon. The reference need not be returned.
Exact equal-state consistency remains a separate property.
-/

open MeasureTheory

namespace NumStability.LocalRiemannInformation

/-- Each admitted execution approximates the interface mean flux of some
physical reference for that same ordered Riemann problem and time horizon.
The reference is a proof witness; it need not be returned by the routine.
Exact equal-state consistency is a separate property. -/
def Routine.HasRiemannAccuracy {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (routine : Routine law Result Information) (errorBound : Problem law → ℝ) : Prop :=
  ∀ problem admitted, ∃ reference : Reference problem,
    ‖routine.flux problem admitted - reference.meanFlux‖ ≤ errorBound problem

/-- The old method's accuracy certificate survives forgetting consistency. -/
theorem Method.toRoutine_hasRiemannAccuracy {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    (method : Method law Result Information) :
    method.toRoutine.HasRiemannAccuracy method.errorBound := by
  intro problem admitted
  exact method.accurate problem admitted

/-- A certified execution supplies a same-problem physical comparison,
including its initial states and mean-flux normalization. -/
theorem Routine.HasRiemannAccuracy.reference_comparison {m : ℕ} {law : Law m}
    {Result : Problem law → Type*} {Information : Type*}
    {routine : Routine law Result Information} {errorBound : Problem law → ℝ}
    (haccuracy : routine.HasRiemannAccuracy errorBound)
    (problem : Problem law) (admitted : routine.domain problem) :
    ∃ reference : Reference problem,
      IsRiemannData (fun x => reference.field x 0) problem.left problem.right ∧
      IsOneDimensionalCellAverage (fun τ => law.flux (reference.field 0 τ)) 0 problem.duration
        reference.meanFlux ∧
      0 ≤ errorBound problem ∧
      ‖routine.flux problem admitted - reference.meanFlux‖ ≤ errorBound problem ∧
      ∀ (physicalMean : Fin m → ℝ) (comparisonBound : ℝ),
        ‖reference.meanFlux - physicalMean‖ ≤ comparisonBound →
        ‖routine.flux problem admitted - physicalMean‖ ≤ errorBound problem + comparisonBound := by
  obtain ⟨reference, herror⟩ := haccuracy problem admitted
  obtain ⟨hinitial, hmean, hcomparison⟩ :=
    routine.reference_comparison problem admitted reference herror
  exact ⟨reference, hinitial, hmean, (norm_nonneg _).trans herror, herror, hcomparison⟩

end NumStability.LocalRiemannInformation
