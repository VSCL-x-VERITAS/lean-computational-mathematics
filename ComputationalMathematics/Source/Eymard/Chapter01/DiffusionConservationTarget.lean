/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.Eymard.Chapter01.DiffusionTargets

/-!
# Diffusion Conservation Target

Local conservation in Example 1.2, for the interior formula (1.9).
Distinct cells of the rectangular mesh share one actual nondegenerate segment.
The source mesh identifies their reciprocal interior neighbours. The actual
numerical flux uses this segment's Euclidean length, the distance between the
actual rectangle centres, and the same states with the two roles reversed.
This concerns interior faces and arbitrary real cell states; no orthogonality,
consistency or solution of the discrete equations is asserted.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume

/-- Local conservation in Example 1.2, for the interior formula (1.9).
Distinct cells of the rectangular mesh share one actual nondegenerate segment.
The source mesh identifies their reciprocal interior neighbours. The actual
numerical flux uses this segment's Euclidean length, the distance between the
actual rectangle centres, and the same states with the two roles reversed.
This concerns interior faces and arbitrary real cell states; no orthogonality,
consistency or solution of the discrete equations is asserted. -/
def diffusionConservationTarget : Prop :=
  ∀ (Cell Face : Type*) [DecidableEq Face]
    (M : Example12DiffusionMesh Cell Face) (values : Cell → ℝ)
    (K L : Cell) (σ : Face),
      K ≠ L → σ ∈ M.data.cellFaces K → σ ∈ M.data.cellFaces L →
        rectangularNumericalFlux M.data values K σ =
          -rectangularNumericalFlux M.data values L σ

end NumStability.Eymard.Chapter01
