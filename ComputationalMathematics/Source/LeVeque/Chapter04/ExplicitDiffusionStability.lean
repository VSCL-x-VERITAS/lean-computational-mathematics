/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionStep
import Mathlib.Data.Real.Archimedean
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: the explicit diffusion time-step restriction

The two-periodic alternating mode of the centered explicit diffusion
update is amplified by `1 - 4r`, where `r = β Δt / Δx²`. Above `r = 1/2`
its magnitude grows without bound.
-/

namespace NumStability

/-- The constant-coefficient explicit diffusion update (4.12) on a
two-periodic grid. -/
noncomputable def leveque04_periodicDiffusionStep
    (ratio : ℝ) (old : Fin 2 → ℝ) : Fin 2 → ℝ :=
  fun i => old i + ratio * (old (i - 1) - 2 * old i + old (i + 1))

/-- The alternating mode on two cells. -/
def leveque04_alternatingMode (amplitude : ℝ) : Fin 2 → ℝ :=
  fun i => if i = 0 then amplitude else -amplitude

/-- The alternating mode has one-step amplification `1 - 4r`. -/
theorem leveque04_periodicDiffusionStep_alternating
    (ratio amplitude : ℝ) :
    leveque04_periodicDiffusionStep ratio
        (leveque04_alternatingMode amplitude) =
      leveque04_alternatingMode ((1 - 4 * ratio) * amplitude) := by
  funext i
  fin_cases i <;>
    norm_num [leveque04_periodicDiffusionStep, leveque04_alternatingMode,
      Fin.add_def, Fin.sub_def] <;> ring

/-- After `n` steps the alternating amplitude is `(1 - 4r)^n`. -/
theorem leveque04_periodicDiffusionStep_alternating_iterate
    (ratio : ℝ) (n : ℕ) :
    ((leveque04_periodicDiffusionStep ratio)^[n]
      (leveque04_alternatingMode 1)) =
        leveque04_alternatingMode ((1 - 4 * ratio) ^ n) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih,
        leveque04_periodicDiffusionStep_alternating]
      rw [pow_succ]
      congr 1
      ring

/-- If the explicit diffusion ratio exceeds `1/2`, its two-cell
periodic solution has no uniform absolute bound. -/
theorem leveque04_periodicDiffusion_unstable
    (ratio : ℝ) (hratio : 1 / 2 < ratio) (bound : ℝ) :
    ∃ n : ℕ, bound <
      |((leveque04_periodicDiffusionStep ratio)^[n]
        (leveque04_alternatingMode 1)) 0| := by
  have hfactor : 1 < |1 - 4 * ratio| := by
    have hnegative : 1 - 4 * ratio < 0 := by linarith
    rw [abs_of_neg hnegative]
    linarith
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt bound hfactor
  refine ⟨n, ?_⟩
  rw [leveque04_periodicDiffusionStep_alternating_iterate]
  simpa [leveque04_alternatingMode, abs_pow] using hn

/-- A uniform bound on the explicit diffusion iterates forces the
quadratic time-step restriction `Δt ≤ Δx² / (2β)`. -/
theorem leveque04_explicitDiffusion_quadraticNecessary
    (diffusivity timeStep cellWidth : ℝ)
    (hdiffusivity : 0 < diffusivity) (hwidth : 0 < cellWidth)
    (hstable : ∃ bound : ℝ, ∀ n : ℕ,
      |((leveque04_periodicDiffusionStep
          (timeStep * diffusivity / cellWidth ^ 2))^[n]
        (leveque04_alternatingMode 1)) 0| ≤ bound) :
    timeStep ≤ cellWidth ^ 2 / (2 * diffusivity) := by
  by_contra hlimit
  have hlarge : cellWidth ^ 2 / (2 * diffusivity) < timeStep :=
    lt_of_not_ge hlimit
  have hfactor : cellWidth ^ 2 < 2 * diffusivity * timeStep := by
    simpa [mul_comm] using
      (div_lt_iff₀ (by positivity : 0 < 2 * diffusivity)).mp hlarge
  have hratio : 1 / 2 < timeStep * diffusivity / cellWidth ^ 2 := by
    rw [lt_div_iff₀ (sq_pos_of_pos hwidth)]
    nlinarith
  obtain ⟨bound, hbound⟩ := hstable
  obtain ⟨n, hn⟩ := leveque04_periodicDiffusion_unstable
    (timeStep * diffusivity / cellWidth ^ 2) hratio bound
  exact (not_lt_of_ge (hbound n)) hn

end NumStability
