/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicTransfer

/-!
# Periodic vector stability for a common characteristic speed

When the physical flux is a scalar speed times every vector component,
the coupled-vector equation-(4.20) update is a convex combination of
its two neighboring vector states under the scalar Courant bound.
The sum of state norms is consequently nonexpansive.
-/

namespace NumStability

open scoped BigOperators

theorem leveque04_periodicVectorLaxFriedrichs_commonSpeed_l1_contract
    {m : ℕ} (n : ℕ) [NeZero n]
    (speed ratio : ℝ) (hcfl : |speed * ratio| ≤ 1)
    (u v : ZMod n → Fin m → ℝ) :
    (∑ i : ZMod n,
      ‖leveque04_periodicVectorLaxFriedrichsStep n
          (fun state => speed • state) ratio u i -
        leveque04_periodicVectorLaxFriedrichsStep n
          (fun state => speed • state) ratio v i‖) ≤
      ∑ i : ZMod n, ‖u i - v i‖ := by
  let α : ℝ := (1 + ratio * speed) / 2
  let β : ℝ := (1 - ratio * speed) / 2
  have hcfl' : |ratio * speed| ≤ 1 := by simpa only [mul_comm] using hcfl
  have hα : 0 ≤ α := by
    dsimp [α]
    have h := (abs_le.mp hcfl').1
    linarith
  have hβ : 0 ≤ β := by
    dsimp [β]
    have h := (abs_le.mp hcfl').2
    linarith
  have hsum : α + β = 1 := by dsimp [α, β]; ring
  have hstep (w : ZMod n → Fin m → ℝ) (i : ZMod n) :
      leveque04_periodicVectorLaxFriedrichsStep n
        (fun state => speed • state) ratio w i =
      α • w (i - 1) + β • w (i + 1) := by
    funext p
    simp only [leveque04_periodicVectorLaxFriedrichsStep,
      Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
      α, β]
    ring
  have hminus :
      (∑ i : ZMod n, ‖u (i - 1) - v (i - 1)‖) =
        ∑ i : ZMod n, ‖u i - v i‖ := by
    simpa only [Equiv.coe_addRight, sub_eq_add_neg] using
      Equiv.sum_comp (Equiv.addRight (-1 : ZMod n))
        (fun i => ‖u i - v i‖)
  have hplus :
      (∑ i : ZMod n, ‖u (i + 1) - v (i + 1)‖) =
        ∑ i : ZMod n, ‖u i - v i‖ := by
    simpa only [Equiv.coe_addRight] using
      Equiv.sum_comp (Equiv.addRight (1 : ZMod n))
        (fun i => ‖u i - v i‖)
  have hpoint (i : ZMod n) :
      ‖leveque04_periodicVectorLaxFriedrichsStep n
          (fun state => speed • state) ratio u i -
        leveque04_periodicVectorLaxFriedrichsStep n
          (fun state => speed • state) ratio v i‖ ≤
        α * ‖u (i - 1) - v (i - 1)‖ +
          β * ‖u (i + 1) - v (i + 1)‖ := by
    rw [hstep u i, hstep v i]
    have hdecomp :
        (α • u (i - 1) + β • u (i + 1)) -
          (α • v (i - 1) + β • v (i + 1)) =
        α • (u (i - 1) - v (i - 1)) +
          β • (u (i + 1) - v (i + 1)) := by
      rw [smul_sub, smul_sub]
      abel
    rw [hdecomp]
    calc
      _ ≤ ‖α • (u (i - 1) - v (i - 1))‖ +
          ‖β • (u (i + 1) - v (i + 1))‖ := norm_add_le _ _
      _ = _ := by
        rw [norm_smul, norm_smul, Real.norm_eq_abs,
          Real.norm_eq_abs, abs_of_nonneg hα, abs_of_nonneg hβ]
  calc
    _ ≤ ∑ i : ZMod n,
        (α * ‖u (i - 1) - v (i - 1)‖ +
          β * ‖u (i + 1) - v (i + 1)‖) :=
      Finset.sum_le_sum (fun i _ => hpoint i)
    _ = α * (∑ i : ZMod n, ‖u i - v i‖) +
        β * (∑ i : ZMod n, ‖u i - v i‖) := by
      rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum,
        hminus, hplus]
    _ = _ := by rw [← add_mul, hsum, one_mul]

/-- For a common-speed linear vector flux, the Courant bound supplies
the contraction premise of the vector finite-horizon transfer. -/
theorem leveque04_periodicVectorLaxFriedrichs_commonSpeed_finiteHorizonAccuracy
    {m : ℕ} (n : ℕ) [NeZero n]
    (speed ratio timeStep width localBound horizon : ℝ)
    (hcfl : |speed * ratio| ≤ 1)
    (htime : 0 < timeStep) (hwidth : 0 ≤ width)
    (hbound : 0 ≤ localBound)
    (approx exactState : ℕ → ZMod n → Fin m → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicVectorLaxFriedrichsStep n
        (fun state => speed • state) ratio (approx k) i)
    (steps : ℕ)
    (hlocal : ∀ k, k < steps → ∀ i,
      ‖timeStep⁻¹ •
          (leveque04_periodicVectorLaxFriedrichsStep n
            (fun state => speed • state) ratio
            (exactState k) i - exactState (k + 1) i)‖ ≤
        localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i : ZMod n, ‖approx steps i - exactState steps i‖) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, ‖approx 0 i - exactState 0 i‖) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  exact leveque04_periodicVectorLaxFriedrichs_finiteHorizonAccuracy_of_l1_contract
    n (fun state => speed • state) ratio timeStep width localBound horizon
    htime hwidth hbound
    (leveque04_periodicVectorLaxFriedrichs_commonSpeed_l1_contract
      n speed ratio hcfl)
    approx exactState happrox steps hlocal hhorizon

end NumStability
