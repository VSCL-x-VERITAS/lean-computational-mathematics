import ComputationalMathematics.HDP.Optimization.GrothendieckTruncation

/-! Frozen proof-free signature for display (3.16). -/

noncomputable section

open MeasureTheory
open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_16__contract_type : Prop :=
  ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) (m n : ℕ)
    (A : Matrix (Fin m) (Fin n) ℝ)
    (U : Fin m → Lp ℝ 2 μ) (V : Fin n → Lp ℝ 2 μ),
    (∫ ω, ∑ i, ∑ j, A i j * U i ω * V j ω ∂μ) =
      ∑ i, ∑ j, A i j * ⟪U i, V j⟫_ℝ

end NumStability.HDP.Contract
