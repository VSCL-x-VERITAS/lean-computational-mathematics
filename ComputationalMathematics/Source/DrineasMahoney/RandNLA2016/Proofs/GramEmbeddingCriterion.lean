import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.GramEmbeddingCriterion
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.GramCriterion

/-! # Gram residual criterion for subspace embeddings -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem gramEmbeddingCriterion : Targets.gramEmbeddingCriterion := by
  intro m d t U B hU ε hε _
  have heq : rowGram U = idMatrix d := rowGram_eq_id_of_orthonormal_columns U hU
  have hiff : opNorm2 (fun i j => idMatrix d i j - rowSketchGram B i j) ≤ ε ↔
      ∀ x : Fin d → ℝ,
        |vecNorm2Sq (B.mulVec x) - vecNorm2Sq x| ≤ ε * vecNorm2Sq x := by
    rw [opNorm2_sub_rev (idMatrix d) (rowSketchGram B)]
    exact gram_opNorm2_le_iff_squared_norm B hε.le
  refine ⟨by rw [heq], hiff, ?_⟩
  rw [hiff]
  constructor
  · intro h x
    have hb := abs_le.mp (h x)
    constructor <;> nlinarith [hb.1, hb.2]
  · intro h x
    have hb := h x
    apply abs_le.mpr
    constructor <;> nlinarith [hb.1, hb.2]

end NumStability.Source.DrineasMahoney.RandNLA2016
