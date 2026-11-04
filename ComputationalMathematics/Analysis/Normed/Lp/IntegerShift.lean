/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Lp.Reindex
import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Analysis.InnerProductSpace.Adjoint

/-!
# Integer shifts and discrete summation by parts on real ℓ²

The successor pullback and predecessor pullback are inverse linear isometries.
Their inner-product flip gives the adjoint relation between the backward
difference and forward divergence without pointwise convergence assumptions.
-/

namespace NumStability

open scoped InnerProductSpace

noncomputable section

private def intSuccessorEquiv : ℤ ≃ ℤ where
  toFun i := i + 1
  invFun i := i - 1
  left_inv i := by simp
  right_inv i := by simp

/-- Pull back a square-summable real sequence along the integer successor. -/
def l2IntForwardShift :
    lp (fun _ : ℤ => ℝ) 2 ≃ₗᵢ[ℝ] lp (fun _ : ℤ => ℝ) 2 :=
  lpReindex intSuccessorEquiv

/-- The inverse shift pulls back along the integer predecessor. -/
def l2IntBackwardShift :
    lp (fun _ : ℤ => ℝ) 2 ≃ₗᵢ[ℝ] lp (fun _ : ℤ => ℝ) 2 :=
  l2IntForwardShift.symm

@[simp] theorem l2IntForwardShift_apply (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    l2IntForwardShift u i = u (i + 1) := rfl

@[simp] theorem l2IntBackwardShift_apply (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    l2IntBackwardShift u i = u (i - 1) := rfl

@[simp] theorem l2IntForwardShift_backward (u : lp (fun _ : ℤ => ℝ) 2) :
    l2IntForwardShift (l2IntBackwardShift u) = u :=
  l2IntForwardShift.apply_symm_apply u

@[simp] theorem l2IntBackwardShift_forward (u : lp (fun _ : ℤ => ℝ) 2) :
    l2IntBackwardShift (l2IntForwardShift u) = u :=
  l2IntForwardShift.symm_apply_apply u

/-- The successor and predecessor pullbacks are adjoint in the real ℓ² pairing. -/
theorem l2IntForwardShift_inner (u v : lp (fun _ : ℤ => ℝ) 2) :
    ⟪l2IntForwardShift u, v⟫_ℝ = ⟪u, l2IntBackwardShift v⟫_ℝ :=
  l2IntForwardShift.inner_map_eq_flip u v

theorem l2IntBackwardShift_inner (u v : lp (fun _ : ℤ => ℝ) 2) :
    ⟪l2IntBackwardShift u, v⟫_ℝ = ⟪u, l2IntForwardShift v⟫_ℝ :=
  l2IntBackwardShift.inner_map_eq_flip u v

/-- The bounded unscaled backward difference `u_i - u_(i-1)`. -/
def l2IntBackwardDifference :
    lp (fun _ : ℤ => ℝ) 2 →L[ℝ] lp (fun _ : ℤ => ℝ) 2 :=
  ContinuousLinearMap.id ℝ _ -
    l2IntBackwardShift.toContinuousLinearEquiv.toContinuousLinearMap

/-- The bounded unscaled forward divergence `v_(i+1) - v_i`. -/
def l2IntForwardDivergence :
    lp (fun _ : ℤ => ℝ) 2 →L[ℝ] lp (fun _ : ℤ => ℝ) 2 :=
  l2IntForwardShift.toContinuousLinearEquiv.toContinuousLinearMap -
    ContinuousLinearMap.id ℝ _

@[simp] theorem l2IntBackwardDifference_apply
    (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    l2IntBackwardDifference u i = u i - u (i - 1) := rfl

@[simp] theorem l2IntForwardDivergence_apply
    (v : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    l2IntForwardDivergence v i = v (i + 1) - v i := rfl

/-- Discrete summation by parts on the entire integer grid. -/
theorem l2IntBackwardDifference_inner (u v : lp (fun _ : ℤ => ℝ) 2) :
    ⟪l2IntBackwardDifference u, v⟫_ℝ =
      -⟪u, l2IntForwardDivergence v⟫_ℝ := by
  change ⟪u - l2IntBackwardShift u, v⟫_ℝ =
    -⟪u, l2IntForwardShift v - v⟫_ℝ
  rw [inner_sub_left, inner_sub_right, l2IntBackwardShift_inner]
  exact (neg_sub _ _).symm

/-- The divergence has the negative backward difference as its adjoint. -/
theorem l2IntForwardDivergence_inner (u v : lp (fun _ : ℤ => ℝ) 2) :
    ⟪l2IntForwardDivergence v, u⟫_ℝ =
      -⟪v, l2IntBackwardDifference u⟫_ℝ := by
  change ⟪l2IntForwardShift v - v, u⟫_ℝ =
    -⟪v, u - l2IntBackwardShift u⟫_ℝ
  rw [inner_sub_left, inner_sub_right, l2IntForwardShift_inner]
  exact (neg_sub _ _).symm

/-- The actual continuous-linear adjoint of the backward difference. -/
theorem l2IntBackwardDifference_adjoint :
    l2IntBackwardDifference.adjoint = -l2IntForwardDivergence := by
  symm
  apply (ContinuousLinearMap.eq_adjoint_iff _ _).mpr
  intro v u
  simp only [ContinuousLinearMap.neg_apply, inner_neg_left,
    l2IntForwardDivergence_inner, neg_neg]

end

end NumStability
