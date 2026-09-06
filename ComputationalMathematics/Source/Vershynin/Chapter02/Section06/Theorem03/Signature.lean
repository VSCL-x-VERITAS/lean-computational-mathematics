import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Probability.Independence.Basic
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Theorem 2.6.3. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

def hdp_02_hthm_h2_d6_d3__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      {X : ι → Ω → ℝ},
      (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      iIndepFun X μ →
      ∀ (a : ι → ℝ) {t : ℝ}, 0 ≤ t →
        μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
          2 * Real.exp
            (-(c * t ^ 2 /
              ((NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 *
                ∑ i, a i ^ 2)))

end NumStability.HDP.Contract
