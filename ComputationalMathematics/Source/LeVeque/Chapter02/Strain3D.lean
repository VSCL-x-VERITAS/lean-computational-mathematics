/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Strain3DTarget
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: three-dimensional infinitesimal strain
-/

namespace NumStability.Leveque02Tracer

private theorem fromSix_symm (c : Fin 6 → ℝ) : (strain3DFromSix c).IsSymm := by
  apply Matrix.IsSymm.ext
  intro i j
  fin_cases i <;> fin_cases j <;>
    simp [strain3DFromSix]

private theorem fromSix_toSix (E : Matrix (Fin 3) (Fin 3) ℝ) (hE : E.IsSymm) :
    strain3DFromSix ![E 0 0, E 0 1, E 0 2, E 1 1, E 1 2, E 2 2] = E := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [strain3DFromSix, hE.apply 1 0, hE.apply 2 0, hE.apply 2 1]

private theorem toSix_fromSix (c : Fin 6 → ℝ) :
    ![(strain3DFromSix c) 0 0, (strain3DFromSix c) 0 1,
      (strain3DFromSix c) 0 2, (strain3DFromSix c) 1 1,
      (strain3DFromSix c) 1 2, (strain3DFromSix c) 2 2] = c := by
  funext i
  fin_cases i <;> simp [strain3DFromSix]

/-- Actual coordinate partials give a symmetric strain with exactly six free
pointwise matrix entries. -/
theorem strain3D : strain3DTarget := by
  constructor
  · intro displacement position G _
    have hsymm : (infinitesimalStrain3D G).IsSymm := by
      exact (Matrix.isSymm_add_transpose_self G).smul (1 / 2 : ℝ)
    refine ⟨hsymm, ?_⟩
    let c : Fin 6 → ℝ := ![(infinitesimalStrain3D G) 0 0,
      (infinitesimalStrain3D G) 0 1, (infinitesimalStrain3D G) 0 2,
      (infinitesimalStrain3D G) 1 1, (infinitesimalStrain3D G) 1 2,
      (infinitesimalStrain3D G) 2 2]
    refine ⟨c, fromSix_toSix _ hsymm, ?_⟩
    intro d hd
    calc
      d = ![(strain3DFromSix d) 0 0, (strain3DFromSix d) 0 1,
        (strain3DFromSix d) 0 2, (strain3DFromSix d) 1 1,
        (strain3DFromSix d) 1 2, (strain3DFromSix d) 2 2] :=
          (toSix_fromSix d).symm
      _ = c := by simp [c, hd]
  · intro components
    have hs := fromSix_symm components
    constructor
    · exact hs
    · ext i j
      simp [infinitesimalStrain3D, Matrix.smul_apply,
        Matrix.add_apply, Matrix.transpose_apply, hs.apply i j]
      ring

end NumStability.Leveque02Tracer
