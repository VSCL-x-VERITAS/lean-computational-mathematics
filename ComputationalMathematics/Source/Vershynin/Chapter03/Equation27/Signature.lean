import ComputationalMathematics.HDP.Graph.ArccosBound

/-! Frozen proof-free signature for display (3.27). -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_27__contract_type : Prop :=
  ∀ t : ℝ, t ∈ Set.Icc (-1 : ℝ) 1 →
    (1 - 2 / Real.pi * Real.arcsin t = 2 / Real.pi * Real.arccos t) ∧
      (0.878 : ℝ) * (1 - t) ≤ 2 / Real.pi * Real.arccos t

end NumStability.HDP.Contract
