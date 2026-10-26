/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution

/-!
# Entropy rectangle inequality for a moving scalar jump

Transport balance is reused for the entropy-transformed jump. The excess
entropy flux decreases across the jump exactly when the coefficient
inequality holds. Space and time intervals are ordered in the inequality.
-/

open MeasureTheory

namespace NumStability

/-- A moving jump with its right representative satisfies the entropy
inequality on every ordered rectangle if its jump coefficient is dissipative. -/
theorem travelingRiemannJump_entropy_rectangle
    (left right speed : ℝ) (entropy entropyFlux : ℝ → ℝ)
    (hdissipation : speed * (entropy left - entropy right) ≤
      entropyFlux left - entropyFlux right)
    (a b s t : ℝ) (hab : a ≤ b) (hst : s ≤ t) :
    let q := travelingWave (riemannData left right right) speed
    (∫ x in a..b, entropy (q x t)) - (∫ x in a..b, entropy (q x s)) ≤
      ∫ τ in s..t, (entropyFlux (q a τ) - entropyFlux (q b τ)) := by
  let q := travelingWave (riemannData left right right) speed
  have hmap (f : ℝ → ℝ) :
      (fun x τ => f (q x τ)) =
        travelingWave (riemannData (f left) (f right) (f right)) speed := by
    funext x τ
    dsimp [q, travelingWave, riemannData]
    split_ifs <;> rfl
  have hbase := travelingWave_isRectangleConservationLawSolution
    (riemannData (entropy left) (entropy right) (entropy right))
    (riemannData_intervalIntegrable _ _ _) speed
  rw [← hmap entropy] at hbase
  have hflux (x : ℝ) : IntervalIntegrable (fun τ => entropyFlux (q x τ)) volume s t := by
    have h := travelingWave_intervalIntegrable_time
      (riemannData (entropyFlux left) (entropyFlux right) (entropyFlux right))
      (riemannData_intervalIntegrable _ _ _) speed x s t
    simpa only [← hmap entropyFlux] using h
  have hpoint (τ : ℝ) :
      speed * entropy (q a τ) - speed * entropy (q b τ) ≤
        entropyFlux (q a τ) - entropyFlux (q b τ) := by
    by_cases ha : a - speed * τ < 0
    · by_cases hb : b - speed * τ < 0
      · simp [q, travelingWave, riemannData, ha, hb]
      · simpa [q, travelingWave, riemannData, ha, hb, mul_sub] using hdissipation
    · have hb : ¬ b - speed * τ < 0 := by linarith
      simp [q, travelingWave, riemannData, ha, hb]
  dsimp only
  change (∫ x in a..b, entropy (q x t)) - (∫ x in a..b, entropy (q x s)) ≤ _
  rw [hbase.2.2 a b s t]
  apply intervalIntegral.integral_mono hst
    ((hbase.2.1 a s t).sub (hbase.2.1 b s t)) ((hflux a).sub (hflux b))
  exact hpoint

end NumStability
