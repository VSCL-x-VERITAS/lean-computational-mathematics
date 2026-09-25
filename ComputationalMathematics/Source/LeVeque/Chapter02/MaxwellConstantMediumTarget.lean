/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellAmpereModel
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellFaradayModel
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellScalarConstitutiveModel

/-!
# Proof-free target for LeVeque equation (2.115)

The permittivity and permeability are fixed, nonzero scalar coefficients.
The time derivatives of `E` are stated explicitly; the spatial derivatives of
`B` follow from `B = μ H` and the Ampère derivative witnesses.
-/

namespace NumStability.Leveque02Tracer

/-- In a homogeneous isotropic medium, the source-free Maxwell evolution laws
for `D,H,B,E` imply the two displayed equations for `E,B`. -/
def maxwellConstantMediumTarget : Prop :=
  ∀ (permittivity permeability : ℝ)
    (electricDisplacement electricField magneticInduction magneticField : MaxwellField)
    (position : MaxwellVector) (time : ℝ),
    permittivity ≠ 0 → permeability ≠ 0 →
    IsMaxwellScalarConstitutive electricDisplacement electricField permittivity →
    IsMaxwellScalarConstitutive magneticInduction magneticField permeability →
    IsMaxwellAmpereAt electricDisplacement magneticField position time →
    IsMaxwellFaradayAt magneticInduction electricField position time →
    (∀ component,
      HasDerivAt (fun τ => electricField position τ component)
        (maxwellTimePartial electricField component position time) time) →
    (∀ component,
      maxwellTimePartial electricField component position time -
        (1 / (permittivity * permeability)) *
          maxwellCurl magneticInduction position time component = 0) ∧
    (∀ component,
      maxwellTimePartial magneticInduction component position time +
        maxwellCurl electricField position time component = 0)

end NumStability.Leveque02Tracer
