/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearMaxwellPositiveSlopeModel

/-!
# Corrected condition for nonlinear Maxwell hyperbolicity

The source's unqualified claim after (2.121) is refuted separately by
`NonlinearMaxwellHyperbolicityCounterexampleTarget`. This target states a
local sufficient condition for its transverse plane-wave reduction.
-/

namespace NumStability.Leveque02Tracer

/-- Positive *differential* electric and magnetic constitutive responses
give a real eigenbasis for the frozen nonlinear plane-wave symbol. -/
def nonlinearMaxwellPositiveSlopeTarget : Prop :=
  ∀ (permittivity permeability : ℝ → ℝ)
    (electricField magneticField : ℝ),
    0 < electricConstitutiveSlope permittivity electricField →
    0 < magneticConstitutiveSlope permeability magneticField →
    NumStability.IsRealHyperbolicMatrix
      (frozenNonlinearMaxwellMatrix permittivity permeability
        electricField magneticField)

end NumStability.Leveque02Tracer
