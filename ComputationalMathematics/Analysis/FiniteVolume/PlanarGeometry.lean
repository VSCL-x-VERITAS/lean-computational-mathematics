/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.OpenClosureCover
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Topology
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.MeasureTheory.Measure.Hausdorff

/-!
# Planar Geometry

The Euclidean plane, with its Euclidean metric and inner product.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.FiniteVolume.Planar

open Set MeasureTheory

/-- The Euclidean plane, with its Euclidean metric and inner product. -/
abbrev Point := EuclideanSpace ℝ (Fin 2)

/-- A filled nondegenerate bounded convex polygon, represented by its vertices. -/
structure Polygon where
  /-- Finite vertex set whose convex hull determines the polygon. -/
  vertices : Finset Point
  interior_nonempty : (interior (convexHull ℝ (vertices : Set Point))).Nonempty

/-- Closed filled polygon. -/
def Polygon.carrier (K : Polygon) : Set Point :=
  convexHull ℝ (K.vertices : Set Point)

/-- Open control-volume convention; the polygon boundary is excluded. -/
def Polygon.region (K : Polygon) : Set Point :=
  interior K.carrier

/-- An actual nondegenerate closed Euclidean segment. -/
structure Segment where
  /-- First endpoint of the nondegenerate segment. -/
  a : Point
  /-- Second endpoint of the nondegenerate segment. -/
  b : Point
  nondegenerate : a ≠ b

/-- Closed segment joining the two endpoints. -/
def Segment.carrier (σ : Segment) : Set Point :=
  segment ℝ σ.a σ.b

/-- Set consisting of the two segment endpoints. -/
def Segment.endpoints (σ : Segment) : Set Point :=
  {σ.a, σ.b}

/-- Physical Euclidean length of the shared segment. The pinned
`MeasureTheory.Measure.hausdorffMeasure_segment` identifies H1 of its carrier
with `edist a b`; its real-valued adaptation is separate support. -/
def Segment.length (σ : Segment) : ℝ :=
  dist σ.a σ.b

/-- A genuine outward unit normal along a straight polygon boundary segment.
The supporting-halfspace condition fixes the outward orientation. -/
def IsOutwardNormal (K : Polygon) (σ : Segment) (normal : Point) : Prop :=
  ‖normal‖ = 1 ∧ σ.carrier ⊆ frontier K.carrier ∧
    inner ℝ (σ.b - σ.a) normal = 0 ∧
    ∀ x ∈ K.carrier, inner ℝ (x - σ.a) normal ≤ 0

/-- One-dimensional Hausdorff measure for Euclidean segment length. -/
def lengthMeasure : Measure Point :=
  Measure.hausdorffMeasure 1

/-- A full-plane polygon mesh with finite incident faces per cell.
Faces may be nondegenerate interface pieces of polygon sides. Distinct faces
of one cell overlap only at endpoints. Neither global index type is finite.
The normal and neighbour contracts are geometric input data; reversal of
normals and antisymmetry of numerical fluxes are not fields. -/
structure Mesh (Cell Face : Type) [DecidableEq Face] where
  /-- Polygon assigned to each cell. -/
  polygon : Cell → Polygon
  /-- Geometric segment assigned to each face. -/
  segment : Face → Segment
  /-- Finite family of faces incident to each cell. -/
  faces : Cell → Finset Face
  /-- Normal vector assigned to each oriented cell-and-face pair. -/
  normal : Cell → Face → Point
  cover : NumStability.FiniteVolume.IsOpenClosureCover
    (univ : Set Point) (Set.range (fun K => (polygon K).region))
  disjoint : ∀ K L, K ≠ L → Disjoint (polygon K).region (polygon L).region
  boundary_cover : ∀ K,
    frontier (polygon K).carrier = ⋃ σ ∈ faces K, (segment σ).carrier
  intersections : ∀ K σ τ, σ ∈ faces K → τ ∈ faces K → σ ≠ τ →
    (segment σ).carrier ∩ (segment τ).carrier ⊆
      (segment σ).endpoints ∪ (segment τ).endpoints
  outward : ∀ K σ, σ ∈ faces K →
    IsOutwardNormal (polygon K) (segment σ) (normal K σ)
  /-- Neighbour selected across an oriented cell face. -/
  neighbour : Cell → Face → Cell
  neighbour_ne : ∀ K σ, σ ∈ faces K → neighbour K σ ≠ K
  neighbour_incident : ∀ K σ, σ ∈ faces K → σ ∈ faces (neighbour K σ)
  neighbour_back : ∀ K σ, σ ∈ faces K → neighbour (neighbour K σ) σ = K
  only_two : ∀ K σ L, σ ∈ faces K → σ ∈ faces L → L = K ∨ L = neighbour K σ

/-- Actual planar Lebesgue area of the open polygon region. -/
def cellArea {Cell Face : Type} [DecidableEq Face]
    (M : Mesh Cell Face) (K : Cell) : ℝ :=
  (volume (M.polygon K).region).toReal

end NumStability.FiniteVolume.Planar
