import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeadingSubspaceLeverage
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.BasisGeometry

/-! # Leading-subspace leverage distribution proof -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

open scoped BigOperators

theorem leadingSubspaceLeverageDistribution :
    Targets.leadingSubspaceLeverageDistribution := by
  intro m n A _hm _hn k hkpos hk s u v hsvd W hW hspan
  let U := leadingLeftSingularColumns u hk
  have hU : HasOrthonormalColumns U :=
    hsvd.hasOrthonormalColumns_leadingLeftSingularColumns hk
  have hden := rowSqNormProbDen_eq_nat_of_orthonormal_columns W hW
  have hdenpos := rowSqNormProbDen_pos_of_orthonormal_columns W hW hkpos
  have hratio (i : Fin m) :
      leverageScoreProb W i = (∑ j : Fin k, W i j ^ 2) / (k : ℝ) := by
    unfold leverageScoreProb rowSqNormProb rowNormSq
    rw [hden]
  refine ⟨hden, rowSqNormProb_nonneg W hdenpos, ?_, hratio, ?_⟩
  · change (∑ i : Fin m, rowNormSq W i / rowSqNormProbDen W) = 1
    rw [← Finset.sum_div]
    have hsum : (∑ i : Fin m, rowNormSq W i) = rowSqNormProbDen W := rfl
    rw [hsum, div_self hdenpos.ne']
  · intro i
    rw [hratio]
    have hP : W * W.transpose = leadingLeftSingularProjector u hk :=
      orthonormal_projector_eq_of_range_eq W U hW hU hspan
    have hii := congrFun (congrFun hP i) i
    simpa only [Matrix.mul_apply, Matrix.transpose_apply, ← pow_two] using
      congrArg (fun x : ℝ => x / (k : ℝ)) hii

end NumStability.Source.DrineasMahoney.RandNLA2016
