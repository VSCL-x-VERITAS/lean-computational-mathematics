/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonDerivativeBound

/-!
# Adjacent variation of smooth interface-flux errors

A derivative bound on a smooth extension of sampled face errors gives
the neighboring-error cancellation used by conservative residual bounds.
-/

namespace NumStability

/-- A face error sampled from a differentiable profile with quadratic
derivative bound varies cubically between neighboring interfaces. -/
theorem leveque04_smoothFaceError_adjacent_bound
    {m : ℕ} (numericalFace exactFace : ℤ → Fin m → ℝ)
    (error error' : Fin m → ℝ → ℝ)
    (width bound : ℝ) (hwidth : 0 < width)
    (hsample : ∀ i k,
      numericalFace i k - exactFace i k = error k ((i : ℝ) * width))
    (hderiv : ∀ k x, HasDerivAt (error k) (error' k x) x)
    (hderivBound : ∀ k x, |error' k x| ≤ bound * width ^ 2) :
    ∀ i k,
      |((numericalFace (i + 1) k - exactFace (i + 1) k) -
          (numericalFace i k - exactFace i k))| ≤ bound * width ^ 3 := by
  intro i k
  rw [hsample (i + 1) k, hsample i k]
  have h := leveque04_lipschitz_of_bounded_derivative
    (error k) (error' k) (bound * width ^ 2)
    (hderiv k) (hderivBound k)
    (((i + 1 : ℤ) : ℝ) * width) ((i : ℝ) * width)
  have hcoord : (((i + 1 : ℤ) : ℝ) * width) -
      (i : ℝ) * width = width := by push_cast; ring
  rw [hcoord, abs_of_pos hwidth] at h
  simpa only [pow_succ, mul_assoc] using h

end NumStability
