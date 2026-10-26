/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsDiagonalSystem
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicSmoothGlobal

/-!
# Smooth exact solutions for diagonal nonlinear Lax–Friedrichs systems

Every component of a diagonal nonlinear conservation law has the
existing scalar smooth exact-cell-average residual and periodic L1
contraction. The same equation-(4.20) vector update therefore has a
first-order mean error in each physical component over a fixed horizon.
-/

namespace NumStability

/-- The diagonal nonlinear equation-(4.20) update has first-order
componentwise mean L1 error on smooth periodic exact cell averages
under uniform scalar CFL and smoothness hypotheses. -/
theorem leveque04_periodicDiagonalNonlinearLaxFriedrichs_smoothFixedHorizonAccuracy
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : Fin m → ℝ → ℝ → Fin 1 → ℝ)
    (flux flux' : Fin m → ℝ → ℝ)
    (profileDeriv : Fin m → ℕ → ℝ → ℝ)
    (width ratio L Kspace K S M maxWidth Ktime horizon : ℝ)
    (times : ℕ → ℝ) (a b : ZMod n → ℝ)
    (approx : ℕ → ZMod n → Fin m → ℝ) (steps : ℕ)
    (hwidth : 0 < width) (hratio : 0 < ratio)
    (hcflGlobal : ratio * L ≤ 1)
    (hfluxGlobal : ∀ p x y, |flux p x - flux p y| ≤ L * |x - y|)
    (hmax : width ≤ maxWidth)
    (hKspace : 0 ≤ Kspace) (hK : 0 ≤ K)
    (hS : 0 ≤ S) (hM : 0 ≤ M) (hKtime : 0 ≤ Ktime)
    (hbudget : Ktime * ratio ^ 2 +
      (2 * (K * S ^ 2)) * ratio ≤ Kspace)
    (ha : ∀ i, a i = (i.val : ℝ) * width - width / 2)
    (hb : ∀ i, b i = (i.val : ℝ) * width + width / 2)
    (htimes : ∀ k, times (k + 1) = times k + ratio * width)
    (hq : ∀ p, IsRectangleConservationLawSolution (q p)
      (fun state _ => flux p (state 0)))
    (hperiod : ∀ p k, k < steps → ∀ x,
      q p (x + (n : ℝ) * width) (times k) 0 =
        q p x (times k) 0)
    (hprofile : ∀ p k, k < steps → ∀ x, HasDerivAt
      (fun y => q p y (times k) 0) (profileDeriv p k x) x)
    (hspaceLip : ∀ p k, k < steps → ∀ x y,
      |profileDeriv p k x - profileDeriv p k y| ≤
        Kspace * |x - y|)
    (hfluxDeriv : ∀ p y, HasDerivAt (flux p) (flux' p y) y)
    (hfluxLip : ∀ p y z, |flux' p y - flux' p z| ≤
      K * |y - z|)
    (hcell : ∀ p k, k < steps → ∀ i,
      Continuous (fun τ => flux p (q p (a i) τ 0) -
        flux p (q p (b i) τ 0)) ∧
      (∀ s τ,
        |(flux p (q p (a i) s 0) - flux p (q p (b i) s 0)) / width -
          (flux p (q p (a i) τ 0) - flux p (q p (b i) τ 0)) / width| ≤
          Ktime * |s - τ|) ∧
      |q p (a i) (times k) 0 -
        (oneDimensionalCellAverage (fun x => q p x (times k))
          (a i) (b i)) 0| ≤ S * width ∧
      |q p (b i) (times k) 0 -
        (oneDimensionalCellAverage (fun x => q p x (times k))
          (a i) (b i)) 0| ≤ S * width ∧
      |(q p (b i) (times k) 0 - q p (a i) (times k) 0) / width| ≤ M ∧
      |flux' p ((oneDimensionalCellAverage
        (fun x => q p x (times k)) (a i) (b i)) 0) * ratio| ≤ 1)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicDiagonalNonlinearLaxFriedrichsStep
        n flux ratio (approx k) i)
    (hhorizon : (steps : ℝ) * (ratio * width) ≤ horizon)
    (p : Fin m) :
    let exactState : ℕ → ZMod n → Fin m → ℝ := fun k i p =>
      leveque04_periodicScalarExactCellAverage n (q p) width (times k) i
    (∑ i : ZMod n, |approx steps i p - exactState steps i p|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, |approx 0 i p - exactState 0 i p|) /
        (Fintype.card (ZMod n) : ℝ) +
      horizon *
        ((2 * Kspace + ratio *
          (K * (M + Kspace * maxWidth) ^ 2)) / ratio) * width := by
  dsimp only
  have hscalarApprox : ∀ k i,
      approx (k + 1) i p =
        leveque04_periodicNonlinearLaxFriedrichsStep n (flux p) ratio
          (fun j => approx k j p) i := by
    intro k i
    rw [happrox k i]
    exact leveque04_periodicDiagonalNonlinearLaxFriedrichs_component
      n flux ratio (approx k) i p
  exact leveque04_periodicNonlinearLaxFriedrichs_smoothFixedHorizonAccuracy
    n hn (q p) (flux p) (flux' p) (profileDeriv p)
    width ratio L Kspace K S M maxWidth Ktime horizon
    times a b (fun k i => approx k i p) steps
    hwidth hratio hcflGlobal (hfluxGlobal p) hmax
    hKspace hK hS hM hKtime hbudget ha hb htimes
    (hq p) (hperiod p) (hprofile p) (hspaceLip p)
    (hfluxDeriv p) (hfluxLip p) (hcell p)
    hscalarApprox hhorizon

end NumStability
