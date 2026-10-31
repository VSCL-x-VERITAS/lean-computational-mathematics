import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SignalNormChildren
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417WitnessProof
import ComputationalMathematics.HDP.Matrix.ReindexSpectral
import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Signal norm discrepancy and absence of a uniform lower constant

These source-model results support the separately specified analyst-derived
children of the printed stochastic-block claims.
-/

noncomputable section

set_option maxHeartbeats 1000000
set_option backward.isDefEq.respectTransparency false

open Matrix MeasureTheory
open NumStability.HDP.Graph
open scoped Matrix.Norms.L2Operator

namespace NumStability.HDP.Contract.DiscrepancyChildren

private theorem no_uniform_norm_lower : ∀ c : ℝ, 0 < c → ∀ K : ℕ,
    ∃ k : ℕ, K ≤ k ∧ 2 ≤ k ∧ ∃ θ : StochasticBlock.Parameters,
      θ.q < θ.p ∧
      ‖FinStochasticBlock.expectedAdjacency (BalancedFinSBM.community k) θ.p θ.q‖ <
        c * ((2*k : ℕ) : ℝ) := by
  intro c hc K
  let k := max K 2
  let p : ℝ := min c 1 / 2
  have hp : 0 < p := half_pos (lt_min hc zero_lt_one)
  have hp1 : p ≤ 1 := by dsimp [p]; linarith [min_le_right c 1]
  have hpc : p < c := by dsimp [p]; linarith [min_le_left c 1]
  let θ : StochasticBlock.Parameters :=
    { p := ⟨p, hp.le⟩, q := 0, hp := hp1, hq := by norm_num }
  have hk2 : 2 ≤ k := le_max_right _ _
  have hk : 0 < k := by omega
  refine ⟨k, le_max_left _ _, hk2, θ, hp, ?_⟩
  rw [BalancedFinSBM.expectedAdjacency_eq_population, BalancedFinSBM.population,
    NumStability.HDP.Matrix.l2_opNorm_reindex]
  change ‖looplessExpectedAdjacency k p 0‖ < _
  rw [norm_looplessExpectedAdjacency hk (by norm_num) hp]
  have hkR : (0 : ℝ) < k := by exact_mod_cast hk
  push_cast
  nlinarith [mul_pos hkR (sub_pos.mpr hpc)]

/-- The two-vertex discrepancy and varying-probability obstruction to an absolute uniform linear lower bound. -/
theorem signal_norm_witness_child_proved : HDP04SBMSignalNormWitnessChildTarget := by
  refine ⟨?_, no_uniform_norm_lower⟩
  obtain ⟨θ, hp, hq, hEA, hM, hB, _, _, _⟩ := equation417_witness_child_proved
  refine ⟨θ, hp, hq, hEA, ?_, ?_, ?_, ?_⟩
  · rw [hM, norm_zero]
  · rw [hB, norm_one]
  · rw [hM, hB, norm_zero, norm_one]; norm_num
  · refine ⟨0, 1, by decide, ?_⟩
    norm_num

end NumStability.HDP.Contract.DiscrepancyChildren
