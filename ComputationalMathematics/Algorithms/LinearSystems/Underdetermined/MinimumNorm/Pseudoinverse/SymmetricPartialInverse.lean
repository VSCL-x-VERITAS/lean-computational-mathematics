import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.CompactSVD
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.PenroseEquations
import ComputationalMathematics.Analysis.SingularValues.SymmetricPartialInverse

/-!
# Construction of symmetric partial inverses

This thin wrapper combines the existing arbitrary-rank compact-SVD constructor
with the source-free Penrose algebra in Analysis. The constructor is unchanged;
in particular, no invertibility or positive-dimension assumption is introduced.
-/

namespace NumStability

/-- The existing arbitrary-rank pseudoinverse supplies the symmetric partial
inverse and complementary projections of any real symmetric matrix. -/
theorem symmetricPartialInverseData_rectMoorePenrose {n : ℕ}
    (S : Matrix (Fin n) (Fin n) ℝ) (hS : S.transpose = S) :
    let T : Matrix (Fin n) (Fin n) ℝ := Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse S
    SymmetricPartialInverseData S T (S * T) (1 - S * T) := by
  obtain ⟨hSTS, hTST, hST, hTS⟩ :=
    (rectMoorePenrosePseudoinverse_iff_penrose_equations _ _).mp
      (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse_certificate S)
  exact symmetricPartialInverseData_of_penrose _ _ hS hSTS hTST hST hTS

/-- Existence includes singular and zero matrices, and also empty index types. -/
theorem exists_symmetricPartialInverseData {n : ℕ}
    (S : Matrix (Fin n) (Fin n) ℝ) (hS : S.transpose = S) :
    ∃ T P Q : Matrix (Fin n) (Fin n) ℝ, SymmetricPartialInverseData S T P Q := by
  exact ⟨_, _, _, symmetricPartialInverseData_rectMoorePenrose S hS⟩

/-- A positive-semidefinite matrix has the same partial-inverse data, without a
positive-definiteness or rank hypothesis. -/
theorem exists_symmetricPartialInverseData_of_posSemidef {n : ℕ}
    (S : Matrix (Fin n) (Fin n) ℝ) (hS : S.PosSemidef) :
    ∃ T P Q : Matrix (Fin n) (Fin n) ℝ, SymmetricPartialInverseData S T P Q := by
  apply exists_symmetricPartialInverseData S
  simpa only [Matrix.conjTranspose_eq_transpose_of_trivial] using hS.isHermitian.eq

end NumStability
