/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.RectangularDiffusion
import ComputationalMathematics.Analysis.FiniteVolume.CoordinateBalance
import ComputationalMathematics.Analysis.FiniteVolume.EuclideanMeasures
import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.InnerProductSpace.Laplacian
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-!
# Classical flux integrals on nondegenerate Euclidean rectangles

These are transparent definitions and unproved foundation propositions. The
rectangle, its four sides and its positive half-widths are the existing geometric
objects. Surface normalization is the Euclidean H1 convention, not division by
edge length. All differential operators act on the supplied ambient function.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume.RectangleClassicalBalance

open Set MeasureTheory
open scoped BigOperators
open NumStability.FiniteVolume.Planar

/-- Positive-coordinate sides point along the basis vector; negative-coordinate
sides point against it. This is a fixed geometric normal, not an input callback. -/
def outwardNormal (R : Rectangle2) (s : RectangleSide2) : Point :=
  if s.2 then R.frame s.1 else -R.frame s.1

/-- Exact integrated outward flux, with no edge-average normalization. -/
def edgeFlux (R : Rectangle2) (F : Point → Point) (s : RectangleSide2) : ℝ :=
  ∫ x in R.side s, inner ℝ (F x) (outwardNormal R s)
    ∂(EuclideanMeasure.surfaceMeasure 2)

/-- Sum of the four oriented side flux integrals of the vector field. -/
def boundaryFlux (R : Rectangle2) (F : Point → Point) : ℝ :=
  ∑ s : RectangleSide2, edgeFlux R F s

/-- Negative gradient vector field of the scalar potential. -/
def negativeGradient (u : Point → ℝ) (x : Point) : Point :=
  -(gradient u x)

/-- Stationary reuse of the project's actual coordinate divergence. -/
def spatialDivergence (F : Point → Point) (x : Point) : ℝ :=
  CoordinateBalance.divergence (fun y _ => F y) x 0

/-- C2 neighbourhood applicability and the actual pointwise Poisson equation.
The open neighbourhood is ambient and can extend beyond a physical domain. -/
def ClassicalPoissonOn (U : Set Point) (u f : Point → ℝ) : Prop :=
  IsOpen U ∧ ContDiffOn ℝ 2 u U ∧
    ∀ x ∈ U, -(Laplacian.laplacian u x) = f x

/-- Geometry and measure correspondence remain foundation work. In particular,
intersecting closed sides are allowed to share H1-null endpoints. -/
def rectangleGeometryFoundationTarget : Prop :=
  ∀ R : Rectangle2,
    IsOpen R.region ∧ IsCompact (closure R.region) ∧
    frontier R.region = (⋃ s : RectangleSide2, R.side s) ∧
    (EuclideanMeasure.spatialVolume 2) R.region =
      ENNReal.ofReal (4 * R.halfWidth 0 * R.halfWidth 1) ∧
    (∀ s : RectangleSide2,
      ‖outwardNormal R s‖ = 1 ∧ R.side s ⊆ frontier R.region ∧
      (∀ x ∈ R.side s, ∀ y ∈ closure R.region,
        inner ℝ (y - x) (outwardNormal R s) ≤ 0) ∧
      (EuclideanMeasure.surfaceMeasure 2) (R.side s) =
        ENNReal.ofReal (2 * R.halfWidth (rectangleOtherAxis2 s.1))) ∧
    ∀ s t : RectangleSide2, s ≠ t →
      (EuclideanMeasure.surfaceMeasure 2) (R.side s ∩ R.side t) = 0

/-- Bridges between existing coordinate derivatives and the actual Mathlib
gradient/Laplacian, as consequences of C2 regularity, never row premises. -/
def rectangleDerivativeFoundationTarget : Prop :=
  ∀ (U : Set Point) (u : Point → ℝ), IsOpen U → ContDiffOn ℝ 2 u U →
    ContDiffOn ℝ 1 (negativeGradient u) U ∧
    (∀ x ∈ U, gradient u x = WithLp.toLp 2
      (CoordinateBalance.spatialJacobian (fun y _ => u y) x 0)) ∧
    ∀ x ∈ U,
      spatialDivergence (negativeGradient u) x = -(Laplacian.laplacian u x)

/-- The hypotheses imply genuine area/edge integrability; totalized Bochner
integrals are not used as a substitute for this missing foundation. -/
def rectangleIntegrabilityFoundationTarget : Prop :=
  ∀ (R : Rectangle2) (U : Set Point) (u f : Point → ℝ),
    closure R.region ⊆ U → ClassicalPoissonOn U u f →
      IntegrableOn f R.region (EuclideanMeasure.spatialVolume 2) ∧
      IntegrableOn (Laplacian.laplacian u) R.region
        (EuclideanMeasure.spatialVolume 2) ∧
      ∀ s : RectangleSide2,
        IntegrableOn (fun x => inner ℝ (negativeGradient u x) (outwardNormal R s))
          (R.side s) (EuclideanMeasure.surfaceMeasure 2)

/-- Full arbitrary-orientation rectangular Gauss identity. This is an
outstanding substantive foundation proposition, not an assumed certificate. -/
def rectangleGaussFoundationTarget : Prop :=
  ∀ (R : Rectangle2) (U : Set Point) (F : Point → Point),
    IsOpen U → closure R.region ⊆ U → ContDiffOn ℝ 1 F U →
      boundaryFlux R F = ∫ x in R.region, spatialDivergence F x
        ∂(EuclideanMeasure.spatialVolume 2)

end NumStability.FiniteVolume.RectangleClassicalBalance
