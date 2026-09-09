/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity

/-!
# Physical cells and shared directional fluxes

The physical references and numerical rules are independently supplied.
All admission, positive-step, domain and error hypotheses are explicit.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.DirectionalFiniteVolume

variable {D : Type*} [DecidableEq D] {m : ℕ}

local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

/-- Supplied physical cells and shared normal-face geometry, with actual
directional flux functions hyperbolic on declared admissible states.
No chart, Jacobian, boundary extension or geometry is inferred from indices. -/
structure PhysicalData (D Point FacePoint : Type*) [DecidableEq D]
    [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] (m : ℕ) where
  cells : FiniteVolumeCellPartition (D → ℤ) Point
  measure : Measure Point
  positive : ∀ cell, measure (cells.cellRegion cell) ≠ 0
  finite : ∀ cell, measure (cells.cellRegion cell) ≠ ⊤
  faceMeasure : D → (D → ℤ) → Measure FacePoint
  facePoint : D → (D → ℤ) → FacePoint → Point
  incidence : ∀ d cell point,
    facePoint d cell point ∈ closure (cells.cellRegion (Function.update cell d (cell d - 1))) ∧
    facePoint d cell point ∈ closure (cells.cellRegion cell)
  admissibleStates : D → Set (Fin m → ℝ)
  normalFlux : D → (D → ℤ) → FacePoint → (Fin m → ℝ) → (Fin m → ℝ)
  hyperbolic : ∀ d cell point, IsHyperbolicFluxOn (normalFlux d cell point) (admissibleStates d)

namespace PhysicalData

variable {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
  [MeasurableSpace FacePoint]
variable (data : PhysicalData D Point FacePoint m)

noncomputable def cellVolume (cell : Cell) : ℝ := (data.measure (data.cells.cellRegion cell)).toReal

theorem cellVolume_pos (cell : Cell) : 0 < data.cellVolume cell :=
  ENNReal.toReal_pos (data.positive cell) (data.finite cell)

noncomputable def cellMean (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)

noncomputable def faceFlux (d : D) (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  ∫ point, data.normalFlux d cell point (q (data.facePoint d cell point) t) ∂data.faceMeasure d cell

/-- Actual physical-reference inputs on one finite directional substep.
They do not mention the numerical rule or its output. -/
def ReferenceOn (d : D) (q : Point → ℝ → State) (s t : ℝ) : Prop :=
  (∀ cell, ∀ τ ∈ Set.uIcc s t, IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure) ∧
  (∀ cell, ∀ τ ∈ Set.uIcc s t, Integrable
    (fun point => data.normalFlux d cell point (q (data.facePoint d cell point) τ)) (data.faceMeasure d cell)) ∧
  (∀ cell point, ∀ τ ∈ Set.uIcc s t, q (data.facePoint d cell point) τ ∈ data.admissibleStates d) ∧
  (∀ x ∈ data.cells.domain, ∀ τ ∈ Set.uIcc s t, q x τ ∈ data.admissibleStates d) ∧
  IsDirectionalReference data.cellVolume (data.cellMean q) (data.faceFlux d q) d s t

end PhysicalData

end NumStability.DirectionalFiniteVolume
