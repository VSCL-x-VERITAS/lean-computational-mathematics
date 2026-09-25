/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.Symmetric

/-!
# Infinitesimal strain in three spatial dimensions

The six coordinates are the three diagonal and three upper-triangle entries.
-/

namespace NumStability.Leveque02Tracer

/-- Symmetric part of a three-dimensional displacement gradient. -/
noncomputable def infinitesimalStrain3D
    (G : Matrix (Fin 3) (Fin 3) ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  (1 / 2 : ℝ) • (G + G.transpose)

/-- The three extension and three shear entries of a symmetric 3×3 matrix. -/
noncomputable def strain3DFromSix (components : Fin 6 → ℝ) :
    Matrix (Fin 3) (Fin 3) ℝ :=
  !![components 0, components 1, components 2;
     components 1, components 3, components 4;
     components 2, components 4, components 5]

end NumStability.Leveque02Tracer
