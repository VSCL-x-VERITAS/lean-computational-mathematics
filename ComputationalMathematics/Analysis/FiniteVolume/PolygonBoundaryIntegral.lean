/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import ComputationalMathematics.Analysis.FiniteVolume.ConvexPolytopeGeometry
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-! Proposed reusable producer. No theorem, compilation or acceptance is claimed. -/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume.Planar

open Set MeasureTheory

/-- A genuine whole side of the filled polygon, defined by maximality among
straight boundary segments. This is geometry, not an assumed integral formula. -/
def IsMaximalBoundarySegment (K : Polygon) (a b : Point) : Prop :=
  a ≠ b ∧ segment ℝ a b ⊆ frontier K.carrier ∧
    ∀ c d : Point, segment ℝ a b ⊆ segment ℝ c d →
      segment ℝ c d ⊆ frontier K.carrier → segment ℝ c d = segment ℝ a b

/-- All actual whole sides, deduplicated by equality of their closed carriers.
Reversing endpoints cannot double count. Redundant input vertices do not add
proper subsegments of a side. No supplied edge list or coverage certificate. -/
def polygonEdgeSets (K : Polygon) : Finset (Set Point) :=
  letI : DecidablePred (fun p : Point × Point =>
      IsMaximalBoundarySegment K p.1 p.2) := Classical.decPred _
  letI : DecidableEq (Set Point) := Classical.decEq _
  ((K.vertices ×ˢ K.vertices).filter
    (fun p => IsMaximalBoundarySegment K p.1 p.2)).image
      (fun p => segment ℝ p.1 p.2)

/-- Geometric endpoints of an edge, represented among the actual vertices. -/
def polygonEdgeEndpoints (K : Polygon) (e : Set Point) : Set Point :=
  {x | ∃ a ∈ K.vertices, ∃ b ∈ K.vertices,
    a ≠ b ∧ e = segment ℝ a b ∧ (x = a ∨ x = b)}

/-- A whole exposed side and its outward support orientation. -/
def IsPolygonEdgeNormal (K : Polygon) (e : Set Point) (normal : Point) : Prop :=
  ‖normal‖ = 1 ∧ ∃ c : ℝ,
    e = {x | x ∈ K.carrier ∧ inner ℝ x normal = c} ∧
      ∀ x ∈ K.carrier, inner ℝ x normal ≤ c

/-- Normal determined by the polygon and the actual edge. The zero fallback
is totalization only; the geometry contract must prove unique existence. -/
def polygonEdgeNormal (K : Polygon) (e : Set Point) : Point :=
  @dite Point (∃! n, IsPolygonEdgeNormal K e n)
    (Classical.propDecidable _)
    (fun h => Classical.choose h.exists) (fun _ => 0)

/-- Canonical outward unit normal on the topological boundary, with zero at
nonunique points. Vertices are handled by nullity, never pointwise agreement. -/
def polygonBoundaryNormal (K : Polygon) (x : Point) : Point :=
  NumStability.FiniteVolume.ConvexPolytope.outwardUnitNormal K.carrier x

/-- All geometric facts are conclusions. In particular no boundary cover,
intersection-nullity, edge-normal agreement or decomposition is an input. -/
def polygonEdgeGeometryTarget : Prop :=
  ∀ K : Polygon,
    closure K.region = K.carrier ∧
    frontier K.region = frontier K.carrier ∧
    (polygonEdgeSets K).Nonempty ∧
    frontier K.carrier = ⋃ e ∈ polygonEdgeSets K, e ∧
    lengthMeasure (K.vertices : Set Point) = 0 ∧
    (∀ e ∈ polygonEdgeSets K,
      MeasurableSet e ∧
      ∃ a ∈ K.vertices, ∃ b ∈ K.vertices,
        a ≠ b ∧ e = segment ℝ a b ∧
        IsMaximalBoundarySegment K a b ∧ lengthMeasure e = edist a b) ∧
    (∀ e ∈ polygonEdgeSets K, ∀ f ∈ polygonEdgeSets K, e ≠ f →
      e ∩ f ⊆ polygonEdgeEndpoints K e ∩ polygonEdgeEndpoints K f ∧
      lengthMeasure (e ∩ f) = 0) ∧
    (∀ e ∈ polygonEdgeSets K,
      (∃! n, IsPolygonEdgeNormal K e n) ∧
      IsPolygonEdgeNormal K e (polygonEdgeNormal K e) ∧
      (∀ x ∈ e \ polygonEdgeEndpoints K e,
        polygonBoundaryNormal K x = polygonEdgeNormal K e) ∧
      (∀ᵐ x ∂(lengthMeasure.restrict e),
        polygonBoundaryNormal K x = polygonEdgeNormal K e))

/-- Finite boundary additivity on every bounded full-dimensional convex
polygon. Integrability is the explicit L1 applicability condition. -/
def polygonBoundaryIntegralTarget : Prop :=
  ∀ (K : Polygon) (g : Point → ℝ),
    IntegrableOn g (frontier K.carrier) lengthMeasure →
    (∀ e ∈ polygonEdgeSets K, IntegrableOn g e lengthMeasure) ∧
    (∫ x in frontier K.carrier, g x ∂lengthMeasure) =
      ∑ e ∈ polygonEdgeSets K, ∫ x in e, g x ∂lengthMeasure

/-- Exact flux specialization. V and u are pointwise boundary data, not
equivalence classes for planar volume. No integrability of edge fluxes is
assumed: it is a conclusion after a.e. normal agreement. -/
def polygonBoundaryFluxTarget : Prop :=
  ∀ (K : Polygon) (V : Point → Point) (u : Point → ℝ),
    IntegrableOn (fun x => inner ℝ (V x) (polygonBoundaryNormal K x) * u x)
      (frontier K.carrier) lengthMeasure →
    (∀ e ∈ polygonEdgeSets K,
      IntegrableOn (fun x => inner ℝ (V x) (polygonEdgeNormal K e) * u x)
        e lengthMeasure) ∧
    (∫ x in frontier K.carrier,
      inner ℝ (V x) (polygonBoundaryNormal K x) * u x ∂lengthMeasure) =
      ∑ e ∈ polygonEdgeSets K, ∫ x in e,
        inner ℝ (V x) (polygonEdgeNormal K e) * u x ∂lengthMeasure

end NumStability.FiniteVolume.Planar
