/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation02Target

/-!
# LeVeque Chapter 4, equation (4.2): cellwise integral balance

This is the ordered-cell instance of the integral conservation law. The flux
entering at the left interface has positive sign; the flux leaving at the
right interface has negative sign.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The integral conservation law gives the printed cell balance (4.2). -/
theorem leveque04_equation02
    {m : ℕ} (interface : ℤ → ℝ)
    (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (i : ℤ) (t : ℝ) :
    leveque04_equation02_target interface q flux i t := by
  intro hcell hsolution
  have hIntegral :
      (fun τ : ℝ => ∫ x in leveque04_cell interface i, q x τ) =
        (fun τ : ℝ => ∫ x in (interface (i - 1))..(interface i), q x τ) := by
    funext τ
    simp only [leveque04_cell]
    rw [intervalIntegral.integral_of_le hcell.le, integral_Ioc_eq_integral_Ioo]
  rw [hIntegral]
  exact (hsolution (interface (i - 1)) (interface i) t).2

end NumStability
