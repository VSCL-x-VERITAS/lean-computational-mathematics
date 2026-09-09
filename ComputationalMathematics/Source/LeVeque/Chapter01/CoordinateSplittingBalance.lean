/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate

/-!
# Chapter 1: conservative coordinate splitting

The coordinator-selected logical-grid convention supplies coordinate
connectivity, positive physical cell volumes and shared area-integrated normal
fluxes. Each full-line rule reads the actual intermediate numerical state.
The finite positive-duration schedule covers every direction, in its supplied
order. Repeated directions and larger line stencils remain possible.

Information routines and measured Cartesian grids are explicit specializations.
The general contract requires neither a global chart nor a two-state stencil.
It asserts conservative execution, not an accuracy order or a high-resolution
property. Physical geometry is supplied in the logical case and is proved from
the axis grids in the Cartesian companion, using transverse-coordinate measure.
-/

open scoped BigOperators
open MeasureTheory

namespace NumStability

open CoordinateLineBalance

/-- Every stage consumes the actual prefix output, acts along its coordinate
lines, and conserves supplied-volume mass with exterior shared-face terms. -/
theorem leveque01_coordinateSplittingBalance_sourceContract
    {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]
    (cellVolume : (D → ℤ) → ℝ) (hvolume : ∀ cell, 0 < cellVolume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hduration : ∀ stage ∈ stages, 0 < stage.2) (state : (D → ℤ) → E) :
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ stage ∈ stages, 0 < stage.2) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := sweep cellVolume rule before state
      sweep cellVolume rule stages state =
        sweep cellVolume rule after (advance cellVolume rule d dt current) ∧
      (∀ cell, cellVolume cell • advance cellVolume rule d dt current cell =
        cellVolume cell • current cell - dt • netOutwardFlux rule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, cellVolume (Function.update base d (start + k)) •
          advance cellVolume rule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
          dt • (normalFaceFlux rule d dt current (Function.update base d (start + count)) -
            normalFaceFlux rule d dt current (Function.update base d start))) ∧
      ∀ other base,
        (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, advance cellVolume rule d dt current (Function.update base d j) =
          advance cellVolume rule d dt other (Function.update base d j) := by
  refine ⟨hnonempty, hcover, hduration, ?_⟩
  intro before d dt after hstages
  dsimp only
  refine ⟨?_, advance_mass_balance cellVolume hvolume rule d dt _,
    finite_line_mass_balance cellVolume hvolume rule d dt _, ?_⟩
  · subst stages
    simp [sweep, orderedOperatorSweep, List.foldl_append]
  · intro other base hline
    exact advance_line_local cellVolume rule d dt _ other base hline

/-- Admitted information routines are evaluated on each actual prefix state.
The result, its ordered input and the extracted area-weighted flux agree;
the executed sweep is independent of the off-domain extension. -/
theorem leveque01_coordinateSplittingBalance_information
    {D : Type*} [DecidableEq D] {m : ℕ}
    {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
    {Information : D → Type*}
    (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))
    (cellVolume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (hadmitted : RiemannInformationCoordinate.SweepAdmitted methods cellVolume area fallback stages state) :
    (∀ other, sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area fallback) stages state =
      sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area other) stages state) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      let current := sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area fallback) before state
      ∃ admitted : RiemannInformationCoordinate.FaceAdmitted methods d dt current cell,
        let problem := adjacentCellRiemannProblem (laws d)
          (fun j => current (Function.update cell d j)) (cell d)
        let result := (methods d dt).solve problem admitted
        problem.leftState = current (Function.update cell d (cell d - 1)) ∧
        problem.rightState = current cell ∧
        normalFaceFlux (RiemannInformationCoordinate.guardedRule methods area fallback) d dt current cell =
          area d cell • (methods d dt).numericalFlux ((methods d dt).extract result) := by
  refine ⟨?_, ?_⟩
  · intro other
    exact RiemannInformationCoordinate.sweep_fallback_independent methods cellVolume area
      fallback other stages state hadmitted
  · intro before d dt after hstages cell
    subst stages
    let h := RiemannInformationCoordinate.admission_at_prefix methods cellVolume area fallback
      before d dt after state hadmitted cell
    exact ⟨h, RiemannInformationCoordinate.admitted_face_observation methods area fallback
      d dt _ cell h⟩

/-- The full-line executor specializes to the actual one-dimensional update
on measured Cartesian cells, with measured transverse areas and shared faces. -/
theorem leveque01_coordinateSplittingBalance_cartesian
    {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
    (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (base : D → ℤ) :
    (∀ cell, 0 < CartesianGrid.cellVolume axes cell) ∧
    (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = CartesianGrid.cellVolume axes cell) ∧
    (∀ cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
    (∀ cell : D → ℤ, (axes d).cellRight (cell d) =
      (axes d).cellLeft ((Function.update cell d (cell d + 1)) d)) ∧
    (fun j => advance (CartesianGrid.cellVolume axes)
      (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt state (Function.update base d j)) =
      riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
        (fun j => rule d (Function.update base d j) dt (fun k => state (Function.update base d k))) := by
  exact ⟨CartesianGrid.cellVolume_pos axes, CartesianGrid.cellBox_volume axes,
    CartesianGrid.tangentialFaceBox_volume axes d, CartesianGrid.shared_face_position axes d,
    CartesianCoordinateUpdate.cartesian_full_line_update axes rule d dt state base⟩

end NumStability
