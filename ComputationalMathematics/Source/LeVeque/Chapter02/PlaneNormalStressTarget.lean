/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneNormalStressModel

/-!
# LeVeque equation (2.89): P-wave normal-stress relation
-/

namespace NumStability.Leveque02Tracer

/-- In the positive-modulus regime, the selected linear elastic normal stress
is `(λ+2μ) ε¹¹` at every space-time point. -/
def planeNormalStressTarget : Prop :=
  ∀ (lameLambda shearModulus : ℝ) (extensionStrain : ℝ → ℝ → ℝ),
    0 < lameLambda + 2 * shearModulus →
      ∀ (x t : ℝ),
        planeNormalStress lameLambda shearModulus extensionStrain x t =
          (lameLambda + 2 * shearModulus) * extensionStrain x t

end NumStability.Leveque02Tracer
