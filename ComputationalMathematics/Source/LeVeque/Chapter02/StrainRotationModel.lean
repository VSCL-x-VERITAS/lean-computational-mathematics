/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DisplacementGradientModel

/-!
# Symmetric strain and skew rotation from a planar displacement gradient

These are the two halves of the gradient's symmetric/skew decomposition.
-/

namespace NumStability.Leveque02Tracer

/-- Infinitesimal strain: the symmetric part of a displacement gradient. -/
noncomputable def infinitesimalStrain
    (G : Matrix (Fin 2) (Fin 2) ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  (1 / 2 : ℝ) • (G + G.transpose)

/-- Infinitesimal rotation: the skew part of a displacement gradient. -/
noncomputable def infinitesimalRotation
    (G : Matrix (Fin 2) (Fin 2) ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  (1 / 2 : ℝ) • (G - G.transpose)

end NumStability.Leveque02Tracer
