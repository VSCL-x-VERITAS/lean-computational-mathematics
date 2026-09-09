/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage

/-!
Actual measured active cells and shared physical faces, with incidence required almost everywhere under the face measure.
-/

open MeasureTheory
open scoped BigOperators
namespace NumStability.FiniteCoordinate

/-- Finite active physical cells with shared face IDs. Exterior faces require
incidence with their active cell only; no fictitious exterior physical cell
or unspecified boundary condition is introduced. -/
structure PhysicalData (D Cell Face Point FacePoint : Type*)
    [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] (m : ℕ) where
  /-- The measurable partition of the physical domain whose cells are exactly the active cells;
  `cells.cellRegion cell` is the region owned by `cell`. -/
  cells : FiniteVolumeCellPartition Cell Point
  /-- The volume measure on physical points; its value on a cell region is that cell's volume. -/
  measure : Measure Point
  positive : ∀ cell, measure (cells.cellRegion cell) ≠ 0
  finite : ∀ cell, measure (cells.cellRegion cell) ≠ ⊤
  /-- The ID of the face on the left (lower) side of a cell in direction `d`. Neighbouring cells
  report the same ID for their shared face, so one numerical flux serves both incident cells. -/
  leftFace : D → Cell → Face
  /-- The ID of the face on the right (upper) side of a cell in direction `d`, oriented so that a
  directional update subtracts the `leftFace` flux from the `rightFace` flux. -/
  rightFace : D → Cell → Face
  /-- The surface measure on the face-parametrising points of each face in direction `d`; face
  integrals such as `faceFlux` are taken against it. -/
  faceMeasure : D → Face → Measure FacePoint
  /-- Embeds a face-parametrising point of a face in direction `d` into the physical domain. The
  incidence fields require these images to lie in the closure of the incident cell almost
  everywhere under `faceMeasure`. -/
  facePoint : D → Face → FacePoint → Point
  left_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (leftFace d cell),
    facePoint d (leftFace d cell) point ∈ closure (cells.cellRegion cell)
  right_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (rightFace d cell),
    facePoint d (rightFace d cell) point ∈ closure (cells.cellRegion cell)
  /-- The set of admissible conserved-variable states in direction `d`, on which the normal flux
  is required to be hyperbolic. -/
  admissibleStates : D → Set (Fin m → ℝ)
  /-- The physical flux normal to a face in direction `d`, as a function of the face point and the
  conserved state there; it is the integrand of `faceFlux`. -/
  normalFlux : D → Face → FacePoint → (Fin m → ℝ) → Fin m → ℝ
  hyperbolic : ∀ d face point, IsHyperbolicFluxOn (normalFlux d face point) (admissibleStates d)

variable {D Cell Face Point FacePoint : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The real volume of an active cell: the value of `data.measure` on the cell's region, which is
nonzero and finite by `positive` and `finite`, converted to a real number (`cellVolume_pos`). -/
noncomputable def PhysicalData.cellVolume (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : ℝ := (data.measure (data.cells.cellRegion cell)).toReal

theorem PhysicalData.cellVolume_pos (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : 0 < data.cellVolume cell := ENNReal.toReal_pos (data.positive cell) (data.finite cell)

/-- The exact cell average at time `t` of the space-time state field `q` over an active cell:
the `cellVolumeAverage` of `q · t` on the cell's region with respect to `data.measure`. -/
noncomputable def PhysicalData.cellMean (data : PhysicalData D Cell Face Point FacePoint m)
    (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)

/-- The exact total normal flux through `face` in direction `d` at time `t`: the integral, against
the face measure, of `normalFlux` evaluated at the trace of `q` on the face via `facePoint`. -/
noncomputable def PhysicalData.faceFlux (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (face : Face) (t : ℝ) : State :=
  ∫ point, data.normalFlux d face point (q (data.facePoint d face point) t) ∂data.faceMeasure d face


end NumStability.FiniteCoordinate
