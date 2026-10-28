/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Normed.Affine.Isometry

/-!
# Euclidean simplex carriers

The convex hull of an arbitrary nonempty finite family of real Euclidean vertices,
its canonical affine carrier and direction, and its centered realization in that
direction. Repeated vertices and zero vertices are allowed, including a single
vertex when `k = 0`.
-/

set_option autoImplicit false

namespace NumStability.EuclideanSimplex

/-- The unbundled simplex set of the supplied vertices. -/
noncomputable def simplexSet {n k : ℕ} (v : Fin (k + 1) → EuclideanSpace ℝ (Fin n)) :
    Set (EuclideanSpace ℝ (Fin n)) :=
  convexHull ℝ (Set.range v)

/-- The canonical affine carrier of the supplied vertices. -/
noncomputable def simplexAffineSpan {n k : ℕ}
    (v : Fin (k + 1) → EuclideanSpace ℝ (Fin n)) :
    AffineSubspace ℝ (EuclideanSpace ℝ (Fin n)) :=
  affineSpan ℝ (Set.range v)

/-- The canonical direction, independent of a choice of centering vertex. -/
noncomputable def simplexDirection {n k : ℕ}
    (v : Fin (k + 1) → EuclideanSpace ℝ (Fin n)) :
    Submodule ℝ (EuclideanSpace ℝ (Fin n)) :=
  (simplexAffineSpan v).direction

/-- Each actual supplied vertex regarded as a point in the affine carrier. -/
noncomputable def simplexVertex {n k : ℕ}
    (v : Fin (k + 1) → EuclideanSpace ℝ (Fin n)) (i : Fin (k + 1)) :
    simplexAffineSpan v :=
  ⟨v i, subset_affineSpan ℝ (Set.range v) (Set.mem_range_self i)⟩

/-- The actual simplex set pulled back to its affine carrier. -/
noncomputable def simplexInCarrier {n k : ℕ}
    (v : Fin (k + 1) → EuclideanSpace ℝ (Fin n)) : Set (simplexAffineSpan v) :=
  Subtype.val ⁻¹' simplexSet v

/-- The simplex centered at a carrier point, with displacement `p -ᵥ q`.
In particular, `simplexVertex v i` supplies any chosen actual vertex as anchor. -/
noncomputable def centeredSimplex {n k : ℕ}
    (v : Fin (k + 1) → EuclideanSpace ℝ (Fin n)) (q : simplexAffineSpan v) :
    Set (simplexDirection v) :=
  letI : Nonempty (simplexAffineSpan v) := ⟨q⟩
  (AffineIsometryEquiv.vaddConst ℝ q).symm '' simplexInCarrier v

end NumStability.EuclideanSimplex
