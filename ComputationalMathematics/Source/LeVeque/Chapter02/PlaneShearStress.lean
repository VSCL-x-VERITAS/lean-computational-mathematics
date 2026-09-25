/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneShearStressTarget

/-!
# LeVeque equation (2.90): linear shear-stress model
-/

namespace NumStability.Leveque02Tracer

/-- The declared linear elastic shear-stress model has its constitutive value.
This verifies the model definition; it does not derive a material law. -/
theorem planeShearStressFormula : planeShearStressTarget := by
  intro shearModulus shearStrain hmodulus x t
  rfl

end NumStability.Leveque02Tracer
