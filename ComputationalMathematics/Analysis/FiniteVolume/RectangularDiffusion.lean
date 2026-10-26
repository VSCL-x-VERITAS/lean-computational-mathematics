/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import Mathlib.Analysis.Convex.Segment
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.Topology.MetricSpace.HausdorffDistance

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume

/- Use the identical Point and Segment producers as polygonal transport. -/
open Planar
abbrev RectangleSide2 := Fin 2 × Bool

/-- A nondegenerate Euclidean rectangle, with arbitrary orientation and widths. -/
structure Rectangle2 where
  center : Point
  frame : OrthonormalBasis (Fin 2) ℝ Point
  halfWidth : Fin 2 → ℝ
  halfWidth_pos : ∀ i, 0 < halfWidth i

def Rectangle2.region (R : Rectangle2) : Set Point :=
  {x | ∀ i, |inner ℝ (R.frame i) (x - R.center)| < R.halfWidth i}

def rectangleOtherAxis2 (i : Fin 2) : Fin 2 := if i = 0 then 1 else 0

def Rectangle2.sidePoint (R : Rectangle2) (s : RectangleSide2) (t : ℝ) : Point :=
  R.center + (if s.2 then R.halfWidth s.1 else -R.halfWidth s.1) • R.frame s.1 +
    t • R.frame (rectangleOtherAxis2 s.1)

def Rectangle2.side (R : Rectangle2) (s : RectangleSide2) : Set Point :=
  segment ℝ (R.sidePoint s (-R.halfWidth (rectangleOtherAxis2 s.1)))
    (R.sidePoint s (R.halfWidth (rectangleOtherAxis2 s.1)))

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
  rectangle : Cell → Rectangle2
  edge : Face → Segment
  cellFaces : Cell → Finset Face
  neighbour : Cell → Face → Option Cell

def rectangularNumericalFlux {Cell Face : Type*} [DecidableEq Face]
    (M : RectangularDiffusionData Cell Face) (values : Cell → ℝ)
    (K : Cell) (σ : Face) : ℝ :=
  match M.neighbour K σ with
  | some L => rectangleInteriorFlux (M.rectangle K) (M.rectangle L) (M.edge σ)
      (values K) (values L)
  | none => rectangleBoundaryFlux (M.rectangle K) (M.edge σ) (values K)

end NumStability.FiniteVolume
