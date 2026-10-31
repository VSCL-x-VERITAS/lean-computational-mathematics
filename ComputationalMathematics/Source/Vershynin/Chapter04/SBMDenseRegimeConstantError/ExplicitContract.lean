import ComputationalMathematics.HDP.Graph.FinStochasticBlockLaws
import ComputationalMathematics.HDP.Graph.SpectralClusteringCoordinates
import ComputationalMathematics.Source.Vershynin.Chapter04.SBMDenseRegimeConstantError.Contract

/-!
# Dense stochastic-block bound with explicit law and coordinate certificates

This separately named result combines the original dense-regime conclusion with
finite configuration laws for its actual loopless measure and coordinate
identities for its actual selected second eigenvector. It retains the original
balanced indexing, choice of vector and quantitative bound.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators NNReal ENNReal

namespace NumStability.HDP.Contract

/-- The dense-regime bound together with the exact probability law and a
complete ordered coordinate eigendecomposition of every sampled adjacency
matrix. The constant is uniform in the size, probabilities and positive lower
bound `c₀`; the probability and spectral identities are conclusions. -/
theorem hdp_04_sbm_dense_regime_constant_error_explicit :
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
        let hn : 1 < n := by omega
        P Set.univ = 1 ∧
          (∀ (S : Finset (NumStability.HDP.Graph.FinStochasticBlock.UpperPair n))
            (v : NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool),
            P {x | ∀ e ∈ S, x e = v e} =
              ∏ e ∈ S, if v e then
                (NumStability.HDP.Graph.FinStochasticBlock.upperProbability community θ e : ℝ≥0∞)
              else ((1 - NumStability.HDP.Graph.FinStochasticBlock.upperProbability
                community θ e : ℝ≥0) : ℝ≥0∞)) ∧
          (∀ i : Fin n, P {x | x ⟨(i, i), le_rfl⟩ = true} = 0) ∧
          (∀ ω, ∃ (eigenvalue : Fin n → ℝ) (b : Fin n → Fin n → ℝ),
            (∀ i j, i.val ≤ j.val → eigenvalue j ≤ eigenvalue i) ∧
            (∀ i j, (∑ l, b i l * b j l) = if i = j then 1 else 0) ∧
            (∀ x : Fin n → ℝ, ∀ j, (∑ i, (∑ l, b i l * x l) * b i j) = x j) ∧
            (∀ i j, (∑ l, A ω j l * b i l) = eigenvalue i * b i j) ∧
            (∀ j, NumStability.HDP.Graph.SpectralClustering.secondEigenvector
              (A ω) (hA ω) hn j = b ⟨1, hn⟩ j)) ∧
          P.real {ω | ¬ sbmSpectralClusteringSucceeds community
            (Real.sqrt n •
              NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                (A ω) (hA ω) (by omega : 2 ≤ n))
            (C / c₀ ^ 2)} ≤
              4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, hbound⟩ := hdp_04_sbm_dense_regime_constant_error
  refine ⟨C, hC, ?_⟩
  intro k hk θ c₀ hc₀ hcq hcpq
  refine ⟨NumStability.HDP.Graph.FinStochasticBlock.measure_univ_eq_one _ _,
    NumStability.HDP.Graph.FinStochasticBlock.measure_finite_configuration _ _,
    NumStability.HDP.Graph.FinStochasticBlock.measure_true_diagonal_eq_zero _ _,
    ?_, hbound hk θ c₀ hc₀ hcq hcpq⟩
  intro ω
  exact NumStability.HDP.Graph.SpectralClustering.secondEigenvector_coordinateOrderedCertificate
    _ _ _

end NumStability.HDP.Contract
