/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Strain3DModel
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target: six independent components of 3D infinitesimal strain

The matrix entries are witnessed as actual spatial partial derivatives of a
three-component displacement at a reference position. No global compatibility
or elasticity PDE claim is made.
-/

namespace NumStability.Leveque02Tracer

/-- Symmetrization yields a unique six-coordinate strain; every six-tuple
gives a symmetric matrix and is realized by its own symmetric gradient. -/
def strain3DTarget : Prop :=
  (∀ (displacement : (Fin 3 → ℝ) → (Fin 3 → ℝ))
      (position : Fin 3 → ℝ) (G : Matrix (Fin 3) (Fin 3) ℝ),
    (∀ i j : Fin 3,
      HasDerivAt
        (fun step : ℝ =>
          displacement (fun k => position k + if k = j then step else 0) i)
        (G i j) 0) →
    (infinitesimalStrain3D G).IsSymm ∧
    ∃! components : Fin 6 → ℝ,
      strain3DFromSix components = infinitesimalStrain3D G) ∧
  (∀ components : Fin 6 → ℝ,
    (strain3DFromSix components).IsSymm ∧
    infinitesimalStrain3D (strain3DFromSix components) =
      strain3DFromSix components)

end NumStability.Leveque02Tracer
