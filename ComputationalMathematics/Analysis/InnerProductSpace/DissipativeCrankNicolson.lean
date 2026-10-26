/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Tactic.Abel
import Mathlib.Tactic.Linarith

/-!
# Crank–Nicolson solvability for bounded dissipative operators

On a real Hilbert space, every bounded dissipative spatial operator admits a
unique Crank–Nicolson step at each nonnegative time step. The coercive
resolvent is inverted using Mathlib's bounded-inner-product criterion.
-/

namespace NumStability

open scoped InnerProductSpace

/-- The implicit Crank–Nicolson equation has one solution for every initial
state and every nonnegative time step on a real Hilbert space. -/
theorem dissipative_crankNicolson_existsUnique
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]
    (spatial : E →L[ℝ] E)
    (hdissipative : ∀ x, ⟪spatial x, x⟫_ℝ ≤ 0)
    (before : E) (timeStep : ℝ) (htime : 0 ≤ timeStep) :
    ∃! after : E, after - before = (timeStep / 2) • spatial (after + before) := by
  let A : E →L[ℝ] E := ContinuousLinearMap.id ℝ E - (timeStep / 2) • spatial
  have hA (x : E) : A x = x - (timeStep / 2) • spatial x := by
    simp [A]
  have hcoercive (x : E) : ‖x‖ ^ 2 ≤ ⟪A x, x⟫_ℝ := by
    rw [hA, inner_sub_left, real_inner_smul_left, real_inner_self_eq_norm_sq]
    have hnonpos := mul_nonpos_of_nonneg_of_nonpos
      (show 0 ≤ timeStep / 2 by linarith) (hdissipative x)
    linarith
  have hunit : IsUnit A := ContinuousLinearMap.isUnit_of_forall_le_norm_inner_map
    A (c := 1) (by norm_num) (fun x => by
      simpa using (hcoercive x).trans (le_abs_self ⟪A x, x⟫_ℝ))
  have hbijective : Function.Bijective A :=
    ContinuousLinearMap.isUnit_iff_bijective.mp hunit
  obtain ⟨after, hafter⟩ := hbijective.surjective (before + (timeStep / 2) • spatial before)
  have heq (u : E) :
      A u = before + (timeStep / 2) • spatial before ↔
        u - before = (timeStep / 2) • spatial (u + before) := by
    rw [hA, map_add, smul_add]
    simp only [sub_eq_iff_eq_add]
    constructor <;> intro h <;> convert h using 1 <;> abel
  refine ⟨after, (heq after).mp hafter, ?_⟩
  intro other hother
  apply hbijective.injective
  exact ((heq other).mpr hother).trans hafter.symm

/-- A dissipative Crank–Nicolson step contracts the Hilbert norm for every
nonnegative time step. No completeness or boundedness assumption is needed. -/
theorem dissipative_crankNicolson_contracts
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (spatial : E →ₗ[ℝ] E) (before after : E) (timeStep : ℝ)
    (htime : 0 ≤ timeStep)
    (hdissipative : ∀ x, ⟪spatial x, x⟫_ℝ ≤ 0)
    (hstep : after - before =
      (timeStep / 2) • spatial (after + before)) :
    ‖after‖ ≤ ‖before‖  := by
  have henergy : ‖after‖ ^ 2 - ‖before‖ ^ 2 =
      (timeStep / 2) * ⟪spatial (after + before), after + before⟫_ℝ := by
    calc
      ‖after‖ ^ 2 - ‖before‖ ^ 2 =
          ⟪after - before, after + before⟫_ℝ := by
            simp only [inner_sub_left, inner_add_right,
              real_inner_comm before after,
              real_inner_self_eq_norm_sq]
            ring
      _ = _ := by rw [hstep, real_inner_smul_left]
  have hnonpos : ‖after‖ ^ 2 - ‖before‖ ^ 2 ≤ 0 := by
    rw [henergy]
    exact mul_nonpos_of_nonneg_of_nonpos (by linarith) (hdissipative _)
  nlinarith [norm_nonneg before, norm_nonneg after]

open scoped BigOperators Matrix

/-- Finite-coordinate form of the dissipative Crank–Nicolson contraction:
the spatial operator is the negative of a positive-semidefinite real matrix.
The finite index type may be empty, and the time step has no upper bound. -/
theorem posSemidef_crankNicolson_sum_sq_le
    {V : Type*} [Fintype V] [DecidableEq V]
    (A : Matrix V V ℝ) (hA : A.PosSemidef)
    (before after : V → ℝ) (timeStep : ℝ) (htime : 0 ≤ timeStep)
    (hstep : ∀ i, after i - before i = -(timeStep / 2) *
      (A *ᵥ (after + before)) i) :
    (∑ i, after i ^ 2) ≤ ∑ i, before i ^ 2 := by
  let spatial : EuclideanSpace ℝ V →ₗ[ℝ] EuclideanSpace ℝ V :=
    -(Matrix.toLpLin 2 2 A)
  have hdissipative (x : EuclideanSpace ℝ V) :
      ⟪spatial x, x⟫_ℝ ≤ 0 := by
    change ⟪-((Matrix.toLpLin 2 2 A) x), x⟫_ℝ ≤ 0
    rw [inner_neg_left]
    exact neg_nonpos.mpr
      ((Matrix.isPositive_toEuclideanLin_iff.mpr hA).inner_nonneg_left x)
  have hstepLp : WithLp.toLp 2 after - WithLp.toLp 2 before =
      (timeStep / 2) • spatial (WithLp.toLp 2 after + WithLp.toLp 2 before) := by
    ext i
    change after i - before i = (timeStep / 2) * -(A *ᵥ (after + before)) i
    simpa only [neg_mul, mul_neg] using hstep i
  have hnorm := dissipative_crankNicolson_contracts spatial
    (WithLp.toLp 2 before) (WithLp.toLp 2 after) timeStep htime hdissipative hstepLp
  have hsq := pow_le_pow_left₀ (norm_nonneg (WithLp.toLp 2 after)) hnorm 2
  simpa only [EuclideanSpace.norm_sq_eq, Real.norm_eq_abs, sq_abs] using hsq

end NumStability
