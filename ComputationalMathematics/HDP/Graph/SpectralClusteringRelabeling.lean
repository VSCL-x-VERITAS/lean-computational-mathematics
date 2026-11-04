import ComputationalMathematics.HDP.Graph.SpectralClustering
import Mathlib.Analysis.Normed.Lp.PiLp

/-!
# Relabeling complete ordered spectral certificates

A vertex-coordinate permutation is a linear isometry. Mapping a complete
orthonormal eigenbasis through it retains the same decreasing eigenvalue list
and second-slot vector, including all choices in repeated eigenspaces. The
inverse permutation reflects the certificate. No chosen-basis equality or
empirical eigengap is required.
-/

noncomputable section

namespace NumStability.HDP.Graph.SpectralClustering

private theorem action_reindex {n : ℕ} (e : Equiv.Perm (Fin n))
    (A : Matrix (Fin n) (Fin n) ℝ) (v : EuclideanSpace ℝ (Fin n)) :
    (Matrix.reindex e e A).toEuclideanLin
        ((LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e) v) =
      (LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e) (A.toEuclideanLin v) := by
  ext i
  change Matrix.mulVec (A.submatrix e.symm e.symm) (fun j => v (e.symm j)) i =
    Matrix.mulVec A (fun j => v j) (e.symm i)
  rw [Matrix.submatrix_mulVec_equiv]
  simp only [Function.comp_def, Equiv.apply_symm_apply]

private theorem transport_forward {n : ℕ} (hn : 1 < n) (e : Equiv.Perm (Fin n))
    (A : Matrix (Fin n) (Fin n) ℝ) (v : EuclideanSpace ℝ (Fin n))
    (h : IsSecondOrderedEigenvector A hn v) :
    IsSecondOrderedEigenvector (Matrix.reindex e e A) hn
      ((LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e) v) := by
  obtain ⟨eigenvalue, b, heigenvalue, hb, hv⟩ := h
  let L := LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e
  refine ⟨eigenvalue, b.map L, heigenvalue, ?_, ?_⟩
  · intro i
    simp only [OrthonormalBasis.map_apply]
    rw [action_reindex, hb i, map_smul]
  · simpa only [OrthonormalBasis.map_apply] using congrArg L hv

/-- Vertex-coordinate permutations preserve and reflect complete second-slot
certificates, including every choice within a repeated eigenspace. -/
theorem isSecondOrderedEigenvector_reindex_iff {n : ℕ} (hn : 1 < n)
    (e : Equiv.Perm (Fin n)) (A : Matrix (Fin n) (Fin n) ℝ)
    (v : EuclideanSpace ℝ (Fin n)) :
    IsSecondOrderedEigenvector A hn v ↔
      IsSecondOrderedEigenvector (Matrix.reindex e e A) hn
        ((LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e) v) := by
  constructor
  · exact transport_forward hn e A v
  · intro h
    have hback := transport_forward hn e.symm _ _ h
    have hA : Matrix.reindex e.symm e.symm (Matrix.reindex e e A) = A := by
      ext i j
      simp [Matrix.reindex_apply, Matrix.submatrix_apply]
    have hv := (LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e).symm_apply_apply v
    rw [LinearIsometryEquiv.piLpCongrLeft_symm] at hv
    simpa only [hA, hv] using hback

end NumStability.HDP.Graph.SpectralClustering
