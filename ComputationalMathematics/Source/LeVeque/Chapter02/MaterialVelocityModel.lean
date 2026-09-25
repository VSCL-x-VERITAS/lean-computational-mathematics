/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDisplacementModel
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Velocity of a planar material point

Velocity is the pair of time derivatives of the two displacement components.
-/

namespace NumStability.Leveque02Tracer

/-- The time derivative of planar displacement, component by component. -/
noncomputable def materialVelocity
    (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ) : ℝ × ℝ :=
  (deriv (fun τ => (materialDisplacement X Y x y τ).1) t,
   deriv (fun τ => (materialDisplacement X Y x y τ).2) t)

end NumStability.Leveque02Tracer
