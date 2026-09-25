/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneShearStressModel

/-!
# LeVeque equation (2.90): S-wave shear-stress relation
-/

namespace NumStability.Leveque02Tracer

/-- In the positive-shear-modulus regime, the selected linear elastic shear
stress is `2μ ε¹²` at every space-time point. -/
def planeShearStressTarget : Prop :=
  ∀ (shearModulus : ℝ) (shearStrain : ℝ → ℝ → ℝ),
    0 < shearModulus →
      ∀ (x t : ℝ),
        planeShearStress shearModulus shearStrain x t =
          2 * shearModulus * shearStrain x t

end NumStability.Leveque02Tracer
