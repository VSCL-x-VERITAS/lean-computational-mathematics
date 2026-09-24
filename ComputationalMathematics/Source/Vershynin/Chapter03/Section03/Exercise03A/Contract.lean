import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise03A.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Exercise 3.3.3(a): Gaussian law of a fixed linear functional. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

/-- If `X` is a standard Gaussian vector, then its inner product with a fixed
vector `u` is centered Gaussian with variance `‖u‖²`. -/
theorem hdp_03_ex_3_3_3a : hdp_03_ex_3_3_3a__contract_type := by
  intro n Omega _ mu _ X u hX
  rcases NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mp hX with
    ⟨hIndep, hLaw⟩
  have h :=
    NumStability.HDP.Scalar.SubGaussian.independentGaussianWeightedSumLaw
      (fun i => u i) hLaw hIndep
  convert h using 1
  · ext omega
    apply Finset.sum_congr rfl
    intro i _
    exact mul_comm _ _
  · congr 1
    apply NNReal.eq
    simp only [NNReal.coe_mk, NNReal.coe_sum, mul_one]
    rw [EuclideanSpace.norm_sq_eq]
    simp [Real.toNNReal_of_nonneg (sq_nonneg _), Real.norm_eq_abs, sq_abs]

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_3a__contract : hdp_03_ex_3_3_3a__contract_type :=
  hdp_03_ex_3_3_3a

end NumStability.HDP.Contract
