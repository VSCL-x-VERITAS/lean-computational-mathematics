import ComputationalMathematics.HDP.Vector.CoordinateDistributionSubGaussian

/-! Frozen proof-free signature for Exercise 3.4.4. -/

noncomputable section

open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_4__contract_type : Prop :=
  ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
    ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ENNReal.ofReal (c * Real.sqrt ((n : ℝ) / Real.log n)) ≤
          NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
            (NumStability.HDP.Vector.CoordinateDistribution.coordinateDistributionMeasure n)
            (NumStability.HDP.Vector.CoordinateDistribution.coordinateRandomVector n) ∧
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
            (NumStability.HDP.Vector.CoordinateDistribution.coordinateDistributionMeasure n)
            (NumStability.HDP.Vector.CoordinateDistribution.coordinateRandomVector n) ≤
          ENNReal.ofReal (C * Real.sqrt ((n : ℝ) / Real.log n))

end NumStability.HDP.Contract
