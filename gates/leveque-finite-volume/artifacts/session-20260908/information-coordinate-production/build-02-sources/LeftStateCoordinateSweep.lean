/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateSweep

/-!
# Two directional steps of the left-state information method

The existing ordered-pair routine and unit-speed law give a concrete positive
unit-step sweep with distinct outputs. Its result contains no space-time field.
This finite example does not establish general accuracy or convergence.
-/

namespace NumStability.LeftStateCoordinateSweep

open RiemannInformationCoordinate

theorem left_rule (area : Fin 2 → (Fin 2 → ℤ) → ℝ)
    (fallback : Fin 2 → (Fin 2 → ℤ) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ)
    (d : Fin 2) (cell : (Fin 2 → ℤ)) (dt : ℝ) (old : ℤ → Fin 1 → ℝ) :
    guardedRule (fun (_d : Fin 2) (_dt : ℝ) => LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))) area fallback d cell dt old = area d cell • old (cell d - 1) := by
  simp [guardedRule, LeftStateInformationFlux.method,
    adjacentCellRiemannProblem, StationaryRiemannField.physicalFlux]

theorem left_sweep_admitted (volume : (Fin 2 → ℤ) → ℝ)
    (area : Fin 2 → (Fin 2 → ℤ) → ℝ)
    (fallback : Fin 2 → (Fin 2 → ℤ) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ)
    (stages : List (Fin 2 × ℝ)) (state : (Fin 2 → ℤ) → Fin 1 → ℝ) :
    SweepAdmitted (fun (_d : Fin 2) (_dt : ℝ) => LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))) volume area fallback stages state := by
  induction stages generalizing state with
  | nil => trivial
  | cons step stages ih => exact ⟨fun _ => trivial, ih _⟩

theorem left_unit_update
    (fallback : Fin 2 → (Fin 2 → ℤ) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ)
    (d : Fin 2) (state : (Fin 2 → ℤ) → Fin 1 → ℝ) (cell : (Fin 2 → ℤ)) :
    CoordinateLineBalance.advance (fun _ => 1)
      (guardedRule (fun (_d : Fin 2) (_dt : ℝ) => LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))) (fun _ _ => 1) fallback) d 1 state cell =
        state (Function.update cell d (cell d - 1)) := by
  simp [CoordinateLineBalance.advance, finiteVolumeCellAverageUpdate,
    CoordinateLineBalance.netOutwardFlux, CoordinateLineBalance.normalFaceFlux, left_rule]

theorem left_two_stage_nonvacuity
    (fallback : Fin 2 → (Fin 2 → ℤ) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ) :
    SweepAdmitted (fun (_d : Fin 2) (_dt : ℝ) => LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))) (fun _ => 1) (fun _ _ => 1) fallback [(0, 1), (1, 1)]
      (fun cell : Fin 2 → ℤ => if cell 1 = 0 then (0 : Fin 1 → ℝ) else 1) ∧
    CoordinateLineBalance.sweep (fun _ => 1)
      (guardedRule (fun (_d : Fin 2) (_dt : ℝ) => LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))) (fun _ _ => 1) fallback) [(0, 1), (1, 1)]
      (fun cell : Fin 2 → ℤ => if cell 1 = 0 then (0 : Fin 1 → ℝ) else 1) ![0, 1] = 0 ∧
    CoordinateLineBalance.sweep (fun _ => 1)
      (guardedRule (fun (_d : Fin 2) (_dt : ℝ) => LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))) (fun _ _ => 1) fallback) [(0, 1), (1, 1)]
      (fun cell : Fin 2 → ℤ => if cell 1 = 0 then (0 : Fin 1 → ℝ) else 1) ![0, 2] = 1 := by
  refine ⟨left_sweep_admitted _ _ _ _ _, ?_, ?_⟩
  · rw [CoordinateLineBalance.sweep_two, left_unit_update, left_unit_update]
    simp
  · rw [CoordinateLineBalance.sweep_two, left_unit_update, left_unit_update]
    simp

end NumStability.LeftStateCoordinateSweep
