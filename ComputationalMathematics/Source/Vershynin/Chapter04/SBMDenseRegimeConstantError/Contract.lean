import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem456.Contract

/-!
# Vershynin Chapter 4, dense stochastic-block regime
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-- The dense-regime consequence following Theorem 4.5.6.  If both `q` and
`p - q` are bounded below by a positive constant `c₀`, the theorem's
misclassification budget is at most `C / c₀²`, independently of the number
of vertices. -/
theorem hdp_04_sbm_dense_regime_constant_error :
    ∃ C : ℝ, 0 < C ∧
      ∀ {k : ℕ} (hk : 0 < k)
        (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
        (c₀ : ℝ),
        0 < c₀ →
        c₀ ≤ (θ.q : ℝ) →
        c₀ ≤ (θ.p : ℝ) - θ.q →
        let n := 2 * k
        let community := BalancedFinSBM.community k
        let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
        let A : (NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool) →
            Matrix (Fin n) (Fin n) ℝ :=
          NumStability.HDP.Graph.FinStochasticBlock.adjacency
        let hA : ∀ ω, (A ω).IsHermitian :=
          NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian
        P.real {ω | ¬ sbmSpectralClusteringSucceeds community
          (Real.sqrt n •
            NumStability.HDP.Graph.SpectralClustering.secondEigenvector
              (A ω) (hA ω) (by omega : 2 ≤ n))
          (C / c₀ ^ 2)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, htheorem⟩ := hdp_04_theorem_4_5_6
  refine ⟨C, hC, ?_⟩
  intro k hk θ c₀ hc₀ hcq hcpq
  have hq : 0 < (θ.q : ℝ) := hc₀.trans_le hcq
  have hpq : (θ.q : ℝ) < θ.p := by linarith
  have hbase := (htheorem hk θ hq hpq).2.2.2
  dsimp only at hbase ⊢
  have hmin : c₀ ≤ min (θ.q : ℝ) ((θ.p : ℝ) - θ.q) :=
    le_min hcq hcpq
  have hminpos : 0 < min (θ.q : ℝ) ((θ.p : ℝ) - θ.q) :=
    hc₀.trans_le hmin
  have hthreshold :
      C / (min (θ.q : ℝ) ((θ.p : ℝ) - θ.q)) ^ 2 ≤ C / c₀ ^ 2 := by
    rw [div_le_div_iff₀ (sq_pos_of_pos hminpos) (sq_pos_of_pos hc₀)]
    apply mul_le_mul_of_nonneg_left ?_ hC.le
    nlinarith [sq_nonneg
      (min (θ.q : ℝ) ((θ.p : ℝ) - θ.q) - c₀)]
  apply (measureReal_mono ?_ (measure_ne_top _ _)).trans hbase
  intro ω hlarge hsmall
  apply hlarge
  rcases hsmall with hsmall | hsmall
  · exact Or.inl (hsmall.trans hthreshold)
  · exact Or.inr (hsmall.trans hthreshold)

end NumStability.HDP.Contract
