/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import Mathlib.Analysis.Convex.Segment
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.Topology.MetricSpace.HausdorffDistance

/-!
# Rectangular Diffusion

A nondegenerate Euclidean rectangle, with arbitrary orientation and widths.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume

/- Use the identical Point and Segment producers as polygonal transport. -/
open Planar
/-- A rectangle side specified by its normal coordinate and a choice of sign. -/
abbrev RectangleSide2 := Fin 2 × Bool

/-- A nondegenerate Euclidean rectangle, with arbitrary orientation and widths. -/
structure Rectangle2 where
  /-- Center of the rectangle. -/
  center : Point
  /-- Orthonormal coordinate frame of the rectangle. -/
  frame : OrthonormalBasis (Fin 2) ℝ Point
  /-- Half-width in each coordinate direction of the rectangle frame. -/
  halfWidth : Fin 2 → ℝ
  halfWidth_pos : ∀ i, 0 < halfWidth i

/-- Open rectangle defined by the strict frame-coordinate inequalities. -/
def Rectangle2.region (R : Rectangle2) : Set Point :=
  {x | ∀ i, |inner ℝ (R.frame i) (x - R.center)| < R.halfWidth i}

/-- The coordinate axis different from the supplied axis in dimension two. -/
def rectangleOtherAxis2 (i : Fin 2) : Fin 2 := if i = 0 then 1 else 0

/-- Parameterization of a rectangle side along its free coordinate direction. -/
def Rectangle2.sidePoint (R : Rectangle2) (s : RectangleSide2) (t : ℝ) : Point :=
  R.center + (if s.2 then R.halfWidth s.1 else -R.halfWidth s.1) • R.frame s.1 +
    t • R.frame (rectangleOtherAxis2 s.1)

/-- Closed segment forming the selected rectangle side. -/
def Rectangle2.side (R : Rectangle2) (s : RectangleSide2) : Set Point :=
  segment ℝ (R.sidePoint s (-R.halfWidth (rectangleOtherAxis2 s.1)))
    (R.sidePoint s (R.halfWidth (rectangleOtherAxis2 s.1)))

/-- Lebesgue volume of the rectangle region, converted to a real number. -/
def Rectangle2.area (R : Rectangle2) : ℝ :=
  (MeasureTheory.volume R.region).toReal

/-- Distance to this particular segment, rather than to a whole domain boundary. -/
def rectangleFaceDistance (R : Rectangle2) (e : Segment) : ℝ :=
  Metric.infDist R.center e.carrier

/-- Interface pieces are permitted; no whole-side conformity is imposed. -/
def IsRectangleSidePiece (R : Rectangle2) (e : Segment) : Prop :=
  ∃ s : RectangleSide2, e.carrier ⊆ R.side s

/-- The perpendicular foot on the supporting rectangle side lies in this
particular segment. This is automatic for a whole side, but not every side piece.
It records precisely the extra boundary applicability used on raw PDF39. -/
def HasRectangleBoundaryFoot (R : Rectangle2) (e : Segment) : Prop :=
  ∃ s : RectangleSide2, e.carrier ⊆ R.side s ∧ R.sidePoint s 0 ∈ e.carrier

/-- Local geometric applicability of an interior two-point flux.
The last condition states the physical nonzero-denominator domain explicitly;
deriving it from the other geometric conditions is separate support. -/
def IsInteriorRectangleFace (K L : Rectangle2) (e : Segment) : Prop :=
  Disjoint K.region L.region ∧ IsRectangleSidePiece K e ∧
    IsRectangleSidePiece L e ∧ 0 < dist K.center L.center

/-- Local geometric applicability of a homogeneous Dirichlet face flux. -/
def IsBoundaryRectangleFace (K : Rectangle2) (e : Segment) : Prop :=
  IsRectangleSidePiece K e ∧ 0 < rectangleFaceDistance K e

/-- Two-point outward diffusion flux on actual rectangle/segment geometry.
Use `IsInteriorRectangleFace` for its physical applicability. -/
def rectangleInteriorFlux (K L : Rectangle2) (e : Segment)
    (localState neighbourState : ℝ) : ℝ :=
  -(e.length / dist K.center L.center) * (neighbourState - localState)

/-- Homogeneous Dirichlet outward flux, using the particular-face distance.
Use `IsBoundaryRectangleFace` for its physical applicability. -/
def rectangleBoundaryFlux (K : Rectangle2) (e : Segment) (localState : ℝ) : ℝ :=
  (e.length / rectangleFaceDistance K e) * localState

/-- Assembly data needs only finitely many faces at each cell. The index types
need not be globally finite. Geometric/source correspondence is stated separately. -/
structure RectangularDiffusionData (Cell Face : Type*) [DecidableEq Face] where
  /-- Rectangle attached to each cell. -/
  rectangle : Cell → Rectangle2
  /-- Geometric segment attached to each face. -/
  edge : Face → Segment
  /-- Finite face family attached to each rectangular cell. -/
  cellFaces : Cell → Finset Face
  /-- Optional neighbour across a cell face; absence denotes the boundary branch. -/
  neighbour : Cell → Face → Option Cell

/-- Two-point rectangular diffusion flux, including the prescribed boundary branch. -/
def rectangularNumericalFlux {Cell Face : Type*} [DecidableEq Face]
    (M : RectangularDiffusionData Cell Face) (values : Cell → ℝ)
    (K : Cell) (σ : Face) : ℝ :=
  match M.neighbour K σ with
  | some L => rectangleInteriorFlux (M.rectangle K) (M.rectangle L) (M.edge σ)
      (values K) (values L)
  | none => rectangleBoundaryFlux (M.rectangle K) (M.edge σ) (values K)

end NumStability.FiniteVolume
