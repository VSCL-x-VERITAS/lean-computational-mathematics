import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Probability.Independence.Basic
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Theorem 2.6.2. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

def hdp_02_hthm_h2_d6_d2__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ},
      (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      iIndepFun X μ →
      ∀ {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, X i ω| ≥ t} ≤
          2 * Real.exp
            (-(c * t ^ 2 /
              ∑ i,
                (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                  (X i)).toReal ^ 2))

end NumStability.HDP.Contract
