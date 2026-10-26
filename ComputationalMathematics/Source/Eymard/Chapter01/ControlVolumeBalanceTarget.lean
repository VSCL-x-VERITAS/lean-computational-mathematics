/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.ConvexPolytopeGeometry
import ComputationalMathematics.Analysis.FiniteVolume.CoordinateBalance
import ComputationalMathematics.Analysis.FiniteVolume.EuclideanMeasures
import ComputationalMathematics.Source.Eymard.Chapter01.GeneralLawTarget
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-!
# Control Volume Balance Target

Reuse the existing actual coordinate partial derivatives, at a dummy time
for this time-independent vector field.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01.ControlVolume

open Set MeasureTheory
open NumStability.FiniteVolume.CoordinateBalance
open NumStability.FiniteVolume.ConvexPolytope

/-- Reuse the existing actual coordinate partial derivatives, at a dummy time
for this time-independent vector field. -/
def spatialDivergence {d : ℕ} (F : Point d → Point d) (x : Point d) : ℝ :=
  divergence (fun y _ => F y) x 0

/-- Pair a vector field with the prescribed outward unit normal at the boundary point. -/
def normalFlux {d : ℕ} (K : Set (Point d))
    (F : Point d → Point d) (x : Point d) : ℝ :=
  inner ℝ (F x) (outwardUnitNormal K x)

/-- Embed a real coordinate into one-dimensional Euclidean space. -/
def point1 (a : ℝ) : Point 1 := WithLp.toLp 2 (fun _ => a)

/-- Open interval in the one-dimensional Euclidean coordinate space. -/
def interval1 (a b : ℝ) : Set (Point 1) :=
  {x | a < x 0 ∧ x 0 < b}

/-- Separate foundation obligations for the chosen normal and actual integrals.
These are consequences to establish, never supplied input contracts. -/
def normalConventionAndIntegrabilityTarget : Prop :=
  ∀ d, IsSourceDimension d → ∀ (K U : Set (Point d))
      (F : Point d → Point d),
    IsOpenConvexPolytope K → IsOpen U → closure K ⊆ U →
      ContDiffOn ℝ 1 F U →
      (∀ᵐ x ∂(NumStability.FiniteVolume.EuclideanMeasure.boundaryMeasure (frontier K)),
        IsOutwardUnitSupport K x (outwardUnitNormal K x)) ∧
      IntegrableOn (spatialDivergence F) K
        (NumStability.FiniteVolume.EuclideanMeasure.spatialVolume d) ∧
      IntegrableOn (normalFlux K F) (frontier K)
        (NumStability.FiniteVolume.EuclideanMeasure.surfaceMeasure d)

/-- Owner-selected classical realization of the opening balance principle.
All bounded nonempty open convex polytopes in dimensions 1,2,3 are included.
Only geometry and C1 neighbourhood regularity are supplied. The divergence
identity is the conclusion. The final clause makes the two d=1 endpoint terms
explicit. The separate foundation proposition above is not an assumption.
No numerical flux, solution existence, weak trace or time balance is asserted. -/
def controlVolumeBalanceTarget : Prop :=
  (∀ d, IsSourceDimension d → ∀ (K U : Set (Point d))
      (F : Point d → Point d),
    IsOpenConvexPolytope K → IsOpen U → closure K ⊆ U →
      ContDiffOn ℝ 1 F U →
      (∫ x in K, spatialDivergence F x
          ∂(NumStability.FiniteVolume.EuclideanMeasure.spatialVolume d)) =
        ∫ x in frontier K, normalFlux K F x
          ∂(NumStability.FiniteVolume.EuclideanMeasure.surfaceMeasure d)) ∧
  (∀ (a b : ℝ) (U : Set (Point 1)) (F : Point 1 → Point 1),
    a < b → IsOpen U → closure (interval1 a b) ⊆ U →
      ContDiffOn ℝ 1 F U →
      (∫ x in frontier (interval1 a b), normalFlux (interval1 a b) F x
          ∂(NumStability.FiniteVolume.EuclideanMeasure.surfaceMeasure 1)) =
        -(F (point1 a) 0) + F (point1 b) 0)

end NumStability.Eymard.Chapter01.ControlVolume
