import ComputationalMathematics.HDP.Graph.CertifiedSecondEigenvector
import ComputationalMathematics.HDP.Matrix.SymmetricOperatorNormBounded
import ComputationalMathematics.HDP.Matrix.TwoUnitEigenvectorAlignment
import ComputationalMathematics.HDP.Vector.SignRecovery

/-!
# Sign recovery with a supplied reference eigenvector

The reference signal is a supplied complete second-eigenvector certificate.
Its scaled coordinates have absolute value one. The existing two-unit
alignment and common operator-norm event control every supplied perturbed
certificate; no source-specific labels or eigenvector selection are chosen.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Graph

/-- A supplied reference certificate and any corresponding perturbed
certificate satisfy the same sign-error bound. -/
theorem exists_sign_card_signDisagreements_le_of_two_certified_second_eigenvectors
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
    (hsignal : ∀ i, |(Real.sqrt n • u) i| = 1) :
    ∃ θ : ℝ, (θ = -1 ∨ θ = 1) ∧
      ((NumStability.HDP.Vector.SignRecovery.signDisagreements
        (Real.sqrt n • u) (θ • (Real.sqrt n • v))).card : ℝ) ≤
          (2 * Real.sqrt 2 * C) ^ 2 / μ ^ 2 := by
  have hn0 : 0 < n := Nat.zero_lt_of_lt hn
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn0
  have hSqrt : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 hnR
  obtain ⟨hunorm, hSu⟩ := hu.spec hS
  obtain ⟨hvnorm, hTv⟩ := hv.spec hT
  obtain ⟨θ, hθ, hbound⟩ :=
    NumStability.HDP.Matrix.exists_sign_unit_eigenvectors_norm_sub_le
      S T hS hT ⟨1, hn⟩ (μ * (n : ℝ)) (mul_pos hμ hnR)
      hgap u v hunorm hvnorm hSu hTv
  have hUnit : ‖u - θ • v‖ ≤ 2 * Real.sqrt 2 * C / (μ * Real.sqrt n) := by
    apply hbound.trans
    calc
      2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm (S - T) /
            (μ * (n : ℝ)) ≤
          2 * Real.sqrt 2 * (C * Real.sqrt n) / (μ * (n : ℝ)) := by
        gcongr
      _ = 2 * Real.sqrt 2 * C / (μ * Real.sqrt n) := by
        have hsquare : Real.sqrt (n : ℝ) ^ 2 = (n : ℝ) := Real.sq_sqrt hnR.le
        field_simp [hμ.ne', hSqrt.ne']
        nlinarith
  have hscaled : ‖Real.sqrt n • u - θ • (Real.sqrt n • v)‖ ≤
      (2 * Real.sqrt 2 * C) / μ := by
    calc
      _ = Real.sqrt n * ‖u - θ • v‖ := by
        rw [show Real.sqrt n • u - θ • (Real.sqrt n • v) =
          Real.sqrt n • (u - θ • v) by simp [smul_sub, smul_smul, mul_comm]]
        rw [norm_smul, Real.norm_eq_abs, abs_of_pos hSqrt]
      _ ≤ Real.sqrt n * (2 * Real.sqrt 2 * C / (μ * Real.sqrt n)) :=
        mul_le_mul_of_nonneg_left hUnit hSqrt.le
      _ = (2 * Real.sqrt 2 * C) / μ := by
        field_simp [ne_of_gt hSqrt, ne_of_gt hμ]
  exact ⟨θ, hθ,
    NumStability.HDP.Vector.SignRecovery.card_signDisagreements_le_div_sq_of_euclideanNorm_le
      _ _ hsignal (2 * Real.sqrt 2 * C) μ (by positivity) hμ hscaled⟩

/-- A universal constant controls every perturbed certificate relative to
any supplied binary reference certificate on the common bounded-noise event. -/
theorem exists_arbitrary_reference_spectral_sign_recovery_tail_of_symmetric_centered_bounded_noise :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {n : ℕ} (hn2 : 2 ≤ n)
        (D : Matrix (Fin n) (Fin n) ℝ)
        (A : Ω → Matrix (Fin n) (Fin n) ℝ)
        (hD : D.IsHermitian) (_hA : ∀ ω, (A ω).IsHermitian)
        (μ : ℝ) (_hμ : 0 < μ)
        (u : EuclideanSpace ℝ (Fin n))
        (_hu : SpectralClustering.IsSecondOrderedEigenvector D hn2 u),
        (∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
          μ * (n : ℝ) ≤ |NumStability.hermitianOrderedEigenvalue hD ⟨1, hn2⟩ -
            NumStability.hermitianOrderedEigenvalue hD j|) →
        (∀ i, |(Real.sqrt n • u) i| = 1) →
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
                  (Real.sqrt n • u) (θ • (Real.sqrt n • v))).card : ℝ)} ≤
          4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C₀, hC₀, hTail⟩ :=
    NumStability.HDP.Matrix.exists_symmetric_operatorNorm_sqrt_tail_of_independent_centered_bounded_entries
  let B : ℝ := 2 * Real.sqrt 2 * C₀
  refine ⟨B ^ 2, sq_pos_of_pos (by dsimp [B]; positivity), ?_⟩
  intro Ω instΩ P instP n hn2 D A hD hA μ hμ u hu hgap hsignal hSym hMeas hBound hMean hIndep
  have hn : 0 < n := lt_of_lt_of_le (by norm_num) hn2
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  have hNoiseTail := hTail hn (fun ω => D - A ω) hSym hMeas hBound hMean hIndep
  have hSubset :
      {ω | ∃ v : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector (A ω) hn2 v ∧
        ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
          B ^ 2 / μ ^ 2 <
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              (Real.sqrt n • u) (θ • (Real.sqrt n • v))).card : ℝ)} ⊆
        {ω | C₀ * Real.sqrt n < NumStability.realMatrixOperatorNorm (D - A ω)} := by
    rintro ω ⟨v, hv, hBad⟩
    by_contra hNotNoise
    have hNoise : NumStability.realMatrixOperatorNorm (D - A ω) ≤ C₀ * Real.sqrt n :=
      le_of_not_gt hNotNoise
    obtain ⟨θ, hθ, hCard⟩ :=
      exists_sign_card_signDisagreements_le_of_two_certified_second_eigenvectors
        hn2 D (A ω) hD (hA ω) C₀ μ hC₀.le hμ hgap hNoise u v hu hv hsignal
    exact (not_lt_of_ge hCard) (hBad θ hθ)
  exact (measureReal_mono hSubset (measure_ne_top P _)).trans hNoiseTail

end NumStability.HDP.Graph
