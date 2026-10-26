/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsFiniteHorizonAccuracy
import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux

/-!
# Periodic diagonal nonlinear Lax–Friedrichs systems

For a componentwise nonlinear physical flux, equation (4.20)
decomposes into scalar nonlinear Lax–Friedrichs steps. The existing
scalar finite-horizon L1 estimate then applies to each component of
the same vector update.
-/

namespace NumStability

/-- The periodic equation-(4.20) Lax–Friedrichs update with a
componentwise nonlinear physical flux. -/
noncomputable def leveque04_periodicDiagonalNonlinearLaxFriedrichsStep
    {m : ℕ} (n : ℕ) [NeZero n] (flux : Fin m → ℝ → ℝ)
    (ratio : ℝ) (u : ZMod n → Fin m → ℝ) : ZMod n → Fin m → ℝ :=
  fun i => (1 / 2 : ℝ) • (u (i - 1) + u (i + 1)) -
    (ratio / 2) •
      ((fun p => flux p (u (i + 1) p)) -
       (fun p => flux p (u (i - 1) p)))

/-- Each state component is exactly the existing scalar periodic
nonlinear Lax–Friedrichs stencil. -/
theorem leveque04_periodicDiagonalNonlinearLaxFriedrichs_component
    {m : ℕ} (n : ℕ) [NeZero n] (flux : Fin m → ℝ → ℝ)
    (ratio : ℝ) (u : ZMod n → Fin m → ℝ)
    (i : ZMod n) (p : Fin m) :
    leveque04_periodicDiagonalNonlinearLaxFriedrichsStep
        n flux ratio u i p =
      leveque04_periodicNonlinearLaxFriedrichsStep n (flux p) ratio
        (fun j => u j p) i := by
  simp only [leveque04_periodicDiagonalNonlinearLaxFriedrichsStep,
    leveque04_periodicNonlinearLaxFriedrichsStep,
    Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- The componentwise periodic update is the source's equation-(4.20)
finite-volume update on the chosen neighboring vector states. -/
theorem leveque04_periodicDiagonalNonlinearLaxFriedrichs_eq_equation20
    {m : ℕ} (n : ℕ) [NeZero n] (flux : Fin m → ℝ → ℝ)
    (ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width)
    (u : ZMod n → Fin m → ℝ) (i : ZMod n) (p : Fin m) :
    let old : ℤ → Fin m → ℝ := fun j =>
      if j = -1 then u (i - 1) else if j = 0 then u i else u (i + 1)
    leveque04_periodicDiagonalNonlinearLaxFriedrichsStep
        n flux ratio u i p =
      leveque04_finiteVolumeUpdate (ratio * width) width old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width
            (fun state q => flux q (state q))) old) 0 p := by
  dsimp only
  rw [leveque04_equation20 (ratio * width) width
    (fun state q => flux q (state q))
    (fun j => if j = -1 then u (i - 1) else if j = 0 then u i else u (i + 1))
    0 p (mul_pos hratio hwidth) hwidth]
  simp only [zero_sub, zero_add, ite_true]
  have hnot : (1 : ℤ) ≠ -1 := by norm_num
  have hnot0 : (1 : ℤ) ≠ 0 := by norm_num
  simp only [hnot, hnot0, ↓reduceIte]
  have hcoef : ratio * width / (2 * width) = ratio / 2 := by
    field_simp
  rw [hcoef]
  exact leveque04_periodicDiagonalNonlinearLaxFriedrichs_component
    n flux ratio u i p

/-- Every component of a diagonal nonlinear hyperbolic-system
Lax–Friedrichs update has first-order mean error over a fixed horizon
when its scalar CFL and local-residual hypotheses hold. -/
theorem leveque04_periodicDiagonalNonlinearLaxFriedrichs_finiteHorizonAccuracy
    {m : ℕ} (n : ℕ) [NeZero n] (flux : Fin m → ℝ → ℝ)
    (ratio L timeStep width localBound horizon : ℝ)
    (hratio : 0 ≤ ratio)
    (hcfl : ratio * L ≤ 1)
    (hflux : ∀ p x y, |flux p x - flux p y| ≤ L * |x - y|)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hbound : 0 ≤ localBound)
    (approx exactState : ℕ → ZMod n → Fin m → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicDiagonalNonlinearLaxFriedrichsStep
        n flux ratio (approx k) i)
    (steps : ℕ)
    (hlocal : ∀ k, k < steps → ∀ i p,
      |(leveque04_periodicDiagonalNonlinearLaxFriedrichsStep
          n flux ratio (exactState k) i p -
          exactState (k + 1) i p) / timeStep| ≤
        localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon)
    (p : Fin m) :
    (∑ i : ZMod n, |approx steps i p - exactState steps i p|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, |approx 0 i p - exactState 0 i p|) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  exact leveque04_periodicNonlinearLaxFriedrichs_finiteHorizonAccuracy
    n (flux p) ratio L timeStep width localBound horizon
    hratio hcfl (hflux p) htime hwidth hbound
    (fun k i => approx k i p) (fun k i => exactState k i p)
    (by
      intro k i
      change approx (k + 1) i p =
        leveque04_periodicNonlinearLaxFriedrichsStep n (flux p) ratio
          (fun j => approx k j p) i
      rw [happrox k i]
      exact leveque04_periodicDiagonalNonlinearLaxFriedrichs_component
        n flux ratio (approx k) i p)
    steps
    (by
      intro k hk i
      simpa only [leveque04_periodicDiagonalNonlinearLaxFriedrichs_component]
        using hlocal k hk i p)
    hhorizon

end NumStability
