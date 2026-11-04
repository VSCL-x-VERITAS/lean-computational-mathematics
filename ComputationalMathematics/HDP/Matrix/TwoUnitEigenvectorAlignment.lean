import ComputationalMathematics.HDP.Matrix.UnitEigenvectorAlignment

/-!
# Sign alignment with an arbitrary reference eigenvector

A separated reference eigenvalue determines every unit eigenvector up to
sign. Composing that exact identity with the existing arbitrary-unit
perturbation bound removes dependence on the chosen reference eigenbasis.
-/

noncomputable section

namespace NumStability.HDP.Matrix

/-- Every unit reference eigenvector at a separated ordered value agrees
with the selected ordered vector up to sign. -/
theorem exists_sign_eq_orderedEigenvector_of_unit_eigenvector
    {n : ℕ} (S : Matrix (Fin n) (Fin n) ℝ) (hS : S.IsHermitian) (i : Fin n)
    (δ : ℝ) (hδ : 0 < δ)
    (hsep : ∀ j : Fin n, j ≠ i →
      δ ≤ |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hS j|)
    (u : EuclideanSpace ℝ (Fin n)) (hu : ‖u‖ = 1)
    (hSu : S.toEuclideanLin u = NumStability.hermitianOrderedEigenvalue hS i • u) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      NumStability.hermitianOrderedEigenbasis hS i = θ • u := by
  obtain ⟨θ, hθ, hbound⟩ :=
    exists_sign_unit_eigenvector_norm_sub_le S S hS hS i δ hδ hsep u hu hSu
  have hzero : ‖NumStability.hermitianOrderedEigenbasis hS i - θ • u‖ = 0 := by
    apply le_antisymm
    · simpa [NumStability.realMatrixOperatorNorm,
        NumStability.realMatrixContinuousLinearMap] using hbound
    · exact norm_nonneg _
  exact ⟨θ, hθ, sub_eq_zero.mp (norm_eq_zero.mp hzero)⟩

/-- Arbitrary corresponding unit eigenvectors of both matrices have the
same sign-alignment bound. Only the reference eigenvalue is separated. -/
theorem exists_sign_unit_eigenvectors_norm_sub_le
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n)
    (δ : ℝ) (hδ : 0 < δ)
    (hsep : ∀ j : Fin n, j ≠ i →
      δ ≤ |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hS j|)
    (u v : EuclideanSpace ℝ (Fin n)) (hu : ‖u‖ = 1) (hv : ‖v‖ = 1)
    (hSu : S.toEuclideanLin u = NumStability.hermitianOrderedEigenvalue hS i • u)
    (hTv : T.toEuclideanLin v = NumStability.hermitianOrderedEigenvalue hT i • v) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ‖u - θ • v‖ ≤
        2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm (S - T) / δ := by
  obtain ⟨α, hα, hreference⟩ :=
    exists_sign_eq_orderedEigenvector_of_unit_eigenvector S hS i δ hδ hsep u hu hSu
  obtain ⟨β, hβ, hbound⟩ :=
    exists_sign_unit_eigenvector_norm_sub_le S T hS hT i δ hδ hsep v hv hTv
  have hreference' : u = α • NumStability.hermitianOrderedEigenbasis hS i := by
    rw [hreference]
    rcases hα with rfl | rfl <;> simp
  have habs : |α| = 1 := by rcases hα with rfl | rfl <;> norm_num
  refine ⟨α * β, ?_, ?_⟩
  · rcases hα with rfl | rfl <;> rcases hβ with rfl | rfl <;> norm_num
  · calc
      ‖u - (α * β) • v‖ =
          ‖α • (NumStability.hermitianOrderedEigenbasis hS i - β • v)‖ := by
        rw [hreference', smul_sub, smul_smul]
      _ = ‖NumStability.hermitianOrderedEigenbasis hS i - β • v‖ := by
        rw [norm_smul, Real.norm_eq_abs, habs, one_mul]
      _ ≤ 2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm (S - T) / δ := hbound

end NumStability.HDP.Matrix
