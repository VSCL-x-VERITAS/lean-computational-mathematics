/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.MonotoneConservativeContraction
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness

/-!
# Nonlinear periodic Lax–Friedrichs stability

On a finite periodic scalar grid, the source's nonlinear
Lax–Friedrichs stencil is conservative. Under its Lipschitz CFL bound,
monotonicity gives finite-grid L1 contraction.
-/

namespace NumStability

/-- The source's scalar nonlinear two-neighbor Lax–Friedrichs update
on finite periodic data. -/
noncomputable def leveque04_periodicNonlinearLaxFriedrichsStep
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ) (ratio : ℝ)
    (u : ZMod n → ℝ) (i : ZMod n) : ℝ :=
  (u (i - 1) + u (i + 1)) / 2 -
    ratio / 2 * (flux (u (i + 1)) - flux (u (i - 1)))

private theorem periodic_sum_add_one (n : ℕ) [NeZero n]
    (u : ZMod n → ℝ) :
    (∑ i : ZMod n, u (i + 1)) = ∑ i : ZMod n, u i := by
  simpa only [Equiv.coe_addRight] using
    Equiv.sum_comp (Equiv.addRight (1 : ZMod n)) u

private theorem periodic_sum_sub_one (n : ℕ) [NeZero n]
    (u : ZMod n → ℝ) :
    (∑ i : ZMod n, u (i - 1)) = ∑ i : ZMod n, u i := by
  simpa only [Equiv.coe_addRight, sub_eq_add_neg] using
    Equiv.sum_comp (Equiv.addRight (-1 : ZMod n)) u

/-- The periodic nonlinear Lax–Friedrichs step preserves the sum of
cell states for every physical flux. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_conserve
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ) (ratio : ℝ)
    (u : ZMod n → ℝ) :
    (∑ i : ZMod n,
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio u i) =
        ∑ i : ZMod n, u i := by
  have hplus := periodic_sum_add_one n u
  have hminus := periodic_sum_sub_one n u
  have hfplus := periodic_sum_add_one n (flux ∘ u)
  have hfminus := periodic_sum_sub_one n (flux ∘ u)
  simp only [leveque04_periodicNonlinearLaxFriedrichsStep]
  simp only [Finset.sum_sub_distrib, Finset.sum_add_distrib,
    ← Finset.mul_sum, ← Finset.sum_div]
  simp only [Function.comp_apply] at hfplus hfminus
  rw [hplus, hminus, hfplus, hfminus]
  ring

/-- Under the scalar Lipschitz CFL bound, the actual nonlinear
periodic Lax–Friedrichs update contracts finite-grid L1 distance. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_l1_contract
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ) (ratio L : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : ratio * L ≤ 1)
    (hflux : ∀ x y, |flux x - flux y| ≤ L * |x - y|)
    (u v : ZMod n → ℝ) :
    (∑ i : ZMod n,
      |leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio u i -
        leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio v i|) ≤
      ∑ i : ZMod n, |u i - v i| := by
  apply finiteMonotoneConservative_l1_contract
    (leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio)
  · intro a b hab i
    exact leveque04_laxFriedrichs_nonlinearStep_monotone
      flux ratio L (a (i - 1)) (b (i - 1))
      (a (i + 1)) (b (i + 1)) hratio hcfl hflux
      (hab _) (hab _)
  · intro a
    exact leveque04_periodicNonlinearLaxFriedrichs_conserve n flux ratio a

/-- Local residuals for the nonlinear periodic Lax–Friedrichs update
accumulate additively in finite-grid L1 over any finite number of steps. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_iterate_error
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ) (ratio L : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : ratio * L ≤ 1)
    (hflux : ∀ x y, |flux x - flux y| ≤ L * |x - y|)
    (approx exactState residual : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (exactState k) i + residual k i)
    (steps : ℕ) :
    (∑ i : ZMod n, |approx steps i - exactState steps i|) ≤
      (∑ i : ZMod n, |approx 0 i - exactState 0 i|) +
        ∑ k ∈ Finset.range steps,
          ∑ i : ZMod n, |residual k i| := by
  apply finiteMonotoneConservative_iterate_error
    (leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio)
  · intro a b hab i
    exact leveque04_laxFriedrichs_nonlinearStep_monotone
      flux ratio L (a (i - 1)) (b (i - 1))
      (a (i + 1)) (b (i + 1)) hratio hcfl hflux
      (hab _) (hab _)
  · intro a
    exact leveque04_periodicNonlinearLaxFriedrichs_conserve n flux ratio a
  · exact happrox
  · exact hexact

/-- A uniform first-order normalized local residual gives a
first-order cell-averaged L1 error at a fixed time horizon. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_fixedHorizonMeanError
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ)
    (ratio L timeStep width localBound horizon : ℝ)
    (hratio : 0 ≤ ratio) (hcfl : ratio * L ≤ 1)
    (hflux : ∀ x y, |flux x - flux y| ≤ L * |x - y|)
    (hwidth : 0 < width)
    (hbound : 0 ≤ localBound)
    (approx exactState residual : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (approx k) i)
    (hexact : ∀ k i, exactState (k + 1) i =
      leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (exactState k) i + residual k i)
    (hlocal : ∀ k i, |residual k i| ≤ timeStep * localBound * width)
    (steps : ℕ) (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i : ZMod n, |approx steps i - exactState steps i|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, |approx 0 i - exactState 0 i|) /
        (Fintype.card (ZMod n) : ℝ) +
          horizon * localBound * width := by
  exact finiteMonotoneConservative_fixedHorizonMeanError
    (leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio)
    (by
      intro a b hab i
      exact leveque04_laxFriedrichs_nonlinearStep_monotone
        flux ratio L (a (i - 1)) (b (i - 1))
        (a (i + 1)) (b (i + 1)) hratio hcfl hflux
        (hab _) (hab _))
    (leveque04_periodicNonlinearLaxFriedrichs_conserve n flux ratio)
    timeStep width localBound horizon hwidth hbound
    approx exactState residual happrox hexact hlocal steps hhorizon

end NumStability
