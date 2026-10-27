/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.MonotoneConservativeFiniteHorizon
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovPeriodicConservation

/-!
# Bounded-state CFL estimates for the actual Burgers Godunov step

Clipping is used only to extend the flux in the proof. On the stated state
interval the extension equals the selected Riemann flux exactly.
-/

namespace NumStability

private noncomputable def clipState (bound x : ℝ) : ℝ := max (-bound) (min bound x)

private theorem clipState_bounds (bound x : ℝ) (hb : 0 ≤ bound) :
    -bound ≤ clipState bound x ∧ clipState bound x ≤ bound := by
  exact ⟨le_max_left _ _, max_le (by linarith) (min_le_left _ _)⟩

private theorem clipState_eq (bound x : ℝ) (hx : -bound ≤ x ∧ x ≤ bound) :
    clipState bound x = x := by
  simp [clipState, min_eq_right hx.2, max_eq_right hx.1]

private theorem clipState_monotone (bound : ℝ) : Monotone (clipState bound) := by
  intro a b hab
  exact max_le_max_left _ (min_le_min_left _ hab)

private theorem clipState_lipschitz (bound a b : ℝ) :
    |clipState bound a - clipState bound b| ≤ |a - b| := by
  have hmin : |min bound a - min bound b| ≤ |a - b| := by
    simpa only [sub_self, abs_zero, max_eq_right (abs_nonneg (a - b))] using
      abs_min_sub_min_le_max bound a bound b
  have hmax : |max (-bound) (min bound a) - max (-bound) (min bound b)| ≤
      |min bound a - min bound b| := by
    simpa only [sub_self, abs_zero,
      max_eq_right (abs_nonneg (min bound a - min bound b))] using
      abs_max_sub_max_le_max (-bound) (min bound a) (-bound) (min bound b)
  exact hmax.trans hmin

private noncomputable def boundedFlux (bound left right : ℝ) : ℝ :=
  (leveque04_burgersSelectedInterfaceState (clipState bound left)
    (clipState bound right)) ^ 2 / 2

private theorem boundedFlux_step_monotone
    (n : ℕ) [NeZero n] (bound ratio : ℝ) (hb : 0 ≤ bound)
    (hr : 0 ≤ ratio) (hcfl : ratio * (bound + bound) ≤ 1)
    (u v : ZMod n → ℝ) (huv : ∀ i, u i ≤ v i) (i : ZMod n) :
    finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio u i ≤
      finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio v i := by
  apply finitePeriodicTwoStateFluxStep_monotone_of_lipschitz n
    (boundedFlux bound) ratio bound bound hr hcfl
  · intro a b c hab
    exact leveque04_burgersSelectedInterfaceFlux_monotone_left _ _ _
      (clipState_monotone bound hab)
  · intro a b c hab
    exact leveque04_burgersSelectedInterfaceFlux_antitone_right _ _ _
      (clipState_monotone bound hab)
  · intro a b c hab
    have h := leveque04_burgersSelectedInterfaceFlux_left_lipschitz bound
      (clipState bound b) (clipState bound a) (clipState bound c) hb
      (clipState_bounds bound b hb).2 (clipState_bounds bound a hb).2
    have hgap := mul_le_mul_of_nonneg_left (clipState_lipschitz bound b a) hb
    exact (le_abs_self _).trans (h.trans (by
      simpa only [abs_of_nonneg (sub_nonneg.mpr hab)] using hgap))
  · intro a b c hab
    have h := leveque04_burgersSelectedInterfaceFlux_right_lipschitz bound
      (clipState bound c) (clipState bound a) (clipState bound b) hb
      (clipState_bounds bound a hb).1 (clipState_bounds bound b hb).1
    have hgap := mul_le_mul_of_nonneg_left (clipState_lipschitz bound a b) hb
    exact (le_abs_self _).trans (h.trans (by
      simpa only [abs_sub_comm a b, abs_of_nonneg (sub_nonneg.mpr hab)] using hgap))
  · exact huv

/-- Conservative periodic step with the evaluated actual Burgers interface flux. -/
noncomputable def leveque04_burgersGodunovStep
    (n : ℕ) [NeZero n] (ratio : ℝ) (u : ZMod n → ℝ) (i : ZMod n) : ℝ :=
  finitePeriodicTwoStateFluxStep n
    (fun a b => (leveque04_burgersSelectedInterfaceState a b) ^ 2 / 2) ratio u i

/-- This evaluated step is exactly the periodic step of the certified
selected Riemann method, for every state, before any bound is imposed. -/
theorem leveque04_burgersGodunovStep_eq_selected
    (n : ℕ) [NeZero n]
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ, law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (timeStep : ℝ) (htime : 0 < timeStep) (ratio : ℝ)
    (u : ZMod n → ℝ) (i : ZMod n) :
    leveque04_burgersGodunovStep n ratio u i =
      leveque04_periodicSelectedGodunovStep
        (leveque04_burgersSelectedFluxMethod law hburgers timeStep htime)
        (fun _ _ => trivial) ratio u i := by
  rw [leveque04_periodicSelectedGodunovStep_eq_twoState _ (fun _ _ => trivial)]
  have hflux : leveque04_selectedGodunovTwoStateFlux
      (leveque04_burgersSelectedFluxMethod law hburgers timeStep htime)
      (fun _ _ => trivial) =
      fun a b => (leveque04_burgersSelectedInterfaceState a b) ^ 2 / 2 := by
    funext a b
    exact leveque04_burgersSelectedFlux_scalar law hburgers
      (leveque04_scalarPairRiemannProblem law a b) timeStep htime
  rw [hflux]
  rfl

private theorem boundedFlux_step_eq
    (n : ℕ) [NeZero n] (bound ratio : ℝ) (u : ZMod n → ℝ)
    (hu : ∀ i, -bound ≤ u i ∧ u i ≤ bound) (i : ZMod n) :
    finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio u i =
      leveque04_burgersGodunovStep n ratio u i := by
  simp only [finitePeriodicTwoStateFluxStep, finitePeriodicFluxDifferenceUpdate,
    leveque04_burgersGodunovStep, boundedFlux, clipState_eq bound _ (hu _)]

/-- The actual step is order preserving on the bounded-state interval under
the sufficient CFL restriction `2 * bound * ratio ≤ 1`. -/
theorem leveque04_burgersGodunovStep_monotone_on_bounds
    (n : ℕ) [NeZero n] (bound ratio : ℝ) (hb : 0 ≤ bound)
    (hr : 0 ≤ ratio) (hcfl : ratio * (bound + bound) ≤ 1)
    (u v : ZMod n → ℝ)
    (hu : ∀ i, -bound ≤ u i ∧ u i ≤ bound)
    (hv : ∀ i, -bound ≤ v i ∧ v i ≤ bound)
    (huv : ∀ i, u i ≤ v i) (i : ZMod n) :
    leveque04_burgersGodunovStep n ratio u i ≤
      leveque04_burgersGodunovStep n ratio v i := by
  rw [← boundedFlux_step_eq n bound ratio u hu i,
    ← boundedFlux_step_eq n bound ratio v hv i]
  exact boundedFlux_step_monotone n bound ratio hb hr hcfl u v huv i

/-- The CFL step preserves the same state interval. -/
theorem leveque04_burgersGodunovStep_preserves_bounds
    (n : ℕ) [NeZero n] (bound ratio : ℝ) (hb : 0 ≤ bound)
    (hr : 0 ≤ ratio) (hcfl : ratio * (bound + bound) ≤ 1)
    (u : ZMod n → ℝ) (hu : ∀ i, -bound ≤ u i ∧ u i ≤ bound) (i : ZMod n) :
    -bound ≤ leveque04_burgersGodunovStep n ratio u i ∧
      leveque04_burgersGodunovStep n ratio u i ≤ bound := by
  have hlo := leveque04_burgersGodunovStep_monotone_on_bounds n bound ratio hb hr hcfl
    (fun _ => -bound) u (fun _ => ⟨le_rfl, by linarith⟩) hu (fun j => (hu j).1) i
  have hhi := leveque04_burgersGodunovStep_monotone_on_bounds n bound ratio hb hr hcfl
    u (fun _ => bound) hu (fun _ => ⟨by linarith, le_rfl⟩) (fun j => (hu j).2) i
  simpa [leveque04_burgersGodunovStep, finitePeriodicTwoStateFluxStep,
    finitePeriodicFluxDifferenceUpdate] using And.intro hlo hhi

/-- L1 contraction for the actual bounded-state Burgers step follows from
the existing conservative monotone map theorem applied to the proof extension. -/
theorem leveque04_burgersGodunovStep_l1_contract_on_bounds
    (n : ℕ) [NeZero n] (bound ratio : ℝ) (hb : 0 ≤ bound)
    (hr : 0 ≤ ratio) (hcfl : ratio * (bound + bound) ≤ 1)
    (u v : ZMod n → ℝ)
    (hu : ∀ i, -bound ≤ u i ∧ u i ≤ bound)
    (hv : ∀ i, -bound ≤ v i ∧ v i ≤ bound) :
    (∑ i, |leveque04_burgersGodunovStep n ratio u i -
      leveque04_burgersGodunovStep n ratio v i|) ≤ ∑ i, |u i - v i| := by
  have h := finiteMonotoneConservative_l1_contract
    (finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio)
    (boundedFlux_step_monotone n bound ratio hb hr hcfl)
    (fun w => finitePeriodicFluxDifferenceUpdate_conserve
      (Equiv.addRight (1 : ZMod n)) ratio w
      (fun j => boundedFlux bound (w (j - 1)) (w j))) u v
  simpa only [boundedFlux_step_eq n bound ratio u hu,
    boundedFlux_step_eq n bound ratio v hv] using h

/-- Every iterate of the actual step stays in its initial state bound. -/
theorem leveque04_burgersGodunovStep_orbit_bounds
    (n : ℕ) [NeZero n] (bound ratio : ℝ) (hb : 0 ≤ bound)
    (hr : 0 ≤ ratio) (hcfl : ratio * (bound + bound) ≤ 1)
    (orbit : ℕ → ZMod n → ℝ)
    (hstep : ∀ k i, orbit (k + 1) i = leveque04_burgersGodunovStep n ratio (orbit k) i)
    (hinitial : ∀ i, -bound ≤ orbit 0 i ∧ orbit 0 i ≤ bound)
    (k : ℕ) (i : ZMod n) : -bound ≤ orbit k i ∧ orbit k i ≤ bound := by
  induction k generalizing i with
  | zero => exact hinitial i
  | succ k ih =>
      rw [hstep]
      exact leveque04_burgersGodunovStep_preserves_bounds n bound ratio hb hr hcfl
        (orbit k) (fun j => ih j) i

/-- The actual Burgers step has the existing fixed-horizon mean L1 error
transfer under its concrete state bound and sufficient CFL restriction.
The comparison residual must be established separately from smooth data. -/
theorem leveque04_burgersGodunovStep_fixedHorizonMeanError
    (n : ℕ) [NeZero n] (bound ratio timeStep width localBound horizon : ℝ)
    (hb : 0 ≤ bound) (hr : 0 ≤ ratio) (hcfl : ratio * (bound + bound) ≤ 1)
    (hwidth : 0 < width) (hlocalBound : 0 ≤ localBound)
    (approx exactState residual : ℕ → ZMod n → ℝ)
    (happrox : ∀ k i, approx (k + 1) i = leveque04_burgersGodunovStep n ratio (approx k) i)
    (hinitial : ∀ i, -bound ≤ approx 0 i ∧ approx 0 i ≤ bound)
    (hexactBound : ∀ k i, -bound ≤ exactState k i ∧ exactState k i ≤ bound)
    (hexact : ∀ k i, exactState (k + 1) i =
      leveque04_burgersGodunovStep n ratio (exactState k) i + residual k i)
    (hlocal : ∀ k i, |residual k i| ≤ timeStep * localBound * width)
    (steps : ℕ) (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i, |approx steps i - exactState steps i|) / (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i, |approx 0 i - exactState 0 i|) / (Fintype.card (ZMod n) : ℝ) +
        horizon * localBound * width := by
  have happroxBound (k : ℕ) (i : ZMod n) :=
    leveque04_burgersGodunovStep_orbit_bounds n bound ratio hb hr hcfl approx happrox hinitial k i
  have happroxClip : ∀ k i, approx (k + 1) i =
      finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio (approx k) i := by
    intro k i
    rw [boundedFlux_step_eq n bound ratio (approx k) (happroxBound k) i]
    exact happrox k i
  have hexactClip : ∀ k i, exactState (k + 1) i =
      finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio (exactState k) i + residual k i := by
    intro k i
    rw [boundedFlux_step_eq n bound ratio (exactState k) (hexactBound k) i]
    exact hexact k i
  exact finiteMonotoneConservative_fixedHorizonMeanError
    (finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio)
    (boundedFlux_step_monotone n bound ratio hb hr hcfl)
    (fun w => finitePeriodicFluxDifferenceUpdate_conserve
      (Equiv.addRight (1 : ZMod n)) ratio w
      (fun j => boundedFlux bound (w (j - 1)) (w j)))
    timeStep width localBound horizon hwidth hlocalBound approx exactState residual
    happroxClip hexactClip hlocal steps hhorizon

/-- The bounded actual step transfers error from a comparison defined only
through the requested finite horizon. -/
theorem leveque04_burgersGodunovStep_fixedHorizonMeanError_prefix
    (n : ℕ) [NeZero n] (bound ratio timeStep width localBound horizon : ℝ)
    (hb : 0 ≤ bound) (hr : 0 ≤ ratio) (hcfl : ratio * (bound + bound) ≤ 1)
    (htime : 0 ≤ timeStep) (hwidth : 0 < width) (hlocalBound : 0 ≤ localBound)
    (approx exactState residual : ℕ → ZMod n → ℝ) (steps : ℕ)
    (happrox : ∀ k i, approx (k + 1) i = leveque04_burgersGodunovStep n ratio (approx k) i)
    (hinitial : ∀ i, -bound ≤ approx 0 i ∧ approx 0 i ≤ bound)
    (hexactBound : ∀ k ≤ steps, ∀ i, -bound ≤ exactState k i ∧ exactState k i ≤ bound)
    (hexact : ∀ k < steps, ∀ i, exactState (k + 1) i =
      leveque04_burgersGodunovStep n ratio (exactState k) i + residual k i)
    (hlocal : ∀ k < steps, ∀ i, |residual k i| ≤ timeStep * localBound * width)
    (hhorizon : (steps : ℝ) * timeStep ≤ horizon) :
    (∑ i, |approx steps i - exactState steps i|) / (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i, |approx 0 i - exactState 0 i|) / (Fintype.card (ZMod n) : ℝ) +
        horizon * localBound * width := by
  apply finiteMonotoneConservative_fixedHorizonMeanError_prefix
    (finitePeriodicTwoStateFluxStep n (boundedFlux bound) ratio)
    (boundedFlux_step_monotone n bound ratio hb hr hcfl)
    (fun w => finitePeriodicFluxDifferenceUpdate_conserve
      (Equiv.addRight (1 : ZMod n)) ratio w
      (fun j => boundedFlux bound (w (j - 1)) (w j)))
    timeStep width localBound horizon htime hwidth hlocalBound approx exactState residual steps
  · intro k _ i
    rw [boundedFlux_step_eq n bound ratio (approx k)
      (leveque04_burgersGodunovStep_orbit_bounds n bound ratio hb hr hcfl
        approx happrox hinitial k) i]
    exact happrox k i
  · intro k hk i
    rw [boundedFlux_step_eq n bound ratio (exactState k)
      (hexactBound k (Nat.le_of_lt hk)) i]
    exact hexact k hk i
  · exact hlocal
  · exact hhorizon

end NumStability
