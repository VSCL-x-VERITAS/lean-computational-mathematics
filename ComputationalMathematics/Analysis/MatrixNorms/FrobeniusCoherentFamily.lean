import ComputationalMathematics.Analysis.MatrixNorms.CoherentFamily
import ComputationalMathematics.Analysis.MatrixNorms.FrobeniusFamily

/-! # The Frobenius coherent unitarily invariant norm family

This concrete instance satisfies the bare norm and isometric-coherence fields;
the rectangular product bounds are obtained through the derived family API.
-/
namespace NumStability

/-- The Frobenius norms form a coherent unitarily invariant family under
rectangular isometric embeddings. -/
noncomputable def complexFrobeniusUnitaryInvariantNormFamily :
    ComplexMatrixUnitaryInvariantNormFamily where
  fixed := complexFrobeniusFixedUnitaryInvariantNorm
  left_isometry := by
    intro m n p E A hE
    exact complexMatrixFrobenius_left_isometry E A hE
  right_isometry := by
    intro m n p A E hE
    exact complexMatrixFrobenius_right_isometry A E hE

@[simp] theorem complexFrobeniusUnitaryInvariantNormFamily_norm {m n : ℕ}
    (A : CMatrix m n) :
    complexFrobeniusUnitaryInvariantNormFamily.ideal.norm A = complexMatrixFrobenius A := rfl

@[simp] theorem complexFrobeniusUnitaryInvariantNormFamily_realNorm {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    complexFrobeniusUnitaryInvariantNormFamily.realNorm A = frobNormRect A := by
  exact (frobNormRect_eq_complexMatrixFrobenius_realRectToCMatrix A).symm

instance : Nonempty ComplexMatrixUnitaryInvariantNormFamily :=
  ⟨complexFrobeniusUnitaryInvariantNormFamily⟩

end NumStability
