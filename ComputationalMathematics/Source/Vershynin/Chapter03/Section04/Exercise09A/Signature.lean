import ComputationalMathematics.HDP.Vector.L1BallMoments

/-! Frozen proof-free signature for Exercise 3.4.9(a). -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_9a__contract_type : Prop :=
  ∃ r : ℕ → ℝ,
    (∀ n : ℕ, 0 < n → (n : ℝ) / 2 ≤ r n ∧ r n ≤ 2 * n) ∧
    ∀ n : ℕ, 0 < n →
      NumStability.HDP.Vector.Isotropy.IsIsotropic
        (NumStability.HDP.Vector.L1Ball.uniformMeasure n (r n))
        (fun i x ↦ x i)

end NumStability.HDP.Contract
