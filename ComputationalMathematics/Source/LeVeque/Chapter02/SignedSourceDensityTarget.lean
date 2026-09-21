/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SignedSourceDensityModel

/-!
# Signed source-density target

Proof-free target for the signed source-density definition in Section 2.5.
-/

namespace NumStability.Leveque02Tracer

/-- Every negative value of a signed local source density represents a sink. -/
def signedSourceDensityTarget : Prop :=
  ∀ (sourceDensity : SignedSourceDensity) (state : LinearMassDensity)
    (position time : ℝ),
    sourceDensity.value state position time < 0 →
      IsSinkAt sourceDensity state position time

end NumStability.Leveque02Tracer
