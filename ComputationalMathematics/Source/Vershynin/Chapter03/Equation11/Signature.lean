import ComputationalMathematics.HDP.Vector.GaussianNormConcentration

/-! Frozen proof-free signature for Equation (3.11). -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_11__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧ ∀ {n : ℕ}, 0 < n →
    (NumStability.standardGaussianVectorMeasure n).real
        {x | NumStability.vecNorm2 x < Real.sqrt n / 2} ≤
      2 * Real.exp (-(c * n))

end NumStability.HDP.Contract
