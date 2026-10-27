/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Eigenspace.Basic
import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Data.Real.Archimedean
import Mathlib.Algebra.Order.Field.Power
import Mathlib.Tactic.Linarith

/-!
# Eigenvalues of eventually bounded orbits

An eigenvector whose iterated images are eventually bounded cannot have an
eigenvalue of absolute value greater than one.
-/

namespace NumStability

/-- An eventual orbit bound forces a real eigenvalue into the closed unit interval. -/
theorem abs_eigenvalue_le_one_of_eventually_bounded_orbit
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (S : E →ₗ[ℝ] E) (eigenvalue : ℝ) (u : E) (hu : u ≠ 0)
    (heigen : S u = eigenvalue • u)
    (hbounded : ∃ bound : ℝ, ∃ start : ℕ, ∀ n ≥ start,
      ‖(S ^ n) u‖ ≤ bound * ‖u‖) : |eigenvalue| ≤ 1 := by
  obtain ⟨bound,start,hbound⟩ := hbounded
  have hv : Module.End.HasEigenvector S eigenvalue u :=
    ⟨Module.End.mem_eigenspace_iff.mpr heigen, hu⟩
  have hn : 0 < ‖u‖ := norm_pos_iff.mpr hu
  by_contra hc
  have hc1 : 1 < |eigenvalue| := lt_of_not_ge hc
  obtain ⟨n,hpow⟩ := pow_unbounded_of_one_lt (max bound (|eigenvalue| ^ start)) hc1
  have hns : start ≤ n := by
    by_contra hh
    have hle := pow_le_pow_right₀ hc1.le (le_of_lt (lt_of_not_ge hh))
    exact ((le_max_right _ _).trans_lt hpow).not_ge hle
  have h := hbound n hns
  rw [hv.pow_apply n, norm_smul, Real.norm_eq_abs, abs_pow] at h
  have hb : bound < |eigenvalue| ^ n := (le_max_left _ _).trans_lt hpow
  exact (mul_lt_mul_of_pos_right hb hn).not_ge h

end NumStability
