/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PolygonBoundaryIntegral

/-! Proposed conditional finite-interface API. No proof or acceptance is claimed.
The canonical all-polygon geometry producer remains a separate obligation. -/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume.Planar

open Set MeasureTheory

/-- Supplied geometric data for a finite incident interface family. These are
actual nondegenerate segments and actual outward supporting unit normals.
Proper subdivisions of whole polygon sides are allowed. No integrability,
integral identity, nullity or a.e. normal agreement is assumed. -/
def IsPrescribedBoundaryFamily {Face : Type} (K : Polygon) (faces : Finset Face)
    (segments : Face → Segment) (normals : Face → Point) : Prop :=
  frontier K.carrier = ⋃ σ ∈ faces, (segments σ).carrier ∧
  (∀ σ ∈ faces, ∀ τ ∈ faces, σ ≠ τ →
    (segments σ).carrier ∩ (segments τ).carrier ⊆
      (segments σ).endpoints ∪ (segments τ).endpoints) ∧
  ∀ σ ∈ faces, IsOutwardNormal K (segments σ) (normals σ)

/-- Derived local geometry for a supplied finite segment family. This does
not construct the canonical whole-side cover of an arbitrary polygon. -/
def prescribedBoundaryGeometryTarget : Prop :=
  ∀ (Face : Type) (K : Polygon) (faces : Finset Face)
      (segments : Face → Segment) (normals : Face → Point),
    IsPrescribedBoundaryFamily K faces segments normals →
    (∀ σ ∈ faces,
      MeasurableSet (segments σ).carrier ∧
      lengthMeasure (segments σ).carrier = edist (segments σ).a (segments σ).b ∧
      lengthMeasure (segments σ).endpoints = 0 ∧
      (∀ x ∈ (segments σ).carrier \ (segments σ).endpoints,
        polygonBoundaryNormal K x = normals σ) ∧
      (∀ᵐ x ∂(lengthMeasure.restrict (segments σ).carrier),
        polygonBoundaryNormal K x = normals σ)) ∧
    (∀ σ ∈ faces, ∀ τ ∈ faces, σ ≠ τ →
      lengthMeasure ((segments σ).carrier ∩ (segments τ).carrier) = 0)

/-- Scalar finite additivity over the exact supplied incident index. -/
def prescribedBoundaryIntegralTarget : Prop :=
  ∀ (Face : Type) (K : Polygon) (faces : Finset Face)
      (segments : Face → Segment) (normals : Face → Point),
    IsPrescribedBoundaryFamily K faces segments normals →
    ∀ g : Point → ℝ,
      IntegrableOn g (frontier K.carrier) lengthMeasure →
      (∀ σ ∈ faces, IntegrableOn g (segments σ).carrier lengthMeasure) ∧
      (∫ x in frontier K.carrier, g x ∂lengthMeasure) =
        ∑ σ ∈ faces, ∫ x in (segments σ).carrier, g x ∂lengthMeasure

/-- General flux support over the exact supplied incident index. -/
def prescribedBoundaryFluxTarget : Prop :=
  ∀ (Face : Type) (K : Polygon) (faces : Finset Face)
      (segments : Face → Segment) (normals : Face → Point),
    IsPrescribedBoundaryFamily K faces segments normals →
    ∀ (V : Point → Point) (u : Point → ℝ),
      IntegrableOn (fun x => inner ℝ (V x) (polygonBoundaryNormal K x) * u x)
        (frontier K.carrier) lengthMeasure →
      (∀ σ ∈ faces,
        IntegrableOn (fun x => inner ℝ (V x) (normals σ) * u x)
          (segments σ).carrier lengthMeasure) ∧
      (∫ x in frontier K.carrier,
        inner ℝ (V x) (polygonBoundaryNormal K x) * u x ∂lengthMeasure) =
        ∑ σ ∈ faces, ∫ x in (segments σ).carrier,
          inner ℝ (V x) (normals σ) * u x ∂lengthMeasure

/-- The prescribed pieces contained in a given canonical whole side. -/
def prescribedPiecesOnEdge {Face : Type} (faces : Finset Face)
    (segments : Face → Segment) (e : Set Point) : Finset Face :=
  letI : DecidablePred (fun σ => (segments σ).carrier ⊆ e) := Classical.decPred _
  faces.filter (fun σ => (segments σ).carrier ⊆ e)

/-- Genuine correspondence to canonical whole sides, not equality of indices.
Coverage and unique side membership are conclusions. Normal orientation is
identified with the actual canonical support normal. -/
def prescribedCanonicalGeometryTarget : Prop :=
  ∀ (Face : Type) (K : Polygon) (faces : Finset Face)
      (segments : Face → Segment) (normals : Face → Point),
    IsPrescribedBoundaryFamily K faces segments normals →
    (∀ σ ∈ faces, ∃! e : Set Point,
      e ∈ polygonEdgeSets K ∧ (segments σ).carrier ⊆ e ∧
        normals σ = polygonEdgeNormal K e) ∧
    (∀ e ∈ polygonEdgeSets K,
      e = ⋃ σ ∈ prescribedPiecesOnEdge faces segments e, (segments σ).carrier)

/-- Scalar subdivision of each canonical side and equality of the two sums.
No desired integral equality is among the hypotheses. -/
def prescribedCanonicalIntegralTarget : Prop :=
  ∀ (Face : Type) (K : Polygon) (faces : Finset Face)
      (segments : Face → Segment) (normals : Face → Point),
    IsPrescribedBoundaryFamily K faces segments normals →
    ∀ g : Point → ℝ,
      IntegrableOn g (frontier K.carrier) lengthMeasure →
      (∀ e ∈ polygonEdgeSets K,
        (∫ x in e, g x ∂lengthMeasure) =
          ∑ σ ∈ prescribedPiecesOnEdge faces segments e,
            ∫ x in (segments σ).carrier, g x ∂lengthMeasure) ∧
      (∑ e ∈ polygonEdgeSets K, ∫ x in e, g x ∂lengthMeasure) =
        ∑ σ ∈ faces, ∫ x in (segments σ).carrier, g x ∂lengthMeasure

/-- Flux subdivision, including constant canonical-to-prescribed normal
replacement on the actual pieces. This is a separate support conclusion. -/
def prescribedCanonicalFluxTarget : Prop :=
  ∀ (Face : Type) (K : Polygon) (faces : Finset Face)
      (segments : Face → Segment) (normals : Face → Point),
    IsPrescribedBoundaryFamily K faces segments normals →
    ∀ (V : Point → Point) (u : Point → ℝ),
      IntegrableOn (fun x => inner ℝ (V x) (polygonBoundaryNormal K x) * u x)
        (frontier K.carrier) lengthMeasure →
      (∀ e ∈ polygonEdgeSets K,
        (∫ x in e, inner ℝ (V x) (polygonEdgeNormal K e) * u x ∂lengthMeasure) =
          ∑ σ ∈ prescribedPiecesOnEdge faces segments e,
            ∫ x in (segments σ).carrier,
              inner ℝ (V x) (normals σ) * u x ∂lengthMeasure) ∧
      (∑ e ∈ polygonEdgeSets K, ∫ x in e,
        inner ℝ (V x) (polygonEdgeNormal K e) * u x ∂lengthMeasure) =
        ∑ σ ∈ faces, ∫ x in (segments σ).carrier,
          inner ℝ (V x) (normals σ) * u x ∂lengthMeasure

/-- Existing Mesh fields supply exactly the conditional geometry above.
The full-plane Mesh.cover is not used to establish all-polygon geometry. -/
def meshPrescribedBoundaryFamilyTarget : Prop :=
  ∀ (Cell Face : Type) [DecidableEq Face] (M : Mesh Cell Face) (K : Cell),
    IsPrescribedBoundaryFamily (M.polygon K) (M.faces K) M.segment (M.normal K)

/-- Direct scalar specialization at the actual existing Mesh.faces K index. -/
def meshBoundaryIntegralTarget : Prop :=
  ∀ (Cell Face : Type) [DecidableEq Face] (M : Mesh Cell Face) (K : Cell)
      (g : Point → ℝ),
    IntegrableOn g (frontier (M.polygon K).carrier) lengthMeasure →
    (∀ σ ∈ M.faces K, IntegrableOn g (M.segment σ).carrier lengthMeasure) ∧
    (∫ x in frontier (M.polygon K).carrier, g x ∂lengthMeasure) =
      ∑ σ ∈ M.faces K, ∫ x in (M.segment σ).carrier, g x ∂lengthMeasure

end NumStability.FiniteVolume.Planar
