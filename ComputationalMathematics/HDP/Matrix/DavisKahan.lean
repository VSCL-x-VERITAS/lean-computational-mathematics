import ComputationalMathematics.HDP.Matrix.Weyl
import Mathlib.Geometry.Euclidean.Angle.Unoriented.Basic

/-!
# Davis--Kahan eigenvector perturbation inequality

This file proves the one-dimensional real symmetric Davis--Kahan bound from
the orthonormal spectral decomposition and Weyl's eigenvalue inequality.
-/

noncomputable section

open scoped BigOperators RealInnerProductSpace

namespace NumStability.HDP.Matrix

private theorem spectral_gap_mul_sin_angle_le_residual
    {n : ℕ} (S : Matrix (Fin n) (Fin n) ℝ) (hS : S.IsHermitian)
    (i : Fin n) (δ : ℝ) (hδ : 0 < δ)
    (hsep : ∀ j : Fin n, j ≠ i →
      δ ≤ |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hS j|)
    (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1) :
    δ * Real.sin
        (InnerProductGeometry.angle
          (NumStability.hermitianOrderedEigenbasis hS i) v) ≤
      ‖Matrix.toEuclideanLin S v -
        NumStability.hermitianOrderedEigenvalue hS i • v‖ := by
  classical
  let b := NumStability.hermitianOrderedEigenbasis hS
  let evals := NumStability.hermitianOrderedEigenvalue hS
  let r := Matrix.toEuclideanLin S v - evals i • v
  have hcoord (j : Fin n) :
      b.repr r j = (evals j - evals i) * b.repr v j := by
    have hdiag :=
      (Matrix.isHermitian_iff_isSymmetric.mp hS).eigenvectorBasis_apply_self_apply
        finrank_euclideanSpace_fin v j
    change b.repr (Matrix.toEuclideanLin S v) j = evals j * b.repr v j at hdiag
    simp only [r, map_sub, map_smul, WithLp.ofLp_sub, WithLp.ofLp_smul,
      Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
    rw [hdiag]
    ring
  have hvsum : ∑ j : Fin n, (b.repr v j) ^ 2 = 1 := by
    have h := b.sum_sq_inner_right v
    simp_rw [← b.repr_apply_apply] at h
    simpa [hv] using h
  have hsplit :
      ∑ j ∈ (Finset.univ.erase i), (b.repr v j) ^ 2 =
        1 - (b.repr v i) ^ 2 := by
    have h := Finset.sum_erase_add (Finset.univ : Finset (Fin n))
      (fun j ↦ (b.repr v j) ^ 2) (Finset.mem_univ i)
    rw [hvsum] at h
    linarith
  have hcos :
      Real.cos
          (InnerProductGeometry.angle
            (NumStability.hermitianOrderedEigenbasis hS i) v) =
        b.repr v i := by
    rw [InnerProductGeometry.cos_angle,
      NumStability.norm_hermitianOrderedEigenbasis hS i, hv, one_mul, div_one]
    exact (b.repr_apply_apply v i).symm
  have hsinSq :
      Real.sin
          (InnerProductGeometry.angle
            (NumStability.hermitianOrderedEigenbasis hS i) v) ^ 2 =
        ∑ j ∈ (Finset.univ.erase i), (b.repr v j) ^ 2 := by
    have htrig := Real.sin_sq_add_cos_sq
      (InnerProductGeometry.angle
        (NumStability.hermitianOrderedEigenbasis hS i) v)
    rw [hcos] at htrig
    rw [hsplit]
    nlinarith
  have hresSq :
      ‖r‖ ^ 2 = ∑ j : Fin n, ((evals j - evals i) * b.repr v j) ^ 2 := by
    have h := b.sum_sq_inner_right r
    simp_rw [← b.repr_apply_apply, hcoord] at h
    exact h.symm
  have hterm : ∀ j ∈ (Finset.univ.erase i),
      δ ^ 2 * (b.repr v j) ^ 2 ≤
        ((evals j - evals i) * b.repr v j) ^ 2 := by
    intro j hj
    have hji : j ≠ i := (Finset.mem_erase.mp hj).1
    have habs : δ ≤ |evals i - evals j| := hsep j hji
    have hsquare : δ ^ 2 ≤ (evals j - evals i) ^ 2 := by
      have habs0 : 0 ≤ |evals i - evals j| := abs_nonneg _
      have hsq : δ ^ 2 ≤ |evals i - evals j| ^ 2 := by nlinarith
      calc
        δ ^ 2 ≤ (evals i - evals j) ^ 2 := by simpa [sq_abs] using hsq
        _ = (evals j - evals i) ^ 2 := by ring
    have := mul_le_mul_of_nonneg_right hsquare (sq_nonneg (b.repr v j))
    nlinarith
  have hgapSq :
      δ ^ 2 *
          ∑ j ∈ (Finset.univ.erase i), (b.repr v j) ^ 2 ≤ ‖r‖ ^ 2 := by
    calc
      δ ^ 2 * ∑ j ∈ (Finset.univ.erase i), (b.repr v j) ^ 2 =
          ∑ j ∈ (Finset.univ.erase i),
            δ ^ 2 * (b.repr v j) ^ 2 := by
              rw [Finset.mul_sum]
      _ ≤ ∑ j ∈ (Finset.univ.erase i),
          ((evals j - evals i) * b.repr v j) ^ 2 :=
        Finset.sum_le_sum hterm
      _ ≤ ∑ j : Fin n, ((evals j - evals i) * b.repr v j) ^ 2 := by
        exact Finset.sum_le_sum_of_subset_of_nonneg
          (Finset.erase_subset i Finset.univ)
          (fun _ _ _ ↦ sq_nonneg _)
      _ = ‖r‖ ^ 2 := hresSq.symm
  have hsin0 : 0 ≤ Real.sin
      (InnerProductGeometry.angle
        (NumStability.hermitianOrderedEigenbasis hS i) v) :=
    InnerProductGeometry.sin_angle_nonneg _ _
  have hleft0 : 0 ≤ δ * Real.sin
      (InnerProductGeometry.angle
        (NumStability.hermitianOrderedEigenbasis hS i) v) :=
    mul_nonneg hδ.le hsin0
  rw [← hsinSq] at hgapSq
  change δ * Real.sin
      (InnerProductGeometry.angle
        (NumStability.hermitianOrderedEigenbasis hS i) v) ≤ ‖r‖
  nlinarith [norm_nonneg r]

private theorem eigenvector_residual_le_two_operatorNorm
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n) :
    ‖Matrix.toEuclideanLin S
          (NumStability.hermitianOrderedEigenbasis hT i) -
        NumStability.hermitianOrderedEigenvalue hS i •
          NumStability.hermitianOrderedEigenbasis hT i‖ ≤
      2 * NumStability.realMatrixOperatorNorm (S - T) := by
  let v := NumStability.hermitianOrderedEigenbasis hT i
  let evalS := NumStability.hermitianOrderedEigenvalue hS i
  let evalT := NumStability.hermitianOrderedEigenvalue hT i
  have hTv : Matrix.toEuclideanLin T v = evalT • v :=
    NumStability.hermitianOrderedEigenbasis_apply hT i
  have hdecomp :
      Matrix.toEuclideanLin S v - evalS • v =
        Matrix.toEuclideanLin (S - T) v + (evalT - evalS) • v := by
    have hST : Matrix.toEuclideanLin (S - T) v =
        Matrix.toEuclideanLin S v - Matrix.toEuclideanLin T v := by
      ext j
      simp [Matrix.toLpLin_apply]
    rw [hST, hTv]
    module
  have hmatrix :
      ‖Matrix.toEuclideanLin (S - T) v‖ ≤
        NumStability.realMatrixOperatorNorm (S - T) := by
    change ‖NumStability.realMatrixContinuousLinearMap (S - T) v‖ ≤
      ‖NumStability.realMatrixContinuousLinearMap (S - T)‖
    calc
      ‖NumStability.realMatrixContinuousLinearMap (S - T) v‖ ≤
          ‖NumStability.realMatrixContinuousLinearMap (S - T)‖ * ‖v‖ :=
        ContinuousLinearMap.le_opNorm _ _
      _ = ‖NumStability.realMatrixContinuousLinearMap (S - T)‖ := by
        rw [NumStability.norm_hermitianOrderedEigenbasis hT i, mul_one]
  have heigen : |evalT - evalS| ≤
      NumStability.realMatrixOperatorNorm (S - T) := by
    simpa [abs_sub_comm] using
      abs_hermitianOrderedEigenvalue_sub_le_operatorNorm S T hS hT i
  calc
    ‖Matrix.toEuclideanLin S v - evalS • v‖ =
        ‖Matrix.toEuclideanLin (S - T) v + (evalT - evalS) • v‖ := by rw [hdecomp]
    _ ≤ ‖Matrix.toEuclideanLin (S - T) v‖ + ‖(evalT - evalS) • v‖ := norm_add_le _ _
    _ = ‖Matrix.toEuclideanLin (S - T) v‖ + |evalT - evalS| := by
      rw [norm_smul, Real.norm_eq_abs,
        NumStability.norm_hermitianOrderedEigenbasis hT i, mul_one]
    _ ≤ NumStability.realMatrixOperatorNorm (S - T) +
        NumStability.realMatrixOperatorNorm (S - T) := add_le_add hmatrix heigen
    _ = 2 * NumStability.realMatrixOperatorNorm (S - T) := by ring

/-- Davis--Kahan for a simple ordered eigenvalue of two real Hermitian
matrices.  The angle is sign-invariant because its sine is unchanged by
negating either eigenvector. -/
theorem sin_angle_orderedEigenvectors_le_two_operatorNorm_div_gap
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n)
    (δ : ℝ) (hδ : 0 < δ)
    (hsep : ∀ j : Fin n, j ≠ i →
      δ ≤ |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hS j|) :
    Real.sin
        (InnerProductGeometry.angle
          (NumStability.hermitianOrderedEigenbasis hS i)
          (NumStability.hermitianOrderedEigenbasis hT i)) ≤
      2 * NumStability.realMatrixOperatorNorm (S - T) / δ := by
  have hlower := spectral_gap_mul_sin_angle_le_residual
    S hS i δ hδ hsep
      (NumStability.hermitianOrderedEigenbasis hT i)
      (NumStability.norm_hermitianOrderedEigenbasis hT i)
  have hupper := eigenvector_residual_le_two_operatorNorm S T hS hT i
  apply (le_div_iff₀ hδ).2
  rw [mul_comm]
  exact hlower.trans hupper

end NumStability.HDP.Matrix
