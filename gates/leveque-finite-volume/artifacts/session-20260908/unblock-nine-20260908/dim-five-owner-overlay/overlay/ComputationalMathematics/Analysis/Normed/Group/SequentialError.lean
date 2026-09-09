/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.Order.Ring.Pow
import Mathlib.Analysis.Normed.Group.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Push

/-!
Finite successive-operator perturbation estimates with separate local and reference-mismatch defects.
-/

open scoped BigOperators
namespace NumStability.SequentialError
variable {Cell E : Type*} [NormedAddCommGroup E]

def execution (step : ℕ → (Cell → E) → Cell → E) (initial : Cell → E) : ℕ → Cell → E
  | 0 => initial
  | n + 1 => step n (execution step initial n)

def errorBudget (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ) : ℕ → ℝ
  | 0 => initialError
  | n + 1 => amplification n * errorBudget amplification localDefect splittingDefect initialError n +
    localDefect n + splittingDefect n

/-- Actual successive numerical states are compared with an independent
reference sequence. The directional consistency defect and reference/splitting
mismatch remain separate; no high order for the composite is inferred. -/
theorem execution_error_le
    (step : ℕ → (Cell → E) → Cell → E) (admitted : ℕ → (Cell → E) → Prop)
    (initial : Cell → E) (reference directionalReference : ℕ → Cell → E)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (hinitial : ∀ cell, ‖initial cell - reference 0 cell‖ ≤ initialError)
    (hactual : ∀ n, admitted n (execution step initial n))
    (hrefadmit : ∀ n, admitted n (reference n))
    (hstable : ∀ n q other, admitted n q → admitted n other →
      ∀ error : ℝ, (∀ cell, ‖q cell - other cell‖ ≤ error) →
      ∀ cell, ‖step n q cell - step n other cell‖ ≤ amplification n * error)
    (hlocal : ∀ n cell, ‖step n (reference n) cell - directionalReference n cell‖ ≤ localDefect n)
    (hsplit : ∀ n cell, ‖directionalReference n cell - reference (n + 1) cell‖ ≤ splittingDefect n) :
    ∀ n cell, ‖execution step initial n cell - reference n cell‖ ≤
      errorBudget amplification localDefect splittingDefect initialError n := by
  intro n
  induction n with
  | zero => exact hinitial
  | succ n ih =>
    intro cell
    have hs := hstable n (execution step initial n) (reference n) (hactual n) (hrefadmit n)
      (errorBudget amplification localDefect splittingDefect initialError n) ih cell
    calc
      ‖execution step initial (n + 1) cell - reference (n + 1) cell‖ ≤
          ‖step n (execution step initial n) cell - step n (reference n) cell‖ +
            ‖step n (reference n) cell - reference (n + 1) cell‖ :=
        norm_sub_le_norm_sub_add_norm_sub ..
      _ ≤ amplification n * errorBudget amplification localDefect splittingDefect initialError n +
          (localDefect n + splittingDefect n) := add_le_add hs
        ((norm_sub_le_norm_sub_add_norm_sub _ (directionalReference n cell) _).trans
          (add_le_add (hlocal n cell) (hsplit n cell)))
      _ = errorBudget amplification localDefect splittingDefect initialError (n + 1) := by
        simp [errorBudget, add_assoc]

theorem execution_error_le_upto
    (step : ℕ → (Cell → E) → Cell → E) (admitted : ℕ → (Cell → E) → Prop)
    (initial : Cell → E) (reference directionalReference : ℕ → Cell → E)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ) (steps : ℕ)
    (hinitial : ∀ cell, ‖initial cell - reference 0 cell‖ ≤ initialError)
    (hactual : ∀ n < steps, admitted n (execution step initial n))
    (hrefadmit : ∀ n < steps, admitted n (reference n))
    (hstable : ∀ n < steps, ∀ q other, admitted n q → admitted n other →
      ∀ error : ℝ, (∀ cell, ‖q cell - other cell‖ ≤ error) →
      ∀ cell, ‖step n q cell - step n other cell‖ ≤ amplification n * error)
    (hlocal : ∀ n < steps, ∀ cell, ‖step n (reference n) cell - directionalReference n cell‖ ≤ localDefect n)
    (hsplit : ∀ n < steps, ∀ cell, ‖directionalReference n cell - reference (n + 1) cell‖ ≤ splittingDefect n) :
    ∀ n ≤ steps, ∀ cell, ‖execution step initial n cell - reference n cell‖ ≤
      errorBudget amplification localDefect splittingDefect initialError n := by
  intro n
  induction n with
  | zero => intro _; exact hinitial
  | succ n ih =>
    intro hn cell
    have hn' : n < steps := Nat.lt_of_succ_le hn
    have hs := hstable n hn' (execution step initial n) (reference n) (hactual n hn') (hrefadmit n hn')
      (errorBudget amplification localDefect splittingDefect initialError n)
      (ih (Nat.le_of_succ_le hn)) cell
    calc
      ‖execution step initial (n + 1) cell - reference (n + 1) cell‖ ≤
          ‖step n (execution step initial n) cell - step n (reference n) cell‖ +
            ‖step n (reference n) cell - reference (n + 1) cell‖ :=
        norm_sub_le_norm_sub_add_norm_sub ..
      _ ≤ amplification n * errorBudget amplification localDefect splittingDefect initialError n +
          (localDefect n + splittingDefect n) := add_le_add hs
        ((norm_sub_le_norm_sub_add_norm_sub _ (directionalReference n cell) _).trans
          (add_le_add (hlocal n hn' cell) (hsplit n hn' cell)))
      _ = errorBudget amplification localDefect splittingDefect initialError (n + 1) := by
        simp [errorBudget, add_assoc]

theorem errorBudget_uniform_le (amplification localDefect splittingDefect : ℕ → ℝ)
    (initialError A delta : ℝ) (hA : 1 ≤ A) (hE : 0 ≤ initialError) (hd : 0 ≤ delta)
    (ha : ∀ n, 0 ≤ amplification n ∧ amplification n ≤ A)
    (hl : ∀ n, 0 ≤ localDefect n) (hs : ∀ n, 0 ≤ splittingDefect n)
    (hdefect : ∀ n, localDefect n + splittingDefect n ≤ delta) :
    ∀ n, errorBudget amplification localDefect splittingDefect initialError n ≤
      A ^ n * (initialError + n * delta) := by
  have hnonneg : ∀ n, 0 ≤ errorBudget amplification localDefect splittingDefect initialError n := by
    intro n
    induction n with
    | zero => exact hE
    | succ n ih => exact add_nonneg (add_nonneg (mul_nonneg (ha n).1 ih) (hl n)) (hs n)
  intro n
  induction n with
  | zero => simp [errorBudget]
  | succ n ih =>
    have hp : 1 ≤ A ^ (n + 1) := one_le_pow₀ hA
    calc
      errorBudget amplification localDefect splittingDefect initialError (n + 1) ≤
          A * (A ^ n * (initialError + n * delta)) + delta := by
        dsimp [errorBudget]
        linarith [mul_le_mul (ha n).2 ih (hnonneg n) (le_trans (by norm_num) hA), hdefect n]
      _ ≤ A ^ (n + 1) * (initialError + (n + 1 : ℕ) * delta) := by
        rw [pow_succ] at hp ⊢
        push_cast
        nlinarith [mul_le_mul_of_nonneg_right hp hd]

end NumStability.SequentialError
