/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import ComputationalMathematics.Analysis.FiniteVolume.ConvexPolytopeGeometry
import ComputationalMathematics.Analysis.FiniteVolume.CoordinateBalance
import ComputationalMathematics.Analysis.FiniteVolume.EuclideanMeasures
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-!
# Classical planar transport balance: proposed mathematical interfaces

All fields below are actual supplied functions. Derivatives are the existing
coordinate derivatives. Normal and measures are fixed geometrically. Targets
are transparent propositions, without proof or mathematical acceptance.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume.ClassicalPlanarTransport

open Set MeasureTheory
open NumStability.FiniteVolume
open CoordinateBalance ConvexPolytope

/-- A nonempty open interval contained in strictly positive times; unbounded
intervals are permitted. Order convexity is the interval property in R. -/
def IsPositiveOpenInterval (I : Set ℝ) : Prop :=
  I.Nonempty ∧ IsOpen I ∧ OrdConnected I ∧ I ⊆ Ioi 0

/-- Actual scalar-state flux with the full authorized time-dependent velocity. -/
def flux (V : Point 2 → ℝ → Point 2) (u : Point 2 → ℝ → ℝ)
    (x : Point 2) (t : ℝ) : Point 2 := u x t • V x t

/-- Explicit embedding of the original spatial velocity; not a restriction
on the primary time-dependent velocity domain. -/
@[nolint unusedArguments] -- The time argument is part of the constant-in-time field interface.
def constantTimeVelocity (v : Point 2 → Point 2) : Point 2 → ℝ → Point 2 :=
  fun x _ => v x

/-- Joint C1 regularity of the state and time-dependent velocity on the space-time product. -/
def C1On (U : Set (Point 2)) (I : Set ℝ)
    (u : Point 2 → ℝ → ℝ) (V : Point 2 → ℝ → Point 2) : Prop :=
  ContDiffOn ℝ 1 (fun z : Point 2 × ℝ => u z.1 z.2) (U.prod I) ∧
  ContDiffOn ℝ 1 (fun z : Point 2 × ℝ => V z.1 z.2) (U.prod I)

/-- The prescribed outward scalar flux. The zero convention at polygon
vertices is immaterial only after the separate a.e. geometry fact is proved. -/
def boundaryFlux (K : Planar.Polygon) (u : Point 2 → ℝ → ℝ)
    (V : Point 2 → ℝ → Point 2) (t : ℝ) (x : Point 2) : ℝ :=
  inner ℝ (V x t) (outwardUnitNormal K.region x) * u x t

/-- Literal integral of u_t, plus outward vu flux; no time derivative of a
cell integral occurs. Area is canonical planar Lebesgue volume and the
surface measure at d=2 is exactly H1. -/
def BalanceAt (K : Planar.Polygon) (u : Point 2 → ℝ → ℝ)
    (V : Point 2 → ℝ → Point 2) (t : ℝ) : Prop :=
  (∫ x in K.region, timePartial u x t ∂(EuclideanMeasure.spatialVolume 2)) +
    (∫ x in frontier K.region, boundaryFlux K u V t x
      ∂(EuclideanMeasure.surfaceMeasure 2)) = 0

/-- Foundation only: finite-hull polygons represent open full-dimensional
polytopes, with the expected compact closure and outward normal a.e.
This proposition is an obligation, never an assumption of the source target. -/
def polygonGeometryTarget : Prop :=
  ∀ K : Planar.Polygon,
    IsOpenConvexPolytope K.region ∧ IsCompact (closure K.region) ∧
    closure K.region = K.carrier ∧ frontier K.region = frontier K.carrier ∧
    (∀ᵐ x ∂(EuclideanMeasure.boundaryMeasure (frontier K.region)),
      IsOutwardUnitSupport K.region x (outwardUnitNormal K.region x))

/-- Foundation only: actual C1 fields supply actual derivatives and genuine
integrability. No PDE or integral balance is assumed. -/
def classicalApplicabilityTarget : Prop :=
  ∀ (K : Planar.Polygon) (U : Set (Point 2)) (I : Set ℝ)
      (u : Point 2 → ℝ → ℝ) (V : Point 2 → ℝ → Point 2),
    IsOpen U → closure K.region ⊆ U → IsPositiveOpenInterval I →
    C1On U I u V → ∀ t ∈ I,
      (∀ x ∈ U, PartialsExistAt u (flux V u) x t) ∧
      ContDiffOn ℝ 1 (fun x => flux V u x t) U ∧
      IntegrableOn (fun x => timePartial u x t) K.region
        (EuclideanMeasure.spatialVolume 2) ∧
      IntegrableOn (fun x => divergence (flux V u) x t) K.region
        (EuclideanMeasure.spatialVolume 2) ∧
      IntegrableOn (boundaryFlux K u V t) (frontier K.region)
        (EuclideanMeasure.surfaceMeasure 2)

/-- Separate foundation contract for arbitrary planar convex polygons.
The existing controlVolumeBalanceTarget's d=2 clause is a reusable proposed
upstream obligation. It is not an input assumption of the transport target. -/
def planarDivergenceTarget : Prop :=
  ∀ (K : Planar.Polygon) (U : Set (Point 2)) (F : Point 2 → Point 2),
    IsOpen U → closure K.region ⊆ U → ContDiffOn ℝ 1 F U →
    (∫ x in K.region, divergence (fun y _ => F y) x 0
      ∂(EuclideanMeasure.spatialVolume 2)) =
      ∫ x in frontier K.region, inner ℝ (F x) (outwardUnitNormal K.region x)
        ∂(EuclideanMeasure.surfaceMeasure 2)

end NumStability.FiniteVolume.ClassicalPlanarTransport
