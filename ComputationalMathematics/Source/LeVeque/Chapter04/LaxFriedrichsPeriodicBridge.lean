/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsNonlinearAccuracy
import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux

/-!
# The periodic nonlinear stencil as equation (4.20)

Each periodic step at a cell depends only on its two neighbors. Those
neighbors can be supplied to the integer-indexed equation-(4.20)
finite-volume update, including at the wraparound cells.
-/

namespace NumStability

/-- The periodic nonlinear scalar Lax–Friedrichs step is exactly the
source's integer-indexed conservative update on the two selected
neighbor states. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_eq_equation20
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ)
    (ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width)
    (u : ZMod n → ℝ) (i : ZMod n) :
    let old : ℤ → Fin 1 → ℝ := fun j _ =>
      if j = -1 then u (i - 1) else u (i + 1)
    leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio u i =
      leveque04_finiteVolumeUpdate (ratio * width) width old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width
            (fun state (_ : Fin 1) => flux (state 0))) old) 0 0 := by
  dsimp only
  rw [leveque04_equation20 (ratio * width) width
    (fun state (_ : Fin 1) => flux (state 0))
    (fun j (_ : Fin 1) => if j = -1 then u (i - 1) else u (i + 1))
    0 0 (mul_pos hratio hwidth) hwidth]
  simp only [zero_sub, zero_add, ite_true]
  have hnot : (1 : ℤ) ≠ -1 := by norm_num
  simp only [hnot, ↓reduceIte]
  have hne : width ≠ 0 := ne_of_gt hwidth
  have hcoef : ratio * width / (2 * width) = ratio / 2 := by
    field_simp
  rw [hcoef]
  rfl

end NumStability
