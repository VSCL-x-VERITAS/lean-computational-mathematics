/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.SegmentSupportingFoot
import ComputationalMathematics.Analysis.FiniteVolume.RectangularDiffusion

/-!
# Rectangle Boundary Foot Targets

Existing actual side/sidePoint membership is applicability. The computed
foot, its perpendicularity, positive distance and infDist correspondence are
conclusions. Side pieces are allowed; the midpoint of the selected piece need
not be the sidePoint. No new distance or flux operation is defined.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume
open Planar

/-- Existing actual side/sidePoint membership is applicability. The computed
foot, its perpendicularity, positive distance and infDist correspondence are
conclusions. Side pieces are allowed; the midpoint of the selected piece need
not be the sidePoint. No new distance or flux operation is defined. -/
def rectangleSelectedBoundaryGeometryTarget : Prop :=
  ∀ (R : Rectangle2) (e : Segment) (s : RectangleSide2),
    e.carrier ⊆ R.side s → R.sidePoint s 0 ∈ e.carrier →
      segmentSupportingFoot e R.center = R.sidePoint s 0 ∧
      segmentSupportingFoot e R.center ∈ e.carrier ∧
      inner ℝ (R.center - segmentSupportingFoot e R.center) (e.b - e.a) = 0 ∧
      dist R.center (segmentSupportingFoot e R.center) = R.halfWidth s.1 ∧
      0 < dist R.center (segmentSupportingFoot e R.center) ∧
      rectangleFaceDistance R e = dist R.center (segmentSupportingFoot e R.center)

end NumStability.FiniteVolume
