/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.CoordinateBalance
import Mathlib.Analysis.Convex.Topology

/-!
# Convex Polytope Geometry

The open full-dimensional part of a finite Euclidean convex hull.
Nonempty interior excludes lower-dimensional and empty polytopes.
Finite convex hulls are compact; the region is therefore bounded.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.FiniteVolume.ConvexPolytope

open Set
open NumStability.FiniteVolume.CoordinateBalance

/-- The open full-dimensional part of a finite Euclidean convex hull.
Nonempty interior excludes lower-dimensional and empty polytopes.
Finite convex hulls are compact; the region is therefore bounded. -/
def IsOpenConvexPolytope {d : ℕ} (K : Set (Point d)) : Prop :=
  K.Nonempty ∧ ∃ vertices : Finset (Point d),
    K = interior (convexHull ℝ (vertices : Set (Point d)))

/-- A unit vector supporting the actual closed region at x, directed outward.
The sign says that the entire region lies on the inward side of the plane.
At smooth boundary points of a convex polytope this unit vector is unique. -/
def IsOutwardUnitSupport {d : ℕ} (K : Set (Point d))
    (x n : Point d) : Prop :=
  x ∈ frontier K ∧ ‖n‖ = 1 ∧
    ∀ y ∈ closure K, inner ℝ (y - x) n ≤ 0

/-- The unique outward unit supporting vector where it exists, and zero at
singular points. This is determined by K, with no supplied normal callback.
The exceptional set is surface-null for the selected polytopes; that fact is
an outstanding geometry result, not a hypothesis of the divergence target. -/
def outwardUnitNormal {d : ℕ} (K : Set (Point d)) (x : Point d) : Point d :=
  @dite (Point d) (∃! n, IsOutwardUnitSupport K x n)
    (Classical.propDecidable (∃! n, IsOutwardUnitSupport K x n))
    (fun h => Classical.choose h.exists) (fun _ => 0)

end NumStability.FiniteVolume.ConvexPolytope
