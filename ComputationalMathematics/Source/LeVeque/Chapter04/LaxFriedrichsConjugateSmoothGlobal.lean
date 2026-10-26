/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsConjugateAccuracy

/-!
# Smooth characteristic solutions for a conjugated nonlinear system

The smooth scalar exact-solution estimates apply to the physical vector
equation-(4.20) update after a fixed change of basis. The exact physical
cell averages are the inverse-basis images of the scalar cell averages.
-/

namespace NumStability

/-- Smooth periodic characteristic solutions give a first-order
fixed-horizon mean error for the physical vector Lax–Friedrichs update
with a fixed-basis conjugated nonlinear flux. -/
theorem leveque04_periodicConjugateNonlinearLaxFriedrichs_smoothFixedHorizonAccuracy
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
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
      leveque04_periodicVectorLaxFriedrichsStep n
        (leveque04_conjugateNonlinearFlux basis flux) ratio (approx k) i)
    (hhorizon : (steps : ℝ) * (ratio * width) ≤ horizon)
    (p : Fin m) :
    let exactState : ℕ → ZMod n → Fin m → ℝ := fun k i =>
      basis.equivFun.symm (fun r =>
        leveque04_periodicScalarExactCellAverage n (q r) width (times k) i)
    (∑ i : ZMod n,
        |basis.equivFun (approx steps i) p -
          basis.equivFun (exactState steps i) p|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n,
        |basis.equivFun (approx 0 i) p -
          basis.equivFun (exactState 0 i) p|) /
        (Fintype.card (ZMod n) : ℝ) +
      horizon *
        ((2 * Kspace + ratio *
          (K * (M + Kspace * maxWidth) ^ 2)) / ratio) * width := by
  dsimp only
  have hdiagApprox : ∀ k i,
      basis.equivFun (approx (k + 1) i) =
        leveque04_periodicDiagonalNonlinearLaxFriedrichsStep n flux ratio
          (fun j => basis.equivFun (approx k j)) i := by
    intro k i
    rw [happrox k i]
    funext r
    exact leveque04_periodicConjugateNonlinearLaxFriedrichs_characteristicStep
      n basis flux ratio (approx k) i r
  have hdiag := leveque04_periodicDiagonalNonlinearLaxFriedrichs_smoothFixedHorizonAccuracy
    n hn q flux flux' profileDeriv
    width ratio L Kspace K S M maxWidth Ktime horizon times a b
    (fun k i => basis.equivFun (approx k i)) steps
    hwidth hratio hcflGlobal hfluxGlobal hmax hKspace hK hS hM hKtime
    hbudget ha hb htimes hq hperiod hprofile hspaceLip hfluxDeriv
    hfluxLip hcell hdiagApprox hhorizon p
  simpa only [basis.equivFun.apply_symm_apply] using hdiag

end NumStability
