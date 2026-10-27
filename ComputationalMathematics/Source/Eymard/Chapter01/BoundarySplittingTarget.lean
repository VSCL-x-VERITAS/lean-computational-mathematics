/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PrescribedBoundaryIntegral
import ComputationalMathematics.Analysis.FiniteVolume.PlanarUpwindFlux

/-! Example 1.1 (1.4), specificity-20261026, uncompiled successor proposal.
Separate generic geometry/flux/refinement support is not credited as a
conclusion of the named source target below. -/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01

open Set MeasureTheory
open NumStability.FiniteVolume.Planar

/-- Printed velocity/state specialization over canonical whole polygon sides. -/
def canonicalBoundaryTimeFluxTarget : Prop :=
  ∀ (K : Polygon) (v : SpatialVelocity) (step : PositiveStep)
      (u : ℕ → Point → ℝ) (n : ℕ),
    IntegrableOn
      (fun x => inner ℝ (constantTimeLift v x (timeLevel step n))
        (polygonBoundaryNormal K x) * u n x)
      (frontier K.carrier) lengthMeasure →
    (∀ e ∈ polygonEdgeSets K,
      IntegrableOn (fun x => inner ℝ (constantTimeLift v x (timeLevel step n))
        (polygonEdgeNormal K e) * u n x) e lengthMeasure) ∧
    (∫ x in frontier K.carrier,
      inner ℝ (constantTimeLift v x (timeLevel step n))
        (polygonBoundaryNormal K x) * u n x ∂lengthMeasure) =
      ∑ e ∈ polygonEdgeSets K, ∫ x in e,
        inner ℝ (constantTimeLift v x (timeLevel step n))
          (polygonEdgeNormal K e) * u n x ∂lengthMeasure

/-- Same printed identity over any supplied finite genuine segment partition,
retaining its prescribed interface indices and supplied geometric normals. -/
def prescribedBoundaryTimeFluxTarget : Prop :=
  ∀ (Face : Type) (K : Polygon) (faces : Finset Face)
      (segments : Face → Segment) (normals : Face → Point),
    IsPrescribedBoundaryFamily K faces segments normals →
    ∀ (v : SpatialVelocity) (step : PositiveStep)
        (u : ℕ → Point → ℝ) (n : ℕ),
      IntegrableOn
        (fun x => inner ℝ (constantTimeLift v x (timeLevel step n))
          (polygonBoundaryNormal K x) * u n x)
        (frontier K.carrier) lengthMeasure →
      (∀ σ ∈ faces,
        IntegrableOn (fun x => inner ℝ (constantTimeLift v x (timeLevel step n))
          (normals σ) * u n x) (segments σ).carrier lengthMeasure) ∧
      (∫ x in frontier K.carrier,
        inner ℝ (constantTimeLift v x (timeLevel step n))
          (polygonBoundaryNormal K x) * u n x ∂lengthMeasure) =
        ∑ σ ∈ faces, ∫ x in (segments σ).carrier,
          inner ℝ (constantTimeLift v x (timeLevel step n))
            (normals σ) * u n x ∂lengthMeasure

/-- Direct prescribed-index specialization using the actual current Mesh. -/
def meshBoundaryTimeFluxTarget : Prop :=
  ∀ (Cell Face : Type) [DecidableEq Face] (M : Mesh Cell Face) (K : Cell)
      (v : SpatialVelocity) (step : PositiveStep) (u : ℕ → Point → ℝ) (n : ℕ),
    IntegrableOn
      (fun x => inner ℝ (constantTimeLift v x (timeLevel step n))
        (polygonBoundaryNormal (M.polygon K) x) * u n x)
      (frontier (M.polygon K).carrier) lengthMeasure →
    (∀ σ ∈ M.faces K,
      IntegrableOn (fun x => inner ℝ (constantTimeLift v x (timeLevel step n))
        (M.normal K σ) * u n x) (M.segment σ).carrier lengthMeasure) ∧
    (∫ x in frontier (M.polygon K).carrier,
      inner ℝ (constantTimeLift v x (timeLevel step n))
        (polygonBoundaryNormal (M.polygon K) x) * u n x ∂lengthMeasure) =
      ∑ σ ∈ M.faces K, ∫ x in (M.segment σ).carrier,
        inner ℝ (constantTimeLift v x (timeLevel step n))
          (M.normal K σ) * u n x ∂lengthMeasure

/-- Exact source bundle: canonical and prescribed-index scalar splitting,
their printed time-flux specializations, and direct current-Mesh instances.
All edge-integrability clauses displayed by these six conjuncts are included.
Geometry, arbitrary-V flux support and refinement targets are separate support;
none is silently claimed as a consequence of this source target. -/
def boundarySplittingTarget : Prop :=
  polygonBoundaryIntegralTarget ∧
  prescribedBoundaryIntegralTarget ∧
  meshBoundaryIntegralTarget ∧
  canonicalBoundaryTimeFluxTarget ∧
  prescribedBoundaryTimeFluxTarget ∧
  meshBoundaryTimeFluxTarget

end NumStability.Eymard.Chapter01
