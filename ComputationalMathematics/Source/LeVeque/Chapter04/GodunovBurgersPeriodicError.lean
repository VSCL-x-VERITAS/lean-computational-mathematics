/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersBoundedStep
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersLocalTruncation
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicAverages

/-!
# Actual Burgers Godunov error on smooth periodic exact averages

The existing periodic sampling lemmas identify the wrapped neighbors. The
physical rectangle law is required only on each forward comparison step.
-/

open MeasureTheory

namespace NumStability

private theorem scalarLift_average
    (q : ℝ → ℝ) (left right : ℝ) (hq : Continuous q) :
    oneDimensionalCellAverage (fun x (_ : Fin 1) => q x) left right 0 =
      oneDimensionalCellAverage q left right := by
  exact oneDimensionalCellAverage_apply _ _ _
    ((continuous_pi (fun _ => hq)).intervalIntegrable _ _) 0

private theorem sampled_scalarLift_average
    (n : ℕ) (q : ℝ → ℝ → ℝ) (width time : ℝ) (i : ZMod n)
    (hq : Continuous (fun x => q x time)) :
    leveque04_periodicVectorExactCellAverage n (fun x τ (_ : Fin 1) => q x τ) width time i 0 =
      oneDimensionalCellAverage (fun x => q x time)
        ((i.val : ℝ) * width - width / 2) ((i.val : ℝ) * width + width / 2) := by
  exact scalarLift_average _ _ _ hq

/-- The real-line local estimate applies at every cell, including the
periodic seam, to the actual evaluated Godunov step. -/
theorem leveque04_burgersGodunov_periodic_localTruncation
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → ℝ) (qX : ℝ → ℝ)
    (B M K D width oldTime timeStep : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ x, HasDerivAt (fun y => q y oldTime) (qX x) x)
    (hqNext : Continuous (fun x => q x (oldTime + timeStep)))
    (hperiod : ∀ x, q (x + (n : ℝ) * width) oldTime = q x oldTime)
    (hvalue : ∀ x, 0 ≤ q x oldTime ∧ |q x oldTime| ≤ B)
    (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|)
    (hTime : ∀ center τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance : ∀ center,
      (∫ x in center - width / 2..center + width / 2, q x (oldTime + timeStep)) -
          (∫ x in center - width / 2..center + width / 2, q x oldTime) =
        ∫ τ in oldTime..oldTime + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2))
    (i : ZMod n) :
    let exact := fun τ j => leveque04_periodicVectorExactCellAverage n
      (fun x t (_ : Fin 1) => q x t) width τ j 0
    |(leveque04_burgersGodunovStep n (timeStep / width) (exact oldTime) i -
      exact (oldTime + timeStep) i) / timeStep| ≤
      2 * (B * K + M ^ 2) * width + D * timeStep := by
  have hcont : Continuous (fun x => q x oldTime) := continuous_iff_continuousAt.mpr
    (fun x => (hq x).continuousAt)
  have hright := congrArg (fun v : Fin 1 → ℝ => v 0)
    (leveque04_periodicVectorExactCellAverage_right n hn
      (fun x τ (_ : Fin 1) => q x τ) width oldTime
      (fun x => funext (fun _ => hperiod x)) i)
  have hleft := congrArg (fun v : Fin 1 → ℝ => v 0)
    (leveque04_periodicVectorExactCellAverage_left n hn
      (fun x τ (_ : Fin 1) => q x τ) width oldTime
      (fun x => funext (fun _ => hperiod x)) i)
  dsimp only at hright hleft
  rw [scalarLift_average _ _ _ hcont] at hright hleft
  have hcast : ((i.val + 1 : ℕ) : ℝ) * width = (i.val : ℝ) * width + width := by
    push_cast
    ring
  rw [hcast] at hright
  have h := leveque04_burgersGodunov_exactAverage_localTruncation q qX
    B M K D ((i.val : ℝ) * width) width oldTime timeStep hB hM hK hD hwidth htime
    hq hvalue hderiv hLip (hTime _) (hbalance _)
  dsimp only
  simp only [leveque04_burgersGodunovStep, finitePeriodicTwoStateFluxStep,
    finitePeriodicFluxDifferenceUpdate, Equiv.coe_addRight, add_sub_cancel_right]
  rw [hright, hleft, sampled_scalarLift_average _ _ _ _ _ hcont,
    sampled_scalarLift_average _ _ _ _ _ hqNext]
  exact h

/-- Smooth nonnegative periodic exact cell averages have a first-order
finite-time mean L1 error for the actual Burgers Godunov step. Physical
balance and smoothness are required only through the comparison horizon. -/
theorem leveque04_burgersGodunov_periodic_fixedHorizonMeanError
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q qX : ℝ → ℝ → ℝ) (B M K D width startTime timeStep horizon : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hcfl : timeStep / width * (B + B) ≤ 1)
    (approx : ℕ → ZMod n → ℝ) (steps : ℕ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_burgersGodunovStep n (timeStep / width) (approx k) i)
    (hinitial : ∀ i, -B ≤ approx 0 i ∧ approx 0 i ≤ B)
    (hq : ∀ k ≤ steps, ∀ x,
      HasDerivAt (fun y => q y (startTime + (k : ℝ) * timeStep))
        (qX x (startTime + (k : ℝ) * timeStep)) x)
    (hperiod : ∀ k < steps, ∀ x,
      q (x + (n : ℝ) * width) (startTime + (k : ℝ) * timeStep) =
        q x (startTime + (k : ℝ) * timeStep))
    (hvalue : ∀ k ≤ steps, ∀ x,
      0 ≤ q x (startTime + (k : ℝ) * timeStep) ∧
        |q x (startTime + (k : ℝ) * timeStep)| ≤ B)
    (hderiv : ∀ k < steps, ∀ x, |qX x (startTime + (k : ℝ) * timeStep)| ≤ M)
    (hLip : ∀ k < steps, ∀ x y,
      |qX x (startTime + (k : ℝ) * timeStep) - qX y (startTime + (k : ℝ) * timeStep)| ≤
        K * |x - y|)
    (hTime : ∀ center τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance : ∀ k < steps, ∀ center,
      (∫ x in center - width / 2..center + width / 2,
        q x (startTime + (k : ℝ) * timeStep + timeStep)) -
          (∫ x in center - width / 2..center + width / 2,
            q x (startTime + (k : ℝ) * timeStep)) =
        ∫ τ in startTime + (k : ℝ) * timeStep..startTime + (k : ℝ) * timeStep + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2))
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    let exact := fun (k : ℕ) i => leveque04_periodicVectorExactCellAverage n
      (fun x τ (_ : Fin 1) => q x τ) width (startTime + (k : ℝ) * timeStep) i 0
    (∑ i, |approx steps i - exact steps i|) / (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i, |approx 0 i - exact 0 i|) / (Fintype.card (ZMod n) : ℝ) +
        horizon * (2 * (B * K + M ^ 2) + D * (timeStep / width)) * width := by
  let exact := fun (k : ℕ) i => leveque04_periodicVectorExactCellAverage n
    (fun x τ (_ : Fin 1) => q x τ) width (startTime + (k : ℝ) * timeStep) i 0
  let residual := fun k i => exact (k + 1) i -
    leveque04_burgersGodunovStep n (timeStep / width) (exact k) i
  have hcont (k : ℕ) (hk : k ≤ steps) :
      Continuous (fun x => q x (startTime + (k : ℝ) * timeStep)) :=
    continuous_iff_continuousAt.mpr (fun x => (hq k hk x).continuousAt)
  have hexactBound : ∀ k ≤ steps, ∀ i, -B ≤ exact k i ∧ exact k i ≤ B := by
    intro k hk i
    have hinterval : (i.val : ℝ) * width - width / 2 <
        (i.val : ℝ) * width + width / 2 := by linarith
    have h := abs_oneDimensionalCellAverage_le_of_bound
      (fun x => q x (startTime + (k : ℝ) * timeStep)) B _ _ hinterval
      ((hcont k hk).intervalIntegrable _ _) (fun x => (hvalue k hk x).2)
    dsimp only [exact]
    rw [sampled_scalarLift_average _ _ _ _ _ (hcont k hk)]
    exact abs_le.mp h
  have hbound : 0 ≤ 2 * (B * K + M ^ 2) + D * (timeStep / width) := by positivity
  apply leveque04_burgersGodunovStep_fixedHorizonMeanError_prefix n
    B (timeStep / width) timeStep width (2 * (B * K + M ^ 2) + D * (timeStep / width))
    horizon hB (div_nonneg htime.le hwidth.le) hcfl htime.le hwidth hbound
    approx exact residual steps happrox hinitial hexactBound
  · intro k _ i
    dsimp [residual]
    ring
  · intro k hk i
    have htimeEq : startTime + ((k + 1 : ℕ) : ℝ) * timeStep =
        startTime + (k : ℝ) * timeStep + timeStep := by push_cast; ring
    have hnext : Continuous (fun x => q x (startTime + (k : ℝ) * timeStep + timeStep)) := by
      rw [← htimeEq]
      exact hcont (k + 1) (by omega)
    have h := leveque04_burgersGodunov_periodic_localTruncation n hn q
      (fun x => qX x (startTime + (k : ℝ) * timeStep))
      B M K D width (startTime + (k : ℝ) * timeStep) timeStep hB hM hK hD hwidth htime
      (hq k (Nat.le_of_lt hk)) hnext (hperiod k hk) (hvalue k (Nat.le_of_lt hk))
      (hderiv k hk) (hLip k hk) hTime (hbalance k hk) i
    dsimp only at h
    rw [← htimeEq, abs_div, abs_of_pos htime] at h
    have hscaled := (div_le_iff₀ htime).mp h
    have hfactor : (2 * (B * K + M ^ 2) * width + D * timeStep) * timeStep =
        timeStep * (2 * (B * K + M ^ 2) + D * (timeStep / width)) * width := by
      field_simp
    rw [hfactor] at hscaled
    simpa only [residual, exact, abs_sub_comm] using hscaled
  · exact hhorizon

/-- The mixed-sign real-line local estimate applies at every cell, including the
periodic seam, to the actual evaluated Godunov step. -/
theorem leveque04_burgersGodunov_mixed_periodic_localTruncation
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → ℝ) (qX : ℝ → ℝ)
    (B M K D width oldTime timeStep : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ x, HasDerivAt (fun y => q y oldTime) (qX x) x)
    (hqNext : Continuous (fun x => q x (oldTime + timeStep)))
    (hperiod : ∀ x, q (x + (n : ℝ) * width) oldTime = q x oldTime)
    (hvalue : ∀ x, |q x oldTime| ≤ B)
    (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|)
    (hTime : ∀ center τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance : ∀ center,
      (∫ x in center - width / 2..center + width / 2, q x (oldTime + timeStep)) -
          (∫ x in center - width / 2..center + width / 2, q x oldTime) =
        ∫ τ in oldTime..oldTime + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2))
    (i : ZMod n) :
    let exact := fun τ j => leveque04_periodicVectorExactCellAverage n
      (fun x t (_ : Fin 1) => q x t) width τ j 0
    |(leveque04_burgersGodunovStep n (timeStep / width) (exact oldTime) i -
      exact (oldTime + timeStep) i) / timeStep| ≤
      (3 * (B * K + M ^ 2) + M ^ 2) * width + D * timeStep := by
  have hcont : Continuous (fun x => q x oldTime) := continuous_iff_continuousAt.mpr
    (fun x => (hq x).continuousAt)
  have hright := congrArg (fun v : Fin 1 → ℝ => v 0)
    (leveque04_periodicVectorExactCellAverage_right n hn
      (fun x τ (_ : Fin 1) => q x τ) width oldTime
      (fun x => funext (fun _ => hperiod x)) i)
  have hleft := congrArg (fun v : Fin 1 → ℝ => v 0)
    (leveque04_periodicVectorExactCellAverage_left n hn
      (fun x τ (_ : Fin 1) => q x τ) width oldTime
      (fun x => funext (fun _ => hperiod x)) i)
  dsimp only at hright hleft
  rw [scalarLift_average _ _ _ hcont] at hright hleft
  have hcast : ((i.val + 1 : ℕ) : ℝ) * width = (i.val : ℝ) * width + width := by
    push_cast
    ring
  rw [hcast] at hright
  have h := leveque04_burgersGodunov_mixed_exactAverage_localTruncation q qX
    B M K D ((i.val : ℝ) * width) width oldTime timeStep hB hM hK hD hwidth htime
    hq hvalue hderiv hLip (hTime _) (hbalance _)
  dsimp only
  simp only [leveque04_burgersGodunovStep, finitePeriodicTwoStateFluxStep,
    finitePeriodicFluxDifferenceUpdate, Equiv.coe_addRight, add_sub_cancel_right]
  rw [hright, hleft, sampled_scalarLift_average _ _ _ _ _ hcont,
    sampled_scalarLift_average _ _ _ _ _ hqNext]
  exact h

/-- Smooth periodic exact cell averages of arbitrary signs have a first-order
finite-time mean L1 error for the actual Burgers Godunov step. Physical
balance and smoothness are required only through the comparison horizon. -/
theorem leveque04_burgersGodunov_mixed_periodic_fixedHorizonMeanError
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q qX : ℝ → ℝ → ℝ) (B M K D width startTime timeStep horizon : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hcfl : timeStep / width * (B + B) ≤ 1)
    (approx : ℕ → ZMod n → ℝ) (steps : ℕ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_burgersGodunovStep n (timeStep / width) (approx k) i)
    (hinitial : ∀ i, -B ≤ approx 0 i ∧ approx 0 i ≤ B)
    (hq : ∀ k ≤ steps, ∀ x,
      HasDerivAt (fun y => q y (startTime + (k : ℝ) * timeStep))
        (qX x (startTime + (k : ℝ) * timeStep)) x)
    (hperiod : ∀ k < steps, ∀ x,
      q (x + (n : ℝ) * width) (startTime + (k : ℝ) * timeStep) =
        q x (startTime + (k : ℝ) * timeStep))
    (hvalue : ∀ k ≤ steps, ∀ x,
      |q x (startTime + (k : ℝ) * timeStep)| ≤ B)
    (hderiv : ∀ k < steps, ∀ x, |qX x (startTime + (k : ℝ) * timeStep)| ≤ M)
    (hLip : ∀ k < steps, ∀ x y,
      |qX x (startTime + (k : ℝ) * timeStep) - qX y (startTime + (k : ℝ) * timeStep)| ≤
        K * |x - y|)
    (hTime : ∀ center τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance : ∀ k < steps, ∀ center,
      (∫ x in center - width / 2..center + width / 2,
        q x (startTime + (k : ℝ) * timeStep + timeStep)) -
          (∫ x in center - width / 2..center + width / 2,
            q x (startTime + (k : ℝ) * timeStep)) =
        ∫ τ in startTime + (k : ℝ) * timeStep..startTime + (k : ℝ) * timeStep + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2))
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    let exact := fun (k : ℕ) i => leveque04_periodicVectorExactCellAverage n
      (fun x τ (_ : Fin 1) => q x τ) width (startTime + (k : ℝ) * timeStep) i 0
    (∑ i, |approx steps i - exact steps i|) / (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i, |approx 0 i - exact 0 i|) / (Fintype.card (ZMod n) : ℝ) +
        horizon * ((3 * (B * K + M ^ 2) + M ^ 2) + D * (timeStep / width)) * width := by
  let exact := fun (k : ℕ) i => leveque04_periodicVectorExactCellAverage n
    (fun x τ (_ : Fin 1) => q x τ) width (startTime + (k : ℝ) * timeStep) i 0
  let residual := fun k i => exact (k + 1) i -
    leveque04_burgersGodunovStep n (timeStep / width) (exact k) i
  have hcont (k : ℕ) (hk : k ≤ steps) :
      Continuous (fun x => q x (startTime + (k : ℝ) * timeStep)) :=
    continuous_iff_continuousAt.mpr (fun x => (hq k hk x).continuousAt)
  have hexactBound : ∀ k ≤ steps, ∀ i, -B ≤ exact k i ∧ exact k i ≤ B := by
    intro k hk i
    have hinterval : (i.val : ℝ) * width - width / 2 <
        (i.val : ℝ) * width + width / 2 := by linarith
    have h := abs_oneDimensionalCellAverage_le_of_bound
      (fun x => q x (startTime + (k : ℝ) * timeStep)) B _ _ hinterval
      ((hcont k hk).intervalIntegrable _ _) (hvalue k hk)
    dsimp only [exact]
    rw [sampled_scalarLift_average _ _ _ _ _ (hcont k hk)]
    exact abs_le.mp h
  have hbound : 0 ≤ (3 * (B * K + M ^ 2) + M ^ 2) + D * (timeStep / width) := by positivity
  apply leveque04_burgersGodunovStep_fixedHorizonMeanError_prefix n
    B (timeStep / width) timeStep width ((3 * (B * K + M ^ 2) + M ^ 2) + D * (timeStep / width))
    horizon hB (div_nonneg htime.le hwidth.le) hcfl htime.le hwidth hbound
    approx exact residual steps happrox hinitial hexactBound
  · intro k _ i
    dsimp [residual]
    ring
  · intro k hk i
    have htimeEq : startTime + ((k + 1 : ℕ) : ℝ) * timeStep =
        startTime + (k : ℝ) * timeStep + timeStep := by push_cast; ring
    have hnext : Continuous (fun x => q x (startTime + (k : ℝ) * timeStep + timeStep)) := by
      rw [← htimeEq]
      exact hcont (k + 1) (by omega)
    have h := leveque04_burgersGodunov_mixed_periodic_localTruncation n hn q
      (fun x => qX x (startTime + (k : ℝ) * timeStep))
      B M K D width (startTime + (k : ℝ) * timeStep) timeStep hB hM hK hD hwidth htime
      (hq k (Nat.le_of_lt hk)) hnext (hperiod k hk) (hvalue k (Nat.le_of_lt hk))
      (hderiv k hk) (hLip k hk) hTime (hbalance k hk) i
    dsimp only at h
    rw [← htimeEq, abs_div, abs_of_pos htime] at h
    have hscaled := (div_le_iff₀ htime).mp h
    have hfactor : ((3 * (B * K + M ^ 2) + M ^ 2) * width + D * timeStep) * timeStep =
        timeStep * ((3 * (B * K + M ^ 2) + M ^ 2) + D * (timeStep / width)) * width := by
      field_simp
    rw [hfactor] at hscaled
    simpa only [residual, exact, abs_sub_comm] using hscaled
  · exact hhorizon

end NumStability
