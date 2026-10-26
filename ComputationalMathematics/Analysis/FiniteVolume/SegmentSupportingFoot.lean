/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume
open Planar

/-- Supporting-line projection computed from the actual nondegenerate segment
endpoints. The existing Segment.nondegenerate supplies a ≠ b. -/
def segmentSupportingFoot (e : Segment) (x : Point) : Point :=
  e.a + (inner ℝ (e.b - e.a) (x - e.a) / ‖e.b - e.a‖ ^ 2) • (e.b - e.a)

/-- Reusable geometric obligation; no supplied projection, perpendicularity
certificate, distance identity or conclusion is an input. -/
def segmentSupportingFootGeometryTarget : Prop :=
  ∀ (e : Segment) (x : Point),
    (∃ t : ℝ, segmentSupportingFoot e x = e.a + t • (e.b - e.a)) ∧
    inner ℝ (x - segmentSupportingFoot e x) (e.b - e.a) = 0 ∧
    ∀ z : Point, (∃ t : ℝ, z = e.a + t • (e.b - e.a)) →
      inner ℝ (x - z) (e.b - e.a) = 0 → z = segmentSupportingFoot e x

end NumStability.FiniteVolume
