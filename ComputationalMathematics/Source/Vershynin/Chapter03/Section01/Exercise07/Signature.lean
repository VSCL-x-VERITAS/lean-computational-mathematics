import ComputationalMathematics.Analysis.MatrixAlgebra
import Mathlib.Probability.Moments.Variance

/-! Frozen contract signature for Exercise 3.1.7. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d1_d7__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ {n : ℕ} [Nonempty (Fin n)]
      {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ),
      (∀ i, Measurable (X i)) →
        iIndepFun X μ →
          (∀ i, Measure.map (X i) μ ≤ (volume : Measure ℝ)) →
            ∀ ε : ℝ, 0 < ε →
              μ.real {ω |
                  NumStability.vecNorm2 (fun i => X i ω) ≤
                    ε * Real.sqrt (n : ℝ)} ≤
                (C * ε) ^ n

end NumStability.HDP.Contract
