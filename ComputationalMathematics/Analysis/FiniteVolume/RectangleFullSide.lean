/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.RectangularDiffusion

/-!
# Rectangle Full Side

Select the coordinate presentation of the existing rectangle producer.
Positive half widths are already fields of Rectangle2. Its region and sides
are symmetric about its center; no new rectangle or point producer is used.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume NumStability.FiniteVolume.Planar

/-- Select the coordinate presentation of the existing rectangle producer.
Positive half widths are already fields of Rectangle2. Its region and sides
are symmetric about its center; no new rectangle or point producer is used. -/
def HasCoordinateRectangleFrame (R : Rectangle2) : Prop :=
  ∀ i : Fin 2, R.frame i = EuclideanSpace.single i (1 : ℝ)

/-- A whole side of both rectangles, with either endpoint ordering.
Subset inclusion would also admit the excluded hanging-node configurations. -/
def IsFullCommonRectangleSide (K L : Rectangle2) (σ : Segment) : Prop :=
  ∃ s t : RectangleSide2, σ.carrier = K.side s ∧ σ.carrier = L.side t

end NumStability.Eymard.Chapter01
