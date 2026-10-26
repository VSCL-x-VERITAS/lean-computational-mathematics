/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicSmoothResidual
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsFiniteHorizonAccuracy

/-!
# Fixed-horizon error for a smooth exact periodic scalar solution

Uniform smoothness and CFL bounds supply the same local residual at
every periodic cell and time step. Scalar L1 contraction then controls
the accumulated error over a fixed horizon.
-/

namespace NumStability

/-- Under uniform smoothness and stability hypotheses, nonlinear
periodic Lax–Friedrichs has first-order mean L1 error against exact
scalar cell averages over a fixed horizon. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_smoothFixedHorizonAccuracy
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux flux' : ℝ → ℝ)
    (profileDeriv : ℕ → ℝ → ℝ)
    (width ratio L Kspace K S M maxWidth Ktime horizon : ℝ)
    (times : ℕ → ℝ) (a b : ZMod n → ℝ)
    (approx : ℕ → ZMod n → ℝ) (steps : ℕ)
    (hwidth : 0 < width) (hratio : 0 < ratio)
    (hcflGlobal : ratio * L ≤ 1)
    (hfluxGlobal : ∀ x y, |flux x - flux y| ≤ L * |x - y|)
    (hmax : width ≤ maxWidth)
    (hKspace : 0 ≤ Kspace) (hK : 0 ≤ K)
    (hS : 0 ≤ S) (hM : 0 ≤ M) (hKtime : 0 ≤ Ktime)
    (hbudget : Ktime * ratio ^ 2 +
      (2 * (K * S ^ 2)) * ratio ≤ Kspace)
    (ha : ∀ i, a i = (i.val : ℝ) * width - width / 2)
    (hb : ∀ i, b i = (i.val : ℝ) * width + width / 2)
    (htimes : ∀ k, times (k + 1) = times k + ratio * width)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ k, k < steps → ∀ x,
      q (x + (n : ℝ) * width) (times k) 0 = q x (times k) 0)
    (hprofile : ∀ k, k < steps → ∀ x, HasDerivAt
      (fun y => q y (times k) 0) (profileDeriv k x) x)
    (hspaceLip : ∀ k, k < steps → ∀ x y,
      |profileDeriv k x - profileDeriv k y| ≤ Kspace * |x - y|)
    (hfluxDeriv : ∀ y, HasDerivAt flux (flux' y) y)
    (hfluxLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (hcell : ∀ k, k < steps → ∀ i,
      Continuous (fun τ => flux (q (a i) τ 0) - flux (q (b i) τ 0)) ∧
      (∀ s τ,
        |(flux (q (a i) s 0) - flux (q (b i) s 0)) / width -
          (flux (q (a i) τ 0) - flux (q (b i) τ 0)) / width| ≤
          Ktime * |s - τ|) ∧
      |q (a i) (times k) 0 -
        (oneDimensionalCellAverage (fun x => q x (times k))
          (a i) (b i)) 0| ≤ S * width ∧
      |q (b i) (times k) 0 -
        (oneDimensionalCellAverage (fun x => q x (times k))
          (a i) (b i)) 0| ≤ S * width ∧
      |(q (b i) (times k) 0 - q (a i) (times k) 0) / width| ≤ M ∧
      |flux' ((oneDimensionalCellAverage
        (fun x => q x (times k)) (a i) (b i)) 0) * ratio| ≤ 1)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (approx k) i)
    (hhorizon : (steps : ℝ) * (ratio * width) ≤ horizon) :
    let exactState : ℕ → ZMod n → ℝ := fun k =>
      leveque04_periodicScalarExactCellAverage n q width (times k)
    (∑ i : ZMod n, |approx steps i - exactState steps i|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, |approx 0 i - exactState 0 i|) /
        (Fintype.card (ZMod n) : ℝ) +
      horizon *
        ((2 * Kspace + ratio *
          (K * (M + Kspace * maxWidth) ^ 2)) / ratio) * width := by
  let exactState : ℕ → ZMod n → ℝ := fun k =>
    leveque04_periodicScalarExactCellAverage n q width (times k)
  let localBound : ℝ :=
    (2 * Kspace + ratio * (K * (M + Kspace * maxWidth) ^ 2)) / ratio
  have hbound : 0 ≤ localBound := by
    dsimp [localBound]
    positivity
  have hlocal : ∀ k, k < steps → ∀ i,
      |(leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
          (exactState k) i - exactState (k + 1) i) /
          (ratio * width)| ≤ localBound * width := by
    intro k hk i
    obtain ⟨hcont, hrate, hfaceL, hfaceR, hslope, hcfl⟩ := hcell k hk i
    have h := leveque04_periodicNonlinearLaxFriedrichs_smoothExactResidual
      n hn q flux flux' (profileDeriv k)
      (a i) (b i) width (times k) ratio Kspace K S M maxWidth Ktime i
      (ha i) (hb i) hwidth hratio hmax hKspace hK hS hM hKtime
      hq (hperiod k hk) (hprofile k hk) (hspaceLip k hk) hcont
      hfluxDeriv hfluxLip hrate hfaceL hfaceR hslope hcfl hbudget
    simpa only [exactState, localBound, htimes k] using h
  exact leveque04_periodicNonlinearLaxFriedrichs_finiteHorizonAccuracy
    n flux ratio L (ratio * width) width localBound horizon
    hratio.le hcflGlobal hfluxGlobal (mul_pos hratio hwidth)
    hwidth hbound approx exactState happrox steps hlocal hhorizon

end NumStability
