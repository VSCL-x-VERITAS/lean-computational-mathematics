import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMAllUnitClassification
import ComputationalMathematics.HDP.Vector.SignRecoveryScaling
import ComputationalMathematics.HDP.Graph.UnitEigenvectorCertificate
import Mathlib.Analysis.Normed.Module.Normalize

/-!
# Classification by all nonzero second eigenvectors

Normalizing a nonzero second eigenvector preserves its threshold classifier.
The common all-unit event therefore controls all nonzero second eigenvectors
under the same actual balanced Bernoulli law and with the same constant.
No book-source correspondence is asserted.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery

open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

/-- The same absolute tail controls every nonzero actual second eigenvector,
with arbitrary length, orientation and multiplicity. -/
theorem exists_all_balanced_nonzero_binary_classification_tail :
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters)
      (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let P := FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ v : EuclideanSpace ℝ (Fin n), v ≠ 0 ∧
          (FinStochasticBlock.adjacency ω).toEuclideanLin v =
            NumStability.hermitianOrderedEigenvalue
              (FinStochasticBlock.adjacency_hermitian ω) ⟨1, hn⟩ • v ∧
          ∀ swapped : Bool,
            C / μ ^ 2 <
              ((binaryThresholdMisclassifications
                (if swapped then swapBinaryCommunity community else community)
                v).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, htail⟩ := exists_all_balanced_unit_binary_classification_tail
  refine ⟨C, hC, ?_⟩
  intro k hn θ community hbalanced hq hpq
  dsimp only
  refine (measureReal_mono ?_).trans (htail k hn θ community hbalanced hq hpq)
  rintro ω ⟨v, hv, heigen, herr⟩
  let w : EuclideanSpace ℝ (Fin (2 * k)) := NormedSpace.normalize v
  refine ⟨w, ?_, ?_⟩
  · apply (SpectralClustering.isSecondOrderedEigenvector_iff_unit_eigenvector
      (FinStochasticBlock.adjacency ω) (FinStochasticBlock.adjacency_hermitian ω)
      hn w).mpr
    refine ⟨NormedSpace.norm_normalize_eq_one_iff.mpr hv, ?_⟩
    change (FinStochasticBlock.adjacency ω).toEuclideanLin (‖v‖⁻¹ • v) = _
    rw [map_smul, heigen, smul_comm]
    rfl
  · intro swapped
    let labels := if swapped then swapBinaryCommunity community else community
    have hnpos : (0 : ℝ) < (2 * k : ℕ) := by exact_mod_cast (by omega : 0 < 2 * k)
    have hnorm : 0 < ‖v‖ := norm_pos_iff.mpr hv
    have hraw := binaryThresholdMisclassifications_pos_smul labels
      (fun i => w i) ‖v‖ hnorm
    have hscaled := binaryThresholdMisclassifications_pos_smul labels
      (fun i => w i) (Real.sqrt (2 * k : ℕ)) (Real.sqrt_pos.mpr hnpos)
    have hpoint : ‖v‖ • (fun i => w i) = (fun i => v i) := by
      funext i
      exact congrArg (fun z : EuclideanSpace ℝ (Fin (2 * k)) => z i)
        (NormedSpace.norm_smul_normalize v)
    rw [hpoint] at hraw
    change C / min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ)) ^ 2 <
      ((binaryThresholdMisclassifications labels
        (Real.sqrt (2 * k : ℕ) • (fun i => w i))).card : ℝ)
    rw [hscaled, ← hraw]
    exact herr swapped

end NumStability.HDP.Contract.BalancedFinSBMRecovery
