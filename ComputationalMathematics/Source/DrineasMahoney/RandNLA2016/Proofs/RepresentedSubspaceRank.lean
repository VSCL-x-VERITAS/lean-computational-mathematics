import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.RepresentedSubspaceRank
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.BasisGeometry

/-! # Preservation of represented-subspace rank under Eq. (7) -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem representedSubspaceRank : Targets.representedSubspaceRank := by
  intro m d t U T hU ε _hεpos hε hgram
  have hrev := opNorm2Le_sub_rev (idMatrix d) (rowSketchGram (T * U)) hgram
  have hinj := subspace_injective_of_gram_error U T hU hε hrev
  have hUrank : U.rank = d := by
    have hle := Matrix.rank_mul_le_right U.transpose U
    rw [hasOrthonormalColumns_transpose_mul U hU, Matrix.rank_one,
      Fintype.card_fin] at hle
    exact le_antisymm (Matrix.rank_le_width U) hle
  refine ⟨(matrix_rank_mul_eq_of_injective_on_range U T hinj).trans hUrank, hinj, ?_⟩
  intro n A hspan
  exact matrix_rank_preserved_of_gram_error A U T hU hspan hε hrev

end NumStability.Source.DrineasMahoney.RandNLA2016
