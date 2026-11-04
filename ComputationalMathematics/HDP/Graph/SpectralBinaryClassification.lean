import ComputationalMathematics.HDP.Graph.ArbitraryReferenceSpectralSignRecovery
import ComputationalMathematics.HDP.Vector.BinarySignBound

/-!
# Spectral binary classification with genuine label exchange

Supplied reference and perturbed certificates yield the strict-positive
classifier's error bound after an optional exchange of community names. The
existing inclusions retain zero scores. Structural signal and noise premises
are explicit; no book-specific model or eigenvector choice is selected.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Graph

/-- Transfer the supplied-reference sign-error estimate to the actual binary
threshold classifier, allowing exchange of the two community names. -/
theorem exists_label_swap_card_misclassifications_le_of_two_certified_second_eigenvectors
    {n : ℕ} (hn : 1 < n) (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (C μ : ℝ)
    (hC : 0 ≤ C) (hμ : 0 < μ)
    (hgap : ∀ j : Fin n, j ≠ ⟨1, hn⟩ →
      μ * (n : ℝ) ≤ |NumStability.hermitianOrderedEigenvalue hS ⟨1, hn⟩ -
        NumStability.hermitianOrderedEigenvalue hS j|)
    (hnoise : NumStability.realMatrixOperatorNorm (S - T) ≤ C * Real.sqrt n)
    (u v : EuclideanSpace ℝ (Fin n))
    (hu : SpectralClustering.IsSecondOrderedEigenvector S hn u)
    (hv : SpectralClustering.IsSecondOrderedEigenvector T hn v)
    (community : Fin n → Fin 2)
    (hsignal : ∀ i, (Real.sqrt n • u) i = if community i = 0 then 1 else -1) :
    ∃ swapped : Bool,
      ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
        (if swapped then NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
          else community) (Real.sqrt n • v)).card : ℝ) ≤
            (2 * Real.sqrt 2 * C) ^ 2 / μ ^ 2 := by
  have habs : ∀ i, |(Real.sqrt n • u) i| = 1 := by
    intro i
    rw [hsignal i]
    split <;> simp
  apply NumStability.HDP.Vector.SignRecovery.exists_swap_card_binaryThresholdMisclassifications_le_of_sign_disagreements
    community (Real.sqrt n • u) (Real.sqrt n • v)
    ((2 * Real.sqrt 2 * C) ^ 2 / μ ^ 2) hsignal
  exact exists_sign_card_signDisagreements_le_of_two_certified_second_eigenvectors
    hn S T hS hT C μ hC hμ hgap hnoise u v hu hv habs

/-- Every supplied perturbed certificate admits the same classifier error
bound, up to genuine label exchange, outside a common bounded-noise event. -/
theorem exists_spectral_binary_classification_tail_of_symmetric_centered_bounded_noise :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {n : ℕ} (hn2 : 2 ≤ n)
        (D : Matrix (Fin n) (Fin n) ℝ)
        (A : Ω → Matrix (Fin n) (Fin n) ℝ)
        (hD : D.IsHermitian) (_hA : ∀ ω, (A ω).IsHermitian)
        (μ : ℝ) (_hμ : 0 < μ)
        (u : EuclideanSpace ℝ (Fin n))
        (_hu : SpectralClustering.IsSecondOrderedEigenvector D hn2 u)
        (community : Fin n → Fin 2),
        (∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
          μ * (n : ℝ) ≤ |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn2⟩ -
            NumStability.hermitianOrderedEigenvalue hD j|) →
        (∀ i, (Real.sqrt n • u) i = if community i = 0 then 1 else -1) →
        (∀ ω i j, (D - A ω) i j = (D - A ω) j i) →
        (∀ i j, Measurable (fun ω => (D - A ω) i j)) →
        (∀ ω i j, |(D - A ω) i j| ≤ 1) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          (∫ ω, (D - A ω) ij.1.1 ij.1.2 ∂P) = 0) →
        iIndepFun
          (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
            fun ω => (D - A ω) ij.1.1 ij.1.2) P →
        P.real {ω |
          ∃ v : EuclideanSpace ℝ (Fin n),
            SpectralClustering.IsSecondOrderedEigenvector (A ω) hn2 v ∧
            ∀ swapped : Bool,
              C / μ ^ 2 <
                ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                  (if swapped then NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                    else community) (Real.sqrt n • v)).card : ℝ)} ≤
          4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, hTail⟩ :=
    exists_arbitrary_reference_spectral_sign_recovery_tail_of_symmetric_centered_bounded_noise
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ P instP n hn2 D A hD hA μ hμ u hu community hgap hsignal hSym hMeas hBound hMean hIndep
  have habs : ∀ i, |(Real.sqrt n • u) i| = 1 := by
    intro i
    rw [hsignal i]
    split <;> simp
  have hSignTail := hTail hn2 D A hD hA μ hμ u hu hgap habs hSym hMeas hBound hMean hIndep
  have hSubset :
      {ω | ∃ v : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector (A ω) hn2 v ∧
        ∀ swapped : Bool,
          C / μ ^ 2 <
            ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
              (if swapped then NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                else community) (Real.sqrt n • v)).card : ℝ)} ⊆
      {ω | ∃ v : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector (A ω) hn2 v ∧
        ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
          C / μ ^ 2 <
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              (Real.sqrt n • u) (θ • (Real.sqrt n • v))).card : ℝ)} := by
    rintro ω ⟨v, hv, hBad⟩
    refine ⟨v, hv, ?_⟩
    exact NumStability.HDP.Vector.SignRecovery.forall_signs_card_signDisagreements_gt_of_forall_label_swaps
      community (Real.sqrt n • u) (Real.sqrt n • v) (C / μ ^ 2) hsignal hBad
  exact (measureReal_mono hSubset (measure_ne_top P _)).trans hSignTail

end NumStability.HDP.Graph
