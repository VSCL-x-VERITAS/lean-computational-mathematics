/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsConjugateNonlinear

/-!
# Finite-horizon error for a conjugated nonlinear system

The physical flux can couple state components while becoming
componentwise nonlinear in a fixed basis. The source equation-(4.20)
vector update then inherits the diagonal scalar CFL error transfer in
every characteristic coordinate.
-/

namespace NumStability

/-- The periodic vector Lax–Friedrichs step for a basis-conjugated
nonlinear flux has first-order fixed-horizon mean error in each
characteristic coordinate under a uniform local residual. -/
theorem leveque04_periodicConjugateNonlinearLaxFriedrichs_finiteHorizonAccuracy
    {m : ℕ} (n : ℕ) [NeZero n]
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (flux : Fin m → ℝ → ℝ)
    (ratio L timeStep width localBound horizon : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : ratio * L ≤ 1)
    (hflux : ∀ p x y, |flux p x - flux p y| ≤ L * |x - y|)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hbound : 0 ≤ localBound)
    (approx exactState : ℕ → ZMod n → Fin m → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicVectorLaxFriedrichsStep n
        (leveque04_conjugateNonlinearFlux basis flux)
        ratio (approx k) i)
    (steps : ℕ)
    (hlocal : ∀ k, k < steps → ∀ i p,
      |(basis.equivFun
          (leveque04_periodicVectorLaxFriedrichsStep n
            (leveque04_conjugateNonlinearFlux basis flux)
            ratio (exactState k) i) p -
          basis.equivFun (exactState (k + 1) i) p) /
          timeStep| ≤ localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon)
    (p : Fin m) :
    (∑ i : ZMod n,
        |basis.equivFun (approx steps i) p -
          basis.equivFun (exactState steps i) p|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n,
        |basis.equivFun (approx 0 i) p -
          basis.equivFun (exactState 0 i) p|) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  exact leveque04_periodicDiagonalNonlinearLaxFriedrichs_finiteHorizonAccuracy
    n flux ratio L timeStep width localBound horizon
    hratio hcfl hflux htime hwidth hbound
    (fun k i => basis.equivFun (approx k i))
    (fun k i => basis.equivFun (exactState k i))
    (by
      intro k i
      change basis.equivFun (approx (k + 1) i) =
        leveque04_periodicDiagonalNonlinearLaxFriedrichsStep n flux ratio
          (fun j => basis.equivFun (approx k j)) i
      rw [happrox k i]
      funext p
      exact leveque04_periodicConjugateNonlinearLaxFriedrichs_characteristicStep
        n basis flux ratio (approx k) i p)
    steps
    (by
      intro k hk i p
      simpa only [leveque04_periodicConjugateNonlinearLaxFriedrichs_characteristicStep]
        using hlocal k hk i p)
    hhorizon p

end NumStability
