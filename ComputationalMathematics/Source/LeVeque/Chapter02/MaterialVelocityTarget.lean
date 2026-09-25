/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialVelocityModel

/-!
# LeVeque equation (2.84): velocity is the time derivative of displacement
-/

namespace NumStability.Leveque02Tracer

/-- With differentiable current-position fields, the velocity vector is the
actual time derivative of the displacement vector at the same material point. -/
def materialVelocityTarget : Prop :=
  ∀ (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ),
    DifferentiableAt ℝ (fun τ => X x y τ) t →
    DifferentiableAt ℝ (fun τ => Y x y τ) t →
      HasDerivAt (fun τ => materialDisplacement X Y x y τ)
        (materialVelocity X Y x y t) t

end NumStability.Leveque02Tracer
