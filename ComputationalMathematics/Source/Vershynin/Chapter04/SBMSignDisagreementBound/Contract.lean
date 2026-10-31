import ComputationalMathematics.HDP.Vector.SignRecovery
import ComputationalMathematics.HDP.Matrix.EigenvectorPerturbation
import ComputationalMathematics.HDP.Graph.SpectralClustering
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation420.Contract

/-!
# Vershynin Chapter 4, SBM sign-disagreement bound
-/

namespace NumStability.HDP.Contract

/-- The deterministic sign-counting implication in Vershynin, Section 4.5.4:
once the population eigenvector has the displayed community signs and the
squared coefficient error is at most `C/μ²`, at most `C/μ²` vertices
can have the wrong sign. The source obtains these premises from its loopless
block law. This implication only needs the sign certificate and squared-error
bound; it also allows an arbitrary scalar orientation `θ`. -/
theorem hdp_04_sbm_sign_disagreement_bound_of_squared_error
    {n : ℕ} (hn2 : 2 ≤ n)
    (D A : Matrix (Fin n) (Fin n) ℝ)
    (hD : D.IsHermitian) (hA : A.IsHermitian)
    (community : Fin n → Fin 2) (θ C μ : ℝ)
    (hsignal : ∀ i,
      (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) i =
        if community i = 0 then 1 else -1)
    (herror :
      (∑ i,
        ((Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) i -
          (θ • (Real.sqrt n •
            NumStability.hermitianOrderedEigenbasis hA ⟨1, hn2⟩)) i) ^ 2) ≤
        C / μ ^ 2) :
    ((NumStability.HDP.Vector.SignRecovery.signDisagreements
      (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
      (θ • (Real.sqrt n •
        NumStability.hermitianOrderedEigenbasis hA ⟨1, hn2⟩))).card : ℝ) ≤
      C / μ ^ 2 :=
  (NumStability.HDP.Vector.SignRecovery.card_signDisagreements_le_sum_sq
    (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
    (θ • (Real.sqrt n •
      NumStability.hermitianOrderedEigenbasis hA ⟨1, hn2⟩))
    (fun i ↦ by rw [hsignal i]; split <;> simp)).trans herror

/-- Vershynin, Section 4.5.4, for the exact balanced loopless
independent-Bernoulli stochastic-block model.  The population ordered second
eigenvector is the community-sign vector up to a global sign, and outside an
event of probability at most `4 exp (-n)` one orientation of the empirical
second eigenvector disagrees with it on at most `C / μ²` coordinates. -/
theorem hdp_04_sbm_sign_disagreement_bound :
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
        ∃ ρ : ℝ, (ρ = -1 ∨ ρ = 1) ∧
          Real.sqrt n •
              NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩ =
            ρ • BalancedFinSBM.communitySign k ∧
          (∀ ω,
            NumStability.HDP.Graph.SpectralClustering.IsSecondOrderedEigenvector
              (A ω) (by omega)
              (NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                (A ω) (hA ω) (by omega))) ∧
          P.real {ω | ¬ ∃ α : ℝ, (α = -1 ∨ α = 1) ∧
            (∑ i,
              ((ρ • (Real.sqrt n •
                  NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩)) i -
                (α • (Real.sqrt n •
                  NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                    (A ω) (hA ω) (by omega))) i) ^ 2) ≤ C / μ ^ 2 ∧
            ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
              community
              (α • (Real.sqrt n •
                NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                  (A ω) (hA ω) (by omega)))).card : ℝ) ≤ C / μ ^ 2} ≤
            4 * Real.exp (-(n : ℝ)) := by
  rcases hdp_04_equation_4_20 with ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
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
  obtain ⟨ρ, hρ, hρeq⟩ :=
    BalancedFinSBM.exists_population_second_eigenbasis_sign hk θ hq hpq
  have hρeq' :
      Real.sqrt n •
          NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩ =
        ρ • BalancedFinSBM.communitySign k := by
    simpa [n, hD] using hρeq
  refine ⟨ρ, hρ, hρeq', ?_, ?_⟩
  · intro ω
    exact
      NumStability.HDP.Graph.SpectralClustering.secondEigenvector_completeOrderedCertificate
        (A ω) (hA ω) (by omega)
  have hcommunity : ∀ i : Fin n,
      BalancedFinSBM.communitySign k i =
        if community i = 0 then 1 else -1 := by
    intro i
    simp [n, community, BalancedFinSBM.community,
      BalancedFinSBM.communitySign,
      NumStability.HDP.Graph.StochasticBlock.communitySign]
  have hsource := htail hk θ hq hpq
  apply (MeasureTheory.measureReal_mono ?_ (MeasureTheory.measure_ne_top P _)).trans
    hsource
  intro ω hbad hgood
  rcases hgood with ⟨α, hα, hsum⟩
  let u : Fin n → ℝ :=
    Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, by omega⟩
  let v : Fin n → ℝ :=
    Real.sqrt n • NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, by omega⟩
  have hρeqU : u = ρ • BalancedFinSBM.communitySign k := by
    simpa [u] using hρeq'
  apply hbad
  rcases hρ with hρneg | hρpos
  · subst ρ
    have hnegα : -α = -1 ∨ -α = 1 := by
      rcases hα with rfl | rfl <;> norm_num
    have hnegU : ∀ i, (-u) i = if community i = 0 then 1 else -1 := by
      intro i
      calc
        (-u) i = -u i := by rfl
        _ = BalancedFinSBM.communitySign k i := by
          rw [congrFun hρeqU i]
          simp
        _ = if community i = 0 then 1 else -1 := hcommunity i
    refine ⟨-α, hnegα, ?_, ?_⟩
    · simpa [u, v, n, μ,
        NumStability.HDP.Graph.SpectralClustering.secondEigenvector] using
        (show ∑ i, ((-u) i - ((-α) • v) i) ^ 2 ≤ C / μ ^ 2 by
          calc
            ∑ i, ((-u) i - ((-α) • v) i) ^ 2 =
                ∑ i, (u i - (α • v) i) ^ 2 := by
              apply Finset.sum_congr rfl
              intro i _hi
              simp only [Pi.neg_apply, Pi.smul_apply, smul_eq_mul]
              ring
            _ ≤ C / μ ^ 2 := by
              simpa [u, v, sq_abs, n, μ] using hsum)
    apply (NumStability.HDP.Vector.SignRecovery.card_binaryThresholdMisclassifications_le_sum_sq
        community (-u) ((-α) • v) hnegU).trans
    calc
      ∑ i, ((-u) i - ((-α) • v) i) ^ 2 =
          ∑ i, (u i - (α • v) i) ^ 2 := by
        apply Finset.sum_congr rfl
        intro i _hi
        simp only [Pi.neg_apply, Pi.smul_apply, smul_eq_mul]
        ring
      _ ≤ C / μ ^ 2 := by
        simpa [u, v, sq_abs, n, μ] using hsum
  · subst ρ
    have hu : ∀ i, u i = if community i = 0 then 1 else -1 := by
      intro i
      calc
        u i = BalancedFinSBM.communitySign k i := by
          rw [congrFun hρeqU i]
          simp
        _ = if community i = 0 then 1 else -1 := hcommunity i
    refine ⟨α, hα, ?_, ?_⟩
    · simpa [u, v, n, μ,
        NumStability.HDP.Graph.SpectralClustering.secondEigenvector] using hsum
    apply (NumStability.HDP.Vector.SignRecovery.card_binaryThresholdMisclassifications_le_sum_sq
        community u (α • v) hu).trans
    simpa [u, v, sq_abs, n, μ] using hsum

end NumStability.HDP.Contract
