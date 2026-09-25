/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.RigidRotationStrainModel
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Target: a rigid rotation has no exact strain

LeVeque, printed page 37 (raw PDF page 59), says a rigid-body rotation creates
no internal strain or stress. The finite deformation uses exact metric strain;
the small-strain tensor in (2.87) applies only in the infinitesimal regime.
-/

namespace NumStability.Leveque02Tracer

/-- Orthogonal finite rotations preserve the metric and induce no stress from
a zero-at-zero constitutive law. A quarter-turn shows that substituting the
finite displacement gradient into (2.87) would be incorrect. -/
def rigidRotationStrainTarget : Prop :=
  (∀ (R : Matrix (Fin 2) (Fin 2) ℝ),
      R.transpose * R = 1 → R.det = 1 →
      ∀ (stress : Matrix (Fin 2) (Fin 2) ℝ → Matrix (Fin 2) (Fin 2) ℝ),
        stress 0 = 0 →
        exactPlanarStrain R = 0 ∧ stress (exactPlanarStrain R) = 0) ∧
    (∀ (G : Matrix (Fin 2) (Fin 2) ℝ),
      G.transpose = -G → infinitesimalStrain G = 0) ∧
    planarQuarterTurn.transpose * planarQuarterTurn = 1 ∧
    planarQuarterTurn.det = 1 ∧
    infinitesimalStrain (planarQuarterTurn - 1) = -1

end NumStability.Leveque02Tracer
