import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Exercise11.Signature

/-! Stable Chapter 2 contract module for Exercise 2.7.11. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.SubExponential

theorem hdp_02_hex_h2_d7_d11_exact : hdp_02_hex_h2_d7_d11__contract_type := by
  intro Ω _ μ _ ψ
  exact orliczAEEqSpace_norm_axioms ψ μ

theorem hdp_02_hex_h2_d7_d11__contract : hdp_02_hex_h2_d7_d11__contract_type := by
  exact hdp_02_hex_h2_d7_d11_exact

end NumStability.HDP.Contract
