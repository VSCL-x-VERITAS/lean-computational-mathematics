import ComputationalMathematics.HDP.Matrix.EigenvectorPerturbation
import ComputationalMathematics.HDP.Vector.SignRecovery
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-!
# Exact balanced-SBM recovery bridge

This module combines the independent-Bernoulli loopless model, the exact
ordered population eigengap, and Davis--Kahan into the high-probability
eigenvector estimates used in Section 4.5.4 of Vershynin's text.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery

open NumStability.HDP.Contract

/-- For the exact balanced independent-Bernoulli stochastic-block law, the
ordered second empirical eigenvector is, up to sign, within the source scale
`C /(μ √n)` of the population eigenvector.  The simultaneously stated scaled
bound is the form used in Equation (4.20), where
`μ = min q (p - q)` and `n = 2k`. -/
theorem exists_eigenvector_perturbation_tail :
    ∃ C : ℝ, 0 < C ∧
      ∀ {k : ℕ} (hk : 0 < k)
        (θ : NumStability.HDP.Graph.StochasticBlock.Parameters),
        0 < θ.q → θ.q < θ.p →
        let n := 2 * k
        let community := BalancedFinSBM.community k
        let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
        let A : (NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool) →
            Matrix (Fin n) (Fin n) ℝ :=
          NumStability.HDP.Graph.FinStochasticBlock.adjacency
        let hA : ∀ ω, (A ω).IsHermitian :=
          NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian
        let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
        let μ : ℝ := min θ.q (θ.p - θ.q)
        P.real {ω | ¬ ∃ α : ℝ, (α = -1 ∨ α = 1) ∧
          ‖NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩ -
              α • NumStability.hermitianOrderedEigenbasis (hA ω)
                ⟨1, by omega⟩‖ ≤ C / (μ * Real.sqrt n) ∧
          ‖Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩ -
              α • (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, by omega⟩)‖ ≤ C / μ} ≤
            4 * Real.exp (-(n : ℝ)) := by
  rcases
      NumStability.HDP.Graph.FinStochasticBlock.exists_operatorNorm_noise_sqrt_tail with
    ⟨C₀, hC₀, htail⟩
  let C : ℝ := 4 * Real.sqrt 2 * C₀
  refine ⟨C, by dsimp [C]; positivity, ?_⟩
  intro k hk θ hq hpq
  dsimp only
  let n := 2 * k
  let community := BalancedFinSBM.community k
  let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
  let A : (NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool) →
      Matrix (Fin n) (Fin n) ℝ :=
    NumStability.HDP.Graph.FinStochasticBlock.adjacency
  let hA : ∀ ω, (A ω).IsHermitian :=
    NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian
  let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
  let μ : ℝ := min θ.q (θ.p - θ.q)
  let gap : ℝ := min (((θ.p : ℝ) - θ.q) / 2) θ.q
  have hn : 0 < n := by dsimp [n]; omega
  have hn2 : 2 ≤ n := by dsimp [n]; omega
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hsqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 hnR
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hμ : 0 < μ := by
    dsimp [μ]
    exact lt_min hqR (sub_pos.mpr hpqR)
  have hgap : 0 < gap := by
    dsimp [gap]
    exact lt_min (half_pos (sub_pos.mpr hpqR)) hqR
  have hcompare : μ / 2 ≤ gap := by
    dsimp [μ, gap]
    simp only [min_def]
    split <;> split <;> linarith
  have hsep : ∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
      (μ / 2) * (n : ℝ) ≤
        |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn2⟩ -
          NumStability.hermitianOrderedEigenvalue hD j| := by
    intro j hj
    apply (mul_le_mul_of_nonneg_right hcompare hnR.le).trans
    simpa [n, gap, hD] using
      BalancedFinSBM.population_second_eigengap hk θ hq hpq j hj
  have htail' := htail hn (BalancedFinSBM.community k) θ
  apply (measureReal_mono ?_ (measure_ne_top P _)).trans
  · simpa [n, community, P, A,
      BalancedFinSBM.expectedAdjacency_eq_population] using htail'
  intro ω hfailure
  by_contra hnotNoise
  have hnoise0 : NumStability.realMatrixOperatorNorm
      (BalancedFinSBM.population k θ.p θ.q - A ω) ≤
        C₀ * (Real.sqrt 2 * Real.sqrt k) := by
    apply le_of_not_gt
    exact hnotNoise
  have hnoise : NumStability.realMatrixOperatorNorm
      (BalancedFinSBM.population k θ.p θ.q - A ω) ≤
        C₀ * Real.sqrt n := by
    simpa [n] using hnoise0
  obtain ⟨α, hα, hunit0⟩ :=
    NumStability.HDP.Matrix.exists_sign_orderedEigenvectors_norm_sub_le_sbm_scale
      hn (BalancedFinSBM.population k θ.p θ.q) (A ω) hD (hA ω)
        ⟨1, hn2⟩ C₀ (μ / 2) hC₀.le (half_pos hμ) hsep hnoise
  have hunit :
      ‖NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
          α • NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩‖ ≤
        C / (μ * Real.sqrt n) := by
    calc
      _ ≤ 2 * Real.sqrt 2 * C₀ / ((μ / 2) * Real.sqrt n) := hunit0
      _ = C / (μ * Real.sqrt n) := by
        dsimp [C]
        field_simp [hμ.ne', hsqrt.ne']
        <;> ring
  have hscaled :
      ‖Real.sqrt n •
            NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
          α • (Real.sqrt n •
            NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩)‖ ≤
        C / μ := by
    calc
      _ = Real.sqrt n *
          ‖NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
            α • NumStability.hermitianOrderedEigenbasis (hA ω)
              ⟨1, hn2⟩‖ := by
        rw [show
          Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
              α • (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩) =
            Real.sqrt n •
              (NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
                α • NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, hn2⟩) by
            simp [smul_sub, smul_smul, mul_comm]]
        rw [norm_smul, Real.norm_eq_abs, abs_of_pos hsqrt]
      _ ≤ Real.sqrt n * (C / (μ * Real.sqrt n)) :=
        mul_le_mul_of_nonneg_left hunit hsqrt.le
      _ = C / μ := by
        field_simp [hμ.ne', hsqrt.ne']
  exact hfailure ⟨α, hα, hunit, hscaled⟩

end NumStability.HDP.Contract.BalancedFinSBMRecovery
