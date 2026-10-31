import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMAllUnitClassification
import ComputationalMathematics.HDP.Graph.BalancedCommunityEquivalence
import ComputationalMathematics.HDP.Graph.FinStochasticBlockRelabeling
import ComputationalMathematics.HDP.Graph.SpectralClusteringRelabeling
import ComputationalMathematics.HDP.Vector.SignRecoveryRelabeling

/-!
# All-unit classification with arbitrary balanced labels

Relabeling the specified loopless Bernoulli model transports the canonical
balanced guarantee to every equal-sized binary partition. A single event
controls all certified second unit eigenvectors, including multiplicities.
No book-source correspondence is asserted.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery

open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

/-- Every balanced binary partition has the same absolute all-unit error tail
under its actual loopless independent-Bernoulli law. -/
theorem exists_all_balanced_unit_binary_classification_tail :
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters)
      (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let P := FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ v : EuclideanSpace ℝ (Fin n),
          SpectralClustering.IsSecondOrderedEigenvector
            (FinStochasticBlock.adjacency ω) hn v ∧
          ∀ swapped : Bool,
            C / μ ^ 2 <
              ((binaryThresholdMisclassifications
                (if swapped then swapBinaryCommunity community else community)
                (Real.sqrt n • v)).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, htail⟩ := exists_all_unit_binary_classification_tail
  refine ⟨C, hC, ?_⟩
  intro k hn θ community hbalanced hq hpq
  dsimp only
  let n := 2 * k
  let canonical := BalancedFinSBM.community k
  let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
  obtain ⟨e, he⟩ := exists_balancedCommunityIndexEquiv hbalanced
  have hlabels : ∀ i, canonical (e i) = community i := he
  let f := FinStochasticBlock.sampleRelabel e
  let L := LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e
  let bad : (Fin n → Fin 2) → Set (FinStochasticBlock.UpperPair n → Bool) :=
    fun labels => {ω |
      ∃ v : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector
          (FinStochasticBlock.adjacency ω) hn v ∧
        ∀ swapped : Bool,
          C / μ ^ 2 <
            ((binaryThresholdMisclassifications
              (if swapped then swapBinaryCommunity labels else labels)
              (Real.sqrt n • v)).card : ℝ)}
  have hsub : bad community ⊆ f ⁻¹' bad canonical := by
    rintro ω ⟨v, hv, herr⟩
    refine ⟨L v, ?_, ?_⟩
    · have h := (SpectralClustering.isSecondOrderedEigenvector_reindex_iff
        hn e (FinStochasticBlock.adjacency ω) v).mp hv
      simpa only [FinStochasticBlock.adjacency_sampleRelabel] using h
    · intro swapped
      have hswap : ∀ i,
          (if swapped then swapBinaryCommunity canonical else canonical) (e i) =
            (if swapped then swapBinaryCommunity community else community) i := by
        intro i
        cases swapped <;> simp [swapBinaryCommunity, hlabels]
      have hscore : ∀ i, (Real.sqrt n • L v) (e i) = (Real.sqrt n • v) i := by
        intro i
        change Real.sqrt (n : ℝ) * v (e.symm (e i)) = Real.sqrt (n : ℝ) * v i
        rw [Equiv.symm_apply_apply]
      have hc := card_binaryThresholdMisclassifications_eq_of_equiv
        (if swapped then swapBinaryCommunity community else community)
        (if swapped then swapBinaryCommunity canonical else canonical)
        e hswap (Real.sqrt n • v) (Real.sqrt n • L v) hscore
      rw [← hc]
      exact herr swapped
  have htail' : (FinStochasticBlock.measure canonical θ).real (bad canonical) ≤
      4 * Real.exp (-(n : ℝ)) := htail k hn θ hq hpq
  calc
    (FinStochasticBlock.measure community θ).real (bad community) ≤
        (FinStochasticBlock.measure community θ).real (f ⁻¹' bad canonical) :=
      measureReal_mono hsub
    _ = ((FinStochasticBlock.measure community θ).map f).real (bad canonical) :=
      (map_measureReal_apply f.measurable (Set.toFinite _).measurableSet).symm
    _ = (FinStochasticBlock.measure canonical θ).real (bad canonical) := by
      rw [FinStochasticBlock.measure_map_sampleRelabel community canonical e hlabels θ]
    _ ≤ 4 * Real.exp (-(n : ℝ)) := htail'

end NumStability.HDP.Contract.BalancedFinSBMRecovery
