import ComputationalMathematics.HDP.Vector.NormConcentration
import Mathlib.Probability.Moments.Variance

/-!
# Euclidean-norm variance foundations

Variance bounds derived from the reusable Euclidean-norm concentration API.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.NormVariance

open NumStability.HDP.Scalar

theorem varianceEuclideanNorm_le :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              iIndepFun X μ →
                variance
                    (fun ω => NumStability.vecNorm2 (fun i => X i ω)) μ ≤
                  C * (SubGaussian.psiTwoNormMax μ X) ^ 4 := by
  rcases NormConcentration.euclideanNormDeviation_psiTwoGauge with
    ⟨A, hA, hGauge⟩
  let D : ℝ := (16 * Real.exp 1 * A * Real.sqrt 2) ^ 2
  let C : ℝ := 1 + D
  have hA0 : 0 ≤ A := le_trans zero_le_one hA
  have hD0 : 0 ≤ D := sq_nonneg _
  have hC : 1 ≤ C := by dsimp [C]; linarith
  refine ⟨C, hC, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep
  let K : ℝ := SubGaussian.psiTwoNormMax μ X
  let R : Ω → ℝ := fun ω => NumStability.vecNorm2 (fun i => X i ω)
  let s : ℝ := Real.sqrt (n : ℝ)
  let Z : Ω → ℝ := fun ω => R ω - s
  have hK0 : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hRMeas : Measurable R := by
    dsimp [R, NumStability.vecNorm2, NumStability.vecNorm2Sq]
    fun_prop
  have hZMeas : Measurable Z := by
    dsimp [Z]
    fun_prop
  have hGaugeBound :
      SubGaussian.PsiTwoGauge μ Z ≤ ENNReal.ofReal (A * K ^ 2) := by
    simpa only [Z, R, s, K] using hGauge X hMeas hFinite hSecond hIndep
  have hZFinite : SubGaussian.PsiTwoGauge μ Z < ∞ :=
    hGaugeBound.trans_lt ENNReal.ofReal_lt_top
  have hGaugeRealBound :
      (SubGaussian.PsiTwoGauge μ Z).toReal ≤ A * K ^ 2 := by
    exact ENNReal.toReal_le_of_le_ofReal
      (mul_nonneg hA0 (sq_nonneg K)) hGaugeBound
  have hGrowth := SubGaussian.psiTwoGaugeToLpMomentGrowth hZMeas hZFinite
  have hMomentTwo := hGrowth.2 2 (by norm_num : (1 : ℝ) ≤ 2)
  have hZSqBound : (∫ ω, Z ω ^ 2 ∂μ) ≤ D * K ^ 4 := by
    calc
      (∫ ω, Z ω ^ 2 ∂μ) ≤
          (16 * Real.exp 1 *
              (SubGaussian.PsiTwoGauge μ Z).toReal * Real.sqrt 2) ^ 2 := by
        simpa [Real.rpow_two, sq_abs] using hMomentTwo.2
      _ ≤ (16 * Real.exp 1 * (A * K ^ 2) * Real.sqrt 2) ^ 2 := by
        gcongr
      _ = D * K ^ 4 := by
        dsimp [D]
        ring
  rw [← variance_sub_const hRMeas.aestronglyMeasurable s]
  have hVariance : variance Z μ ≤ ∫ ω, Z ω ^ 2 ∂μ := by
    simpa only [Pi.pow_apply] using
      (variance_le_expectation_sq hZMeas.aestronglyMeasurable)
  exact hVariance.trans (hZSqBound.trans (by
    dsimp [C]
    nlinarith [hD0, pow_nonneg hK0 4]))

end NumStability.HDP.Vector.NormVariance
