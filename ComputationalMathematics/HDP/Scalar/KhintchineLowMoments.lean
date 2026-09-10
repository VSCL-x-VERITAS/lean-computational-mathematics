import ComputationalMathematics.HDP.Scalar.Khintchine

/-!
# Low-moment Khintchine inequalities

This module combines the `L²` interpolation estimate from the sub-Gaussian
development with the `p = 3` case of the Khintchine inequality. It supplies
the `p = 1` bounds requested by Exercise 2.6.6.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.KhintchineLowMoments

open NumStability.HDP.Scalar.Khintchine
open NumStability.HDP.Scalar.SubGaussian

/-- An algebraic form of the extrapolation argument: if
`A ≤ L₁^(1/4) L₃^(3/4)` and `L₃ ≤ B A`, then `B⁻³ A ≤ L₁`. -/
theorem lower_of_extrapolation
    {A L1 L3 B : ℝ}
    (hA : 0 ≤ A) (hL1 : 0 ≤ L1) (hL3 : 0 ≤ L3) (hB : 0 < B)
    (hinter : A ≤ L1 ^ (1 / 4 : ℝ) * L3 ^ (3 / 4 : ℝ))
    (hupper : L3 ≤ B * A) :
    B⁻¹ ^ 3 * A ≤ L1 := by
  by_cases hAz : A = 0
  · simp [hAz, hL1]
  have hApos : 0 < A := lt_of_le_of_ne hA (Ne.symm hAz)
  have hpow := pow_le_pow_left₀ hA hinter 4
  have hquarter (x : ℝ) (hx : 0 ≤ x) :
      (x ^ (1 / 4 : ℝ)) ^ (4 : ℕ) = x := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul hx]
    norm_num
    exact Real.rpow_one x
  have hthreequarter (x : ℝ) (hx : 0 ≤ x) :
      (x ^ (3 / 4 : ℝ)) ^ (4 : ℕ) = x ^ (3 : ℕ) := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul hx]
    norm_num
    exact Real.rpow_natCast x 3
  have hA4 : A ^ 4 ≤ L1 * L3 ^ 3 := by
    calc
      A ^ 4 ≤ (L1 ^ (1 / 4 : ℝ) * L3 ^ (3 / 4 : ℝ)) ^ 4 := hpow
      _ = L1 * L3 ^ 3 := by
        rw [mul_pow, hquarter L1 hL1, hthreequarter L3 hL3]
  have hL3cube : L3 ^ 3 ≤ (B * A) ^ 3 :=
    pow_le_pow_left₀ hL3 hupper 3
  have hscaled : A ^ 4 ≤ L1 * (B * A) ^ 3 :=
    hA4.trans (mul_le_mul_of_nonneg_left hL3cube hL1)
  have hcancel : A ^ 3 * A ≤ A ^ 3 * (L1 * B ^ 3) := by
    calc
      A ^ 3 * A = A ^ 4 := by ring
      _ ≤ L1 * (B * A) ^ 3 := hscaled
      _ = A ^ 3 * (L1 * B ^ 3) := by ring
  have hmain : A ≤ L1 * B ^ 3 := by
    by_contra hnot
    have hgt : L1 * B ^ 3 < A := lt_of_not_ge hnot
    have hstrict : A ^ 3 * (L1 * B ^ 3) < A ^ 3 * A :=
      mul_lt_mul_of_pos_left hgt (pow_pos hApos 3)
    exact (not_lt_of_ge hcancel) hstrict
  rw [inv_pow]
  simpa only [div_eq_mul_inv, mul_comm] using
    (div_le_iff₀ (pow_pos hB 3)).2 hmain

/-- A sub-Gaussian real random variable belongs to every finite `Lᵖ` with
real exponent at least one. -/
theorem isSubGaussian_memLp_of_one_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : IsSubGaussian μ X)
    {p : ℝ} (hp : 1 ≤ p) :
    MemLp X (ENNReal.ofReal p) μ := by
  have hFinite : PsiTwoGauge μ X < ∞ :=
    (psiTwoGauge_finite_iff (μ := μ) (X := X)).2 hX.2
  have hIntAbs := ((psiTwoGaugeToLpMomentGrowth hX.1 hFinite).2 p hp).1
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  apply (integrable_norm_rpow_iff hX.1.aestronglyMeasurable
    (ENNReal.ofReal_ne_zero_iff.mpr hp0) ENNReal.ofReal_ne_top).1
  simpa [ENNReal.toReal_ofReal hp0.le, Real.norm_eq_abs] using hIntAbs

/-- Exercise 2.6.6: the `p = 1` Khintchine inequality. The explicit positive
coefficient `(C * (1 + K))⁻³` depends only on the maximal `psi₂` norm `K`. -/
theorem independentSubGaussianKhintchineLpOne :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι]
        [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, Var[X i; μ] = 1) →
        iIndepFun X μ →
        ∀ (a : ι → ℝ),
          let K := psiTwoNormMax μ X
          let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
          let A := Real.sqrt (∑ i, a i ^ 2)
          0 < (C * (1 + K))⁻¹ ^ 3 ∧
            (C * (1 + K))⁻¹ ^ 3 * A ≤ lpNorm S 1 μ ∧
            lpNorm S 1 μ ≤ A := by
  rcases independentSubGaussianKhintchine with ⟨C₀, hC₀, hKhin⟩
  let C : ℝ := 2 * C₀
  have hC : 1 ≤ C := by dsimp [C]; nlinarith
  refine ⟨C, hC, ?_⟩
  intro ι Ω _ _ _ μ _ X hSub hCenter hVariance hIndep a
  let K : ℝ := psiTwoNormMax μ X
  let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
  let Q : ℝ := ∑ i, a i ^ 2
  let A : ℝ := Real.sqrt Q
  let B : ℝ := C * (1 + K)
  have hK : 0 ≤ K := by
    simpa [K] using psiTwoNormMax_nonneg (μ := μ) (X := X)
  have hQ : 0 ≤ Q := by
    dsimp [Q]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hA : 0 ≤ A := Real.sqrt_nonneg Q
  have hCpos : 0 < C := lt_of_lt_of_le zero_lt_one hC
  have hB : 0 < B := mul_pos hCpos (by linarith)
  have hXTwo : ∀ i, MemLp (X i) 2 μ := by
    intro i
    simpa only [ENNReal.ofReal_ofNat] using
      isSubGaussian_memLp_of_one_le (hSub i) (p := 2) (by norm_num)
  have hXThree : ∀ i, MemLp (X i) 3 μ := by
    intro i
    simpa only [ENNReal.ofReal_ofNat] using
      isSubGaussian_memLp_of_one_le (hSub i) (p := 3) (by norm_num)
  have hSTwo : MemLp S 2 μ := by
    dsimp [S]
    exact memLp_finset_sum Finset.univ fun i _ => (hXTwo i).const_mul (a i)
  have hSThree : MemLp S 3 μ := by
    dsimp [S]
    exact memLp_finset_sum Finset.univ fun i _ => (hXThree i).const_mul (a i)
  have hSOne : MemLp S 1 μ := hSTwo.mono_exponent (by norm_num)
  have hSecond : (∫ ω, S ω ^ 2 ∂μ) = Q := by
    simpa [S, Q] using weightedIndependentCenteredUnitVariance_secondMoment
      a hXTwo (fun i => (hCenter i).2) hVariance hIndep
  have hNormTwo : lpNorm S 2 μ = A := by
    rw [lpNorm_eq_integral_norm_rpow_toReal (by norm_num) (by norm_num)
      hSTwo.aestronglyMeasurable]
    simp only [ENNReal.toReal_ofNat, Real.norm_eq_abs]
    rw [show (∫ ω, |S ω| ^ (2 : ℝ) ∂μ) = Q by
      simpa only [Real.rpow_two, sq_abs] using hSecond]
    norm_num [A, Real.sqrt_eq_rpow]
  have hUpperOne : lpNorm S 1 μ ≤ A := by
    have he : eLpNorm S 1 μ ≤ eLpNorm S 2 μ :=
      eLpNorm_le_eLpNorm_of_exponent_le (by norm_num) hSOne.aestronglyMeasurable
    have hr : lpNorm S 1 μ ≤ lpNorm S 2 μ := by
      rw [← toReal_eLpNorm hSOne.aestronglyMeasurable,
        ← toReal_eLpNorm hSTwo.aestronglyMeasurable]
      exact ENNReal.toReal_mono hSTwo.eLpNorm_ne_top he
    simpa [hNormTwo] using hr
  have hThreeKhin := (hKhin hSub hCenter hVariance hIndep a 3 (by norm_num)).2
  have hUpperThree : lpNorm S 3 μ ≤ B * A := by
    have hsqrt3 : Real.sqrt 3 ≤ 2 := by
      rw [Real.sqrt_le_iff]
      norm_num
    calc
      lpNorm S 3 μ ≤ C₀ * K * Real.sqrt 3 * A := by
        simpa only [S, K, A, ENNReal.ofReal_ofNat] using hThreeKhin
      _ ≤ C₀ * K * 2 * A := by gcongr
      _ ≤ (2 * C₀) * (1 + K) * A := by
        have hC₀nonneg : 0 ≤ C₀ := le_trans zero_le_one hC₀
        nlinarith [mul_nonneg hC₀nonneg hK, mul_nonneg hA hK]
      _ = B * A := by simp [B, C]
  have hRaw := lpExtrapolation hSOne hSThree
  have hM2 : (∫ ω, |S ω| ^ (2 : ℝ) ∂μ) = Q := by
    simpa only [Real.rpow_two, sq_abs] using hSecond
  have hL1 : (∫ ω, |S ω| ∂μ) = lpNorm S 1 μ := by
    simpa [Real.norm_eq_abs] using
      (lpNorm_one_eq_integral_norm hSOne.aestronglyMeasurable).symm
  let M3 : ℝ := ∫ ω, |S ω| ^ (3 : ℕ) ∂μ
  have hM3 : 0 ≤ M3 := by
    dsimp [M3]
    exact integral_nonneg_of_ae (Filter.Eventually.of_forall fun ω => by positivity)
  have hNormThree : lpNorm S 3 μ = M3 ^ (1 / 3 : ℝ) := by
    rw [lpNorm_eq_integral_norm_rpow_toReal (by norm_num) (by norm_num)
      hSThree.aestronglyMeasurable]
    simp only [ENNReal.toReal_ofNat, Real.norm_eq_abs]
    norm_num [M3]
  have hM3quarter : M3 ^ (1 / 4 : ℝ) =
      (lpNorm S 3 μ) ^ (3 / 4 : ℝ) := by
    rw [hNormThree, ← Real.rpow_mul hM3]
    norm_num
  have hInterp : A ≤
      (lpNorm S 1 μ) ^ (1 / 4 : ℝ) *
        (lpNorm S 3 μ) ^ (3 / 4 : ℝ) := by
    rw [hM2, hL1] at hRaw
    change Q ^ (1 / 2 : ℝ) ≤ _ at hRaw
    rw [show (∫ ω, |S ω| ^ (3 : ℕ) ∂μ) = M3 by rfl,
      hM3quarter] at hRaw
    simpa [A, Real.sqrt_eq_rpow] using hRaw
  have hLower := lower_of_extrapolation hA lpNorm_nonneg lpNorm_nonneg hB
    hInterp hUpperThree
  simpa only [K, S, A, B] using
    ⟨pow_pos (inv_pos.mpr hB) 3, hLower, hUpperOne⟩

end NumStability.HDP.Scalar.KhintchineLowMoments
