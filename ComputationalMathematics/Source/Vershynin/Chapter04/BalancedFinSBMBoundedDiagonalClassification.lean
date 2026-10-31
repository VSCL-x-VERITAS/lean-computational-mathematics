import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMAllUnitClassification
import Mathlib.Analysis.CStarAlgebra.Matrix

/-!
# Canonical balanced classification with every bounded diagonal

The original loopless Bernoulli noise event controls the classifier for every
real diagonal with entries in [0, 1], using the existing deterministic
two-certificate classification bound. The diagonal may be selected after the
sample. No source-model correspondence is asserted.

-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped Matrix.Norms.L2Operator

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery

open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

/-- One common event controls every bounded diagonal and every complete
second-slot unit certificate for the modified actual adjacency. -/
theorem exists_all_unit_bounded_diagonal_binary_classification_tail :
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters),
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let community := BalancedFinSBM.community k
      let P := FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ d : Fin n → ℝ, (∀ i, 0 ≤ d i ∧ d i ≤ 1) ∧
          ∃ v : EuclideanSpace ℝ (Fin n),
            SpectralClustering.IsSecondOrderedEigenvector
              (FinStochasticBlock.adjacency ω + Matrix.diagonal d) hn v ∧
            ∀ swapped : Bool,
              C / μ ^ 2 <
                ((binaryThresholdMisclassifications
                  (if swapped then swapBinaryCommunity community else community)
                  (Real.sqrt n • v)).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C₀, hC₀, htail⟩ := FinStochasticBlock.exists_operatorNorm_noise_sqrt_tail
  refine ⟨4 * (2 * Real.sqrt 2 * (C₀ + 1)) ^ 2, by positivity, ?_⟩
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
  have hnoiseTail :
      (FinStochasticBlock.measure community θ).real {ω |
        C₀ * Real.sqrt n <
          NumStability.realMatrixOperatorNorm (D - FinStochasticBlock.adjacency ω)} ≤
        4 * Real.exp (-(n : ℝ)) := by
    simpa [D, community, BalancedFinSBM.expectedAdjacency_eq_population] using
      htail (by omega : 0 < n) community θ
  have hthreshold :
      (2 * Real.sqrt 2 * (C₀ + 1)) ^ 2 / (μ / 2) ^ 2 =
        (4 * (2 * Real.sqrt 2 * (C₀ + 1)) ^ 2) / μ ^ 2 := by
    field_simp [hμ.ne']
    ring
  apply (measureReal_mono ?_).trans hnoiseTail
  rintro ω ⟨d, hd, v, hv, hbad⟩
  by_contra hnot
  have hnoise :
      NumStability.realMatrixOperatorNorm (D - FinStochasticBlock.adjacency ω) ≤
        C₀ * Real.sqrt n := le_of_not_gt hnot
  have hdiag : NumStability.realMatrixOperatorNorm (Matrix.diagonal d) ≤ 1 := by
    change ‖Matrix.diagonal d‖ ≤ 1
    rw [Matrix.l2_opNorm_diagonal]
    apply (pi_norm_le_iff_of_nonneg zero_le_one).2
    intro i
    rw [Real.norm_eq_abs, abs_of_nonneg (hd i).1]
    exact (hd i).2
  have htriangle :
      NumStability.realMatrixOperatorNorm
          (D - (FinStochasticBlock.adjacency ω + Matrix.diagonal d)) ≤
        NumStability.realMatrixOperatorNorm (D - FinStochasticBlock.adjacency ω) +
          NumStability.realMatrixOperatorNorm (Matrix.diagonal d) := by
    change ‖D - (FinStochasticBlock.adjacency ω + Matrix.diagonal d)‖ ≤
      ‖D - FinStochasticBlock.adjacency ω‖ + ‖Matrix.diagonal d‖
    rw [sub_add_eq_sub_sub]
    exact norm_sub_le _ _
  have hnR : (1 : ℝ) ≤ (n : ℕ) := by
    exact_mod_cast (by omega : 1 ≤ n)
  have hsqrt : 1 ≤ Real.sqrt (n : ℝ) := Real.one_le_sqrt.mpr hnR
  have hperturb :
      NumStability.realMatrixOperatorNorm
          (D - (FinStochasticBlock.adjacency ω + Matrix.diagonal d)) ≤
        (C₀ + 1) * Real.sqrt n := by
    calc
      _ ≤ NumStability.realMatrixOperatorNorm (D - FinStochasticBlock.adjacency ω) +
          NumStability.realMatrixOperatorNorm (Matrix.diagonal d) := htriangle
      _ ≤ C₀ * Real.sqrt n + 1 := add_le_add hnoise hdiag
      _ ≤ (C₀ + 1) * Real.sqrt n := by nlinarith
  have hT : (FinStochasticBlock.adjacency ω + Matrix.diagonal d).IsHermitian :=
    (FinStochasticBlock.adjacency_hermitian ω).add (Matrix.isHermitian_diagonal d)
  obtain ⟨swapped, hcard⟩ :=
    exists_label_swap_card_misclassifications_le_of_two_certified_second_eigenvectors
      hn D (FinStochasticBlock.adjacency ω + Matrix.diagonal d) hD hT
      (C₀ + 1) (μ / 2) (by positivity) (half_pos hμ) hsep hperturb
      u v hu hv community hsignal
  rw [hthreshold] at hcard
  exact (not_lt_of_ge hcard) (hbad swapped)

end NumStability.HDP.Contract.BalancedFinSBMRecovery
