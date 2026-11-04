/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersPhysicalFluctuations
import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import Mathlib.Algebra.BigOperators.Fin

/-!
# The selected Burgers recipe on a finite block with supplied ghost states

An input `old : Fin (N + 2) → ℝ` contains the left ghost, the `N` interior
cell averages, and the right ghost, in that order. Face `j : Fin (N + 1)`
separates `old j.castSucc` from `old j.succ`. Interior cell `i : Fin N`
has left face `i.castSucc`, right face `i.succ`, and old value
`old i.castSucc.succ`.

Every face uses the actual all-state selected shock/fan field and its physical
zero-ray flux. The isolated time average holds for every positive duration.
The conservative update retains both boundary fluxes; no periodic closure,
state bound, or CFL restriction is imposed on this algebraic recipe.

This module does not identify the updated array with the means of a global
entropy evolution through interacting waves. The actual weak/admissibility
correspondence and physical global REA realization retain their separate
obligations. In particular, neither a half-CFL restriction nor a strict
`step < horizon` hypothesis replaces the source's distinct full-CFL scope.
The selected shock takes its right value on the front; a stationary shock's
physical flux is the common flux of its two traces, not a unique point value.
-/

open scoped BigOperators

namespace NumStability

/-- The actual selected local Riemann field at each physical mesh face.
No Riemann-correctness callback or existence hypothesis is an input. -/
noncomputable def leveque04_burgersFiniteGridField
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width : ℝ)
    (face : Fin (N + 1)) (x time : ℝ) : ℝ :=
  leveque04_burgersSelectedField (old face.castSucc) (old face.succ)
    (x - leveque04_uniformInterface origin width (face.val : ℤ)) time

/-- The physical zero-ray flux of the actual selected face problem. -/
noncomputable def leveque04_burgersFiniteGridFlux
    {N : ℕ} (old : Fin (N + 2) → ℝ) (face : Fin (N + 1)) : ℝ :=
  leveque04_burgersPhysicalInterfaceFlux (old face.castSucc) (old face.succ)

/-- The existing conservative cell-average update with the actual two face
fluxes, on the interior cells only. The supplied ghosts are not updated. -/
noncomputable def leveque04_burgersFiniteGridStep
    {N : ℕ} (duration width : ℝ) (old : Fin (N + 2) → ℝ) (cell : Fin N) : ℝ :=
  finiteVolumeCellAverageUpdate duration width (old cell.castSucc.succ)
    (leveque04_burgersFiniteGridFlux old cell.succ -
      leveque04_burgersFiniteGridFlux old cell.castSucc)

/-- The consecutive physical faces have exactly the supplied uniform width. -/
theorem leveque04_burgersFiniteGrid_cell_width
    {N : ℕ} (origin width : ℝ) (cell : Fin N) :
    leveque04_uniformInterface origin width (cell.succ.val : ℤ) -
        leveque04_uniformInterface origin width (cell.castSucc.val : ℤ) = width := by
  simp only [leveque04_uniformInterface, Fin.val_succ, Fin.val_castSucc,
    Nat.cast_add, Nat.cast_one, Int.cast_natCast, Int.cast_add, Int.cast_one]
  ring

/-- Each actual local field has the prescribed ordered Riemann initial data,
with its explicit right value at the face itself. -/
theorem leveque04_burgersFiniteGridField_initial
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width : ℝ)
    (face : Fin (N + 1)) (x : ℝ) :
    leveque04_burgersFiniteGridField old origin width face x 0 =
      riemannData (old face.castSucc) (old face.succ) (old face.succ)
        (x - leveque04_uniformInterface origin width (face.val : ℤ)) := by
  exact leveque04_burgersSelectedField_initial _ _ _

/-- The actual face ray has the selected interface value at every positive
time, for every real adjacent pair including sonic and stationary cases. -/
theorem leveque04_burgersFiniteGridField_zeroRay
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width : ℝ)
    (face : Fin (N + 1)) (time : ℝ) (htime : 0 < time) :
    leveque04_burgersFiniteGridField old origin width face
        (leveque04_uniformInterface origin width (face.val : ℤ)) time =
      leveque04_burgersSelectedInterfaceState (old face.castSucc) (old face.succ) := by
  simpa only [leveque04_burgersFiniteGridField, sub_self] using
    leveque04_burgersSelectedField_interface (old face.castSucc) (old face.succ)
      time htime

/-- Equation (4.37) at each finite-block face is the genuine isolated
physical time average. The initial endpoint has zero measure. -/
theorem leveque04_burgersFiniteGridFlux_timeAverage
    {N : ℕ} (old : Fin (N + 2) → ℝ) (origin width duration : ℝ)
    (hduration : 0 < duration) (face : Fin (N + 1)) :
    (∫ time in (0 : ℝ)..duration,
      (leveque04_burgersFiniteGridField old origin width face
        (leveque04_uniformInterface origin width (face.val : ℤ)) time) ^ 2 / 2) /
        duration = leveque04_burgersFiniteGridFlux old face := by
  simpa only [leveque04_burgersFiniteGridField, sub_self,
    leveque04_burgersFiniteGridFlux] using
    leveque04_burgersPhysicalInterfaceFlux_timeAverage
      (old face.castSucc) (old face.succ) duration hduration

/-- The same face flux is produced by the existing constructed selected
Riemann method, whose domain contains every ordered scalar pair. -/
theorem leveque04_burgersFiniteGridFlux_eq_selected
    {N : ℕ} (old : Fin (N + 2) → ℝ)
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ state : ℝ,
      law.physicalFlux (fun _ : Fin 1 => state) 0 = state ^ 2 / 2)
    (duration : ℝ) (hduration : 0 < duration) (face : Fin (N + 1)) :
    let method := leveque04_burgersSelectedFluxMethod law hburgers duration hduration
    let problem : HyperbolicRiemannProblem law :=
      { leftState := fun _ => old face.castSucc, rightState := fun _ => old face.succ }
    (method.numericalFluxFromInformation
      (method.extractInformation (method.solve problem trivial))) 0 =
      leveque04_burgersFiniteGridFlux old face := by
  exact leveque04_burgersSelectedFlux_scalar law hburgers
    { leftState := fun _ => old face.castSucc, rightState := fun _ => old face.succ }
    duration hduration

/-- The interior step is (4.4), with explicit right-minus-left face order. -/
theorem leveque04_burgersFiniteGridStep_eq_fluxDifference
    {N : ℕ} (duration width : ℝ) (old : Fin (N + 2) → ℝ) (cell : Fin N) :
    leveque04_burgersFiniteGridStep duration width old cell =
      old cell.castSucc.succ - (duration / width) *
        (leveque04_burgersFiniteGridFlux old cell.succ -
          leveque04_burgersFiniteGridFlux old cell.castSucc) := by
  rfl

/-- The accepted physical fluctuation formula instantiates this very finite
step. Its continuous fans are not replaced by one-speed expansion jumps. -/
theorem leveque04_burgersFiniteGridStep_eq_physicalFluctuationUpdate
    {N : ℕ} (duration width : ℝ) (hduration : 0 < duration) (hwidth : 0 < width)
    (old : Fin (N + 2) → ℝ) (cell : Fin N) :
    leveque04_burgersFiniteGridStep duration width old cell =
      leveque04_burgersPhysicalFluctuationUpdate duration width
        (old cell.castSucc.castSucc) (old cell.castSucc.succ) (old cell.succ.succ) := by
  simpa only [leveque04_burgersFiniteGridStep, finiteVolumeCellAverageUpdate,
    smul_eq_mul, leveque04_burgersFiniteGridFlux] using
    (leveque04_burgersPhysicalFluctuations.2
      (old cell.castSucc.castSucc) (old cell.castSucc.succ) (old cell.succ.succ)
      duration width hduration hwidth).symm

/-- Multiplying by the actual positive cell width gives its integral
conservative balance, with no boundary or CFL assumption. -/
theorem leveque04_burgersFiniteGridStep_cellMass_balance
    {N : ℕ} (duration width : ℝ) (old : Fin (N + 2) → ℝ)
    (hwidth : 0 < width) (cell : Fin N) :
    width * leveque04_burgersFiniteGridStep duration width old cell =
      width * old cell.castSucc.succ - duration *
        (leveque04_burgersFiniteGridFlux old cell.succ -
          leveque04_burgersFiniteGridFlux old cell.castSucc) := by
  simpa only [leveque04_burgersFiniteGridStep, smul_eq_mul] using
    cellVolume_smul_finiteVolumeCellAverageUpdate duration width
      (old cell.castSucc.succ)
      (leveque04_burgersFiniteGridFlux old cell.succ -
        leveque04_burgersFiniteGridFlux old cell.castSucc) hwidth.ne'

private theorem sum_finite_face_differences
    {N : ℕ} (flux : Fin (N + 1) → ℝ) :
    (∑ cell : Fin N, (flux cell.succ - flux cell.castSucc)) =
      flux (Fin.last N) - flux 0 := by
  have hfirst := Fin.sum_univ_succ flux
  have hlast := Fin.sum_univ_castSucc flux
  rw [Finset.sum_sub_distrib]
  linarith

/-- Every interior face cancels in the finite block's mass balance. The
right and left ghost-interface fluxes remain; periodicity is not assumed. -/
theorem leveque04_burgersFiniteGridStep_totalMass_balance
    {N : ℕ} (duration width : ℝ) (old : Fin (N + 2) → ℝ) (hwidth : 0 < width) :
    (∑ cell : Fin N, width * leveque04_burgersFiniteGridStep duration width old cell) =
      (∑ cell : Fin N, width * old cell.castSucc.succ) - duration *
        (leveque04_burgersFiniteGridFlux old (Fin.last N) -
          leveque04_burgersFiniteGridFlux old 0) := by
  simp_rw [leveque04_burgersFiniteGridStep_cellMass_balance duration width old hwidth]
  rw [Finset.sum_sub_distrib, ← Finset.mul_sum, ← Finset.mul_sum,
    sum_finite_face_differences]

end NumStability
