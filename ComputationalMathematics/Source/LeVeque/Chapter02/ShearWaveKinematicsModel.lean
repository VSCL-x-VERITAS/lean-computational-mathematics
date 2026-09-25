/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalKinematicsModel

/-!
# One-dimensional transverse displacement, shear strain, and velocity

For an x-directed plane S-wave with displacement `(0,W(x,t))`, the only
independent symmetric shear strain is one half of the spatial derivative of W.
-/

namespace NumStability.Leveque02Tracer

/-- The off-diagonal infinitesimal shear strain of a transverse displacement. -/
noncomputable def shearWaveStrain
    (W : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  (1 / 2 : ℝ) * deriv (fun ξ => W ξ t) x

/-- The transverse particle velocity of the same displacement. -/
noncomputable def shearWaveVelocity
    (W : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  deriv (fun τ => W x τ) t

end NumStability.Leveque02Tracer
