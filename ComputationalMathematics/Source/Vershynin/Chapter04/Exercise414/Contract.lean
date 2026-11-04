import ComputationalMathematics.Analysis.SingularValues.Isometries

/-!
# Vershynin Chapter 4, Exercise 4.1.4

Source contract for the four equivalent characterizations of a rectangular
real isometry.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.1.4: the right Gram identity, the rank-`N`
orthogonal-projection property of the left Gram matrix, Euclidean norm
preservation, and equality of every singular value to one are equivalent.
The source assumes `m ≥ N > 0`. Here `N = n + 1` remains positive, while
the equivalence also covers wide and rank-deficient matrices: the singular
value family has all `N` entries of the ordered right-Gram spectrum, with
zeros retained, including the extra zeros when `m < N`. In that wide case
all four characterizations are false. Each equivalence is exposed as its
two implications; the reusable producer retains the biconditional API. -/
theorem hdp_04_exercise_4_1_4 {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    let gramIdentity : Prop := A.transpose * A = 1
    let rangeProjection : Prop :=
      NumStability.IsRealOrthogonalProjectionMatrix (A * A.transpose) ∧
        (A * A.transpose).rank = n + 1
    let normIsometry : Prop := NumStability.IsRealMatrixIsometry A
    let allSingularValuesOne : Prop :=
      ∀ i : Fin (n + 1),
        NumStability.rectCourantFischerSingularValue A i = 1
    ((gramIdentity → rangeProjection) ∧ (rangeProjection → gramIdentity)) ∧
      ((rangeProjection → normIsometry) ∧ (normIsometry → rangeProjection)) ∧
      ((normIsometry → allSingularValuesOne) ∧ (allSingularValuesOne → normIsometry)) := by
  obtain ⟨hGramProjection, hProjectionIsometry, hIsometrySingular⟩ :=
    NumStability.realMatrix_isometry_characterizations A
  exact ⟨⟨hGramProjection.mp, hGramProjection.mpr⟩,
    ⟨hProjectionIsometry.mp, hProjectionIsometry.mpr⟩,
    ⟨hIsometrySingular.mp, hIsometrySingular.mpr⟩⟩

end NumStability.HDP.Contract
