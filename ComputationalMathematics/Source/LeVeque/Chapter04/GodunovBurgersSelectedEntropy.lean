/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannJumpEntropy
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersRarefactionEntropy
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSelectedSolver

/-!
# Positive-time entropy rectangle inequality of the selected Burgers solver

Ascending pairs use the centered fan's entropy equality; descending pairs
use the moving jump's dissipative coefficient. This establishes the ordered
rectangle inequality, without asserting entropy uniqueness.
-/

open MeasureTheory

namespace NumStability

/-- Every reference-state absolute-value entropy of the actual selected
scalar Burgers field obeys the ordered rectangle inequality at positive times. -/
theorem leveque04_burgersSelectedField_entropy_rectangle_positive
    (left right reference a b s t : ℝ)
    (hab : a ≤ b) (hs : 0 < s) (hst : s ≤ t) :
    (∫ x in a..b, |leveque04_burgersSelectedField left right x t - reference|) -
        (∫ x in a..b, |leveque04_burgersSelectedField left right x s - reference|) ≤
      ∫ τ in s..t, (burgersKruzkovFlux reference (leveque04_burgersSelectedField left right a τ) -
        burgersKruzkovFlux reference (leveque04_burgersSelectedField left right b τ)) := by
  by_cases horder : left ≤ right
  · have ht : 0 < t := hs.trans_le hst
    have hsfield (x : ℝ) : leveque04_burgersSelectedField left right x s =
        leveque04_burgersRarefactionForward left right x s := by
      simp only [leveque04_burgersSelectedField, if_pos horder,
        leveque04_burgersRarefactionGlobalCandidate_positive left right x s hs]
    have htfield (x : ℝ) : leveque04_burgersSelectedField left right x t =
        leveque04_burgersRarefactionForward left right x t := by
      simp only [leveque04_burgersSelectedField, if_pos horder,
        leveque04_burgersRarefactionGlobalCandidate_positive left right x t ht]
    rw [show (fun x => |leveque04_burgersSelectedField left right x t - reference|) =
      (fun x => |leveque04_burgersRarefactionForward left right x t - reference|) by
        funext x; rw [htfield],
      show (fun x => |leveque04_burgersSelectedField left right x s - reference|) =
      (fun x => |leveque04_burgersRarefactionForward left right x s - reference|) by
        funext x; rw [hsfield]]
    have htime :
        (∫ τ in s..t, (burgersKruzkovFlux reference (leveque04_burgersSelectedField left right a τ) -
          burgersKruzkovFlux reference (leveque04_burgersSelectedField left right b τ))) =
        ∫ τ in s..t, (burgersKruzkovFlux reference (leveque04_burgersRarefactionForward left right a τ) -
          burgersKruzkovFlux reference (leveque04_burgersRarefactionForward left right b τ)) := by
      apply intervalIntegral.integral_congr
      intro τ hτ
      have hτpos : 0 < τ := hs.trans_le (by simpa only [Set.mem_uIcc, min_eq_left hst] using hτ.1)
      simp only [leveque04_burgersSelectedField, if_pos horder,
        leveque04_burgersRarefactionGlobalCandidate_positive left right a τ hτpos,
        leveque04_burgersRarefactionGlobalCandidate_positive left right b τ hτpos]
    rw [htime]
    exact (leveque04_burgersRarefactionForward_entropy_rectangle_positive
      left right reference a b s t horder hs ht).le
  · simpa only [leveque04_burgersSelectedField, if_neg horder] using
      travelingRiemannJump_entropy_rectangle left right ((left + right) / 2)
        (fun u => |u - reference|) (burgersKruzkovFlux reference)
        (burgersKruzkovFlux_shock_dissipation left right reference (le_of_not_ge horder))
        a b s t hab hst

end NumStability
