/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.RectangleFullSide

/-!
# Rectangle Orthogonality Target

Current owner-specificity claim for Example 1.2. The two disjuncts expose
the vertical and horizontal cases and matching tangential extents. Nonzero
displacement and perpendicularity are conclusions, never input certificates.
The claim concerns directions; it specifies no outward-oriented normal.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume NumStability.FiniteVolume.Planar

/-- Current owner-specificity claim for Example 1.2. The two disjuncts expose
the vertical and horizontal cases and matching tangential extents. Nonzero
displacement and perpendicularity are conclusions, never input certificates.
The claim concerns directions; it specifies no outward-oriented normal. -/
def rectangleOrthogonalityTarget : Prop :=
  ∀ (K L : Rectangle2) (σ : Segment),
    HasCoordinateRectangleFrame K → HasCoordinateRectangleFrame L →
    Disjoint K.region L.region → IsFullCommonRectangleSide K L σ →
      K.center ≠ L.center ∧ 0 < dist K.center L.center ∧
      ((σ.a 0 = σ.b 0 ∧
          K.center 1 - K.halfWidth 1 = L.center 1 - L.halfWidth 1 ∧
          K.center 1 + K.halfWidth 1 = L.center 1 + L.halfWidth 1 ∧
          K.center 1 = L.center 1 ∧ K.center 0 ≠ L.center 0) ∨
        (σ.a 1 = σ.b 1 ∧
          K.center 0 - K.halfWidth 0 = L.center 0 - L.halfWidth 0 ∧
          K.center 0 + K.halfWidth 0 = L.center 0 + L.halfWidth 0 ∧
          K.center 0 = L.center 0 ∧ K.center 1 ≠ L.center 1)) ∧
      inner ℝ (L.center - K.center) (σ.b - σ.a) = 0 ∧
      ∀ p ∈ σ.carrier, ∀ q ∈ σ.carrier,
        inner ℝ (L.center - K.center) (p - q) = 0

end NumStability.Eymard.Chapter01
