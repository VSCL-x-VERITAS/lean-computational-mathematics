import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMBoundedDiagonalClassification
import ComputationalMathematics.HDP.Graph.BalancedCommunityEquivalence
import ComputationalMathematics.HDP.Graph.FinStochasticBlockRelabeling
import ComputationalMathematics.HDP.Graph.SpectralClusteringRelabeling
import ComputationalMathematics.HDP.Graph.UnitEigenvectorCertificate
import ComputationalMathematics.HDP.Vector.SignRecoveryRelabeling
import ComputationalMathematics.HDP.Vector.SignRecoveryScaling
import Mathlib.Analysis.Normed.Module.Normalize
import Mathlib.Data.Matrix.Diagonal
import Mathlib.Tactic.FinCases

/-!
# Balanced-model classification with every bounded diagonal

The canonical all-unit bounded-diagonal event transports to arbitrary equal
binary fibers and every nonzero second eigenvector of the modified adjacency.
Dimension packaging, actual-law relabeling and positive score scaling retain
the same absolute constant, including zero scores and repeated eigenvalues.
No source-model correspondence is asserted.

-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery

open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

/-- The same canonical constant controls all bounded diagonals and all nonzero
actual second eigenvectors for any equal-sized binary partition. -/
theorem exists_equal_fiber_nonzero_bounded_diagonal_binary_classification_tail :
  ∃ C : ℝ, 0 < C ∧
    ∀ (n : ℕ) (hn : 1 < n)
      (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
      (community : Fin n → Fin 2),
      Fintype.card {i : Fin n // community i = 0} =
        Fintype.card {i : Fin n // community i = 1} →
      0 < θ.q → θ.q < θ.p →
      let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ d : Fin n → ℝ, (∀ i, 0 ≤ d i ∧ d i ≤ 1) ∧
          ∃ v : EuclideanSpace ℝ (Fin n), v ≠ 0 ∧
            (NumStability.HDP.Graph.FinStochasticBlock.adjacency ω +
              Matrix.diagonal d).toEuclideanLin v =
              NumStability.hermitianOrderedEigenvalue
                ((NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian ω).add
                  (Matrix.isHermitian_diagonal d)) ⟨1, hn⟩ • v ∧
            ∀ swapped : Bool,
              C / μ ^ 2 <
                ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                  (if swapped then
                    NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                   else community) v).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, htail⟩ := exists_all_unit_bounded_diagonal_binary_classification_tail
  refine ⟨C, hC, ?_⟩
  intro n hn θ community hbalanced hq hpq
  have hex : ∃ k : ℕ, n = 2 * k ∧
      ∀ b : Fin 2, Fintype.card {i : Fin n // community i = b} = k := by
    let k := Fintype.card {i : Fin n // community i = 0}
    have hcards : ∀ b : Fin 2, Fintype.card {i : Fin n // community i = b} = k := by
      intro b
      fin_cases b
      · rfl
      · exact hbalanced.symm
    obtain ⟨e, _⟩ := exists_balancedCommunityIndexEquiv hcards
    refine ⟨k, ?_, hcards⟩
    simpa only [Fintype.card_fin] using Fintype.card_congr e
  obtain ⟨k, rfl, hcards⟩ := hex
  dsimp only
  let n := 2 * k
  let canonical := BalancedFinSBM.community k
  let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
  obtain ⟨e, he⟩ := exists_balancedCommunityIndexEquiv hcards
  have hlabels : ∀ i, canonical (e i) = community i := he
  let f := FinStochasticBlock.sampleRelabel e
  let L := LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e
  let badActual : Set (FinStochasticBlock.UpperPair n → Bool) := {ω |
    ∃ d : Fin n → ℝ, (∀ i, 0 ≤ d i ∧ d i ≤ 1) ∧
      ∃ v : EuclideanSpace ℝ (Fin n), v ≠ 0 ∧
        (FinStochasticBlock.adjacency ω + Matrix.diagonal d).toEuclideanLin v =
          NumStability.hermitianOrderedEigenvalue
            ((FinStochasticBlock.adjacency_hermitian ω).add
              (Matrix.isHermitian_diagonal d)) ⟨1, hn⟩ • v ∧
        ∀ swapped : Bool,
          C / μ ^ 2 <
            ((binaryThresholdMisclassifications
              (if swapped then swapBinaryCommunity community else community) v).card : ℝ)}
  let badCanonical : Set (FinStochasticBlock.UpperPair n → Bool) := {ω |
    ∃ d : Fin n → ℝ, (∀ i, 0 ≤ d i ∧ d i ≤ 1) ∧
      ∃ v : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector
          (FinStochasticBlock.adjacency ω + Matrix.diagonal d) hn v ∧
        ∀ swapped : Bool,
          C / μ ^ 2 <
            ((binaryThresholdMisclassifications
              (if swapped then swapBinaryCommunity canonical else canonical)
              (Real.sqrt n • v)).card : ℝ)}
  have hsub : badActual ⊆ f ⁻¹' badCanonical := by
    rintro ω ⟨d, hd, v, hv, heigen, herr⟩
    let T := FinStochasticBlock.adjacency ω + Matrix.diagonal d
    let hT : T.IsHermitian :=
      (FinStochasticBlock.adjacency_hermitian ω).add (Matrix.isHermitian_diagonal d)
    let w : EuclideanSpace ℝ (Fin n) := NormedSpace.normalize v
    have hw : SpectralClustering.IsSecondOrderedEigenvector T hn w := by
      apply (SpectralClustering.isSecondOrderedEigenvector_iff_unit_eigenvector
        T hT hn w).mpr
      refine ⟨NormedSpace.norm_normalize_eq_one_iff.mpr hv, ?_⟩
      change T.toEuclideanLin (‖v‖⁻¹ • v) = _
      rw [map_smul, heigen, smul_comm]
      rfl
    let d' : Fin n → ℝ := d ∘ e.symm
    have hmatrix : Matrix.reindex e e T =
        FinStochasticBlock.adjacency (f ω) + Matrix.diagonal d' := by
      change (FinStochasticBlock.adjacency ω).submatrix e.symm e.symm +
        (Matrix.diagonal d).submatrix e.symm e.symm =
        FinStochasticBlock.adjacency (FinStochasticBlock.sampleRelabel e ω) +
          Matrix.diagonal (d ∘ e.symm)
      rw [Matrix.submatrix_diagonal_equiv]
      rw [← FinStochasticBlock.adjacency_sampleRelabel e ω]
      rfl
    refine ⟨d', (fun i => hd (e.symm i)), L w, ?_, ?_⟩
    · have h := (SpectralClustering.isSecondOrderedEigenvector_reindex_iff
        hn e T w).mp hw
      simpa only [hmatrix] using h
    · intro swapped
      have hswap : ∀ i,
          (if swapped then swapBinaryCommunity canonical else canonical) (e i) =
            (if swapped then swapBinaryCommunity community else community) i := by
        intro i
        cases swapped <;> simp [swapBinaryCommunity, hlabels]
      have hscore : ∀ i, (Real.sqrt n • L w) (e i) = (Real.sqrt n • w) i := by
        intro i
        change Real.sqrt (n : ℝ) * w (e.symm (e i)) = Real.sqrt (n : ℝ) * w i
        rw [Equiv.symm_apply_apply]
      have hc := card_binaryThresholdMisclassifications_eq_of_equiv
        (if swapped then swapBinaryCommunity community else community)
        (if swapped then swapBinaryCommunity canonical else canonical)
        e hswap (Real.sqrt n • w) (Real.sqrt n • L w) hscore
      rw [← hc]
      let labels := if swapped then swapBinaryCommunity community else community
      have hnpos : (0 : ℝ) < (n : ℕ) := by exact_mod_cast (by omega : 0 < n)
      have hnorm : 0 < ‖v‖ := norm_pos_iff.mpr hv
      have hraw := binaryThresholdMisclassifications_pos_smul labels
        (fun i => w i) ‖v‖ hnorm
      have hscaled := binaryThresholdMisclassifications_pos_smul labels
        (fun i => w i) (Real.sqrt (n : ℕ)) (Real.sqrt_pos.mpr hnpos)
      have hpoint : ‖v‖ • (fun i => w i) = (fun i => v i) := by
        funext i
        exact congrArg (fun z : EuclideanSpace ℝ (Fin n) => z i)
          (NormedSpace.norm_smul_normalize v)
      rw [hpoint] at hraw
      change C / μ ^ 2 <
        ((binaryThresholdMisclassifications labels
          (Real.sqrt n • (fun i => w i))).card : ℝ)
      rw [hscaled, ← hraw]
      exact herr swapped
  have htail' : (FinStochasticBlock.measure canonical θ).real badCanonical ≤
      4 * Real.exp (-(n : ℝ)) := htail k hn θ hq hpq
  change (FinStochasticBlock.measure community θ).real badActual ≤
    4 * Real.exp (-(n : ℝ))
  calc
    (FinStochasticBlock.measure community θ).real badActual ≤
        (FinStochasticBlock.measure community θ).real (f ⁻¹' badCanonical) :=
      measureReal_mono hsub
    _ = ((FinStochasticBlock.measure community θ).map f).real badCanonical :=
      (map_measureReal_apply f.measurable (Set.toFinite _).measurableSet).symm
    _ = (FinStochasticBlock.measure canonical θ).real badCanonical := by
      rw [FinStochasticBlock.measure_map_sampleRelabel community canonical e hlabels θ]
    _ ≤ 4 * Real.exp (-(n : ℝ)) := htail'

end NumStability.HDP.Contract.BalancedFinSBMRecovery
