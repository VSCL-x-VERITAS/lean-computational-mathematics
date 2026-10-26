/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.RectangleFullSide
import ComputationalMathematics.Analysis.FiniteVolume.SegmentSupportingFoot
import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-!
# Rectangle Hessian Flux Estimate

The actual oriented centre-to-centre normal. Its unit length and outward
orientation are geometric conclusions below, not fields of an input record.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume.RectangleHessianFluxEstimate

open Set MeasureTheory
open NumStability.FiniteVolume.Planar

/-- The actual oriented centre-to-centre normal. Its unit length and outward
orientation are geometric conclusions below, not fields of an input record. -/
def centreNormal (K L : Rectangle2) : Point :=
  (dist K.center L.center)⁻¹ • (L.center - K.center)

/-- Local cell diameter parameter, using the actual closed rectangle regions. -/
def diameterSize (K L : Rectangle2) : ℝ :=
  max (Metric.diam (closure K.region)) (Metric.diam (closure L.region))

/-- Maximum of the four physical side lengths of the two selected rectangles. -/
def edgeSize (K L : Rectangle2) : ℝ :=
  max (max (2 * K.halfWidth 0) (2 * K.halfWidth 1))
    (max (2 * L.halfWidth 0) (2 * L.halfWidth 1))

/-- Classical regularity and a bound on the actual second Frechet derivative
at every point of the whole selected open convex neighbourhood. The nested
continuous-linear-map operator norm is the bilinear Hessian operator norm. -/
def HasBoundedHessianOn (U : Set Point) (u : Point → ℝ) (M : ℝ) : Prop :=
  IsOpen U ∧ Convex ℝ U ∧ ContDiffOn ℝ 2 u U ∧ 0 ≤ M ∧
    ∀ x ∈ U, ‖fderiv ℝ (fderiv ℝ u) x‖ ≤ M

/-- Exact integrated outward diffusive flux with the existing physical H1
length measure. No boundary callback or normal-derivative input is supplied. -/
def exactFlux (K L : Rectangle2) (σ : Segment) (u : Point → ℝ) : ℝ :=
  -(∫ x in σ.carrier, inner ℝ (gradient u x) (centreNormal K L) ∂lengthMeasure)

/-- Numerical flux evaluated at the exact point values, using the canonical
rectangle two-point flux producer. -/
def numericalFlux (K L : Rectangle2) (σ : Segment) (u : Point → ℝ) : ℝ :=
  rectangleInteriorFlux K L σ (u K.center) (u L.center)

/-- Absolute difference between numerical and exact flux, divided by the face length. -/
def normalizedError (K L : Rectangle2) (σ : Segment) (u : Point → ℝ) : ℝ :=
  |numericalFlux K L σ u - exactFlux K L σ u| / σ.length

/-- Reusable geometric obligations for full common sides. Frames of K and L
are independent arbitrary orthonormal frames. None of these conclusions is
assumed by the source target. -/
def fullSideGeometryTarget : Prop :=
  ∀ (K L : Rectangle2) (σ : Segment),
    Disjoint K.region L.region →
    NumStability.Eymard.Chapter01.IsFullCommonRectangleSide K L σ →
      0 < dist K.center L.center ∧ 0 < σ.length ∧
      ‖centreNormal K L‖ = 1 ∧
      inner ℝ (L.center - K.center) (σ.b - σ.a) = 0 ∧
      segmentSupportingFoot σ K.center ∈ σ.carrier ∧
      segmentSupportingFoot σ K.center ∈ segment ℝ K.center L.center ∧
      σ.carrier ⊆ frontier K.region ∧
      (∀ x ∈ closure K.region, ∀ y ∈ σ.carrier,
        inner ℝ (x - y) (centreNormal K L) ≤ 0) ∧
      (∀ x ∈ closure L.region, ∀ y ∈ σ.carrier,
        0 ≤ inner ℝ (x - y) (centreNormal K L)) ∧
      (∀ p ∈ segment ℝ K.center L.center, ∀ q ∈ σ.carrier,
        dist p q ≤ diameterSize K L) ∧
      diameterSize K L ≤ Real.sqrt 2 * edgeSize K L ∧
      lengthMeasure σ.carrier = ENNReal.ofReal σ.length

/-- Derivative/measure consequences needed by the estimate. These are separate
unproved propositions, never prerequisites supplied as certificates. -/
def analyticFoundationTarget : Prop :=
  ∀ (K L : Rectangle2) (σ : Segment) (U : Set Point)
    (u : Point → ℝ) (M : ℝ),
    Disjoint K.region L.region →
    NumStability.Eymard.Chapter01.IsFullCommonRectangleSide K L σ →
    closure K.region ∪ closure L.region ⊆ U → HasBoundedHessianOn U u M →
      (∀ x ∈ U, ∀ y ∈ U, ‖gradient u y - gradient u x‖ ≤ M * ‖y - x‖) ∧
      IntegrableOn (fun x => inner ℝ (gradient u x) (centreNormal K L))
        σ.carrier lengthMeasure

end NumStability.FiniteVolume.RectangleHessianFluxEstimate
