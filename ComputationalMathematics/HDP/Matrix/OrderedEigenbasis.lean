import ComputationalMathematics.Analysis.Eigenvalues.CourantFischer

/-!
# Uniqueness of decreasing eigenvalue lists

A complete eigenbasis determines the characteristic polynomial, including
multiplicities. Sorting its roots identifies any decreasing eigenvalue list
with the canonical ordered list, even when eigenvalues repeat.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Matrix

private theorem roots_charpoly_of_eigenbasis {n : ℕ}
    (T : EuclideanSpace ℝ (Fin n) →ₗ[ℝ] EuclideanSpace ℝ (Fin n))
    (b : Module.Basis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))) (eigenvalue : Fin n → ℝ)
    (heigen : ∀ i, T (b i) = eigenvalue i • b i) :
    T.charpoly.roots = Finset.univ.val.map eigenvalue := by
  have hmatrix : LinearMap.toMatrix b b T = _root_.Matrix.diagonal eigenvalue := by
    ext i j
    rw [LinearMap.toMatrix_apply, heigen, map_smul, Module.Basis.repr_self]
    by_cases hij : i = j
    · subst j
      simp
    · simp [hij]
  rw [← T.charpoly_toMatrix b, hmatrix, _root_.Matrix.charpoly_diagonal,
    Polynomial.roots_prod]
  · simp
  · simp [Finset.prod_ne_zero_iff, Polynomial.X_sub_C_ne_zero]

private theorem sort_eigenvalues_of_antitone {n : ℕ} (eigenvalue : Fin n → ℝ)
    (hmono : Antitone eigenvalue) :
    (Finset.univ.val.map eigenvalue).sort (· ≥ ·) = List.ofFn eigenvalue := by
  rw [Fin.univ_val_map, Multiset.coe_sort]
  apply List.mergeSort_of_pairwise
  simpa only [decide_eq_true_eq, ← List.sortedGE_iff_pairwise] using hmono.sortedGE_ofFn

/-- Every complete orthonormal eigenbasis whose eigenvalue list decreases
has the canonical ordered eigenvalues, with multiplicities retained. -/
theorem antitone_eigenvalue_eq_ordered_of_eigenbasis {n : ℕ}
    {A : _root_.Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian)
    (eigenvalue : Fin n → ℝ)
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hmono : Antitone eigenvalue)
    (heigen : ∀ i, A.toEuclideanLin (b i) = eigenvalue i • b i) :
    eigenvalue = NumStability.hermitianOrderedEigenvalue hA := by
  have hroots := roots_charpoly_of_eigenbasis A.toEuclideanLin b.toBasis eigenvalue heigen
  have hcanonical := roots_charpoly_of_eigenbasis A.toEuclideanLin
    (NumStability.hermitianOrderedEigenbasis hA).toBasis
    (NumStability.hermitianOrderedEigenvalue hA)
    (NumStability.hermitianOrderedEigenbasis_apply hA)
  apply List.ofFn_inj.mp
  rw [← sort_eigenvalues_of_antitone eigenvalue hmono,
    ← sort_eigenvalues_of_antitone _ (NumStability.hermitianOrderedEigenvalue_antitone hA),
    ← hroots, ← hcanonical]

/-- A coordinate-form Gram eigenvector equation for a complete orthonormal
basis, together with descending order, identifies the actual ordered
eigenvalue list including multiplicities. -/
theorem antitone_eigenvalue_eq_ordered_of_coordinate_eigenbasis {n : ℕ}
    {A : _root_.Matrix (Fin n) (Fin n) ℝ} (hA : A.IsHermitian)
    (eigenvalue : Fin n → ℝ)
    (b : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hmono : Antitone eigenvalue)
    (heigen : ∀ p i, (∑ l : Fin n, A i l * b p l) = eigenvalue p * b p i) :
    eigenvalue = NumStability.hermitianOrderedEigenvalue hA := by
  apply antitone_eigenvalue_eq_ordered_of_eigenbasis hA eigenvalue b hmono
  intro p
  apply PiLp.ext
  intro i
  simpa only [_root_.Matrix.toLpLin_apply, _root_.Matrix.mulVec, dotProduct,
    PiLp.smul_apply, smul_eq_mul] using heigen p i

end NumStability.HDP.Matrix
