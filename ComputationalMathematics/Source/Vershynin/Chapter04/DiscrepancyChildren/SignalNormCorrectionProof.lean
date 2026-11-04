import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SignalNormChildren
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.BalancedMean
import ComputationalMathematics.HDP.Matrix.ReindexSpectral
import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Exact loopless signal norm, signs and fixed-parameter linear bounds

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

private theorem balanced_block_norm {k : ℕ} (hk : 0 < k) (θ : StochasticBlock.Parameters)
    (c : Fin (2*k) → Fin 2) (hc : ∀ b : Fin 2, Fintype.card {i // c i = b} = k)
    (hpq : θ.q < θ.p) : ‖BalancedMean.block c θ.p θ.q‖ = (k : ℝ) * ((θ.p : ℝ) + θ.q) := by
  obtain ⟨e, _, hB, _⟩ := BalancedMean.balanced_reindex c hc θ.p θ.q
  rw [hB, NumStability.HDP.Matrix.l2_opNorm_reindex]
  exact StochasticBlock.norm_expectedAdjacency hk θ.q.coe_nonneg hpq

private theorem balanced_mean_norm {k : ℕ} (hk : 0 < k) (θ : StochasticBlock.Parameters)
    (c : Fin (2*k) → Fin 2) (hc : ∀ b : Fin 2, Fintype.card {i // c i = b} = k)
    (hpq : θ.q < θ.p) :
    ‖FinStochasticBlock.expectedAdjacency c θ.p θ.q‖ =
      (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p := by
  obtain ⟨e, _, _, hM⟩ := BalancedMean.balanced_reindex c hc θ.p θ.q
  rw [hM, NumStability.HDP.Matrix.l2_opNorm_reindex]
  exact norm_looplessExpectedAdjacency hk θ.q.coe_nonneg hpq

/-- Exact mean and residual formulas, sign labels and parameter-dependent Theta bounds for every balanced labeling. -/
theorem signal_norm_correction_child_proved : HDP04SBMSignalNormCorrectionChildTarget := by
  classical
  constructor
  · intro k hk θ c hc hpq
    dsimp only
    have hn := balanced_mean_norm hk θ c hc hpq
    obtain ⟨e, he, _, _⟩ := BalancedMean.balanced_reindex c hc θ.p θ.q
    refine ⟨FinStochasticBlock.adjacency_expectation c θ, ?_, ?_,
      balanced_block_norm hk θ c hc hpq, hn, ?_, ?_, ?_, ?_⟩
    · intro ω i j; ring
    · intro i j
      rw [integral_sub Integrable.of_finite (integrable_const _),
        FinStochasticBlock.adjacency_expectation, integral_const]
      simp
    · rw [hn]
      have hkR : (0 : ℝ) < k := by exact_mod_cast hk
      push_cast
      field_simp
    · intro i
      by_cases hi : c i = 0 <;> simp [hi]
    · let a : StochasticBlock.Vertex k := (0, ⟨0,hk⟩)
      let b : StochasticBlock.Vertex k := (1, ⟨0,hk⟩)
      refine ⟨e a, e b, ?_, ?_⟩
      · simp [he, a, b]
      · simp [he, a, b]
    · intro i
      have hi : c i = 0 ∨ c i = 1 := by omega
      rcases hi with hi | hi <;> simp [hi]
  · intro θ hpq
    have hp : (0 : ℝ) < θ.p := lt_of_le_of_lt θ.q.coe_nonneg hpq
    have hq := θ.q.coe_nonneg
    refine ⟨(θ.p : ℝ)/4, (θ.p : ℝ) + θ.q, by positivity, by positivity, ?_⟩
    intro k hk c hc
    dsimp only
    rw [balanced_mean_norm (by omega) θ c hc hpq]
    have hkR : (2 : ℝ) ≤ k := by exact_mod_cast hk
    push_cast
    constructor
    · nlinarith [mul_nonneg (show (0 : ℝ) ≤ k-2 by linarith) hp.le,
        mul_nonneg (show (0 : ℝ) ≤ k by linarith) hq]
    · nlinarith [mul_nonneg (show (0 : ℝ) ≤ k by linarith) (add_nonneg hp.le hq)]

end NumStability.HDP.Contract.DiscrepancyChildren
