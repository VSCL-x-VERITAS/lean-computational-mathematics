/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsConjugateNonlinear

/-!
# Coupled-vector Lax–Friedrichs finite-horizon error transfer

This theorem isolates the stability obligation for an arbitrary coupled
physical flux. It transfers uniform local defects through the actual
periodic equation-(4.20) update when that update is contractive in the
sum of vector norms. No contraction is inferred from the flux hypotheses.
-/

namespace NumStability

open scoped BigOperators

/-- A vector L¹ stability estimate for the actual periodic coupled-vector
Lax–Friedrichs stencil transfers a uniform one-step defect to a
first-order fixed-horizon mean error. -/
theorem leveque04_periodicVectorLaxFriedrichs_finiteHorizonAccuracy_of_l1_contract
    {m : ℕ} (n : ℕ) [NeZero n]
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (ratio timeStep width localBound horizon : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 ≤ width)
    (hbound : 0 ≤ localBound)
    (hcontract : ∀ u v : ZMod n → Fin m → ℝ,
      (∑ i : ZMod n,
        ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio u i -
          leveque04_periodicVectorLaxFriedrichsStep n flux ratio v i‖) ≤
        ∑ i : ZMod n, ‖u i - v i‖)
    (approx exactState : ℕ → ZMod n → Fin m → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicVectorLaxFriedrichsStep n flux ratio (approx k) i)
    (steps : ℕ)
    (hlocal : ∀ k, k < steps → ∀ i,
      ‖timeStep⁻¹ •
          (leveque04_periodicVectorLaxFriedrichsStep n flux ratio
            (exactState k) i - exactState (k + 1) i)‖ ≤
        localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i : ZMod n, ‖approx steps i - exactState steps i‖) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, ‖approx 0 i - exactState 0 i‖) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  let error : ℕ → ℝ := fun k =>
    ∑ i : ZMod n, ‖approx k i - exactState k i‖
  let increment : ℝ :=
    (Fintype.card (ZMod n) : ℝ) *
      (timeStep * localBound * width)
  have hresidual (k : ℕ) (hk : k < steps) (i : ZMod n) :
      ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio
          (exactState k) i - exactState (k + 1) i‖ ≤
        timeStep * localBound * width := by
    have h := hlocal k hk i
    have hnorm :
        ‖timeStep⁻¹ •
          (leveque04_periodicVectorLaxFriedrichsStep n flux ratio
            (exactState k) i - exactState (k + 1) i)‖ =
          ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio
            (exactState k) i - exactState (k + 1) i‖ / timeStep := by
      rw [norm_smul, Real.norm_eq_abs, abs_inv, abs_of_pos htime]
      ring
    rw [hnorm] at h
    have h' := (div_le_iff₀ htime).mp h
    nlinarith
  have hstep (k : ℕ) (hk : k < steps) :
      error (k + 1) ≤ error k + increment := by
    calc
      error (k + 1) = ∑ i : ZMod n,
          ‖(leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (approx k) i -
            leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (exactState k) i) +
            (leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (exactState k) i - exactState (k + 1) i)‖ := by
          dsimp [error]
          apply Finset.sum_congr rfl
          intro i _
          rw [happrox k i]
          congr 1
          abel
      _ ≤ ∑ i : ZMod n,
          (‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (approx k) i -
            leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (exactState k) i‖ +
           ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (exactState k) i - exactState (k + 1) i‖) :=
          Finset.sum_le_sum (fun i _ => norm_add_le _ _)
      _ = (∑ i : ZMod n,
          ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio
            (approx k) i -
            leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (exactState k) i‖) +
          (∑ i : ZMod n,
            ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio
              (exactState k) i - exactState (k + 1) i‖) :=
          Finset.sum_add_distrib
      _ ≤ error k + increment := by
          apply add_le_add
          · exact hcontract (approx k) (exactState k)
          · dsimp [increment]
            calc
              _ ≤ ∑ _i : ZMod n, timeStep * localBound * width :=
                Finset.sum_le_sum (fun i _ => hresidual k hk i)
              _ = _ := by simp
  have hacc : ∀ j, j ≤ steps →
      error j ≤ error 0 + (j : ℝ) * increment := by
    intro j hj
    induction j with
    | zero => simp
    | succ j ih =>
        have hlt : j < steps := Nat.lt_of_succ_le hj
        calc
          error (j + 1) ≤ error j + increment := hstep j hlt
          _ ≤ (error 0 + (j : ℝ) * increment) + increment := by
            linarith [ih (Nat.le_of_lt hlt)]
          _ = error 0 + ((j + 1 : ℕ) : ℝ) * increment := by
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
      ((∑ i : ZMod n, ‖approx 0 i - exactState 0 i‖) /
          (Fintype.card (ZMod n) : ℝ) +
        horizon * localBound * width) *
          (Fintype.card (ZMod n) : ℝ) =
      (∑ i : ZMod n, ‖approx 0 i - exactState 0 i‖) +
        (Fintype.card (ZMod n) : ℝ) *
          (horizon * localBound * width) := by
    rw [add_mul, div_mul_cancel₀ _ (ne_of_gt hcard)]
    ring
  rw [hcancel]
  exact htotal

end NumStability
