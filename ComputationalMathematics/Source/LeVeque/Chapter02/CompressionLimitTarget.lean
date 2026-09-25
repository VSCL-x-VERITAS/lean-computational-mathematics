/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalKinematicsModel

/-!
# Proof-free target for LeVeque's complete-compression strain threshold

At a point where the material map has a genuine spatial derivative, the
extensional strain is `-1` exactly when that derivative vanishes.
-/

namespace NumStability.Leveque02Tracer

/-- Complete one-dimensional compression `Xₓ = 0` corresponds exactly to
extensional strain `ε = -1`. -/
def compressionLimitTarget : Prop :=
  ∀ (X : ℝ → ℝ → ℝ) (x t : ℝ),
    DifferentiableAt ℝ (fun ξ => X ξ t) x →
      (longitudinalStrain X x t = -1 ↔
        deriv (fun ξ => X ξ t) x = 0)

end NumStability.Leveque02Tracer
