import ComputationalMathematics.HDP.Graph.SpectralClusteringGuarantee
import ComputationalMathematics.HDP.Graph.SpectralClustering
import ComputationalMathematics.HDP.Vector.BinaryLabelSwap
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-!
# Vershynin Chapter 4, Theorem 4.5.6
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vertices misclassified by thresholding an oriented spectral vector at
zero, with zero assigned to the source algorithm's nonpositive community. -/
noncomputable def sbmSpectralMisclassifications {n : ℕ}
    (community : Fin n → Fin 2) (v : Fin n → ℝ) : Finset (Fin n) :=
  NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
    community v

/-- The source spectral-clustering algorithm succeeds at error threshold `t`
when its output partition agrees with the latent partition after either the
identity labeling or the genuine global exchange of the two output labels.
This formulation handles zero coordinates exactly: negating a score does not
exchange its strict-positive/otherwise classification at zero. -/
def sbmSpectralClusteringSucceeds {n : ℕ}
    (community : Fin n → Fin 2) (v : Fin n → ℝ) (t : ℝ) : Prop :=
  ((sbmSpectralMisclassifications community v).card : ℝ) ≤ t ∨
    ((sbmSpectralMisclassifications
      (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community)
      v).card : ℝ) ≤ t

private theorem sbmSpectralMisclassifications_subset_signDisagreements
    {n : ℕ} (community : Fin n → Fin 2) (u v : Fin n → ℝ)
    (hu : ∀ i, u i = if community i = 0 then 1 else -1) :
    sbmSpectralMisclassifications community v ⊆
      NumStability.HDP.Vector.SignRecovery.signDisagreements u v := by
  simpa [sbmSpectralMisclassifications] using
    NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications_subset_signDisagreements
      community u v hu

private theorem sbmSpectralMisclassifications_swap_subset_signDisagreements
    {n : ℕ} (community : Fin n → Fin 2) (u v : Fin n → ℝ)
    (hu : ∀ i, u i = if community i = 0 then 1 else -1) :
    sbmSpectralMisclassifications
        (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community) v ⊆
      NumStability.HDP.Vector.SignRecovery.signDisagreements u (-v) := by
  simpa [sbmSpectralMisclassifications] using
    NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications_swap_subset_signDisagreements
      community u v hu

/-- Vershynin, Theorem 4.5.6: when
`μ = min(q, p - q) > 0`, spectral clustering of the stochastic-block adjacency
matrix misclassifies at most `C / μ²` vertices except on an event of
probability at most `4 exp (-n)`.

The community binder, balanced-cardinality hypothesis, loopless
expected-adjacency formula, Boolean adjacency entries, and exact signed signal
vector explicitly connect the abstract matrix concentration argument to the
source's stochastic-block graph.  In accordance with the inherited graph
definition, the expectation has diagonal zero; the chapter's displayed
`p`-diagonal matrix differs by the scalar shift `pI`, which preserves the
eigenvectors and all eigenvalue gaps.  The eigengap is the source proof's exact
`min ((p-q)/2, q) n`; its factor-two difference from the displayed `μ n`
scale is absorbed into `C`. -/
theorem hdp_04_theorem_4_5_6_of_structural_hypotheses :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {n : ℕ} (hn2 : 2 ≤ n)
        (D : Matrix (Fin n) (Fin n) ℝ)
        (A : Ω → Matrix (Fin n) (Fin n) ℝ)
        (hD : D.IsHermitian) (hA : ∀ ω, (A ω).IsHermitian)
        (community : Fin n → Fin 2)
        (p q : ℝ),
        0 < q → q < p →
        Fintype.card {i : Fin n // community i = 0} * 2 = n →
        (∀ i j, D i j =
          if i = j then 0
          else if community i = community j then p else q) →
        (∀ ω i j, A ω i j = 0 ∨ A ω i j = 1) →
        (∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
          min ((p - q) / 2) q * (n : ℝ) ≤
            |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn2⟩ -
              NumStability.hermitianOrderedEigenvalue hD j|) →
        (∀ i, (Real.sqrt n •
            NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) i =
              if community i = 0 then 1 else -1) →
        (∀ ω i j, (D - A ω) i j = (D - A ω) j i) →
        (∀ i j, Measurable (fun ω => (D - A ω) i j)) →
        (∀ ω i j, |(D - A ω) i j| ≤ 1) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          (∫ ω, (D - A ω) ij.1.1 ij.1.2 ∂P) = 0) →
        iIndepFun
          (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
            fun ω => (D - A ω) ij.1.1 ij.1.2) P →
        (∀ ω,
          ‖NumStability.HDP.Graph.SpectralClustering.secondEigenvector
              (A ω) (hA ω) hn2‖ = 1 ∧
            (A ω).toEuclideanLin
                (NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                  (A ω) (hA ω) hn2) =
              NumStability.hermitianOrderedEigenvalue (hA ω) ⟨1, hn2⟩ •
                NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                  (A ω) (hA ω) hn2 ∧
            NumStability.hermitianOrderedEigenvalue (hA ω) ⟨1, hn2⟩ ≤
              NumStability.hermitianOrderedEigenvalue (hA ω)
                ⟨0, Nat.zero_lt_of_lt hn2⟩ ∧
            ∀ j : Fin n, ⟨1, hn2⟩ ≤ j →
              NumStability.hermitianOrderedEigenvalue (hA ω) j ≤
                NumStability.hermitianOrderedEigenvalue (hA ω) ⟨1, hn2⟩) ∧
          P.real {ω | ¬ sbmSpectralClusteringSucceeds community
            (Real.sqrt n •
              NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                (A ω) (hA ω) hn2)
            (C / (min q (p - q)) ^ 2)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  rcases
      NumStability.HDP.Graph.exists_spectral_sign_recovery_tail_of_stochastic_block_gap with
    ⟨C, hC, hGuarantee⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ P instP n hn2 D A hD hA community p q hq hpq hbalanced
    hExpected hAdjacency hgap hsignal hSym hMeas hBound hMean hIndep
  refine ⟨fun ω =>
    NumStability.HDP.Graph.SpectralClustering.secondEigenvector_isSecondOrdered
      (A ω) (hA ω) hn2, ?_⟩
  have hu : ∀ i, |(Real.sqrt n •
      NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) i| = 1 := by
    intro i
    rw [hsignal i]
    split <;> simp
  have hGuarantee' :=
    hGuarantee hn2 D A hD hA p q hq hpq hgap hu hSym hMeas hBound
      hMean hIndep
  apply (measureReal_mono ?_ (measure_ne_top P _)).trans hGuarantee'
  intro ω hFailure θ hθ
  let u : Fin n → ℝ := Real.sqrt n •
    NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩
  let v : Fin n → ℝ := Real.sqrt n •
    NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩
  have hu' : ∀ i, u i = if community i = 0 then 1 else -1 := by
    intro i
    exact hsignal i
  rcases hθ with hθ | hθ
  · subst θ
    have hsubset :
        sbmSpectralMisclassifications
            (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community) v ⊆
          NumStability.HDP.Vector.SignRecovery.signDisagreements u (-v) :=
      sbmSpectralMisclassifications_swap_subset_signDisagreements
        community u v hu'
    have hcard :
        ((sbmSpectralMisclassifications
          (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community)
          v).card : ℝ) ≤
          ((NumStability.HDP.Vector.SignRecovery.signDisagreements
            u ((-1 : ℝ) • v)).card : ℝ) := by
      have hcard' :
          ((sbmSpectralMisclassifications
            (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community)
            v).card : ℝ) ≤
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              u (-v)).card : ℝ) := by
        exact_mod_cast Finset.card_le_card hsubset
      simpa using hcard'
    have hNotActual : ¬
        ((sbmSpectralMisclassifications
          (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community)
          v).card : ℝ) ≤ C / (min q (p - q)) ^ 2 := by
      intro hActual
      apply hFailure
      right
      simpa [v, NumStability.HDP.Graph.SpectralClustering.secondEigenvector]
        using hActual
    exact (lt_of_not_ge hNotActual).trans_le hcard
  · subst θ
    have hsubset :
        sbmSpectralMisclassifications community v ⊆
          NumStability.HDP.Vector.SignRecovery.signDisagreements u v :=
      sbmSpectralMisclassifications_subset_signDisagreements community u v hu'
    have hcard :
        ((sbmSpectralMisclassifications community v).card : ℝ) ≤
          ((NumStability.HDP.Vector.SignRecovery.signDisagreements
            u ((1 : ℝ) • v)).card : ℝ) := by
      simpa using (show
        ((sbmSpectralMisclassifications community v).card : ℝ) ≤
          ((NumStability.HDP.Vector.SignRecovery.signDisagreements u v).card : ℝ)
        by exact_mod_cast Finset.card_le_card hsubset)
    have hNotActual : ¬
        ((sbmSpectralMisclassifications community v).card : ℝ) ≤
          C / (min q (p - q)) ^ 2 := by
      intro hActual
      apply hFailure
      left
      simpa [v, NumStability.HDP.Graph.SpectralClustering.secondEigenvector]
        using hActual
    exact (lt_of_not_ge hNotActual).trans_le hcard

/-- Vershynin, Theorem 4.5.6 for the exact balanced loopless independent-
Bernoulli stochastic-block law.  The statement includes the population
expectation, Boolean adjacency support, and ordered-eigenvector certificate,
so none of the model or algorithm semantics are supplied as hypotheses. -/
theorem hdp_04_theorem_4_5_6 :
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
        (∀ i j : Fin n,
            (∫ ω, A ω i j ∂P) =
              BalancedFinSBM.population k θ.p θ.q i j) ∧
          (∀ ω i j, A ω i j = 0 ∨ A ω i j = 1) ∧
          (∀ ω,
            ‖NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                (A ω) (hA ω) (by omega : 2 ≤ n)‖ = 1 ∧
              (A ω).toEuclideanLin
                  (NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                    (A ω) (hA ω) (by omega : 2 ≤ n)) =
                NumStability.hermitianOrderedEigenvalue (hA ω)
                    ⟨1, by omega⟩ •
                  NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                    (A ω) (hA ω) (by omega : 2 ≤ n) ∧
              NumStability.hermitianOrderedEigenvalue (hA ω) ⟨1, by omega⟩ ≤
                NumStability.hermitianOrderedEigenvalue (hA ω)
                  ⟨0, by omega⟩ ∧
              ∀ j : Fin n, ⟨1, by omega⟩ ≤ j →
                NumStability.hermitianOrderedEigenvalue (hA ω) j ≤
                  NumStability.hermitianOrderedEigenvalue (hA ω)
                    ⟨1, by omega⟩) ∧
          P.real {ω | ¬ sbmSpectralClusteringSucceeds community
            (Real.sqrt n •
              NumStability.HDP.Graph.SpectralClustering.secondEigenvector
                (A ω) (hA ω) (by omega : 2 ≤ n))
            (C / (min (θ.q : ℝ) ((θ.p : ℝ) - θ.q)) ^ 2)} ≤
              4 * Real.exp (-(n : ℝ)) := by
  rcases
      NumStability.HDP.Graph.exists_spectral_sign_recovery_tail_of_stochastic_block_gap with
    ⟨C, hC, hGuarantee⟩
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
  have hn2 : 2 ≤ n := by dsimp [n]; omega
  let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro i j
    simpa [n, community, P, A,
      BalancedFinSBM.expectedAdjacency_eq_population] using
      NumStability.HDP.Graph.FinStochasticBlock.adjacency_expectation
        (BalancedFinSBM.community k) θ i j
  · intro ω i j
    exact NumStability.HDP.Graph.FinStochasticBlock.adjacency_zero_or_one ω i j
  · intro ω
    exact
      NumStability.HDP.Graph.SpectralClustering.secondEigenvector_isSecondOrdered
        (A ω) (hA ω) hn2
  · have hgap : ∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
        min (((θ.p : ℝ) - θ.q) / 2) θ.q * (n : ℝ) ≤
          |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn2⟩ -
            NumStability.hermitianOrderedEigenvalue hD j| := by
      simpa [n, hD] using
        BalancedFinSBM.population_second_eigengap hk θ hq hpq
    have huAbs : ∀ i : Fin n,
        |(Real.sqrt n •
          NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) i| = 1 := by
      simpa [n, hD] using
        BalancedFinSBM.population_second_eigenbasis_scaled_abs hk θ hq hpq
    have hSym : ∀ ω i j,
        (BalancedFinSBM.population k θ.p θ.q - A ω) i j =
          (BalancedFinSBM.population k θ.p θ.q - A ω) j i := by
      simpa [community, A,
        BalancedFinSBM.expectedAdjacency_eq_population] using
        NumStability.HDP.Graph.FinStochasticBlock.noise_symmetric
          (BalancedFinSBM.community k) θ
    have hMeas : ∀ i j, Measurable (fun ω =>
        (BalancedFinSBM.population k θ.p θ.q - A ω) i j) := by
      intro i j
      simpa [community, A,
        BalancedFinSBM.expectedAdjacency_eq_population] using
        NumStability.HDP.Graph.FinStochasticBlock.noise_measurable
          (BalancedFinSBM.community k) θ i j
    have hBound : ∀ ω i j,
        |(BalancedFinSBM.population k θ.p θ.q - A ω) i j| ≤ 1 := by
      intro ω i j
      simpa [community, A,
        BalancedFinSBM.expectedAdjacency_eq_population] using
        NumStability.HDP.Graph.FinStochasticBlock.noise_abs_le_one
          (BalancedFinSBM.community k) θ ω i j
    have hMean : ∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
        (∫ ω, (BalancedFinSBM.population k θ.p θ.q - A ω)
          ij.1.1 ij.1.2 ∂P) = 0 := by
      intro ij
      simpa [n, community, P, A,
        BalancedFinSBM.expectedAdjacency_eq_population] using
        NumStability.HDP.Graph.FinStochasticBlock.noise_mean_zero
          (BalancedFinSBM.community k) θ ij
    have hIndep : iIndepFun
        (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
          fun ω => (BalancedFinSBM.population k θ.p θ.q - A ω)
            ij.1.1 ij.1.2) P := by
      simpa [n, community, P, A,
        BalancedFinSBM.expectedAdjacency_eq_population] using
        NumStability.HDP.Graph.FinStochasticBlock.noise_iIndepFun
          (BalancedFinSBM.community k) θ
    have hTail := hGuarantee hn2
      (BalancedFinSBM.population k θ.p θ.q) A hD hA
      (θ.p : ℝ) (θ.q : ℝ) (by exact_mod_cast hq) (by exact_mod_cast hpq)
      hgap huAbs hSym hMeas hBound hMean hIndep
    obtain ⟨ρ, hρ, hSignal⟩ :=
      BalancedFinSBM.exists_population_second_eigenbasis_sign hk θ hq hpq
    apply (measureReal_mono ?_ (measure_ne_top P _)).trans hTail
    intro ω hFailure α hα
    let u : Fin n → ℝ := Real.sqrt n •
      NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩
    let v : Fin n → ℝ := Real.sqrt n •
      NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩
    let β : ℝ := ρ * α
    have hβ : β = -1 ∨ β = 1 := by
      rcases hρ with hρ | hρ <;> rcases hα with hα | hα <;>
        simp [β, hρ, hα]
    have hCanonical : ∀ i : Fin n,
        BalancedFinSBM.communitySign k i =
          if BalancedFinSBM.community k i = 0 then 1 else -1 := by
      intro i
      simp [BalancedFinSBM.communitySign, BalancedFinSBM.community,
        NumStability.HDP.Graph.StochasticBlock.communitySign]
    have hu : u = ρ • BalancedFinSBM.communitySign k := by
      simpa [u, n, hD] using hSignal
    have hdisc :
        NumStability.HDP.Vector.SignRecovery.signDisagreements u (α • v) =
          NumStability.HDP.Vector.SignRecovery.signDisagreements
            (BalancedFinSBM.communitySign k) (β • v) := by
      rw [hu]
      rcases hρ with hρ | hρ <;> rcases hα with hα | hα <;>
        subst ρ <;> subst α <;>
        simp [β, NumStability.HDP.Vector.SignRecovery.signDisagreements,
          Finset.ext_iff]
    rcases hβ with hβ | hβ
    · have hsubset :
          sbmSpectralMisclassifications
              (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity
                (BalancedFinSBM.community k)) v ⊆
            NumStability.HDP.Vector.SignRecovery.signDisagreements
              (BalancedFinSBM.communitySign k) (-v) :=
        sbmSpectralMisclassifications_swap_subset_signDisagreements
          (BalancedFinSBM.community k) (BalancedFinSBM.communitySign k)
          v hCanonical
      have hdisc' :
          NumStability.HDP.Vector.SignRecovery.signDisagreements u (α • v) =
            NumStability.HDP.Vector.SignRecovery.signDisagreements
              (BalancedFinSBM.communitySign k) (-v) := by
        simpa [hβ] using hdisc
      have hcard :
          ((sbmSpectralMisclassifications
            (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity
              (BalancedFinSBM.community k)) v).card : ℝ) ≤
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              u (α • v)).card : ℝ) := by
        rw [hdisc']
        exact_mod_cast Finset.card_le_card hsubset
      have hNotActual : ¬
          ((sbmSpectralMisclassifications
            (NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity
              (BalancedFinSBM.community k)) v).card : ℝ) ≤
            C / (min (θ.q : ℝ) ((θ.p : ℝ) - θ.q)) ^ 2 := by
        intro hActual
        apply hFailure
        right
        simpa [v, n,
          NumStability.HDP.Graph.SpectralClustering.secondEigenvector] using hActual
      exact (lt_of_not_ge hNotActual).trans_le hcard
    · have hsubset :
          sbmSpectralMisclassifications (BalancedFinSBM.community k) v ⊆
            NumStability.HDP.Vector.SignRecovery.signDisagreements
              (BalancedFinSBM.communitySign k) v :=
        sbmSpectralMisclassifications_subset_signDisagreements
          (BalancedFinSBM.community k) (BalancedFinSBM.communitySign k)
          v hCanonical
      have hdisc' :
          NumStability.HDP.Vector.SignRecovery.signDisagreements u (α • v) =
            NumStability.HDP.Vector.SignRecovery.signDisagreements
              (BalancedFinSBM.communitySign k) v := by
        simpa [hβ] using hdisc
      have hcard :
          ((sbmSpectralMisclassifications (BalancedFinSBM.community k)
            v).card : ℝ) ≤
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              u (α • v)).card : ℝ) := by
        rw [hdisc']
        exact_mod_cast Finset.card_le_card hsubset
      have hNotActual : ¬
          ((sbmSpectralMisclassifications (BalancedFinSBM.community k)
            v).card : ℝ) ≤
            C / (min (θ.q : ℝ) ((θ.p : ℝ) - θ.q)) ^ 2 := by
        intro hActual
        apply hFailure
        left
        simpa [v, n,
          NumStability.HDP.Graph.SpectralClustering.secondEigenvector] using hActual
      exact (lt_of_not_ge hNotActual).trans_le hcard

end NumStability.HDP.Contract
