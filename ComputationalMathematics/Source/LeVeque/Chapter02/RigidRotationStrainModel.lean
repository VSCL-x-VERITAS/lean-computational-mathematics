/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StrainRotationModel

/-!
# Exact planar strain under a finite deformation

The Green–Lagrange strain is zero for an orthogonal deformation gradient.
It must be distinguished from the symmetric *displacement* gradient used in
the small-strain approximation (2.87).
-/

namespace NumStability.Leveque02Tracer

/-- Exact metric strain of a planar deformation gradient. -/
noncomputable def exactPlanarStrain
    (F : Matrix (Fin 2) (Fin 2) ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  (1 / 2 : ℝ) • (F.transpose * F - 1)

/-- A quarter-turn, used to separate finite rotation from its linearization. -/
def planarQuarterTurn : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, -1; 1, 0]

end NumStability.Leveque02Tracer
