/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerFluxTarget

/-!
# LeVeque (2.3): advective tracer flux

The prescribed signed velocity times linear tracer density gives signed
rightward tracer mass per time in the source's one-dimensional model.
This correspondence unfolds the flux convention; it does not assert a
differential balance law for arbitrary density and velocity fields.
-/

namespace NumStability.Leveque02Tracer

/-- The physical tracer-flux product convention of equation (2.3). -/
theorem fluxProduct : fluxProductTarget := by
  intro velocity density x t hdensity
  rfl

end NumStability.Leveque02Tracer
