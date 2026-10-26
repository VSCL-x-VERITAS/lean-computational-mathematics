/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates

/-!
# Exterior fronts of active linear Riemann waves

Only characteristic coordinates with a nonzero jump constrain the exterior
fronts of a Riemann solution. Inactive modes can have arbitrary speeds.
The origin representative is the left state, as in the piecewise constant
reconstruction used by the finite volume library.
-/

namespace NumStability

/-- A lower speed bound is needed only for modes with a nonzero jump. -/
theorem linearRiemannSolution_left_of_active_front
    {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (left right : ι → ℝ) (lower x time : ℝ)
    (hlower : ∀ p, basis.equivFun left p ≠ basis.equivFun right p → lower ≤ speeds p)
    (htime : 0 ≤ time) (hx : x < lower * time) :
    linearRiemannSolution basis speeds left left right x time = left := by
  classical
  calc
    _ = ∑ p, basis.equivFun left p • basis p := by
      apply Finset.sum_congr rfl
      intro p _
      by_cases hp : basis.equivFun left p = basis.equivFun right p
      · simp [eigenmodeTravelingWave, travelingWave, riemannData, ← hp]
      · have harg : x - speeds p * time < 0 := by
          have hmul := mul_le_mul_of_nonneg_right (hlower p hp) htime
          linarith
        simp [eigenmodeTravelingWave, travelingWave, riemannData, harg]
    _ = left := basis.sum_repr left

/-- An upper speed bound is needed only for modes with a nonzero jump. -/
theorem linearRiemannSolution_right_of_active_front
    {ι : Type*} [Fintype ι]
    (basis : Module.Basis ι ℝ (ι → ℝ)) (speeds : ι → ℝ)
    (left right : ι → ℝ) (upper x time : ℝ)
    (hupper : ∀ p, basis.equivFun left p ≠ basis.equivFun right p → speeds p ≤ upper)
    (htime : 0 ≤ time) (hx : upper * time < x) :
    linearRiemannSolution basis speeds left left right x time = right := by
  classical
  calc
    _ = ∑ p, basis.equivFun right p • basis p := by
      apply Finset.sum_congr rfl
      intro p _
      by_cases hp : basis.equivFun left p = basis.equivFun right p
      · simp [eigenmodeTravelingWave, travelingWave, riemannData, hp]
      · have harg : 0 < x - speeds p * time := by
          have hmul := mul_le_mul_of_nonneg_right (hupper p hp) htime
          linarith
        simp [eigenmodeTravelingWave, travelingWave, riemannData, harg,
          not_lt_of_gt harg]
    _ = right := basis.sum_repr right

end NumStability
