import ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Definition06.Signature

/-! Stable Chapter 2 contract module for Definition 2.5.6.

The semantic module owns the value-level forwarding declaration; this module
checks it against a proof-free proposition for source and cross-unit audits.
-/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
theorem hdp_02_hdef_h2_d5_d6__contract :
    hdp_02_hdef_h2_d5_d6__contract_type := by
  intro Ω instΩ μ instμ X hX
  exact hdp_02_hdef_h2_d5_d6 hX

end NumStability.HDP.Contract
