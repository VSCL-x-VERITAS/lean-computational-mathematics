import ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Exercise11.Signature

/-! Stable source-facing wrapper for Exercise 2.5.11. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.GaussianMaxima
open NumStability.HDP.Scalar.LimitTheorems

/-- Exercise 2.5.11: the expected signed maximum of independent standard
normal variables has sharp order `sqrt (log N)`. -/
theorem hdp_02_hex_h2_d5_d11 :
    hdp_02_hex_h2_d5_d11__contract_type := by
  refine ⟨gaussianMaximumLowerConstant, gaussianMaximumLowerConstant_pos, ?_⟩
  intro Ω _ μ _ X N hN hX hLaw hIndep
  letI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
  have hInt : Integrable (prefixMaximum X N) μ := by
    rw [prefixMaximum_eq_finiteMaximum X hN]
    exact integrable_finiteMaximum (fun i =>
      integrable_of_hasLaw_standardNormal (hX i) (hLaw i))
  refine ⟨hInt, ?_⟩
  exact expectation_prefixMaximum_standardNormal_ge_sqrt_log
    hN hX hLaw hIndep

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d5_d11__contract :
    hdp_02_hex_h2_d5_d11__contract_type :=
  hdp_02_hex_h2_d5_d11

end NumStability.HDP.Contract
