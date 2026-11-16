import ComputationalMathematics.Analysis.MatrixSpectral

/-! # Symmetric operator bounds from two quadratic-form inequalities -/
namespace NumStability
open scoped BigOperators

/-- For a real symmetric matrix, upper bounds for both signs give the sharp
operator bound with the same radius. -/
theorem finiteOpNorm2Le_of_symmetric_two_sided_loewner {n : ℕ}
    (M : Fin n → Fin n → ℝ) (hM : IsSymmetricFiniteMatrix M) {c : ℝ}
    (hc : 0 ≤ c)
    (hupper : finiteLoewnerLe M (fun i j => c * finiteIdMatrix i j))
    (hlower : finiteLoewnerLe (fun i j => -M i j) (fun i j => c * finiteIdMatrix i j)) :
    finiteOpNorm2Le M c := by
  let hherm := IsSymmetricFiniteMatrix.to_matrix_isHermitian M hM
  let Q : Fin n → Fin n → ℝ := fun i j => hherm.eigenvectorBasis j i
  let d : Fin n → ℝ := finiteHermitianEigenvalues M hM
  have hQ : IsOrthogonal n Q := by
    apply IsOrthogonal.of_col_orthonormal
    intro j k
    have h := (orthonormal_iff_ite.mp hherm.eigenvectorBasis.orthonormal) j k
    simpa [Q, EuclideanSpace.inner_eq_star_dotProduct, dotProduct, mul_comm] using h
  have heig : ∀ j, finiteMatVec M (fun i => Q i j) = fun i => d j * Q i j := by
    intro j
    exact finiteMatVec_finiteHermitianEigenvector_eq M hM j
  have hdecomp := finiteMatrix_eq_orthogonal_diagonalization_of_eigenvector_columns hQ heig
  apply finiteOpNorm2Le_of_isOrthogonal_diagonalization hdecomp hQ hc
  intro a
  have hu := finiteHermitianEigenvalues_le_of_finiteLoewnerLe_smul_id M hM hupper a
  let v : Fin n → ℝ := ⇑(hherm.eigenvectorBasis a)
  have hl := hlower v
  have heq := finiteQuadraticForm_finiteHermitianEigenvector_eq_eigenvalue_mul_norm_sq M hM a
  have hn := finiteVecNorm2Sq_finiteHermitianEigenvector_eq_one M hM a
  change finiteQuadraticForm (fun i j => -M i j) v ≤ _ at hl
  rw [finiteQuadraticForm_neg, finiteQuadraticForm_smul_finiteIdMatrix,
    heq, hn] at hl
  apply abs_le.mpr
  constructor <;> dsimp [d] <;> linarith

/-- Source-facing spectral norm form of the same sharp equivalence. -/
theorem opNorm2_le_of_symmetric_two_sided_loewner {n : ℕ}
    (M : Fin n → Fin n → ℝ) (hM : IsSymmetricFiniteMatrix M) {c : ℝ}
    (hc : 0 ≤ c)
    (hupper : finiteLoewnerLe M (fun i j => c * finiteIdMatrix i j))
    (hlower : finiteLoewnerLe (fun i j => -M i j) (fun i j => c * finiteIdMatrix i j)) :
    opNorm2 M ≤ c :=
  opNorm2_le_of_finiteOpNorm2Le M hc
    (finiteOpNorm2Le_of_symmetric_two_sided_loewner M hM hc hupper hlower)
end NumStability
