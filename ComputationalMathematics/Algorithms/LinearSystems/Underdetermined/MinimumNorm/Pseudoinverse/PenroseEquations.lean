import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.UnderdeterminedSpec

/-!
# The four Penrose equations

This interface identifies the existing Moore--Penrose certificate with its four
literal matrix equations, without introducing another pseudoinverse predicate.
-/

namespace NumStability

/-- The Moore--Penrose certificate is precisely reproduction of both matrices
and symmetry of the two matrix products. -/
theorem rectMoorePenrosePseudoinverse_iff_penrose_equations {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (B : Matrix (Fin n) (Fin m) ℝ) :
    RectMoorePenrosePseudoinverse m n A B ↔
      (A * B) * A = A ∧ (B * A) * B = B ∧
        (A * B).transpose = A * B ∧ (B * A).transpose = B * A := by
  constructor
  · intro h
    refine ⟨h.reproduces_matrix, h.reproduces_pseudoinverse, ?_, ?_⟩
    · ext i j
      exact h.range_projection_symmetric j i
    · ext i j
      exact h.domain_projection_symmetric j i
  · rintro ⟨hA, hB, hAB, hBA⟩
    refine ⟨hA, hB, ?_, ?_⟩
    · intro i j
      exact (congrFun (congrFun hAB i) j).symm
    · intro i j
      exact (congrFun (congrFun hBA i) j).symm

end NumStability
