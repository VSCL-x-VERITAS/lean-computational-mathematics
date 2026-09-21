/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxModel
import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxModel

/-!
# Combined constant advection and diffusion flux

The constitutive flux is the sum of the constant-velocity advective flux and
Fick's signed diffusive flux.
-/

namespace NumStability.Leveque02Tracer

/-- Combined constant advection and Fick diffusion for a scalar state and its
spatial gradient. -/
noncomputable def combinedAdvectionDiffusionFlux
    (velocity coefficient state gradient : ℝ) : ℝ :=
  stateFlux (fun _ _ ↦ velocity) state 0 0 + fickFlux coefficient gradient

end NumStability.Leveque02Tracer
