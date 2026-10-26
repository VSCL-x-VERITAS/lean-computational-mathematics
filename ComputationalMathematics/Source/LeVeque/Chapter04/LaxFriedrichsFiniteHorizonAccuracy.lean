/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsNonlinearAccuracy

/-!
# Nonlinear periodic Lax–Friedrichs transfer through a finite horizon

Only local residuals before the requested final step are needed to
control the final error. This form supports exact solutions that remain
smooth only through the selected time interval.
-/

namespace NumStability

/-- Scalar periodic L1 contraction transfers local residual bounds
through a specified finite horizon without requiring smoothness at
later steps. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_finiteHorizonAccuracy
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
    (steps : ℕ)
    (hlocal : ∀ k, k < steps → ∀ i,
      |(leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
          (exactState k) i - exactState (k + 1) i) / timeStep| ≤
        localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i : ZMod n, |approx steps i - exactState steps i|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, |approx 0 i - exactState 0 i|) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  let error : ℕ → ℝ := fun k =>
    ∑ i : ZMod n, |approx k i - exactState k i|
  let increment : ℝ :=
    (Fintype.card (ZMod n) : ℝ) *
      (timeStep * localBound * width)
  have hresidual (k : ℕ) (hk : k < steps) (i : ZMod n) :
      |leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
          (exactState k) i - exactState (k + 1) i| ≤
        timeStep * localBound * width := by
    have h := hlocal k hk i
    have hmul := mul_le_mul_of_nonneg_right h htime.le
    rw [abs_div, abs_of_pos htime,
      div_mul_cancel₀ _ (ne_of_gt htime)] at hmul
    nlinarith [hmul]
  have hstep (k : ℕ) (hk : k < steps) :
      error (k + 1) ≤ error k + increment := by
    calc
      error (k + 1) = ∑ i : ZMod n,
          |(leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (approx k) i -
            leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (exactState k) i) +
            (leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (exactState k) i - exactState (k + 1) i)| := by
          dsimp [error]
          apply Finset.sum_congr rfl
          intro i _
          rw [happrox k i]
          congr 1
          ring
      _ ≤ ∑ i : ZMod n,
          (|leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (approx k) i -
            leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (exactState k) i| +
           |leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (exactState k) i - exactState (k + 1) i|) := by
          exact Finset.sum_le_sum (fun i _ => abs_add_le _ _)
      _ = (∑ i : ZMod n,
          |leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
            (approx k) i -
            leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (exactState k) i|) +
          (∑ i : ZMod n,
            |leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
              (exactState k) i - exactState (k + 1) i|) :=
          Finset.sum_add_distrib
      _ ≤ error k + increment := by
          apply add_le_add
          · exact leveque04_periodicNonlinearLaxFriedrichs_l1_contract
              n flux ratio L hratio hcfl hflux (approx k) (exactState k)
          · dsimp [increment]
            calc
              _ ≤ ∑ _i : ZMod n, timeStep * localBound * width :=
                Finset.sum_le_sum (fun i _ => hresidual k hk i)
              _ = _ := by simp
  have hacc : ∀ m, m ≤ steps →
      error m ≤ error 0 + (m : ℝ) * increment := by
    intro m hm
    induction m with
    | zero => simp
    | succ m ih =>
        have hlt : m < steps := Nat.lt_of_succ_le hm
        calc
          error (m + 1) ≤ error m + increment := hstep m hlt
          _ ≤ (error 0 + (m : ℝ) * increment) + increment := by
            linarith [ih (Nat.le_of_lt hlt)]
          _ = error 0 + ((m + 1 : ℕ) : ℝ) * increment := by
            push_cast
            ring
  have hcard : (0 : ℝ) < Fintype.card (ZMod n) := by
    exact_mod_cast Fintype.card_pos
  have hfactor : 0 ≤ (Fintype.card (ZMod n) : ℝ) *
      (localBound * width) := by positivity
  have hscaled := mul_le_mul_of_nonneg_right hhorizon hfactor
  have htotal :
      error steps ≤ error 0 +
        (Fintype.card (ZMod n) : ℝ) *
          (horizon * localBound * width) := by
    have hacc' := hacc steps le_rfl
    dsimp [increment] at hacc'
    nlinarith
  dsimp only [error] at htotal ⊢
  apply (div_le_iff₀ hcard).2
  have hcancel :
      ((∑ i : ZMod n, |approx 0 i - exactState 0 i|) /
          (Fintype.card (ZMod n) : ℝ) +
        horizon * localBound * width) *
          (Fintype.card (ZMod n) : ℝ) =
      (∑ i : ZMod n, |approx 0 i - exactState 0 i|) +
        (Fintype.card (ZMod n) : ℝ) *
          (horizon * localBound * width) := by
    rw [add_mul, div_mul_cancel₀ _ (ne_of_gt hcard)]
    ring
  rw [hcancel]
  exact htotal

end NumStability
