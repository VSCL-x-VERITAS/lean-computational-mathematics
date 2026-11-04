/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.Module.LinearMap.End
import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Topology.MetricSpace.Pseudo.Lemmas
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

/-!
# Error bounds from finite-horizon bounds on linear powers

An actual linear map propagates an error sequence with an actual additive defect
at every executed step. Finite variation of constants expresses the final error
using powers of that same map. A uniform bound on all those powers then controls
the accumulated defects without a one-step growth hypothesis.

The power bound is the pointwise operator bound on every state vector. No
continuity, completeness, PDE interpretation, or solver correctness is inferred.
-/

open Filter
open scoped BigOperators Topology

namespace NumStability

section Algebra

variable {E : Type*} [AddCommMonoid E] [Module ℝ E]

/-- Finite variation of constants for an executed linear error recurrence.
The defect introduced at step `k` is propagated for `M - (k + 1)` further steps. -/
theorem linearError_eq_pow_add_sum
    (N : E →ₗ[ℝ] E) (error defect : ℕ → E) (M : ℕ)
    (hstep : ∀ k, k < M → error (k + 1) = N (error k) + defect k) :
    error M = (N ^ M) (error 0) +
      ∑ k ∈ Finset.range M, (N ^ (M - (k + 1))) (defect k) := by
  revert hstep
  induction M with
  | zero =>
      intro _
      simp
  | succ M ih =>
      intro hstep
      have hprevious : error M = (N ^ M) (error 0) +
          ∑ k ∈ Finset.range M, (N ^ (M - (k + 1))) (defect k) :=
        ih (fun k hk => hstep k (by omega))
      have hinitial : N ((N ^ M) (error 0)) = (N ^ (M + 1)) (error 0) := by
        rw [pow_succ', Module.End.mul_apply]
      have hsum : N (∑ k ∈ Finset.range M, (N ^ (M - (k + 1))) (defect k)) =
          ∑ k ∈ Finset.range M, (N ^ (M + 1 - (k + 1))) (defect k) := by
        rw [map_sum]
        apply Finset.sum_congr rfl
        intro k hk
        have hkM : k < M := Finset.mem_range.mp hk
        have hexponent : M + 1 - (k + 1) = M - (k + 1) + 1 := by omega
        rw [hexponent, pow_succ', Module.End.mul_apply]
      calc
        error (M + 1) = N (error M) + defect M := hstep M (by omega)
        _ = N ((N ^ M) (error 0) +
            ∑ k ∈ Finset.range M, (N ^ (M - (k + 1))) (defect k)) + defect M := by
          rw [hprevious]
        _ = ((N ^ (M + 1)) (error 0) +
            ∑ k ∈ Finset.range M, (N ^ (M + 1 - (k + 1))) (defect k)) + defect M := by
          rw [map_add, hinitial, hsum]
        _ = (N ^ (M + 1)) (error 0) +
            ∑ k ∈ Finset.range (M + 1), (N ^ (M + 1 - (k + 1))) (defect k) := by
          rw [Finset.sum_range_succ]
          simp only [Nat.sub_self, pow_zero, Module.End.one_apply]
          exact add_assoc _ _ _

end Algebra

section Norm

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Bounds on every actual power through `M` control the initial error and the
sum of the norms of the executed defects. No bound on unexecuted defects is used. -/
theorem linearError_norm_le_sum_of_power_bound
    (N : E →ₗ[ℝ] E) (error defect : ℕ → E) (M : ℕ) (C : ℝ)
    (hstep : ∀ k, k < M → error (k + 1) = N (error k) + defect k)
    (hpower : ∀ k, k ≤ M → ∀ x : E, ‖(N ^ k) x‖ ≤ C * ‖x‖) :
    ‖error M‖ ≤ C * (‖error 0‖ + ∑ k ∈ Finset.range M, ‖defect k‖) := by
  rw [linearError_eq_pow_add_sum N error defect M hstep]
  calc
    ‖(N ^ M) (error 0) + ∑ k ∈ Finset.range M, (N ^ (M - (k + 1))) (defect k)‖ ≤
        ‖(N ^ M) (error 0)‖ +
          ‖∑ k ∈ Finset.range M, (N ^ (M - (k + 1))) (defect k)‖ := norm_add_le _ _
    _ ≤ C * ‖error 0‖ + ∑ k ∈ Finset.range M, C * ‖defect k‖ := by
      apply add_le_add (hpower M le_rfl (error 0))
      exact (norm_sum_le _ _).trans (Finset.sum_le_sum (fun k _ =>
        hpower (M - (k + 1)) (Nat.sub_le _ _) (defect k)))
    _ = C * (‖error 0‖ + ∑ k ∈ Finset.range M, ‖defect k‖) := by
      rw [mul_add, Finset.mul_sum]

/-- A common executed-step defect budget yields a finite-step power-bound
estimate. The multiplier controls all states, not only the chosen error path. -/
theorem linearError_norm_le_of_power_bound_of_defect_bound
    (N : E →ₗ[ℝ] E) (error defect : ℕ → E) (M : ℕ) (C budget : ℝ)
    (hC : 0 ≤ C)
    (hstep : ∀ k, k < M → error (k + 1) = N (error k) + defect k)
    (hpower : ∀ k, k ≤ M → ∀ x : E, ‖(N ^ k) x‖ ≤ C * ‖x‖)
    (hdefect : ∀ k, k < M → ‖defect k‖ ≤ budget) :
    ‖error M‖ ≤ C * (‖error 0‖ + (M : ℝ) * budget) := by
  have hsum : (∑ k ∈ Finset.range M, ‖defect k‖) ≤ (M : ℝ) * budget := by
    calc
      (∑ k ∈ Finset.range M, ‖defect k‖) ≤ ∑ _k ∈ Finset.range M, budget :=
        Finset.sum_le_sum (fun k hk => hdefect k (Finset.mem_range.mp hk))
      _ = (M : ℝ) * budget := by simp
  exact (linearError_norm_le_sum_of_power_bound N error defect M C hstep hpower).trans
    (mul_le_mul_of_nonneg_left (add_le_add le_rfl hsum) hC)

/-- Finite-horizon accumulation with actual defects bounded by `dt * rate`.
The nonnegative time-step hypothesis records the time-step domain; once the
defect inequality and clock inequality are supplied, the estimate only needs
nonnegativity of `C` and `rate`. Zero steps and zero time steps are permitted. -/
-- Preserve the source hypotheses and the existing public interface.
@[nolint unusedArguments]
theorem linearError_norm_le_of_power_bound_of_finite_horizon
    (N : E →ₗ[ℝ] E) (error defect : ℕ → E) (M : ℕ)
    (dt C rate horizon : ℝ) (_hdt : 0 ≤ dt) (hC : 0 ≤ C) (hrate : 0 ≤ rate)
    (hstep : ∀ k, k < M → error (k + 1) = N (error k) + defect k)
    (hpower : ∀ k, k ≤ M → ∀ x : E, ‖(N ^ k) x‖ ≤ C * ‖x‖)
    (hdefect : ∀ k, k < M → ‖defect k‖ ≤ dt * rate)
    (hclock : (M : ℝ) * dt ≤ horizon) :
    ‖error M‖ ≤ C * (‖error 0‖ + horizon * rate) := by
  have hbudget : (M : ℝ) * (dt * rate) ≤ horizon * rate := by
    calc
      (M : ℝ) * (dt * rate) = ((M : ℝ) * dt) * rate := by ring
      _ ≤ horizon * rate := mul_le_mul_of_nonneg_right hclock hrate
  exact (linearError_norm_le_of_power_bound_of_defect_bound N error defect M C (dt * rate)
    hC hstep hpower hdefect).trans
    (mul_le_mul_of_nonneg_left (add_le_add le_rfl hbudget) hC)

end Norm

/-- A single power-bound constant controls a family of actual linear error
recurrences over a fixed finite horizon. Vanishing initial errors and uniform
executed-step defect rates imply vanishing final error norms. The genuine normed
real state space may vary with the index; a constant family gives a fixed space.
No one-step growth estimate or PDE convergence assertion is assumed. -/
theorem linearError_norm_tendsto_zero_of_uniform_power_bound
    {F : ℕ → Type*} [∀ n, NormedAddCommGroup (F n)] [∀ n, NormedSpace ℝ (F n)]
    (N : ∀ n, F n →ₗ[ℝ] F n) (error defect : ∀ n, ℕ → F n)
    (steps : ℕ → ℕ) (dt rate : ℕ → ℝ) (C horizon : ℝ)
    (hdt : ∀ n, 0 ≤ dt n) (hC : 0 ≤ C) (hrate_nonneg : ∀ n, 0 ≤ rate n)
    (hstep : ∀ n k, k < steps n → error n (k + 1) = N n (error n k) + defect n k)
    (hpower : ∀ n k, k ≤ steps n → ∀ x : F n, ‖(N n ^ k) x‖ ≤ C * ‖x‖)
    (hdefect : ∀ n k, k < steps n → ‖defect n k‖ ≤ dt n * rate n)
    (hclock : ∀ n, (steps n : ℝ) * dt n ≤ horizon)
    (hinitial : Tendsto (fun n => ‖error n 0‖) atTop (𝓝 0))
    (hrate : Tendsto rate atTop (𝓝 0)) :
    Tendsto (fun n => ‖error n (steps n)‖) atTop (𝓝 0) := by
  have hupper (n : ℕ) : ‖error n (steps n)‖ ≤
      C * (‖error n 0‖ + horizon * rate n) :=
    linearError_norm_le_of_power_bound_of_finite_horizon (N n) (error n) (defect n)
      (steps n) (dt n) C (rate n) horizon (hdt n) hC (hrate_nonneg n)
      (hstep n) (hpower n) (hdefect n) (hclock n)
  apply squeeze_zero (fun n => norm_nonneg (error n (steps n))) hupper
  simpa using (hinitial.add (hrate.const_mul horizon)).const_mul C

end NumStability
