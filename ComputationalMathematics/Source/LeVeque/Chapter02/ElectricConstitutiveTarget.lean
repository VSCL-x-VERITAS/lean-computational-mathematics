/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellScalarConstitutiveModel

/-!
# Proof-free target for LeVeque equation (2.113)
-/

namespace NumStability.Leveque02Tracer

/-- The electric constitutive relation `D=εE` has both the homogeneous
isotropic fixed-scalar form and the spatially varying matrix form described
beside equation (2.113). Each vector-field identity is equivalent to its
three component equations. -/
def electricConstitutiveTarget : Prop :=
  (∀ (permittivity : ℝ)
      (electricDisplacement electricField : MaxwellField),
      IsMaxwellScalarConstitutive electricDisplacement electricField permittivity ↔
        ∀ (position : MaxwellVector) (time : ℝ) (component : Fin 3),
          electricDisplacement position time component =
            permittivity * electricField position time component) ∧
  (∀ (permittivity : MaxwellVector → Matrix (Fin 3) (Fin 3) ℝ)
      (electricDisplacement electricField : MaxwellField),
      IsMaxwellMatrixConstitutive electricDisplacement electricField permittivity ↔
        ∀ (position : MaxwellVector) (time : ℝ) (component : Fin 3),
          electricDisplacement position time component =
            ∑ j : Fin 3,
              permittivity position component j * electricField position time j)

end NumStability.Leveque02Tracer
