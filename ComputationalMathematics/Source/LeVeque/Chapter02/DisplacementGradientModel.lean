/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDisplacementModel
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Spatial gradient of planar displacement

Rows index displacement components; columns index the reference coordinates.
The time argument is held fixed for every spatial partial derivative.
-/

namespace NumStability.Leveque02Tracer

/-- The matrix of spatial partial derivatives of planar displacement. -/
noncomputable def displacementGradient
    (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![deriv (fun ξ => (materialDisplacement X Y ξ y t).1) x,
     deriv (fun η => (materialDisplacement X Y x η t).1) y;
     deriv (fun ξ => (materialDisplacement X Y ξ y t).2) x,
     deriv (fun η => (materialDisplacement X Y x η t).2) y]

end NumStability.Leveque02Tracer
