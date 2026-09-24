import ComputationalMathematics.HDP.Vector.NormConcentration

/-!
# Expected Euclidean-norm foundations

Reusable expectation identities and rates derived from Euclidean-norm
concentration.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.NormConcentration

open NumStability.HDP.Scalar

theorem expectationEuclideanNorm_sqrt_sub_le_div_sqrt :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) →
          (∀ i, SubGaussian.PsiTwoGauge μ (X i) < ∞) →
            (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
              ProbabilityTheory.iIndepFun X μ →
                0 ≤ Real.sqrt (n : ℝ) -
                    (∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ) ∧
                  Real.sqrt (n : ℝ) -
                      (∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ) ≤
                    C * (SubGaussian.psiTwoNormMax μ X) ^ 4 /
                      Real.sqrt (n : ℝ) := by
  rcases euclideanNormDeviation_psiTwoGauge with ⟨A, hA, hGauge⟩
  rcases shellProbability_and_squaredNormMean with ⟨_B, _hB, hMeanSq⟩
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
  have hn : 0 < n := Fin.pos_iff_nonempty.mpr inferInstance
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hs : 0 < s := by simpa [s] using Real.sqrt_pos.2 hnR
  have hK0 : 0 ≤ K := by
    dsimp [K]
    exact SubGaussian.psiTwoNormMax_nonneg
  have hZMeas : Measurable Z := by
    dsimp [Z, R, s, NumStability.vecNorm2, NumStability.vecNorm2Sq]
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
  have hMomentOne := hGrowth.2 1 (by norm_num : (1 : ℝ) ≤ 1)
  have hMomentTwo := hGrowth.2 2 (by norm_num : (1 : ℝ) ≤ 2)
  have hZInt : Integrable Z μ := by
    apply (MeasureTheory.integrable_norm_iff hZMeas.aestronglyMeasurable).mp
    simpa [Real.norm_eq_abs, Real.rpow_one] using hMomentOne.1
  have hZSqInt : Integrable (fun ω => Z ω ^ 2) μ := by
    simpa [Real.rpow_two, sq_abs] using hMomentTwo.1
  have hRSqInt : Integrable (fun ω => R ω ^ 2) μ := by
    have hExpanded : Integrable
        (fun ω => Z ω ^ 2 + 2 * s * Z ω + s ^ 2) μ :=
      (hZSqInt.add (hZInt.const_mul (2 * s))).add (integrable_const _)
    apply hExpanded.congr
    filter_upwards [] with ω
    dsimp [Z]
    ring
  have hRInt : Integrable R μ := by
    have hExpanded : Integrable (fun ω => Z ω + s) μ :=
      hZInt.add (integrable_const _)
    apply hExpanded.congr
    filter_upwards [] with ω
    simp [Z]
  have hMeanRSq : (∫ ω, R ω ^ 2 ∂μ) = n := by
    have h := (hMeanSq X hMeas hFinite hSecond hIndep).2
    simpa only [R, NumStability.vecNorm2_sq] using h
  have hZSqIntegral :
      (∫ ω, Z ω ^ 2 ∂μ) =
        2 * s * (s - ∫ ω, R ω ∂μ) := by
    have hPoint : (fun ω => Z ω ^ 2) =
        (fun ω => R ω ^ 2) - (fun ω => 2 * s * R ω) +
          (fun _ω => s ^ 2) := by
      funext ω
      dsimp [Z]
      ring
    rw [hPoint]
    change (∫ ω, (R ω ^ 2 - 2 * s * R ω) + s ^ 2 ∂μ) = _
    calc
      (∫ ω, (R ω ^ 2 - 2 * s * R ω) + s ^ 2 ∂μ) =
          (∫ ω, R ω ^ 2 - 2 * s * R ω ∂μ) +
            (∫ _ω : Ω, s ^ 2 ∂μ) :=
        integral_add (hRSqInt.sub (hRInt.const_mul (2 * s)))
          (integrable_const _)
      _ = ((∫ ω, R ω ^ 2 ∂μ) -
            (∫ ω, 2 * s * R ω ∂μ)) + (∫ _ω : Ω, s ^ 2 ∂μ) := by
        rw [integral_sub hRSqInt (hRInt.const_mul (2 * s))]
      _ = 2 * s * (s - ∫ ω, R ω ∂μ) := by
        rw [integral_const_mul, integral_const, probReal_univ, one_smul]
        rw [hMeanRSq]
        have hsSq : s ^ 2 = n := by
          dsimp [s]
          rw [Real.sq_sqrt hnR.le]
        nlinarith [hsSq]
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
  have hZSqNonneg : 0 ≤ (∫ ω, Z ω ^ 2 ∂μ) := by
    exact integral_nonneg (fun ω => sq_nonneg (Z ω))
  constructor
  · rw [show Real.sqrt (n : ℝ) = s by rfl,
      show (fun ω => NumStability.vecNorm2 (fun i => X i ω)) = R by rfl]
    nlinarith [hZSqIntegral]
  · rw [show Real.sqrt (n : ℝ) = s by rfl,
      show (fun ω => NumStability.vecNorm2 (fun i => X i ω)) = R by rfl]
    apply (le_div_iff₀ hs).2
    have hK4 : 0 ≤ K ^ 4 := by positivity
    dsimp [C]
    nlinarith [hZSqIntegral, hZSqBound]

end NumStability.HDP.Vector.NormConcentration
