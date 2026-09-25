/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ElectricConstitutiveTarget

/-!
# LeVeque equation (2.113): electric constitutive relation
-/

namespace NumStability.Leveque02Tracer

/-- The electric-displacement constitutive law is equivalent to its component
relations, both for fixed scalar permittivity and for spatially varying
three-by-three permittivity matrices. -/
theorem electricConstitutive : electricConstitutiveTarget := by
  constructor
  · intro permittivity electricDisplacement electricField
    constructor
    · intro h position time component
      have hc := congrFun (h position time) component
      simpa only [Pi.smul_apply, smul_eq_mul] using hc
    · intro h position time
      funext component
      simpa only [Pi.smul_apply, smul_eq_mul] using
        h position time component
  · intro permittivity electricDisplacement electricField
    constructor
    · intro h position time component
      have hc := congrFun (h position time) component
      simpa only [Matrix.mulVec, dotProduct] using hc
    · intro h position time
      funext component
      simpa only [Matrix.mulVec, dotProduct] using
        h position time component

end NumStability.Leveque02Tracer
