/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionGodunovFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionForwardRectangle

/-!
# Actual Godunov flux averages and terminal cell means under full-step CFL

Actual original-face physical flux agrees with the original Godunov flux on
0<t<T. The two time endpoints are null for integration, so terminal Courant-one
contact is retained. Actual full forward rectangle conservation and actual
initial cell masses then identify terminal cell means with the existing finite
grid Godunov update, including both supplied boundary fluxes. The same global
evolution is used throughout; stationary fixed-face shocks stay in its flux.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Interval

namespace NumStability

private theorem interface_flux_eq_gridFlux {N : ℕ} (old : Fin (N + 2) → ℝ) (j : Fin (N + 1)) :
    leveque04_burgersSelectedInterfaceState (leveque04_burgersActionState old j.val)
        (leveque04_burgersActionState old (j.val + 1)) ^ 2 / 2 = leveque04_burgersFiniteGridFlux old j := by
  have hL : leveque04_burgersActionState old j.val = old j.castSucc := leveque04_burgersActionState_eq old j.castSucc
  have hR : leveque04_burgersActionState old (j.val + 1) = old j.succ := leveque04_burgersActionState_eq old j.succ
  unfold leveque04_burgersFiniteGridFlux leveque04_burgersPhysicalInterfaceFlux
  rw [hL, hR]

theorem leveque04_burgersFiniteActionEvolution_CFL_face_flux_integral {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (horizon_pos : 0 < horizon)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) :
    IntervalIntegrable (fun time => leveque04_burgersFiniteActionEvolution old origin width
        (leveque04_burgersActionFace origin width j.val) time ^ 2 / 2) volume 0 horizon ∧
      (∫ time in (0 : ℝ)..horizon, leveque04_burgersFiniteActionEvolution old origin width
        (leveque04_burgersActionFace origin width j.val) time ^ 2 / 2) =
          horizon * leveque04_burgersFiniteGridFlux old j := by
  have hi := (leveque04_burgersFiniteActionEvolution_temporal_flux_integral old origin width
    (leveque04_burgersActionFace origin width j.val) 0 horizon hwidth.le (le_refl 0) horizon_pos.le).1
  have heq : ∀ᵐ time : ℝ, time ∈ Ι (0 : ℝ) horizon →
      leveque04_burgersFiniteActionEvolution old origin width
          (leveque04_burgersActionFace origin width j.val) time ^ 2 / 2 = leveque04_burgersFiniteGridFlux old j := by
    filter_upwards [volume.ae_ne horizon] with time hne ht
    rw [uIoc_of_le horizon_pos.le] at ht
    exact (leveque04_burgersFiniteActionEvolution_CFL_face_flux
      old origin width horizon bound time j hwidth hprop hCFL
        ⟨ht.1, lt_of_le_of_ne ht.2 hne⟩).trans (interface_flux_eq_gridFlux old j)
  refine ⟨hi, ?_⟩
  calc
    _ = ∫ _time in (0 : ℝ)..horizon, leveque04_burgersFiniteGridFlux old j :=
      intervalIntegral.integral_congr_ae heq
    _ = _ := by simp only [intervalIntegral.integral_const, sub_zero, smul_eq_mul]

/-- Equation(4.37) uses the physical time average of the SAME global field,
including terminal Courant-one contact and either supplied ghost. -/
theorem leveque04_burgersFiniteActionEvolution_CFL_face_timeAverage {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (horizon_pos : 0 < horizon)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) :
    (∫ time in (0 : ℝ)..horizon, leveque04_burgersFiniteActionEvolution old origin width
        (leveque04_burgersActionFace origin width j.val) time ^ 2 / 2) / horizon =
      leveque04_burgersFiniteGridFlux old j := by
  rw [(leveque04_burgersFiniteActionEvolution_CFL_face_flux_integral
    old origin width horizon bound j hwidth horizon_pos hprop hCFL).2]
  field_simp [horizon_pos.ne']

private theorem cell_face_width {N : ℕ} (origin width : ℝ) (cell : Fin N) :
    leveque04_burgersActionFace origin width cell.succ.val -
      leveque04_burgersActionFace origin width cell.castSucc.val = width := by
  simp only [leveque04_burgersActionFace_eq, Fin.val_succ, Fin.val_castSucc, Nat.cast_add, Nat.cast_one]
  ring

private theorem initial_cell_mass {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (cell : Fin N) (hwidth : 0 < width) :
    (∫ x in leveque04_burgersActionFace origin width cell.castSucc.val..
      leveque04_burgersActionFace origin width cell.succ.val,
        leveque04_burgersFiniteActionEvolution old origin width x 0) = old cell.castSucc.succ * width := by
  have hleft := (leveque04_burgersActionFace_mem_adjacent_segments origin width cell.castSucc hwidth).2
  have hright := (leveque04_burgersActionFace_mem_adjacent_segments origin width cell.succ hwidth).1
  have hp := leveque04_burgersInitialPrimitive_sub_on_segment old origin width cell.castSucc.succ
    (leveque04_burgersActionFace origin width cell.succ.val)
    (leveque04_burgersActionFace origin width cell.castSucc.val) hright hleft
  have hi := (leveque04_burgersFiniteActionEvolution_spatial_integral old origin width 0
    (leveque04_burgersActionFace origin width cell.castSucc.val)
    (leveque04_burgersActionFace origin width cell.succ.val) hwidth.le (le_refl 0)).2
  rw [leveque04_burgersFiniteActionForwardPotential_initial,
    leveque04_burgersFiniteActionForwardPotential_initial, hp, cell_face_width] at hi
  exact hi

/-- The terminal means are exactly the existing conservative Godunov step.
Nondegenerate cell geometry and actual spatial integrability are included. -/
theorem leveque04_burgersFiniteActionEvolution_CFL_cell_average {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ) (cell : Fin N)
    (hwidth : 0 < width) (horizon_pos : 0 < horizon)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) :
    IsOneDimensionalCellAverage
      (fun x => leveque04_burgersFiniteActionEvolution old origin width x horizon)
      (leveque04_burgersActionFace origin width cell.castSucc.val)
      (leveque04_burgersActionFace origin width cell.succ.val)
      (leveque04_burgersFiniteGridStep horizon width old cell) := by
  let L := leveque04_burgersActionFace origin width cell.castSucc.val
  let R := leveque04_burgersActionFace origin width cell.succ.val
  have hgap : R - L = width := cell_face_width origin width cell
  have horder : L < R := by linarith
  have hrect := leveque04_burgersFiniteActionEvolution_forwardRectangle
    old origin width L R 0 horizon hwidth.le (le_refl 0) horizon_pos.le
  have hL := leveque04_burgersFiniteActionEvolution_CFL_face_flux_integral
    old origin width horizon bound cell.castSucc hwidth horizon_pos hprop hCFL
  have hR := leveque04_burgersFiniteActionEvolution_CFL_face_flux_integral
    old origin width horizon bound cell.succ hwidth horizon_pos hprop hCFL
  have hmass := initial_cell_mass old origin width cell hwidth
  have hbalance := hrect.2.2.2.2
  rw [intervalIntegral.integral_sub hL.1 hR.1, hL.2, hR.2, hmass] at hbalance
  have hfinal : (∫ x in L..R, leveque04_burgersFiniteActionEvolution old origin width x horizon) =
      old cell.castSucc.succ * width + horizon *
        (leveque04_burgersFiniteGridFlux old cell.castSucc - leveque04_burgersFiniteGridFlux old cell.succ) := by
    linarith [hbalance]
  refine ⟨horder, hrect.2.1, ?_⟩
  unfold leveque04_burgersFiniteGridStep finiteVolumeCellAverageUpdate oneDimensionalCellAverage
  rw [hgap, hfinal]
  simp only [smul_eq_mul]
  field_simp [hwidth.ne']
  ring

end NumStability
