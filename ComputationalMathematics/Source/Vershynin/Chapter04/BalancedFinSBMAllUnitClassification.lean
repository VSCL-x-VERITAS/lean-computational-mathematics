import ComputationalMathematics.HDP.Graph.SpectralBinaryClassification
import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import ComputationalMathematics.HDP.Graph.CertifiedEigenvectorOrientation
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-!
# All-unit classification for the specified canonical balanced model

This composition uses the existing loopless Bernoulli law and canonical equal
communities. A single event controls every certified unit second eigenvector,
including multiplicities, with a genuine exchange of the two truth labels.
It records no source-correspondence decision.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery

open NumStability.HDP.Graph

/-- The specified canonical balanced model has one classifier error event
uniform over every complete second-slot unit certificate. -/
theorem exists_all_unit_binary_classification_tail :
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters),
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let community : Fin n → Fin 2 := BalancedFinSBM.community k
      let P := FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ v : EuclideanSpace ℝ (Fin n),
          SpectralClustering.IsSecondOrderedEigenvector
            (FinStochasticBlock.adjacency ω) hn v ∧
          ∀ swapped : Bool,
            C / μ ^ 2 <
              ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                (if swapped then
                  NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                 else community)
                (Real.sqrt n • v)).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C₀, hC₀, htail⟩ :=
    exists_spectral_binary_classification_tail_of_symmetric_centered_bounded_noise
  refine ⟨4 * C₀, by positivity, ?_⟩
  intro k hn θ hq hpq
  dsimp only
  have hk : 0 < k := by omega
  let n := 2 * k
  let community := BalancedFinSBM.community k
  let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
  let D := BalancedFinSBM.population k θ.p θ.q
  let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
  let b := NumStability.hermitianOrderedEigenbasis hD ⟨1, hn⟩
  have hb : SpectralClustering.IsSecondOrderedEigenvector D hn b := by
    exact SpectralClustering.secondEigenvector_completeOrderedCertificate D hD hn
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hμ : 0 < μ := lt_min hqR (sub_pos.mpr hpqR)
  obtain ⟨ρ, hρ, hscale⟩ :=
    BalancedFinSBM.exists_population_second_eigenbasis_sign hk θ hq hpq
  have horiented : ∃ u : EuclideanSpace ℝ (Fin n),
      SpectralClustering.IsSecondOrderedEigenvector D hn u ∧
      ∀ i, (Real.sqrt n • u) i = if community i = 0 then 1 else -1 := by
    rcases hρ with rfl | rfl
    · refine ⟨-b, hb.neg, ?_⟩
      intro i
      have hi := congrFun hscale i
      change Real.sqrt (n : ℝ) * b i = -1 * BalancedFinSBM.communitySign k i at hi
      change Real.sqrt (n : ℝ) * (-b i) = if community i = 0 then 1 else -1
      have hs : BalancedFinSBM.communitySign k i =
          if community i = 0 then 1 else -1 := rfl
      rw [hs] at hi
      linarith
    · refine ⟨b, hb, ?_⟩
      intro i
      have hi := congrFun hscale i
      change Real.sqrt (n : ℝ) * b i = 1 * BalancedFinSBM.communitySign k i at hi
      simpa only [one_mul] using hi
  obtain ⟨u, hu, hsignal⟩ := horiented
  have hcompare : μ / 2 ≤ min (((θ.p : ℝ) - θ.q) / 2) θ.q := by
    dsimp [μ]
    simp only [min_def]
    split <;> split <;> linarith
  have hsep : ∀ j : Fin n, j ≠ ⟨1, hn⟩ →
      (μ / 2) * (n : ℝ) ≤
        |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn⟩ -
          NumStability.hermitianOrderedEigenvalue hD j| := by
    intro j hj
    apply (mul_le_mul_of_nonneg_right hcompare (Nat.cast_nonneg n)).trans
    exact BalancedFinSBM.population_second_eigengap hk θ hq hpq j hj
  have hprob := htail (P := FinStochasticBlock.measure community θ) hn
    D FinStochasticBlock.adjacency hD FinStochasticBlock.adjacency_hermitian
    (μ / 2) (half_pos hμ) u hu community hsep hsignal
    (by simpa [D, community, BalancedFinSBM.expectedAdjacency_eq_population] using
      FinStochasticBlock.noise_symmetric community θ)
    (by simpa [D, community, BalancedFinSBM.expectedAdjacency_eq_population] using
      FinStochasticBlock.noise_measurable community θ)
    (by simpa [D, community, BalancedFinSBM.expectedAdjacency_eq_population] using
      FinStochasticBlock.noise_abs_le_one community θ)
    (by simpa [D, community, BalancedFinSBM.expectedAdjacency_eq_population] using
      FinStochasticBlock.noise_mean_zero community θ)
    (by simpa [D, community, BalancedFinSBM.expectedAdjacency_eq_population] using
      FinStochasticBlock.noise_iIndepFun community θ)
  have hthreshold : C₀ / (μ / 2) ^ 2 = (4 * C₀) / μ ^ 2 := by
    field_simp; ring
  simpa only [hthreshold] using hprob

end NumStability.HDP.Contract.BalancedFinSBMRecovery
