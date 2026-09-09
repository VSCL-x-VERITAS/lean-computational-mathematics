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
  /-- The supplied measurable partition of the physical domain into cells indexed by `D → ℤ`.
  Only its cell regions and domain are used; no chart or Jacobian is read off the indices. -/
  cells : FiniteVolumeCellPartition (D → ℤ) Point
  /-- The volume measure on physical points; it defines cell volumes and cell means. -/
  measure : Measure Point
  positive : ∀ cell, measure (cells.cellRegion cell) ≠ 0
  finite : ∀ cell, measure (cells.cellRegion cell) ≠ ⊤
  /-- The supplied surface measure on face `d cell`, the face of `cell` on its lower side in
  direction `d`, shared with the neighbour `Function.update cell d (cell d - 1)`; the normal flux
  is integrated against it. -/
  faceMeasure : D → (D → ℤ) → Measure FacePoint
  /-- Embedding of the face parameter points of face `d cell` into physical points; `incidence`
  places each image in the closures of both adjacent cell regions. -/
  facePoint : D → (D → ℤ) → FacePoint → Point
  incidence : ∀ d cell point,
    facePoint d cell point ∈ closure (cells.cellRegion (Function.update cell d (cell d - 1))) ∧
    facePoint d cell point ∈ closure (cells.cellRegion cell)
  /-- The declared admissible conserved states for direction `d`: the set on which every normal
  flux in that direction is hyperbolic and in which `ReferenceOn` requires the field to lie. -/
  admissibleStates : D → Set (Fin m → ℝ)
  /-- The actual normal flux function of face `d cell` at face point `point`, sending a conserved
  state to the flux across that face in direction `d`. -/
  normalFlux : D → (D → ℤ) → FacePoint → (Fin m → ℝ) → (Fin m → ℝ)
  hyperbolic : ∀ d cell point, IsHyperbolicFluxOn (normalFlux d cell point) (admissibleStates d)

namespace PhysicalData

variable {Point FacePoint : Type*} [MeasurableSpace Point] [TopologicalSpace Point]
  [MeasurableSpace FacePoint]
variable (data : PhysicalData D Point FacePoint m)

/-- The real volume of `cell`, namely `(data.measure (data.cells.cellRegion cell)).toReal`; it is
positive by `cellVolume_pos` because every cell region has nonzero finite measure. -/
noncomputable def cellVolume (cell : Cell) : ℝ := (data.measure (data.cells.cellRegion cell)).toReal

theorem cellVolume_pos (cell : Cell) : 0 < data.cellVolume cell :=
  ENNReal.toReal_pos (data.positive cell) (data.finite cell)

/-- The volume average (`cellVolumeAverage`) of the physical field `q · t` over the region of
`cell` with respect to `data.measure`; it is the cell mean entering `IsDirectionalReference`. -/
noncomputable def cellMean (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)

/-- The total normal flux through face `d cell` at time `t`: the integral over the face, against
`data.faceMeasure d cell`, of `normalFlux` applied to `q` sampled at the embedded face point.
It is the physical face reference entering `IsDirectionalReference`. -/
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
