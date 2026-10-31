import ComputationalMathematics.HDP.Matrix.DavisKahan
import ComputationalMathematics.HDP.Vector.EigenvectorAlignment

/-!
# Sign-aligned eigenvector perturbation bounds

Consequences of the Davis--Kahan sine bound in the form used by the
stochastic-block-model argument.
-/

noncomputable section

namespace NumStability.HDP.Matrix

/-- A separated ordered eigenvector changes by at most
`2√2 ‖S-T‖/δ`, after choosing its sign. -/
theorem exists_sign_orderedEigenvectors_norm_sub_le
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n)
    (δ : ℝ) (hδ : 0 < δ)
    (hsep : ∀ j : Fin n, j ≠ i →
      δ ≤ |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hS j|) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖NumStability.hermitianOrderedEigenbasis hS i -
          θ • NumStability.hermitianOrderedEigenbasis hT i‖ ≤
        2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm (S - T) / δ := by
  have hsin := sin_angle_orderedEigenvectors_le_two_operatorNorm_div_gap
    S T hS hT i δ hδ hsep
  obtain ⟨θ, hθ, hbound⟩ :=
    NumStability.HDP.Vector.exists_sign_norm_sub_le_of_sin_angle_le
      (NumStability.hermitianOrderedEigenbasis hS i)
      (NumStability.hermitianOrderedEigenbasis hT i)
      (NumStability.norm_hermitianOrderedEigenbasis hS i)
      (NumStability.norm_hermitianOrderedEigenbasis hT i)
      (2 * NumStability.realMatrixOperatorNorm (S - T) / δ) hsin
  refine ⟨θ, hθ, hbound.trans_eq ?_⟩
  field_simp [hδ.ne']

/-- If the spectral gap is `μ n` and the perturbation is at most `C√n`,
then the corresponding unit eigenvectors are sign-aligned within
`2√2 C/(μ√n)`. -/
theorem exists_sign_orderedEigenvectors_norm_sub_le_sbm_scale
    {n : ℕ} (hn : 0 < n) (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n)
    (C μ : ℝ) (hC : 0 ≤ C) (hμ : 0 < μ)
    (hsep : ∀ j : Fin n, j ≠ i →
      μ * (n : ℝ) ≤ |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hS j|)
    (hnoise : NumStability.realMatrixOperatorNorm (S - T) ≤
      C * Real.sqrt n) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖NumStability.hermitianOrderedEigenbasis hS i -
          θ • NumStability.hermitianOrderedEigenbasis hT i‖ ≤
        2 * Real.sqrt 2 * C / (μ * Real.sqrt n) := by
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hsqrt : 0 < Real.sqrt n := Real.sqrt_pos.2 hnR
  have hgap : 0 < μ * (n : ℝ) := mul_pos hμ hnR
  obtain ⟨θ, hθ, hbound⟩ :=
    exists_sign_orderedEigenvectors_norm_sub_le S T hS hT i
      (μ * (n : ℝ)) hgap hsep
  refine ⟨θ, hθ, hbound.trans ?_⟩
  calc
    2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm (S - T) /
          (μ * (n : ℝ)) ≤
        2 * Real.sqrt 2 * (C * Real.sqrt n) / (μ * (n : ℝ)) := by
      gcongr
    _ = 2 * Real.sqrt 2 * C / (μ * Real.sqrt n) := by
      have hsquare : Real.sqrt (n : ℝ) ^ 2 = (n : ℝ) :=
        Real.sq_sqrt hnR.le
      field_simp [hμ.ne', hsqrt.ne']
      nlinarith

end NumStability.HDP.Matrix
