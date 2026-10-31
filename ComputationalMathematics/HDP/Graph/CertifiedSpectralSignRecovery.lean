import ComputationalMathematics.HDP.Graph.CertifiedSecondEigenvector
import ComputationalMathematics.HDP.Matrix.SymmetricOperatorNormBounded
import ComputationalMathematics.HDP.Matrix.UnitEigenvectorAlignment
import ComputationalMathematics.HDP.Vector.SignRecovery

/-!
# Sign recovery for every complete second-eigenvector certificate

One operator-norm event controls the sign error of every certified second
vector. The supplied vector may belong to a repeated perturbed eigenspace;
only the reference matrix has the stated gap. These are ordinary structural
results and select no source-specific diagonal, label or vector-choice policy.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Graph

/-- Compose the existing arbitrary-unit alignment and squared-error APIs for
any complete second-eigenvector certificate. -/
theorem exists_sign_card_signDisagreements_le_of_certified_second_eigenvector {n : ℕ} (hn : 1 < n) (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (C μ : ℝ)
    (hC : 0 ≤ C) (hμ : 0 < μ)
    (hgap : ∀ j : Fin n, j ≠ ⟨1, hn⟩ →
      μ * (n : ℝ) ≤ |NumStability.hermitianOrderedEigenvalue hS ⟨1, hn⟩ -
        NumStability.hermitianOrderedEigenvalue hS j|)
    (hnoise : NumStability.realMatrixOperatorNorm (S - T) ≤ C * Real.sqrt n)
    (hsignal : ∀ i, |(Real.sqrt n •
      NumStability.hermitianOrderedEigenbasis hS ⟨1, hn⟩) i| = 1)
    (v : EuclideanSpace ℝ (Fin n))
    (hv : NumStability.HDP.Graph.SpectralClustering.IsSecondOrderedEigenvector T hn v) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ((NumStability.HDP.Vector.SignRecovery.signDisagreements
        (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hS ⟨1, hn⟩)
        (θ • (Real.sqrt n • v))).card : ℝ) ≤
          (2 * Real.sqrt 2 * C) ^ 2 / μ ^ 2 := by
  have hn0 : 0 < n := Nat.zero_lt_of_lt hn
  obtain ⟨hnorm, heigen⟩ := hv.spec hT
  obtain ⟨θ, hθ, hUnit⟩ :=
    NumStability.HDP.Matrix.exists_sign_unit_eigenvector_norm_sub_le_sbm_scale
      hn0 S T hS hT ⟨1, hn⟩ C μ hC hμ hgap hnoise v hnorm heigen
  have hSqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 (by exact_mod_cast hn0)
  have hscaled : ‖Real.sqrt n • NumStability.hermitianOrderedEigenbasis hS ⟨1, hn⟩ -
      θ • (Real.sqrt n • v)‖ ≤ (2 * Real.sqrt 2 * C) / μ := by
    calc
      _ = Real.sqrt n * ‖NumStability.hermitianOrderedEigenbasis hS ⟨1, hn⟩ -
          θ • v‖ := by
        rw [show Real.sqrt n • NumStability.hermitianOrderedEigenbasis hS ⟨1, hn⟩ -
          θ • (Real.sqrt n • v) = Real.sqrt n •
            (NumStability.hermitianOrderedEigenbasis hS ⟨1, hn⟩ - θ • v) by
              simp [smul_sub, smul_smul, mul_comm]]
        rw [norm_smul, Real.norm_eq_abs, abs_of_pos hSqrt]
      _ ≤ Real.sqrt n * (2 * Real.sqrt 2 * C / (μ * Real.sqrt n)) :=
        mul_le_mul_of_nonneg_left hUnit hSqrt.le
      _ = (2 * Real.sqrt 2 * C) / μ := by
        field_simp [ne_of_gt hSqrt, ne_of_gt hμ]
  exact ⟨θ, hθ,
    NumStability.HDP.Vector.SignRecovery.card_signDisagreements_le_div_sq_of_euclideanNorm_le
      _ _ hsignal (2 * Real.sqrt 2 * C) μ (by positivity) hμ hscaled⟩

/-- The probability of any certified second vector violating the sign-error
bound is controlled by the same centered bounded symmetric-noise event. The
constant is chosen before the dimensions, matrices, gap and vector. -/
theorem exists_certified_spectral_sign_recovery_tail_of_symmetric_centered_bounded_noise :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {n : ℕ} (hn2 : 2 ≤ n)
        (D : Matrix (Fin n) (Fin n) ℝ)
        (A : Ω → Matrix (Fin n) (Fin n) ℝ)
        (hD : D.IsHermitian) (_hA : ∀ ω, (A ω).IsHermitian)
        (μ : ℝ) (_hμ : 0 < μ),
        (∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
          μ * (n : ℝ) ≤
            |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn2⟩ -
              NumStability.hermitianOrderedEigenvalue hD j|) →
        (∀ i, |(Real.sqrt n •
            NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩) i| = 1) →
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
            ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
              C / μ ^ 2 <
                ((NumStability.HDP.Vector.SignRecovery.signDisagreements
                  (Real.sqrt n •
                    NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
                  (θ • (Real.sqrt n • v))).card : ℝ)} ≤
          4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C₀, hC₀, hTail⟩ :=
    NumStability.HDP.Matrix.exists_symmetric_operatorNorm_sqrt_tail_of_independent_centered_bounded_entries
  let B : ℝ := 2 * Real.sqrt 2 * C₀
  refine ⟨B ^ 2, sq_pos_of_pos (by dsimp [B]; positivity), ?_⟩
  intro Ω instΩ P instP n hn2 D A hD hA μ hμ hgap hu hSym hMeas hBound hMean hIndep
  have hn : 0 < n := lt_of_lt_of_le (by norm_num) hn2
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  have hNoiseTail := hTail hn (fun ω => D - A ω) hSym hMeas hBound hMean hIndep
  have hSubset :
      {ω | ∃ v : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector (A ω) hn2 v ∧
        ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
          B ^ 2 / μ ^ 2 <
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              (Real.sqrt n • NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
              (θ • (Real.sqrt n • v))).card : ℝ)} ⊆
        {ω | C₀ * Real.sqrt n < NumStability.realMatrixOperatorNorm (D - A ω)} := by
    rintro ω ⟨v, hv, hBad⟩
    by_contra hNotNoise
    have hNoise : NumStability.realMatrixOperatorNorm (D - A ω) ≤ C₀ * Real.sqrt n :=
      le_of_not_gt hNotNoise
    obtain ⟨θ, hθ, hCard⟩ :=
      exists_sign_card_signDisagreements_le_of_certified_second_eigenvector
        hn2 D (A ω) hD (hA ω) C₀ μ hC₀.le hμ hgap hNoise hu v hv
    exact (not_lt_of_ge hCard) (hBad θ hθ)
  exact (measureReal_mono hSubset (measure_ne_top P _)).trans hNoiseTail

end NumStability.HDP.Graph
