/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannRoutineUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux

/-!
# Information-only routines with nonzero equal-state flux error

The physical example is scalar unit-speed transport on the proper state set
[0,1]. Its finite-time references reuse the established transport Riemann
solution. The numerical routine returns only the two ordered vectors and adds
an arbitrary bias. A nonzero bias violates exact equal-state consistency while
retaining explicit finite error bounds. Neither the reference field nor an
accuracy certificate is stored in the numerical result.
-/

namespace NumStability.BiasedLocalRiemannRoutine
open LocalRiemannInformation

/-- Scalar unit-speed transport on the proper state set `[0, 1]`: the flux is the physical
flux of `StationaryRiemannField.transportLaw`, but only states whose single coordinate lies
in `[0, 1]` are admissible, so hyperbolicity is classified only there. -/
noncomputable def law : Law 1 where
  positive_dimension := by decide
  states := {state | 0 ≤ state 0 ∧ state 0 ≤ 1}
  flux := StationaryRiemannField.transportLaw.physicalFlux
  hyperbolic := fun state _ => hyperbolicConservationLaw_isHyperbolicFluxAt _ state

theorem proper_states : (0 : Fin 1 → ℝ) ∈ law.states ∧
    (1 : Fin 1 → ℝ) ∈ law.states ∧ (2 : Fin 1 → ℝ) ∉ law.states := by
  norm_num [law]

/-- Existing transport reference restricted to the actual finite horizon. -/
noncomputable def reference (problem : Problem law) : Reference problem where
  field := StationaryRiemannField.reference problem.left problem.right
  initial := StationaryRiemannField.reference_initial _ _
  admissible := by
    intro x τ _ _
    unfold StationaryRiemannField.reference travelingWave riemannData
    split_ifs <;> first | exact problem.left_mem | exact problem.right_mem
  spatial_integrable := fun a b τ _ _ =>
    (StationaryRiemannField.reference_rectangle problem.left problem.right).1 a b τ
  face_integrable := fun x s t _ _ _ =>
    (StationaryRiemannField.reference_rectangle problem.left problem.right).2.1 x s t
  rectangle := fun a b s t _ _ _ =>
    (StationaryRiemannField.reference_rectangle problem.left problem.right).2.2 a b s t

theorem reference_mean (problem : Problem law) : (reference problem).meanFlux = problem.left := by
  have h := LeftStateInformationFlux.selected_flux_eq_reference_average
    (⟨problem.left, problem.right⟩ :
      HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := 1)))
    problem.duration_pos
  simpa only [Reference.meanFlux, reference, LeftStateInformationFlux.method,
    StationaryRiemannField.physicalFlux, law] using h.symm

theorem actual_error (problem : Problem law) (bias : Fin 1 → ℝ) :
    ‖(biasedRoutine law bias).flux problem trivial - (reference problem).meanFlux‖ = ‖bias‖ := by
  rw [reference_mean]
  simp only [Routine.flux, biasedRoutine, law,
    StationaryRiemannField.physicalFlux, add_sub_cancel_left]

/-- The equal-state Riemann problem for `law` with both ordered states `0` and unit horizon.
A consistent routine must return the physical flux `0` here, so this problem witnesses the
failure of consistency for any nonzero bias. -/
def equalProblem : Problem law where
  left := 0
  right := 0
  left_mem := proper_states.1
  right_mem := proper_states.1
  duration := 1
  duration_pos := by norm_num

theorem equal_state_selected :
    (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).extract
      (problem := equalProblem)
      ((biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).solve equalProblem trivial) = (0, 0) ∧
    (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux equalProblem trivial =
      (1 / 2 : ℝ) • (1 : Fin 1 → ℝ) := by
  refine ⟨rfl, ?_⟩
  simp only [Routine.flux, biasedRoutine, equalProblem, law,
    StationaryRiemannField.physicalFlux, zero_add]

theorem equal_state_error :
    ‖(biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux equalProblem trivial -
      (reference equalProblem).meanFlux‖ = 1 / 2 := by
  rw [actual_error, norm_smul]
  norm_num

theorem not_consistent :
    ¬ (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).Consistent := by
  intro h
  have heq := h equalProblem trivial rfl
  have hzero := congrFun heq (0 : Fin 1)
  norm_num [Routine.flux, biasedRoutine, equalProblem, law,
    StationaryRiemannField.physicalFlux] at hzero

/-- The direct physical flux bounds remain usable for this nonconsistent
routine. Equal biases cancel in the conservative update. -/
theorem zero_cell_update :
    finiteVolumeCellAverageUpdate 1 1 (0 : Fin 1 → ℝ)
      ((biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux equalProblem trivial -
       (biasedRoutine law ((1 / 2 : ℝ) • (1 : Fin 1 → ℝ))).flux equalProblem trivial) = 0 := by
  simp [finiteVolumeCellAverageUpdate]

end NumStability.BiasedLocalRiemannRoutine
