import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.BasisGeometry
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.BasisGeometry

/-! # Basis invariance of normalized leverage scores -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem leverageBasisInvariance : Targets.leverageBasisInvariance := by
  intro m n p U V _hn _hp hU hV hspan
  exact ⟨orthonormal_projector_eq_of_range_eq U V hU hV hspan,
    leverageScore_and_probability_eq_of_range_eq U V hU hV hspan⟩

theorem subspaceEmbeddingGeometry : Targets.subspaceEmbeddingGeometry := by
  intro m n d r A U S hU hspan ε _hεpos hε hgram
  have hrev := opNorm2Le_sub_rev (idMatrix d) (rowSketchGram (S * U)) hgram
  refine ⟨?_, ?_, matrix_rank_preserved_of_gram_error A U S hU hspan hε hrev⟩
  · intro y hy
    exact subspace_geometry_of_gram_error U S hU hrev y (hspan ▸ hy)
  · rw [hspan]
    exact subspace_injective_of_gram_error U S hU hε hrev

end NumStability.Source.DrineasMahoney.RandNLA2016
