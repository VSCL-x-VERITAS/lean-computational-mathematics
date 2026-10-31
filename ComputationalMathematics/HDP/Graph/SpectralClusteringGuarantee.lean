import ComputationalMathematics.HDP.Matrix.EigenvectorPerturbation
import ComputationalMathematics.HDP.Matrix.SymmetricOperatorNormBounded
import ComputationalMathematics.HDP.Vector.SignRecovery

/-!
# Probabilistic sign recovery by spectral clustering

This module composes a bounded symmetric-noise tail, an eigengap perturbation
bound, and the deterministic sign-disagreement estimate.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Graph

/-- Under the structural properties used by the stochastic-block argument,
the sign partition from the observed second eigenvector makes only
`O(μ⁻²)` errors outside an event of probability `4 exp (-n)`. -/
theorem exists_spectral_sign_recovery_tail_of_symmetric_centered_bounded_noise :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {n : ℕ} (hn2 : 2 ≤ n)
        (D : Matrix (Fin n) (Fin n) ℝ)
        (A : Ω → Matrix (Fin n) (Fin n) ℝ)
        (hD : D.IsHermitian) (hA : ∀ ω, (A ω).IsHermitian)
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
          ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
            C / μ ^ 2 <
              ((NumStability.HDP.Vector.SignRecovery.signDisagreements
                (Real.sqrt n •
                  NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
                (θ • (Real.sqrt n •
                  NumStability.hermitianOrderedEigenbasis (hA ω)
                    ⟨1, hn2⟩))).card : ℝ)} ≤
          4 * Real.exp (-(n : ℝ)) := by
  rcases
      NumStability.HDP.Matrix.exists_symmetric_operatorNorm_sqrt_tail_of_independent_centered_bounded_entries with
    ⟨C₀, hC₀, hTail⟩
  let B : ℝ := 2 * Real.sqrt 2 * C₀
  refine ⟨B ^ 2, sq_pos_of_pos (by dsimp [B]; positivity), ?_⟩
  intro Ω instΩ P instP n hn2 D A hD hA μ hμ hgap hu hSym hMeas hBound
    hMean hIndep
  have hn : 0 < n := lt_of_lt_of_le (by norm_num) hn2
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  have hNoiseTail := hTail hn (fun ω => D - A ω) hSym hMeas hBound hMean hIndep
  have hB : 0 ≤ B := by
    dsimp [B]
    positivity
  have hSubset :
      {ω |
        ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
          B ^ 2 / μ ^ 2 <
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
              (θ • (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, hn2⟩))).card : ℝ)} ⊆
        {ω | C₀ * Real.sqrt n <
          NumStability.realMatrixOperatorNorm (D - A ω)} := by
    intro ω hBad
    by_contra hNotNoise
    have hNoise : NumStability.realMatrixOperatorNorm (D - A ω) ≤
        C₀ * Real.sqrt n := le_of_not_gt hNotNoise
    obtain ⟨θ, hθ, hUnit⟩ :=
      NumStability.HDP.Matrix.exists_sign_orderedEigenvectors_norm_sub_le_sbm_scale
        hn D (A ω) hD (hA ω) ⟨1, hn2⟩ C₀ μ hC₀.le hμ hgap hNoise
    have hSqrt : 0 < Real.sqrt (n : ℝ) :=
      Real.sqrt_pos.2 (by exact_mod_cast hn)
    have hScaled :
        ‖Real.sqrt n •
              NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
            θ • (Real.sqrt n •
              NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩)‖ ≤
          2 * Real.sqrt 2 * C₀ / μ := by
      calc
        ‖Real.sqrt n •
              NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
            θ • (Real.sqrt n •
              NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩)‖ =
            Real.sqrt n *
              ‖NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
                θ • NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, hn2⟩‖ := by
          rw [show
            Real.sqrt n •
                  NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
                θ • (Real.sqrt n •
                  NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩) =
              Real.sqrt n •
                (NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩ -
                  θ • NumStability.hermitianOrderedEigenbasis (hA ω)
                    ⟨1, hn2⟩) by
              simp [smul_sub, smul_smul, mul_comm]]
          rw [norm_smul, Real.norm_eq_abs, abs_of_pos hSqrt]
        _ ≤ Real.sqrt n *
            (2 * Real.sqrt 2 * C₀ / (μ * Real.sqrt n)) :=
          mul_le_mul_of_nonneg_left hUnit hSqrt.le
        _ = 2 * Real.sqrt 2 * C₀ / μ := by
          field_simp [ne_of_gt hSqrt, ne_of_gt hμ]
    have hCard :=
      NumStability.HDP.Vector.SignRecovery.card_signDisagreements_le_div_sq_of_euclideanNorm_le
        (Real.sqrt n •
          NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
        (θ • (Real.sqrt n •
          NumStability.hermitianOrderedEigenbasis (hA ω) ⟨1, hn2⟩))
        hu B μ hB hμ (by simpa [B] using hScaled)
    exact (not_lt_of_ge hCard) (hBad θ hθ)
  exact (measureReal_mono hSubset (measure_ne_top P _)).trans hNoiseTail

/-- Source-scaled stochastic-block corollary.  The second signal eigenvalue is
separated by `min ((p-q)/2) q * n`, while the theorem's displayed error scale
uses `min q (p-q)`.  These quantities differ by at most a factor of two, which
is absorbed into the absolute constant. -/
theorem exists_spectral_sign_recovery_tail_of_stochastic_block_gap :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
        [IsProbabilityMeasure P] {n : ℕ} (hn2 : 2 ≤ n)
        (D : Matrix (Fin n) (Fin n) ℝ)
        (A : Ω → Matrix (Fin n) (Fin n) ℝ)
        (hD : D.IsHermitian) (hA : ∀ ω, (A ω).IsHermitian)
        (p q : ℝ) (_hq : 0 < q) (_hpq : q < p),
        (∀ j : Fin n, j ≠ ⟨1, hn2⟩ →
          min ((p - q) / 2) q * (n : ℝ) ≤
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
          ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
            C / (min q (p - q)) ^ 2 <
              ((NumStability.HDP.Vector.SignRecovery.signDisagreements
                (Real.sqrt n •
                  NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
                (θ • (Real.sqrt n •
                  NumStability.hermitianOrderedEigenbasis (hA ω)
                    ⟨1, hn2⟩))).card : ℝ)} ≤
          4 * Real.exp (-(n : ℝ)) := by
  rcases exists_spectral_sign_recovery_tail_of_symmetric_centered_bounded_noise with
    ⟨C₀, hC₀, htail⟩
  refine ⟨4 * C₀, by positivity, ?_⟩
  intro Ω _ P _ n hn2 D A hD hA p q hq hpq hgap hu hSym hMeas hBound
    hMean hIndep
  let signal : ℝ := min q (p - q)
  let gap : ℝ := min ((p - q) / 2) q
  have hpqPos : 0 < p - q := sub_pos.mpr hpq
  have hsignal : 0 < signal := by
    dsimp [signal]
    exact lt_min hq hpqPos
  have hgapPos : 0 < gap := by
    dsimp [gap]
    exact lt_min (half_pos hpqPos) hq
  have hcompare : signal ≤ 2 * gap := by
    dsimp [signal, gap]
    simp only [min_def]
    split <;> split <;> linarith
  have hsquare : signal ^ 2 ≤ 4 * gap ^ 2 := by
    have hprod : 0 ≤ (2 * gap - signal) * (2 * gap + signal) :=
      mul_nonneg (sub_nonneg.mpr hcompare)
        (add_nonneg (mul_nonneg (by norm_num) hgapPos.le) hsignal.le)
    nlinarith
  have hthreshold : C₀ / gap ^ 2 ≤ (4 * C₀) / signal ^ 2 := by
    rw [div_le_div_iff₀ (sq_pos_of_pos hgapPos) (sq_pos_of_pos hsignal)]
    nlinarith [mul_le_mul_of_nonneg_left hsquare hC₀.le]
  have hsource := htail hn2 D A hD hA gap hgapPos hgap hu hSym hMeas hBound
    hMean hIndep
  have hsubset :
      {ω |
        ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
          (4 * C₀) / signal ^ 2 <
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
              (θ • (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, hn2⟩))).card : ℝ)} ⊆
      {ω |
        ∀ θ : ℝ, (θ = -1 ∨ θ = 1) →
          C₀ / gap ^ 2 <
            ((NumStability.HDP.Vector.SignRecovery.signDisagreements
              (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis hD ⟨1, hn2⟩)
              (θ • (Real.sqrt n •
                NumStability.hermitianOrderedEigenbasis (hA ω)
                  ⟨1, hn2⟩))).card : ℝ)} := by
    intro ω hω θ hθ
    exact hthreshold.trans_lt (hω θ hθ)
  have hmono := measureReal_mono hsubset (measure_ne_top P _)
  simpa [signal, gap] using hmono.trans hsource

end NumStability.HDP.Graph
