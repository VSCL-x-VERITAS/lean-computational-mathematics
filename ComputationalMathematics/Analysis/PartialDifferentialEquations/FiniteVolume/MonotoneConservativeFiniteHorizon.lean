/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.MonotoneConservativeContraction

/-!
# Finite-horizon comparison for a conservative monotone update

After the comparison horizon both sequences are extended by the numerical
update. The existing global error theorem then needs no further physical
comparison equations.
-/

namespace NumStability

/-- Local comparison equations and defect bounds are needed only before
the requested horizon. -/
theorem finiteMonotoneConservative_fixedHorizonMeanError_prefix
    {V : Type*} [Fintype V] [Nonempty V]
    (update : (V → ℝ) → V → ℝ)
    (hmono : ∀ u v, (∀ i, u i ≤ v i) → ∀ i, update u i ≤ update v i)
    (hconserve : ∀ u, ∑ i, update u i = ∑ i, u i)
    (timeStep width localBound horizon : ℝ)
    (htime : 0 ≤ timeStep) (hwidth : 0 < width) (hbound : 0 ≤ localBound)
    (approx exactState residual : ℕ → V → ℝ) (steps : ℕ)
    (happrox : ∀ k < steps, ∀ i, approx (k + 1) i = update (approx k) i)
    (hexact : ∀ k < steps, ∀ i, exactState (k + 1) i =
      update (exactState k) i + residual k i)
    (hlocal : ∀ k < steps, ∀ i, |residual k i| ≤ timeStep * localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i, |approx steps i - exactState steps i|) / (Fintype.card V : ℝ) ≤
      (∑ i, |approx 0 i - exactState 0 i|) / (Fintype.card V : ℝ) +
        horizon * localBound * width := by
  let extend : (ℕ → V → ℝ) → ℕ → V → ℝ := fun orbit =>
    Nat.rec (orbit 0) (fun k u => if k < steps then orbit (k + 1) else update u)
  have heq (orbit : ℕ → V → ℝ) (k : ℕ) (hk : k ≤ steps) : extend orbit k = orbit k := by
    cases k with
    | zero => rfl
    | succ k =>
      change (if k < steps then orbit (k + 1) else update (extend orbit k)) = _
      rw [if_pos (by omega)]
  let defect := fun k i => if k < steps then residual k i else 0
  have hA : ∀ k i, extend approx (k + 1) i = update (extend approx k) i := by
    intro k i
    change (if k < steps then approx (k + 1) else update (extend approx k)) i = _
    by_cases hk : k < steps
    · rw [if_pos hk, heq approx k (by omega)]
      exact happrox k hk i
    · rw [if_neg hk]
  have hE : ∀ k i, extend exactState (k + 1) i =
      update (extend exactState k) i + defect k i := by
    intro k i
    change (if k < steps then exactState (k + 1) else update (extend exactState k)) i =
      _ + (if k < steps then residual k i else 0)
    by_cases hk : k < steps
    · rw [if_pos hk, if_pos hk, heq exactState k (by omega)]
      exact hexact k hk i
    · rw [if_neg hk, if_neg hk, add_zero]
  have hD : ∀ k i, |defect k i| ≤ timeStep * localBound * width := by
    intro k i
    by_cases hk : k < steps
    · simpa only [defect, if_pos hk] using hlocal k hk i
    · simp only [defect, if_neg hk, abs_zero]
      exact mul_nonneg (mul_nonneg htime hbound) hwidth.le
  have h := finiteMonotoneConservative_fixedHorizonMeanError update hmono hconserve
    timeStep width localBound horizon hwidth hbound (extend approx) (extend exactState)
    defect hA hE hD steps hhorizon
  rw [heq approx steps le_rfl, heq exactState steps le_rfl,
    heq approx 0 (Nat.zero_le _), heq exactState 0 (Nat.zero_le _)] at h
  exact h

end NumStability
