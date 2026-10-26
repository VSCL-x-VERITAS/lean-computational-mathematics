/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import ComputationalMathematics.Analysis.FiniteVolume.PlanarUpwindFlux

/-!
# Integrated Velocity Target

The unnumbered coefficient after (1.4), for one actual polygon face.
Point, Segment and carrier come from the shared canonical planar geometry producer.
The printed spatial C1 velocity is interpreted through its explicitly named
constant-time lift. The extra printed time argument is thereby retained as
a documented convention. There is no state factor or length normalization.
No neighbour or full-plane mesh is needed for this local definition.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open MeasureTheory
open NumStability.FiniteVolume.Planar

/-- The unnumbered coefficient after (1.4), for one actual polygon face.
Point, Segment and carrier come from the shared canonical planar geometry producer.
The printed spatial C1 velocity is interpreted through its explicitly named
constant-time lift. The extra printed time argument is thereby retained as
a documented convention. There is no state factor or length normalization.
No neighbour or full-plane mesh is needed for this local definition. -/
def integratedVelocityTarget : Prop :=
  ∀ (K : Polygon) (σ : Segment) (normal : Point),
    IsOutwardNormal K σ normal →
    ∀ (v : SpatialVelocity) (step : PositiveStep) (n : ℕ),
      integratedNormalVelocity v step n σ normal =
        ∫ x in σ.carrier,
          inner ℝ
            (constantTimeLift v x
              (NumStability.FiniteVolume.uniformTimeGrid step.val n))
            normal ∂(Measure.hausdorffMeasure 1)

end NumStability.Eymard.Chapter01
