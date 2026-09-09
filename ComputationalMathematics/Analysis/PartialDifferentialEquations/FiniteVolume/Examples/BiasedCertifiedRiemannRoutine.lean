/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutineAccuracy
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.BiasedLocalRiemannRoutine

/-!
# Biased information routines with genuine Riemann accuracy certificates

Existing scalar transport references certify arbitrary additive bias on every
admitted problem in the proper state domain. A half-unit bias is certified
while violating exact equal-state consistency.
-/

open MeasureTheory

namespace NumStability.BiasedLocalRiemannRoutine
open LocalRiemannInformation

/-- Genuine scalar-transport references certify every admitted ordered problem.
The information routine still returns only the original pair of vectors. -/
theorem hasRiemannAccuracy (bias : Fin 1 → ℝ) :
    (biasedRoutine law bias).HasRiemannAccuracy (fun _ => ‖bias‖) := by
  intro problem admitted
  exact ⟨reference problem, (actual_error problem bias).le⟩

theorem certified_nonconsistent :
    (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).HasRiemannAccuracy (fun _ => 1 / 2) ∧
    ¬ (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).Consistent := by
  refine ⟨?_, not_consistent⟩
  simpa only [norm_smul, Real.norm_eq_abs, norm_one, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 2), mul_one]
    using hasRiemannAccuracy ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))

end NumStability.BiasedLocalRiemannRoutine

