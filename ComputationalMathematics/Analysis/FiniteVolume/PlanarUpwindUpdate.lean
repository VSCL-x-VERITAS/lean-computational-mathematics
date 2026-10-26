/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.SignedUpwindUpdate
import ComputationalMathematics.Analysis.FiniteVolume.PlanarUpwindFlux

/-!
# Planar Upwind Update

Physical realization using the existing actual signed net edge integral.
The spatial C1 velocity uses the already selected constant-in-time lift.
No arbitrary coefficient callback is accepted by this realization.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.FiniteVolume.Planar

/-- Physical realization using the existing actual signed net edge integral.
The spatial C1 velocity uses the already selected constant-in-time lift.
No arbitrary coefficient callback is accepted by this realization. -/
def planarUpwindTrajectory {Cell Face : Type} [DecidableEq Face]
    (M : Mesh Cell Face) (v : SpatialVelocity) (step : PositiveStep)
    (initial : Cell → ℝ) : ℕ → Cell → ℝ :=
  NumStability.FiniteVolume.signedUpwindTrajectory M.faces M.neighbour (cellArea M)
    step.val
    (fun n K σ => integratedNormalVelocity v step n (M.segment σ) (M.normal K σ))
    initial

end NumStability.FiniteVolume.Planar
