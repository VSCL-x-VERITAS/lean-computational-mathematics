/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError

/-!
# Physical reference flux defects and zero-flux invariance

The signed net face-flux defect retains cancellation before a norm estimate.
All original measured-reference integrability, state and subinterval hypotheses remain.
The zero-flux consequences concern actual physical flux histories and measured cell
means; they do not infer pointwise stationarity or continuum PDE equivalence.
-/

namespace NumStability.FiniteCoordinate
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The signed difference of the two actual numerical-minus-physical face errors.
Physical means are time averages of the same reference on the selected slab. -/
noncomputable def netFluxDefect (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) (s t : ℝ) (cell : Cell) : State :=
  (rule d (t - s) current (data.leftFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t) -
    (rule d (t - s) current (data.rightFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t)

/-- Extracted physical weighted error balance, before any triangle estimate.
The reference retains all its cell/face integrability, state, and subinterval premises. -/
theorem advance_error_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell) :
    data.cellVolume cell • (advance data rule d (t - s) current cell - data.cellMean q cell t) =
      data.cellVolume cell • (current cell - data.cellMean q cell s) +
        (t - s) • netFluxDefect data rule d current q s t cell := by
  have href' := href.2.2.2 s Set.left_mem_uIcc t Set.right_mem_uIcc
  have hb := href'.2 cell
  rw [intervalIntegral.integral_sub (href'.1 cell).1 (href'.1 cell).2] at hb
  rw [smul_sub] at hb
  rw [← cellWidth_smul_oneDimensionalCellAverage _ hst,
    ← cellWidth_smul_oneDimensionalCellAverage _ hst] at hb
  rw [smul_sub, advance_mass_balance, eq_add_of_sub_eq hb]
  unfold netFluxDefect
  module

/-- Only the norm of the NET face error is bounded. Separate face errors may
be large and cancel; no separate per-face asymptotic order is imposed. -/
theorem advance_error_le_net (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound netDefectBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hnet : ‖netFluxDefect data rule d current q s t cell‖ ≤ netDefectBound) :
    ‖advance data rule d (t - s) current cell - data.cellMean q cell t‖ ≤
      oldBound + (t - s) / data.cellVolume cell * netDefectBound := by
  have hb := advance_error_balance data rule d current q href hst cell
  simpa only [add_zero] using
    (norm_le_of_weighted_error_balance (rightError := (0 : State)) (rightBound := 0)
      (data.cellVolume_pos cell) (sub_nonneg.mpr hst.le)
      (by simpa only [sub_zero] using hb) hold hnet (by simp))

end NumStability.FiniteCoordinate

namespace NumStability.FiniteCoordinate
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

theorem faceFlux_eq_zero (data : PhysicalData D Cell Face Point FacePoint m) (d : D)
    (hzero : ∀ face point state, data.normalFlux d face point state = 0)
    (q : Point → ℝ → State) (face : Face) (t : ℝ) : data.faceFlux d q face t = 0 := by
  simp [PhysicalData.faceFlux, hzero]

/-- Zero actual physical face fluxes force every measured cell mean to remain
constant on the reference slab. No differentiability recovery is used. -/
theorem cellMean_eq_of_faceFlux_zero (data : PhysicalData D Cell Face Point FacePoint m) (d : D)
    (q : Point → ℝ → State) {s t : ℝ} (href : data.ReferenceOn d q s t)
    (hzero : ∀ face τ, data.faceFlux d q face τ = 0)
    {u v : ℝ} (hu : u ∈ Set.uIcc s t) (hv : v ∈ Set.uIcc s t) (cell : Cell) :
    data.cellMean q cell v = data.cellMean q cell u := by
  have hb := (href.2.2.2 u hu v hv).2 cell
  have hz : data.cellVolume cell • (data.cellMean q cell v - data.cellMean q cell u) = 0 := by
    simpa only [hzero, sub_self, intervalIntegral.integral_zero] using hb
  have he := congrArg (fun value : State => (data.cellVolume cell)⁻¹ • value) hz
  have hdiff : data.cellMean q cell v - data.cellMean q cell u = 0 := by
    simpa only [smul_smul, inv_mul_cancel₀ (data.cellVolume_pos cell).ne', one_smul, smul_zero] using he
  exact sub_eq_zero.mp hdiff

end NumStability.FiniteCoordinate
