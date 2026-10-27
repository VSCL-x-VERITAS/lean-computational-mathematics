/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsNonlinearStability

/-!
# Periodic nonlinear Lax–Friedrichs first-order transfer

A first-order time-normalized local residual of the actual nonlinear
stencil accumulates under periodic scalar L1 contraction to a
first-order fixed-horizon mean error.
-/

namespace NumStability

/-- The periodic nonlinear Lax–Friedrichs map transfers a uniform
time-normalized local residual into fixed-horizon first-order mean L1
accuracy. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_fixedHorizonAccuracy
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ)
    (ratio L timeStep width localBound horizon : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : ratio * L ≤ 1)
    (hflux : ∀ x y, |flux x - flux y| ≤ L * |x - y|)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hbound : 0 ≤ localBound)
    (approx exactState : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (approx k) i)
    (hlocal : ∀ k i,
      |(leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
          (exactState k) i - exactState (k + 1) i) / timeStep| ≤
        localBound * width)
    (steps : ℕ) (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i : ZMod n, |approx steps i - exactState steps i|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, |approx 0 i - exactState 0 i|) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  let residual : ℕ → ZMod n → ℝ := fun k i =>
    exactState (k + 1) i -
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (exactState k) i
  have hexact : ∀ k i, exactState (k + 1) i =
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (exactState k) i + residual k i := by
    intro k i
    dsimp [residual]
    ring
  have hresidual : ∀ k i,
      |residual k i| ≤ timeStep * localBound * width := by
    intro k i
    have h := hlocal k i
    have hmul := mul_le_mul_of_nonneg_right h htime.le
    rw [abs_div, abs_of_pos htime,
      div_mul_cancel₀ _ (ne_of_gt htime)] at hmul
    dsimp [residual]
    rw [abs_sub_comm]
    convert hmul using 1 <;> ring
  exact leveque04_periodicNonlinearLaxFriedrichs_fixedHorizonMeanError
    n flux ratio L timeStep width localBound horizon
    hratio hcfl hflux hwidth hbound approx exactState residual
    happrox hexact hresidual steps hhorizon

end NumStability
