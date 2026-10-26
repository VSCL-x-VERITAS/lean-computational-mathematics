/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorCharacteristicStability
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsFiniteHorizonAccuracy

/-!
# Fixed-horizon error transfer in characteristic coordinates

The actual physical vector equation-(4.20) update for a diagonalizable
constant matrix inherits the scalar finite-horizon estimate in each
characteristic coordinate. The result keeps the adapted error measure
and the local residual hypothesis explicit.
-/

namespace NumStability

open scoped BigOperators

theorem leveque04_periodicVectorLaxFriedrichs_characteristic_finiteHorizonAccuracy
    {m : ℕ} (n : ℕ) [NeZero n]
    (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) =
      waveSpeed p • basis p)
    (ratio timeStep width localBound horizon : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hbound : 0 ≤ localBound)
    (approx exactState : ℕ → ZMod n → Fin m → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicVectorLaxFriedrichsStep n
        coefficient.mulVec ratio (approx k) i)
    (steps : ℕ)
    (hlocal : ∀ k, k < steps → ∀ i p,
      |(basis.equivFun
          (leveque04_periodicVectorLaxFriedrichsStep n
            coefficient.mulVec ratio (exactState k) i) p -
        basis.equivFun (exactState (k + 1) i) p) / timeStep| ≤
        localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ p : Fin m,
      (∑ i : ZMod n,
        |basis.equivFun (approx steps i) p -
          basis.equivFun (exactState steps i) p|) /
        (Fintype.card (ZMod n) : ℝ)) ≤
      ∑ p : Fin m,
        ((∑ i : ZMod n,
          |basis.equivFun (approx 0 i) p -
            basis.equivFun (exactState 0 i) p|) /
          (Fintype.card (ZMod n) : ℝ) +
            horizon * localBound * width) := by
  apply Finset.sum_le_sum
  intro p _
  have hcflp : ratio * |waveSpeed p| ≤ 1 := by
    calc
      ratio * |waveSpeed p| = |waveSpeed p * ratio| := by
        rw [abs_mul, abs_of_nonneg hratio]
        ring
      _ ≤ 1 := hcfl p
  have hflux : ∀ x y,
      |waveSpeed p * x - waveSpeed p * y| ≤
        |waveSpeed p| * |x - y| := by
    intro x y
    rw [← mul_sub, abs_mul]
  exact leveque04_periodicNonlinearLaxFriedrichs_finiteHorizonAccuracy
    n (fun x => waveSpeed p * x)
    ratio |waveSpeed p| timeStep width localBound horizon
    hratio hcflp hflux htime hwidth hbound
    (fun k i => basis.equivFun (approx k i) p)
    (fun k i => basis.equivFun (exactState k i) p)
    (by
      intro k i
      change basis.equivFun (approx (k + 1) i) p =
        leveque04_periodicNonlinearLaxFriedrichsStep n
          (fun x => waveSpeed p * x) ratio
          (fun j => basis.equivFun (approx k j) p) i
      rw [happrox k i]
      exact leveque04_periodicVectorLaxFriedrichs_characteristicStep
        n coefficient basis waveSpeed heigen ratio (approx k) i p)
    steps
    (by
      intro k hk i
      rw [← leveque04_periodicVectorLaxFriedrichs_characteristicStep
        n coefficient basis waveSpeed heigen ratio (exactState k) i p]
      exact hlocal k hk i p)
    hhorizon

end NumStability
