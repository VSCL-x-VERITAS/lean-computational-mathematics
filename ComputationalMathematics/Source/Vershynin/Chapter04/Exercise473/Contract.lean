import ComputationalMathematics.HDP.Vector.CovarianceEstimationBound

/-!
# Vershynin Chapter 4, Exercise 4.7.3
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.7.3: the covariance-estimation error obeys the
stated `n+u` high-probability bound.  As in Theorem 4.7.1, the contract uses
the proof's whitened representation `Xᵢ = B Zᵢ`, allowing singular `B`. -/
theorem hdp_04_exercise_4_7_3 :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ)
          (B Sigma : Matrix (Fin n) (Fin n) ℝ)
          (SigmaM : Ω → Matrix (Fin n) (Fin n) ℝ) {K : ℝ},
        1 ≤ K →
        (∀ i j, Measurable (fun ω ↦ A ω i j)) →
        (∀ i j, MemLp (fun ω ↦ A ω i j) 2 μ) →
        (∀ i, NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (fun j ω ↦ A ω i j)) →
        (∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
          (fun j ω ↦ A ω i j) ≤ ENNReal.ofReal K) →
        iIndepFun (fun i ω ↦ fun j ↦ A ω i j) μ →
        Sigma = B * B.transpose →
        (∀ ω, SigmaM ω = B *
          ((m : ℝ)⁻¹ • ((A ω).transpose * A ω)) * B.transpose) →
        ∀ {u : ℝ}, 0 ≤ u →
        μ.real {ω |
          C * K ^ 2 *
              (Real.sqrt (((n : ℝ) + u) / (m : ℝ)) +
                ((n : ℝ) + u) / (m : ℝ)) *
              NumStability.realMatrixOperatorNorm Sigma <
            NumStability.realMatrixOperatorNorm (SigmaM ω - Sigma)} ≤
          2 * Real.exp (-u) := by
  rcases
      NumStability.HDP.Vector.Covariance.exists_sampleCovariance_error_tail_of_whitened_rows with
    ⟨C, hC, htail⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ m n hm hn A B Sigma SigmaM K hK hMeas hLp hIso hPsi hIndep
    hSigma hSigmaM u hu
  exact htail hm hn A B Sigma SigmaM (lt_of_lt_of_le zero_lt_one hK)
    hMeas hLp hIso hPsi hIndep hSigma hSigmaM hu

end NumStability.HDP.Contract
