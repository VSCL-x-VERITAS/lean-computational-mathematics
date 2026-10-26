/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Data.Real.Archimedean
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: an unstable centered advection mode

The four-periodic real mode `(a,b,-a,-b)` is invariant under the centered
three-point advection step. Its squared amplitude grows by `1 + ν²` per step.
-/

namespace NumStability

/-- The centered scalar advection update on a four-periodic grid. -/
noncomputable def leveque04_centeredPeriodicStep (courant : ℝ) (values : Fin 4 → ℝ) :
    Fin 4 → ℝ :=
  fun i => values i - courant / 2 * (values (i + 1) - values (i - 1))

/-- A real Fourier mode of period four. -/
def leveque04_quarterWave (a b : ℝ) : Fin 4 → ℝ :=
  fun i => if i = 0 then a else if i = 1 then b else if i = 2 then -a else -b

/-- The centered step rotates and enlarges the quarter-wave amplitudes. -/
theorem leveque04_centeredPeriodicStep_quarterWave (courant a b : ℝ) :
    leveque04_centeredPeriodicStep courant (leveque04_quarterWave a b) =
      leveque04_quarterWave (a - courant * b) (b + courant * a) := by
  funext i
  fin_cases i <;>
    norm_num [leveque04_centeredPeriodicStep, leveque04_quarterWave,
      Fin.add_def, Fin.sub_def] <;> simp [Fin.ext_iff] <;> ring

/-- Squared amplitude of the real quarter-wave mode. -/
def leveque04_modeEnergy (amplitude : ℝ × ℝ) : ℝ :=
  amplitude.1 ^ 2 + amplitude.2 ^ 2

/-- Evolution of the two real mode amplitudes. -/
def leveque04_centeredModeStep (courant : ℝ) (amplitude : ℝ × ℝ) : ℝ × ℝ :=
  (amplitude.1 - courant * amplitude.2,
    amplitude.2 + courant * amplitude.1)

/-- The unstable mode has a strictly amplifying energy factor at nonzero CFL. -/
theorem leveque04_centeredModeEnergy_step (courant : ℝ) (amplitude : ℝ × ℝ) :
    leveque04_modeEnergy (leveque04_centeredModeStep courant amplitude) =
      (1 + courant ^ 2) * leveque04_modeEnergy amplitude := by
  dsimp [leveque04_modeEnergy, leveque04_centeredModeStep]
  ring

/-- Repeated centered steps amplify the energy geometrically. -/
theorem leveque04_centeredModeEnergy_iterate (courant : ℝ) (n : ℕ) :
    leveque04_modeEnergy
        ((leveque04_centeredModeStep courant)^[n] (1, 0)) =
      (1 + courant ^ 2) ^ n := by
  induction n with
  | zero => norm_num [leveque04_modeEnergy]
  | succ n ih =>
      rw [Function.iterate_succ_apply', leveque04_centeredModeEnergy_step, ih]
      ring

/-- No uniform energy bound exists for the centered scheme at a fixed
nonzero Courant number, including Courant numbers satisfying CFL. -/
theorem leveque04_centeredModeEnergy_unbounded
    (courant : ℝ) (hν : courant ≠ 0) (bound : ℝ) :
    ∃ n : ℕ, bound <
      leveque04_modeEnergy
        ((leveque04_centeredModeStep courant)^[n] (1, 0)) := by
  have hsq : 0 < courant ^ 2 := sq_pos_of_ne_zero hν
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt bound (by linarith : 1 < 1 + courant ^ 2)
  exact ⟨n, by rwa [leveque04_centeredModeEnergy_iterate]⟩

/-- The two-amplitude calculation is exactly the repeated centered update
of the four-periodic grid values. -/
theorem leveque04_centeredPeriodicStep_iterate (courant : ℝ) (n : ℕ) :
    ((leveque04_centeredPeriodicStep courant)^[n]
      (leveque04_quarterWave 1 0)) =
    leveque04_quarterWave
      (((leveque04_centeredModeStep courant)^[n] (1, 0)).1)
      (((leveque04_centeredModeStep courant)^[n] (1, 0)).2) := by
  induction n with
  | zero => rfl
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih,
        leveque04_centeredPeriodicStep_quarterWave,
        Function.iterate_succ_apply' (leveque04_centeredModeStep courant)]
      rfl

/-- The actual periodic grid update has unbounded mode energy even for
the admissible Courant number `1/2`. This is the counterexample behind the
source's warning that CFL is only necessary, not sufficient. -/
theorem leveque04_centeredPeriodicGrid_unstable (bound : ℝ) :
    ∃ n : ℕ, bound <
      (((leveque04_centeredPeriodicStep (1 / 2 : ℝ))^[n]
          (leveque04_quarterWave 1 0)) 0) ^ 2 +
      (((leveque04_centeredPeriodicStep (1 / 2 : ℝ))^[n]
          (leveque04_quarterWave 1 0)) 1) ^ 2 := by
  obtain ⟨n, hn⟩ := leveque04_centeredModeEnergy_unbounded
    (1 / 2 : ℝ) (by norm_num) bound
  refine ⟨n, ?_⟩
  rw [leveque04_centeredPeriodicStep_iterate]
  simpa [leveque04_quarterWave, leveque04_modeEnergy] using hn

/-- An explicit CFL-admissible centered advection scheme without a
uniform energy bound. -/
theorem leveque04_centeredPeriodicGrid_cflCounterexample :
    (1 / 2 : ℝ) ≤ 1 ∧
      ∀ bound : ℝ, ∃ n : ℕ, bound <
        (((leveque04_centeredPeriodicStep (1 / 2 : ℝ))^[n]
            (leveque04_quarterWave 1 0)) 0) ^ 2 +
        (((leveque04_centeredPeriodicStep (1 / 2 : ℝ))^[n]
            (leveque04_quarterWave 1 0)) 1) ^ 2 := by
  exact ⟨by norm_num, leveque04_centeredPeriodicGrid_unstable⟩

end NumStability
