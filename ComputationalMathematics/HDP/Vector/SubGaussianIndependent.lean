import ComputationalMathematics.HDP.Vector.SubGaussian

/-!
# Sub-Gaussian vectors with independent coordinates

This module lifts the intrinsic scalar `ψ₂` independent-sum estimate to
finite linear marginals and then to the unit-sphere supremum norm of a random
vector.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Vector.SubGaussian

/-- Every linear marginal of a centered independent sub-Gaussian coordinate
family is sub-Gaussian, with its squared scalar `ψ₂` norm controlled by
the coordinate maximum and the squared Euclidean coefficient norm. -/
theorem independentCenteredCoordinates_linearMarginalPsiTwo :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} [Nonempty (Fin n)]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : Fin n → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
        ∀ u : Fin n → ℝ,
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
              (NumStability.HDP.Vector.linearMarginal X u) ∧
            (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                (NumStability.HDP.Vector.linearMarginal X u)).toReal ^ 2 ≤
              C * (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 *
                NumStability.vecNorm2Sq u := by
  rcases NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianSumPsiTwo with
    ⟨C, hC, hSum⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ n instn μ instμ X hSub hCenter hIndep u
  let Y : Fin n → Ω → ℝ := fun i ω => u i * X i ω
  have hYSub : ∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (Y i) := by
    intro i
    apply (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
      (μ := μ) (X := Y i)).2
    by_cases hui : u i = 0
    · simp [Y, hui, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
        NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero]
    · have hXFinite :=
        (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
          (μ := μ) (X := X i)).1 (hSub i)
      rw [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
        show Y i = (fun ω => u i * X i ω) by rfl,
        NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero hui]
      exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top (by
        simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using hXFinite)
  have hYCenter : ∀ i, Integrable (Y i) μ ∧ (∫ ω, Y i ω ∂μ) = 0 := by
    intro i
    refine ⟨by simpa [Y] using (hCenter i).1.const_mul (u i), ?_⟩
    simp [Y, integral_const_mul, (hCenter i).2]
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => u i * x) (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using h
  obtain ⟨hYSumSub, hYSumBound⟩ := hSum hYSub hYCenter hIndepY
  have hMarginal : (fun ω => ∑ i, Y i ω) =
      NumStability.HDP.Vector.linearMarginal X u := by
    funext ω
    simp only [Y, NumStability.HDP.Vector.linearMarginal]
    apply Finset.sum_congr rfl
    intro i _
    ring
  refine ⟨by simpa [hMarginal] using hYSumSub, ?_⟩
  rw [← hMarginal]
  calc
    (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (fun ω => ∑ i, Y i ω)).toReal ^ 2 ≤
        C * ∑ i, (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (Y i)).toReal ^ 2 := hYSumBound
    _ ≤ C * (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 *
        NumStability.vecNorm2Sq u := by
      have hCnonneg : 0 ≤ C := le_trans (by norm_num) hC
      rw [mul_assoc]
      apply mul_le_mul_of_nonneg_left _ hCnonneg
      unfold NumStability.vecNorm2Sq
      rw [Finset.mul_sum]
      apply Finset.sum_le_sum
      intro i _
      have hNormMax :=
        NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_toReal_le_max
          (μ := μ) (X := X) i
      have hSq :
          (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i)).toReal ^ 2 ≤
            (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 := by
        nlinarith [ENNReal.toReal_nonneg
          (a := NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i)),
          NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
            (μ := μ) (X := X)]
      have hYNorm :
          (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (Y i)).toReal =
            |u i| *
              (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ (X i)).toReal := by
        by_cases hui : u i = 0
        · simp [Y, hui, NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
            NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero]
        · rw [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm,
            show Y i = (fun ω => u i * X i ω) by rfl,
            NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero hui,
            ENNReal.toReal_mul, ENNReal.toReal_ofReal (abs_nonneg (u i))]
          rfl
      rw [hYNorm, mul_pow, sq_abs]
      simpa [mul_comm] using
        (mul_le_mul_of_nonneg_left hSq (sq_nonneg (u i)))

/-- A centered random vector with independent sub-Gaussian coordinates is
sub-Gaussian, and its vector `ψ₂` norm is bounded by an absolute constant
times the largest coordinate `ψ₂` norm. -/
theorem independentCenteredCoordinates_vectorSubGaussian :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} [Nonempty (Fin n)]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : Fin n → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
          IsSubGaussian μ X ∧
            PsiTwoNorm μ X ≤
              ENNReal.ofReal
                (C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) := by
  rcases independentCenteredCoordinates_linearMarginalPsiTwo with
    ⟨C, hC, hMarginal⟩
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ n instn μ instμ X hSub hCenter hIndep
  have hAll := hMarginal hSub hCenter hIndep
  refine ⟨fun u => (hAll u).1, ?_⟩
  unfold PsiTwoNorm
  apply iSup_le
  intro u
  have hU := hAll u.1
  have hFinite :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal X u.1) ≠ ∞ :=
    ne_of_lt
      ((NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
        (μ := μ) (X := NumStability.HDP.Vector.linearMarginal X u.1)).1 hU.1)
  apply (ENNReal.toReal_le_toReal hFinite ENNReal.ofReal_ne_top).mp
  have hK : 0 ≤ NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
      (μ := μ) (X := X)
  have hCnonneg : 0 ≤ C := le_trans (by norm_num) hC
  have hCK : 0 ≤ C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X :=
    mul_nonneg hCnonneg hK
  rw [ENNReal.toReal_ofReal hCK]
  have hUnitSq : NumStability.vecNorm2Sq u.1 = 1 := by
    rw [← NumStability.vecNorm2_sq, u.2]
    norm_num
  have hSq :
      (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (NumStability.HDP.Vector.linearMarginal X u.1)).toReal ^ 2 ≤
        C * (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 := by
    simpa [hUnitSq] using hU.2
  have hScaleSq :
      C * (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 ≤
        (C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 := by
    have hFactor :
        0 ≤ C * (C - 1) *
          (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 :=
      mul_nonneg (mul_nonneg hCnonneg (sub_nonneg.mpr hC)) (sq_nonneg _)
    nlinarith
  exact (sq_le_sq₀ ENNReal.toReal_nonneg hCK).mp (hSq.trans hScaleSq)

end NumStability.HDP.Vector.SubGaussian
