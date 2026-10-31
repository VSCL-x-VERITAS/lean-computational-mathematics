import ComputationalMathematics.HDP.Graph.SpectralClustering
import ComputationalMathematics.HDP.Matrix.OrderedEigenbasis

/-!
# Unit eigenvector specifications for complete ordered certificates

Every vector certified in the second slot of a complete decreasing eigenbasis
is a unit vector at the canonical second eigenvalue, including repeated values.
-/

noncomputable section

namespace NumStability.HDP.Graph.SpectralClustering

/-- The complete ordered certificate supplies the unit-vector and canonical
second-eigenvalue equations for any certified vector. -/
theorem IsSecondOrderedEigenvector.spec {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian) {hn : 1 < n}
    {v : EuclideanSpace ℝ (Fin n)} (hv : IsSecondOrderedEigenvector A hn v) :
    ‖v‖ = 1 ∧ A.toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ • v := by
  obtain ⟨eigenvalue, eigenbasis, hmono, heigen, rfl⟩ := hv
  have hvalues := NumStability.HDP.Matrix.antitone_eigenvalue_eq_ordered_of_eigenbasis
    hA eigenvalue eigenbasis hmono heigen
  refine ⟨eigenbasis.norm_eq_one ⟨1, hn⟩, ?_⟩
  simpa only [hvalues] using heigen ⟨1, hn⟩

end NumStability.HDP.Graph.SpectralClustering
