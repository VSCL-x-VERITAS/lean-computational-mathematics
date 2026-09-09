/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalMethodSweep

/-!
# Successive physical directional methods for Chapter 1

This prospective correspondence uses the coordinator-selected logical-grid
interpretation under the recorded goal. Physical cells, shared normal fluxes,
positive admitted stages and conditional reference errors are explicit.
The source does not supply a chart, boundary extension or error rate.
Fresh source-faithfulness review is required for the selected interpretation.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability
open DirectionalFiniteVolume
variable {D : Type*} [DecidableEq D] {m : ℕ}
local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

theorem leveque01_coordinateDirectionalMethods_sourceContract
    {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
    [MeasurableSpace FacePoint] [Fintype D]
    (data : PhysicalData D Point FacePoint m)
    (hdimension : 0 < m)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (admitted : D → Cell → ℝ → (ℤ → State) → Prop)
    (hconstant : ∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hpositive : ∀ stage ∈ stages, 0 < stage.2)
    (initial : Cell → State)
    (reference : List (D × ℝ) → D → ℝ → Point → ℝ → State)
    (oldError faceError : List (D × ℝ) → D → ℝ → Cell → ℝ)
    (hreferences : ∀ before d dt after, stages = before ++ (d, dt) :: after →
      data.ReferenceOn d (reference before d dt) 0 dt)
    (hadmitted : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      admitted d cell dt (fun j => CoordinateLineBalance.sweep data.cellVolume rule before initial
        (Function.update cell d j)))
    (hstates : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      CoordinateLineBalance.sweep data.cellVolume rule before initial cell ∈ data.admissibleStates d)
    (hold : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.sweep data.cellVolume rule before initial cell -
        data.cellMean (reference before d dt) cell 0‖ ≤ oldError before d dt cell)
    (hface : ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      ‖CoordinateLineBalance.normalFaceFlux rule d dt
          (CoordinateLineBalance.sweep data.cellVolume rule before initial) cell -
        faceAverage (data.faceFlux d (reference before d dt)) 0 dt cell‖ ≤ faceError before d dt cell) :
    0 < m ∧
    (∀ d cell point, IsHyperbolicFluxOn (data.normalFlux d cell point) (data.admissibleStates d)) ∧
    (∀ d cell dt value, 0 < dt → value ∈ data.admissibleStates d →
      admitted d cell dt (fun _ => value) →
      Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
      rule d cell dt (fun _ => value) =
        ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell) ∧
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := CoordinateLineBalance.sweep data.cellVolume rule before initial
      0 < dt ∧ data.ReferenceOn d (reference before d dt) 0 dt ∧
      (∀ cell, admitted d cell dt (fun j => current (Function.update cell d j))) ∧
      (∀ cell, current cell ∈ data.admissibleStates d) ∧
      CoordinateLineBalance.sweep data.cellVolume rule stages initial =
        CoordinateLineBalance.sweep data.cellVolume rule after
          (CoordinateLineBalance.advance data.cellVolume rule d dt current) ∧
      (∀ cell, data.cellVolume cell • CoordinateLineBalance.advance data.cellVolume rule d dt current cell =
        data.cellVolume cell • current cell - dt • CoordinateLineBalance.netOutwardFlux rule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, data.cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
        dt • (CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d (start + count)) -
          CoordinateLineBalance.normalFaceFlux rule d dt current (Function.update base d start))) ∧
      (∀ other base, (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, CoordinateLineBalance.advance data.cellVolume rule d dt current (Function.update base d j) =
          CoordinateLineBalance.advance data.cellVolume rule d dt other (Function.update base d j)) ∧
      ∀ cell, ‖CoordinateLineBalance.advance data.cellVolume rule d dt current cell -
          data.cellMean (reference before d dt) cell dt‖ ≤
        oldError before d dt cell + dt / data.cellVolume cell *
          (faceError before d dt cell + faceError before d dt (Function.update cell d (cell d + 1)))) ∧
    (∀ (axes : D → OneDimensionalFiniteVolumeGrid)
      (lineRule : D → Cell → ℝ → (ℤ → State) → State),
      data.cellVolume = CartesianGrid.cellVolume axes →
      rule = CartesianCoordinateUpdate.areaWeightedRule axes lineRule →
      (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = data.cellVolume cell) ∧
      (∀ d cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
      (∀ d dt state base,
        (fun j => CoordinateLineBalance.advance data.cellVolume rule d dt state (Function.update base d j)) =
        riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
          (fun j => lineRule d (Function.update base d j) dt (fun k => state (Function.update base d k)))) ∧
      ∀ d (flux : State → State) (q : ℝ → ℝ → State), IsRectangleConservationLawSolution q flux → ∀ s t,
        IsDirectionalReference data.cellVolume
          (fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d))
          (fun cell τ => CartesianGrid.faceArea axes d cell • flux (q ((axes d).cellLeft (cell d)) τ)) d s t) := by
  exact DirectionalFiniteVolume.directional_splitting_contract data hdimension rule admitted hconstant
    stages hnonempty hcover hpositive initial reference oldError faceError hreferences hadmitted hstates hold hface

end NumStability
