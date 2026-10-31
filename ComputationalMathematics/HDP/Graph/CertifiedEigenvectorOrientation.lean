import ComputationalMathematics.HDP.Graph.CertifiedSecondEigenvector
import ComputationalMathematics.HDP.Matrix.TwoUnitEigenvectorAlignment

/-!
# Orientation of supplied ordered eigenvector certificates

Negating a complete orthonormal eigenbasis preserves its decreasing eigenvalue
list. At a separated reference value, the existing exact sign identity also
turns any corresponding unit eigenvector into a complete certificate.
-/

noncomputable section

namespace NumStability.HDP.Graph.SpectralClustering

/-- A complete second-slot certificate survives simultaneous negation of its
orthonormal eigenbasis, without requiring eigenvalue separation. -/
theorem IsSecondOrderedEigenvector.neg {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} {hn : 1 < n}
    {v : EuclideanSpace ℝ (Fin n)}
    (hv : IsSecondOrderedEigenvector A hn v) :
    IsSecondOrderedEigenvector A hn (-v) := by
  obtain ⟨eigenvalue, eigenbasis, hmono, heigen, rfl⟩ := hv
  refine ⟨eigenvalue, eigenbasis.map (LinearIsometryEquiv.neg ℝ), hmono, ?_, rfl⟩
  intro i
  simpa only [OrthonormalBasis.map_apply, LinearIsometryEquiv.coe_neg,
    map_neg, smul_neg] using congrArg Neg.neg (heigen i)

/-- At a separated second ordered value, every corresponding unit vector
admits a complete decreasing eigendecomposition certificate. -/
theorem isSecondOrderedEigenvector_of_unit_eigenvector_of_gap
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian)
    (hn : 1 < n) (δ : ℝ) (hδ : 0 < δ)
    (hgap : ∀ j : Fin n, j ≠ ⟨1, hn⟩ →
      δ ≤ |NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ -
        NumStability.hermitianOrderedEigenvalue hA j|)
    (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1)
    (heigen : A.toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ • v) :
    IsSecondOrderedEigenvector A hn v := by
  obtain ⟨θ, hθ, hreference⟩ :=
    NumStability.HDP.Matrix.exists_sign_eq_orderedEigenvector_of_unit_eigenvector
      A hA ⟨1, hn⟩ δ hδ hgap v hv heigen
  rcases hθ with rfl | rfl
  · simpa only [secondEigenvector_eq_orderedEigenbasis, hreference,
      neg_one_smul, neg_neg] using
      (secondEigenvector_completeOrderedCertificate A hA hn).neg
  · simpa only [secondEigenvector_eq_orderedEigenbasis, hreference, one_smul] using
      secondEigenvector_completeOrderedCertificate A hA hn

/-- Under reference separation, the complete certificate and the ordinary
unit-vector/canonical-eigenvalue specification have identical applicability. -/
theorem isSecondOrderedEigenvector_iff_unit_eigenvector_of_gap
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian)
    (hn : 1 < n) (δ : ℝ) (hδ : 0 < δ)
    (hgap : ∀ j : Fin n, j ≠ ⟨1, hn⟩ →
      δ ≤ |NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ -
        NumStability.hermitianOrderedEigenvalue hA j|)
    (v : EuclideanSpace ℝ (Fin n)) :
    IsSecondOrderedEigenvector A hn v ↔
      ‖v‖ = 1 ∧ A.toEuclideanLin v =
        NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ • v := by
  constructor
  · intro hv
    exact hv.spec hA
  · rintro ⟨hv, heigen⟩
    exact isSecondOrderedEigenvector_of_unit_eigenvector_of_gap
      A hA hn δ hδ hgap v hv heigen

end NumStability.HDP.Graph.SpectralClustering

