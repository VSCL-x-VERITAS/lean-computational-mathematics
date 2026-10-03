import ComputationalMathematics.HDP.Vector.SignRecovery
import ComputationalMathematics.HDP.Matrix.EigenvectorPerturbation
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMRecovery

/-!
# Vershynin Chapter 4, Equation (4.20)
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- The deterministic implication used in Vershynin, Equation (4.20):
an `ℓ₂` bound between rescaled second eigenvectors gives the displayed sum
of squared coefficient errors. The source applies it to the loopless
stochastic-block model and a global sign. This implication only requires
Hermitian matrices, the norm bound, and the stated scalar inequalities;
neither the block law nor a restriction of `θ` to signs is needed here. -/
theorem hdp_04_equation_4_20_of_perturbation {n : ℕ} (hn2 : 2 ≤ n)
    (D A : Matrix (Fin n) (Fin n) ℝ)
    (hD : D.IsHermitian) (hA : A.IsHermitian)
    (θ C μ : ℝ)
    (hC : 0 ≤ C) (hμ : 0 < μ)
    (hperturb :
      NumStability.vecNorm2
        ((Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) -
          θ • (Real.sqrt n •
            NumStability.hermitianOrderedEigenbasis hA ⟨1, hn2⟩)) ≤
        Real.sqrt C / μ) :
    ∑ j,
      |(Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) j -
        (θ • (Real.sqrt n •
          NumStability.hermitianOrderedEigenbasis hA ⟨1, hn2⟩)) j| ^ 2 ≤
      C / μ ^ 2 := by
  simpa [sq_abs] using
    NumStability.HDP.Vector.SignRecovery.sum_sq_sub_le_div_sq_of_vecNorm2_le
      (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
      (θ • (Real.sqrt n •
        NumStability.hermitianOrderedEigenbasis hA ⟨1, hn2⟩))
      C μ hC hμ hperturb

/-- Vershynin, Equation (4.20), for the exact balanced loopless
independent-Bernoulli stochastic-block law.  Outside an event of probability
at most `4 exp (-n)`, one global sign makes the squared coefficient error
between the rescaled population and empirical second eigenvectors at most
`C / μ²`, where `μ = min(q, p-q)`. -/
theorem hdp_04_equation_4_20 :
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
          ∑ j,
            |(Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis hD
                  ⟨1, by omega⟩) j -
              (α • (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, by omega⟩)) j| ^ 2 ≤ C / μ ^ 2} ≤
            4 * Real.exp (-(n : ℝ)) := by
  rcases BalancedFinSBMRecovery.exists_eigenvector_perturbation_tail with
    ⟨B, hB, htail⟩
  refine ⟨B ^ 2, sq_pos_of_pos hB, ?_⟩
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
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hμ : 0 < μ := by
    dsimp [μ]
    exact lt_min hqR (sub_pos.mpr hpqR)
  have hsource := htail hk θ hq hpq
  apply (measureReal_mono ?_ (measure_ne_top P _)).trans hsource
  intro ω hbad hgood
  rcases hgood with ⟨α, hα, _hunit, hscaled⟩
  apply hbad
  refine ⟨α, hα, ?_⟩
  let u : EuclideanSpace ℝ (Fin n) :=
    Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩
  let v : EuclideanSpace ℝ (Fin n) :=
    α • (Real.sqrt n •
      NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, by omega⟩)
  have hsq : ‖u - v‖ ^ 2 ≤ (B / μ) ^ 2 := by
    exact (sq_le_sq₀ (norm_nonneg _) (div_nonneg hB.le hμ.le)).2
      (by simpa [u, v, n, μ] using hscaled)
  change (∑ j, |u j - v j| ^ 2) ≤ B ^ 2 / μ ^ 2
  calc
    ∑ j, |u j - v j| ^ 2 = ‖u - v‖ ^ 2 := by
      rw [EuclideanSpace.norm_sq_eq]
      apply Finset.sum_congr rfl
      intro j _hj
      simp only [PiLp.sub_apply, Real.norm_eq_abs]
    _ ≤ (B / μ) ^ 2 := hsq
    _ = B ^ 2 / μ ^ 2 := by rw [div_pow]

end NumStability.HDP.Contract
