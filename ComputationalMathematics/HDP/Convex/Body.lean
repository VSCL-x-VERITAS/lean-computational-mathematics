import Mathlib.Analysis.Convex.Body

/-!
# Convex bodies in finite-dimensional probability

This module records the bounded-convex-set convention used in high-dimensional
probability: a convex body has nonempty interior.  This differs intentionally
from Mathlib's compact/nonempty `ConvexBody` structure, which also includes
lower-dimensional bodies.
-/

namespace NumStability.HDP.Convex

/-- A finite-dimensional real convex body is bounded and convex and has
nonempty interior. -/
def IsConvexBody {n : ℕ} (K : Set (Fin n → ℝ)) : Prop :=
  Convex ℝ K ∧ Bornology.IsBounded K ∧ (interior K).Nonempty

/-- The componentwise characterization of the high-dimensional-probability
convex-body convention. -/
theorem isConvexBody_iff {n : ℕ} {K : Set (Fin n → ℝ)} :
    IsConvexBody K ↔
      Convex ℝ K ∧ Bornology.IsBounded K ∧ (interior K).Nonempty :=
  Iff.rfl

end NumStability.HDP.Convex
