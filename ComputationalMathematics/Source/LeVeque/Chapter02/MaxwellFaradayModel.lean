/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellAmpereModel

/-!
# Charge/current-free Faraday evolution in three spatial dimensions
-/

namespace NumStability.Leveque02Tracer

/-- The pointwise Faraday law `Bₜ + ∇ × E = 0`, with exactly the classical
partials used by this equation. -/
def IsMaxwellFaradayAt
    (magneticInduction electricField : MaxwellField)
    (position : MaxwellVector) (time : ℝ) : Prop :=
  (∀ component,
      HasDerivAt (fun τ => magneticInduction position τ component)
        (maxwellTimePartial magneticInduction component position time) time) ∧
  (∀ component direction, MaxwellCurlUses component direction →
      HasDerivAt
        (fun s => electricField (Function.update position direction s) time component)
        (maxwellSpatialPartial electricField component direction position time)
        (position direction)) ∧
  (fun i => maxwellTimePartial magneticInduction i position time +
    maxwellCurl electricField position time i) = 0

end NumStability.Leveque02Tracer
