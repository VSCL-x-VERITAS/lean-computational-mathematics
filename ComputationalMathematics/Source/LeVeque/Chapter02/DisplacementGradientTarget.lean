/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DisplacementGradientModel

/-!
# LeVeque equation (2.85): displacement gradient
-/

namespace NumStability.Leveque02Tracer

/-- The spatial displacement gradient is the current-position Jacobian minus
the two-dimensional identity matrix, displayed in coordinates. -/
def displacementGradientTarget : Prop :=
  ∀ (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ),
    DifferentiableAt ℝ (fun ξ => X ξ y t) x →
    DifferentiableAt ℝ (fun η => X x η t) y →
    DifferentiableAt ℝ (fun ξ => Y ξ y t) x →
    DifferentiableAt ℝ (fun η => Y x η t) y →
      displacementGradient X Y x y t =
        !![deriv (fun ξ => X ξ y t) x - 1,
           deriv (fun η => X x η t) y;
           deriv (fun ξ => Y ξ y t) x,
           deriv (fun η => Y x η t) y - 1]

end NumStability.Leveque02Tracer
