/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointIterationLocality
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Tactic.Ring

/-!
# Local error accumulation for three-point updates

Only the finite initial dependence cone and the shrinking reference-defect
cone are used. A three-point nonexpansive update accumulates a uniform local
defect at most linearly in the number of steps. No global array norm,
linearity, or monotonicity assumption is needed.
-/

open Set
namespace NumStability

/-- A uniform reference defect on the shrinking dependence cone contributes
at most one error budget per update, in addition to the initial error budget.
Both hypotheses are local to the finite dependence cone. -/
theorem iterate_error_le_of_threePoint_nonexpansive_of_initial_error {E : Type*} [NormedAddCommGroup E]
    (update : (ℤ → E) → ℤ → E)
    (hcontract : ∀ (u v : ℤ → E) (j : ℤ),
      ‖update u j - update v j‖ ≤ max ‖u (j-1)-v (j-1)‖
        (max ‖u j-v j‖ ‖u (j+1)-v (j+1)‖))
    (initial : ℤ → E) (reference : ℕ → ℤ → E) (steps : ℕ) (i : ℤ) (initialError error : ℝ)
    (hinitial : ∀ j ∈ Icc (i-(steps:ℤ)) (i+(steps:ℤ)),
      ‖initial j - reference 0 j‖ ≤ initialError)
    (hdefect : ∀ k < steps, ∀ j ∈
      Icc (i-((steps-k-1:ℕ):ℤ)) (i+((steps-k-1:ℕ):ℤ)),
      ‖update (reference k) j - reference (k+1) j‖ ≤ error) :
    ‖(update^[steps] initial) i - reference steps i‖ ≤ initialError + (steps:ℝ)*error := by
  induction steps generalizing i with
  | zero =>
    simpa using hinitial i (by simp)
  | succ steps ih =>
    have herr (j : ℤ) (hj : j ∈ Icc (i-1) (i+1)) :
        ‖(update^[steps] initial) j - reference steps j‖ ≤ initialError + (steps:ℝ)*error := by
      apply ih
      · intro l hl
        apply hinitial l
        simp only [mem_Icc] at hj hl ⊢
        omega
      · intro k hk l hl
        apply hdefect k (by omega) l
        simp only [mem_Icc] at hj hl ⊢
        omega
    rw [Function.iterate_succ_apply']
    calc
      ‖update (update^[steps] initial) i - reference (steps+1) i‖ ≤
          ‖update (update^[steps] initial) i - update (reference steps) i‖ +
            ‖update (reference steps) i - reference (steps+1) i‖ := norm_sub_le_norm_sub_add_norm_sub _ _ _
      _ ≤ initialError + (steps:ℝ)*error + error := by
        apply add_le_add
        · apply (hcontract _ _ i).trans
          apply max_le
          · exact herr (i-1) (by simp only [mem_Icc]; omega)
          · apply max_le
            · exact herr i (by simp only [mem_Icc]; omega)
            · exact herr (i+1) (by simp only [mem_Icc]; omega)
        · exact hdefect steps (by omega) i (by simp)
      _ = initialError + ((steps+1:ℕ):ℝ)*error := by push_cast; ring


/-- A uniform reference defect on the shrinking dependence cone contributes
at most one error budget per update. Initial agreement is local to the cone. -/
theorem iterate_error_le_of_threePoint_nonexpansive {E : Type*} [NormedAddCommGroup E]
    (update : (ℤ → E) → ℤ → E)
    (hcontract : ∀ (u v : ℤ → E) (j : ℤ),
      ‖update u j - update v j‖ ≤ max ‖u (j-1)-v (j-1)‖
        (max ‖u j-v j‖ ‖u (j+1)-v (j+1)‖))
    (initial : ℤ → E) (reference : ℕ → ℤ → E) (steps : ℕ) (i : ℤ) (error : ℝ)
    (hagree : ∀ j ∈ Icc (i-(steps:ℤ)) (i+(steps:ℤ)), initial j = reference 0 j)
    (hdefect : ∀ k < steps, ∀ j ∈
      Icc (i-((steps-k-1:ℕ):ℤ)) (i+((steps-k-1:ℕ):ℤ)),
      ‖update (reference k) j - reference (k+1) j‖ ≤ error) :
    ‖(update^[steps] initial) i - reference steps i‖ ≤ (steps:ℝ)*error := by
  simpa only [zero_add] using
    iterate_error_le_of_threePoint_nonexpansive_of_initial_error
      update hcontract initial reference steps i 0 error
      (by
        intro j hj
        rw [hagree j hj]
        simp) hdefect

/-- An arbitrary norm-nonexpansive update accumulates a uniform reference
defect linearly, with an independently supplied initial error budget. -/
theorem iterate_error_le_of_nonexpansive_of_initial_error {E : Type*} [NormedAddCommGroup E]
    (update : E → E) (hcontract : ∀ u v, ‖update u - update v‖ ≤ ‖u - v‖)
    (initial : E) (reference : ℕ → E) (steps : ℕ) (initialError error : ℝ)
    (hinitial : ‖initial - reference 0‖ ≤ initialError)
    (hdefect : ∀ k < steps, ‖update (reference k) - reference (k + 1)‖ ≤ error) :
    ‖update^[steps] initial - reference steps‖ ≤ initialError + (steps : ℝ) * error := by
  let lifted (u : ℤ → E) (i : ℤ) := update (u i)
  have hconstant (n : ℕ) :
      lifted^[n] (fun _ => initial) = fun _ => update^[n] initial := by
    induction n with
    | zero => rfl
    | succ n ih =>
      rw [Function.iterate_succ_apply', ih]
      funext i
      exact (Function.iterate_succ_apply' update n initial).symm
  have h := iterate_error_le_of_threePoint_nonexpansive_of_initial_error
    lifted (fun u v j => (hcontract (u j) (v j)).trans
      ((le_max_left _ _).trans (le_max_right _ _)))
    (fun _ => initial) (fun k _ => reference k) steps 0 initialError error
    (fun _ _ => hinitial) (fun k hk _ _ => hdefect k hk)
  simpa only [hconstant] using h

end NumStability
