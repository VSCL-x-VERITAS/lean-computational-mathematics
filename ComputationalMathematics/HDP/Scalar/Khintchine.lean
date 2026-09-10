import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic
import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm

/-!
# Khintchine inequalities for independent sub-Gaussian variables

This module combines the exact second-moment identity for a weighted,
independent, centered, unit-variance family with the sub-Gaussian moment-growth
bound.  It supplies the two sides of Exercise 2.6.5 without duplicating either
Mathlib's variance-of-independent-sums theorem or the Chapter 2 `psi₂` API.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.Khintchine

open NumStability.HDP.Scalar.SubGaussian

/-- Root-free `Lᵖ` moment growth implies the corresponding real-valued
`lpNorm` estimate at every positive finite real exponent. -/
theorem lpNorm_le_of_lpMomentGrowth
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {Z : Ω → ℝ} {K p : ℝ}
    (hGrowth : LpMomentGrowth μ Z K) (hK : 0 ≤ K) (hp : 1 ≤ p) :
    lpNorm Z (ENNReal.ofReal p) μ ≤ K * Real.sqrt p := by
  have hp0 : 0 < p := lt_of_lt_of_le zero_lt_one hp
  have hMeas : AEStronglyMeasurable Z μ :=
    hGrowth.1.aestronglyMeasurable
  rw [lpNorm_eq_integral_norm_rpow_toReal
    (by exact ENNReal.ofReal_ne_zero_iff.mpr hp0)
    ENNReal.ofReal_ne_top hMeas]
  rw [ENNReal.toReal_ofReal hp0.le]
  have hMoment := (hGrowth.2 p hp).2
  have hBase : 0 ≤ K * Real.sqrt p :=
    mul_nonneg hK (Real.sqrt_nonneg p)
  calc
    (∫ ω, ‖Z ω‖ ^ p ∂μ) ^ p⁻¹ ≤
        ((K * Real.sqrt p) ^ p) ^ p⁻¹ := by
      exact Real.rpow_le_rpow
        (integral_nonneg fun _ => Real.rpow_nonneg (norm_nonneg _) _)
        (by simpa [Real.norm_eq_abs] using hMoment) (by positivity)
    _ = K * Real.sqrt p := by
      rw [← Real.rpow_mul hBase]
      simp [hp0.ne']

/-- The weighted second moment of an independent centered unit-variance family
is exactly its coefficient energy. -/
theorem weightedIndependentCenteredUnitVariance_secondMoment
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (a : ι → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hCenter : ∀ i, (∫ ω, X i ω ∂μ) = 0)
    (hVariance : ∀ i, Var[X i; μ] = 1)
    (hIndep : iIndepFun X μ) :
    (∫ ω, (∑ i, a i * X i ω) ^ 2 ∂μ) = ∑ i, a i ^ 2 := by
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  have hYLp : ∀ i, MemLp (Y i) 2 μ := by
    intro i
    simpa [Y] using (hX i).const_mul (a i)
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hYVariance : ∀ i, Var[Y i; μ] = a i ^ 2 := by
    intro i
    simpa [Y, hVariance i] using variance_const_mul (a i) (X i) μ
  have hSumLp : MemLp (fun ω => ∑ i, Y i ω) 2 μ :=
    memLp_finset_sum Finset.univ fun i _ => hYLp i
  have hSumCenter : (∫ ω, ∑ i, Y i ω ∂μ) = 0 := by
    rw [integral_finset_sum]
    · simp [Y, integral_const_mul, hCenter]
    · intro i _
      exact (hYLp i).integrable one_le_two
  have hSumFun : (fun ω => ∑ i, Y i ω) = ∑ i, Y i := by
    funext ω
    simp
  have hVarSum : Var[fun ω => ∑ i, Y i ω; μ] = ∑ i, a i ^ 2 := by
    calc
      Var[fun ω => ∑ i, Y i ω; μ] = ∑ i, Var[Y i; μ] := by
        rw [hSumFun]
        exact
          (NumStability.HDP.Scalar.LimitTheorems.independentVarianceSum
            hYLp (fun i j hij => hIndepY.indepFun hij))
      _ = ∑ i, a i ^ 2 := by simp [hYVariance]
  calc
    (∫ ω, (∑ i, a i * X i ω) ^ 2 ∂μ) =
        Var[fun ω => ∑ i, Y i ω; μ] := by
      rw [variance_of_integral_eq_zero hSumLp.aemeasurable hSumCenter]
    _ = ∑ i, a i ^ 2 := hVarSum

/-- Monotonicity from `L²` to `Lᵖ`, combined with the exact second moment,
gives the lower half of Khintchine's inequality. -/
theorem sqrt_coefficientEnergy_le_lpNorm
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (a : ι → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hCenter : ∀ i, (∫ ω, X i ω ∂μ) = 0)
    (hVariance : ∀ i, Var[X i; μ] = 1)
    (hIndep : iIndepFun X μ)
    {p : ℝ≥0∞} (hp : (2 : ℝ≥0∞) ≤ p)
    (hSumP : MemLp (fun ω => ∑ i, a i * X i ω) p μ) :
    Real.sqrt (∑ i, a i ^ 2) ≤
      lpNorm (fun ω => ∑ i, a i * X i ω) p μ := by
  let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
  have hSumTwo : MemLp S 2 μ :=
    memLp_finset_sum Finset.univ fun i _ => by
      simpa [S] using (hX i).const_mul (a i)
  have hSecond : (∫ ω, S ω ^ 2 ∂μ) = ∑ i, a i ^ 2 := by
    simpa [S] using weightedIndependentCenteredUnitVariance_secondMoment
      a hX hCenter hVariance hIndep
  have hnormTwo : lpNorm S 2 μ = Real.sqrt (∑ i, a i ^ 2) := by
    rw [lpNorm_eq_integral_norm_rpow_toReal (by norm_num) (by norm_num)
      hSumTwo.aestronglyMeasurable]
    simp only [ENNReal.toReal_ofNat, Real.norm_eq_abs]
    rw [show (∫ ω, |S ω| ^ (2 : ℝ) ∂μ) = ∑ i, a i ^ 2 by
      simpa only [Real.rpow_two, sq_abs] using hSecond]
    norm_num [Real.sqrt_eq_rpow]
  have hmonoE : eLpNorm S 2 μ ≤ eLpNorm S p μ :=
    eLpNorm_le_eLpNorm_of_exponent_le hp hSumTwo.aestronglyMeasurable
  have hmono : lpNorm S 2 μ ≤ lpNorm S p μ := by
    rw [← toReal_eLpNorm hSumTwo.aestronglyMeasurable,
      ← toReal_eLpNorm hSumP.aestronglyMeasurable]
    exact ENNReal.toReal_mono hSumP.eLpNorm_ne_top hmonoE
  simpa [S, hnormTwo] using hmono

/-- The upper Khintchine estimate follows from the intrinsic `psi₂` bound for
independent centered sums and the moment-growth characterization. -/
theorem weightedIndependentCenteredSubGaussian_lpNorm_upper :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι]
        [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        iIndepFun X μ →
        ∀ (a : ι → ℝ) (p : ℝ), 2 ≤ p →
          lpNorm (fun ω => ∑ i, a i * X i ω)
              (ENNReal.ofReal p) μ ≤
            C * psiTwoNormMax μ X * Real.sqrt p *
              Real.sqrt (∑ i, a i ^ 2) := by
  rcases independentCenteredSubGaussianSumPsiTwo with ⟨C₀, hC₀, hSum⟩
  let C : ℝ := 16 * Real.exp 1 * Real.sqrt C₀
  have hC₀nonneg : 0 ≤ C₀ := le_trans (by norm_num) hC₀
  have hsqrtC₀one : 1 ≤ Real.sqrt C₀ := by
    nlinarith [Real.sq_sqrt hC₀nonneg, Real.sqrt_nonneg C₀]
  have hC : 1 ≤ C := by
    dsimp [C]
    have hexp : 1 ≤ Real.exp 1 := Real.one_le_exp (by norm_num)
    nlinarith
  refine ⟨C, hC, ?_⟩
  intro ι Ω _ _ _ μ _ X hSub hCenter hIndep a p hp
  let Y : ι → Ω → ℝ := fun i ω => a i * X i ω
  let S : Ω → ℝ := fun ω => ∑ i, Y i ω
  let K : ℝ := psiTwoNormMax μ X
  let A : ℝ := ∑ i, a i ^ 2
  have hYSub : ∀ i, IsSubGaussian μ (Y i) := by
    intro i
    apply (isSubGaussian_iff_psiTwoNorm_finite (μ := μ) (X := Y i)).2
    by_cases hai : a i = 0
    · simp [Y, hai, PsiTwoNorm, psiTwoGauge_zero]
    · have hXFinite :=
        (isSubGaussian_iff_psiTwoNorm_finite (μ := μ) (X := X i)).1
          (hSub i)
      rw [PsiTwoNorm, show Y i = (fun ω => a i * X i ω) by rfl,
        psiTwoGauge_smul_of_ne_zero hai]
      exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top (by
        simpa [PsiTwoNorm] using hXFinite)
  have hYCenter : ∀ i, Integrable (Y i) μ ∧
      (∫ ω, Y i ω ∂μ) = 0 := by
    intro i
    refine ⟨by simpa [Y] using (hCenter i).1.const_mul (a i), ?_⟩
    simp [Y, integral_const_mul, (hCenter i).2]
  have hIndepY : iIndepFun Y μ := by
    have h := hIndep.comp (fun i x => a i * x) (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using h
  obtain ⟨hSSub, hSBound⟩ := hSum hYSub hYCenter hIndepY
  have hSSub' : IsSubGaussian μ S := by simpa [S] using hSSub
  have hSMeas : Measurable S := hSSub'.1
  have hSFinite : PsiTwoGauge μ S < ∞ :=
    (psiTwoGauge_finite_iff (μ := μ) (X := S)).2 hSSub'.2
  have hYNorm (i : ι) :
      (PsiTwoNorm μ (Y i)).toReal =
        |a i| * (PsiTwoNorm μ (X i)).toReal := by
    by_cases hai : a i = 0
    · simp [Y, hai, PsiTwoNorm, psiTwoGauge_zero]
    · rw [PsiTwoNorm, show Y i = (fun ω => a i * X i ω) by rfl,
        psiTwoGauge_smul_of_ne_zero hai, ENNReal.toReal_mul,
        ENNReal.toReal_ofReal (abs_nonneg (a i))]
      rfl
  have hKnonneg : 0 ≤ K := by
    simpa [K] using (psiTwoNormMax_nonneg (μ := μ) (X := X))
  have hAnonneg : 0 ≤ A := by
    dsimp [A]
    exact Finset.sum_nonneg fun i _ => sq_nonneg _
  have hEnergy :
      ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2 ≤ K ^ 2 * A := by
    dsimp [A]
    calc
      ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2 ≤
          ∑ i, K ^ 2 * a i ^ 2 := by
        apply Finset.sum_le_sum
        intro i _
        have hi : (PsiTwoNorm μ (X i)).toReal ≤ K := by
          simpa [K] using
            (psiTwoNorm_toReal_le_max (μ := μ) (X := X) i)
        have hsq : (PsiTwoNorm μ (X i)).toReal ^ 2 ≤ K ^ 2 :=
          (sq_le_sq₀ ENNReal.toReal_nonneg hKnonneg).2 hi
        rw [hYNorm i, mul_pow, sq_abs]
        simpa [mul_comm] using
          (mul_le_mul_of_nonneg_right hsq (sq_nonneg (a i)))
      _ = K ^ 2 * ∑ i, a i ^ 2 := by rw [Finset.mul_sum]
  have hGaugeSq :
      (PsiTwoGauge μ S).toReal ^ 2 ≤ C₀ * K ^ 2 * A := by
    have hSBound' : (PsiTwoGauge μ S).toReal ^ 2 ≤
        C₀ * ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2 := by
      simpa [PsiTwoNorm, S] using hSBound
    exact hSBound'.trans (by
      calc
        C₀ * ∑ i, (PsiTwoNorm μ (Y i)).toReal ^ 2 ≤
            C₀ * (K ^ 2 * A) :=
              mul_le_mul_of_nonneg_left hEnergy hC₀nonneg
        _ = C₀ * K ^ 2 * A := by ring)
  have hGauge : (PsiTwoGauge μ S).toReal ≤
      Real.sqrt C₀ * K * Real.sqrt A := by
    have hsqrtC₀ : 0 ≤ Real.sqrt C₀ := Real.sqrt_nonneg C₀
    have hsqrtA : 0 ≤ Real.sqrt A := Real.sqrt_nonneg A
    have hsqC₀ : (Real.sqrt C₀) ^ 2 = C₀ := Real.sq_sqrt hC₀nonneg
    have hsqA : (Real.sqrt A) ^ 2 = A := Real.sq_sqrt hAnonneg
    have hrightnonneg : 0 ≤ Real.sqrt C₀ * K * Real.sqrt A := by
      positivity
    have hrightsq : (Real.sqrt C₀ * K * Real.sqrt A) ^ 2 =
        C₀ * K ^ 2 * A := by
      rw [mul_pow, mul_pow, hsqC₀, hsqA]
    exact (sq_le_sq₀ ENNReal.toReal_nonneg hrightnonneg).1 (by
      simpa [hrightsq] using hGaugeSq)
  have hp1 : 1 ≤ p := le_trans (by norm_num) hp
  have hLp := lpNorm_le_of_lpMomentGrowth
    (psiTwoGaugeToLpMomentGrowth hSMeas hSFinite)
    (mul_nonneg (by positivity) ENNReal.toReal_nonneg) hp1
  calc
    lpNorm (fun ω => ∑ i, a i * X i ω) (ENNReal.ofReal p) μ =
        lpNorm S (ENNReal.ofReal p) μ := by rfl
    _ ≤ (16 * Real.exp 1 * (PsiTwoGauge μ S).toReal) *
        Real.sqrt p := hLp
    _ ≤ (16 * Real.exp 1 * (Real.sqrt C₀ * K * Real.sqrt A)) *
        Real.sqrt p := by
      gcongr
    _ = C * K * Real.sqrt p * Real.sqrt A := by
      dsimp [C, A]
      ring

/-- Exercise 2.6.5: the two-sided Khintchine inequality for independent,
centered, unit-variance sub-Gaussian random variables and `p ≥ 2`. -/
theorem independentSubGaussianKhintchine :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι]
        [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {X : ι → Ω → ℝ},
        (∀ i, IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        (∀ i, Var[X i; μ] = 1) →
        iIndepFun X μ →
        ∀ (a : ι → ℝ) (p : ℝ), 2 ≤ p →
          Real.sqrt (∑ i, a i ^ 2) ≤
              lpNorm (fun ω => ∑ i, a i * X i ω)
                (ENNReal.ofReal p) μ ∧
          lpNorm (fun ω => ∑ i, a i * X i ω)
              (ENNReal.ofReal p) μ ≤
            C * psiTwoNormMax μ X * Real.sqrt p *
              Real.sqrt (∑ i, a i ^ 2) := by
  rcases weightedIndependentCenteredSubGaussian_lpNorm_upper with
    ⟨C, hC, hUpper⟩
  refine ⟨C, hC, ?_⟩
  intro ι Ω _ _ _ μ _ X hSub hCenter hVariance hIndep a p hp
  have hXTwo : ∀ i, MemLp (X i) 2 μ := by
    intro i
    have hFinite : PsiTwoGauge μ (X i) < ∞ :=
      (psiTwoGauge_finite_iff (μ := μ) (X := X i)).2 (hSub i).2
    have hIntAbs : Integrable (fun ω => |X i ω| ^ (2 : ℝ)) μ :=
      ((psiTwoGaugeToLpMomentGrowth (hSub i).1 hFinite).2 2
        (by norm_num)).1
    apply (memLp_two_iff_integrable_sq
      (hSub i).1.aestronglyMeasurable).2
    simpa [sq_abs] using hIntAbs
  constructor
  · exact sqrt_coefficientEnergy_le_lpNorm a hXTwo
      (fun i => (hCenter i).2) hVariance hIndep
      (by
        rw [← ENNReal.ofReal_ofNat]
        exact ENNReal.ofReal_le_ofReal hp)
      (by
        have hSp : MemLp (fun ω => ∑ i, a i * X i ω)
            (ENNReal.ofReal p) μ := by
          apply memLp_finset_sum Finset.univ
          intro i _
          have hXiP : MemLp (X i) (ENNReal.ofReal p) μ := by
            have hFinite : PsiTwoGauge μ (X i) < ∞ :=
              (psiTwoGauge_finite_iff (μ := μ) (X := X i)).2 (hSub i).2
            have hIntAbs :=
              ((psiTwoGaugeToLpMomentGrowth (hSub i).1 hFinite).2 p
                (le_trans (by norm_num) hp)).1
            have hp0 : 0 < p := lt_of_lt_of_le (by norm_num) hp
            apply (integrable_norm_rpow_iff
              (hSub i).1.aestronglyMeasurable
              (ENNReal.ofReal_ne_zero_iff.mpr hp0)
              ENNReal.ofReal_ne_top).1
            simpa [ENNReal.toReal_ofReal (le_trans (by norm_num) hp),
              Real.norm_eq_abs] using hIntAbs
          simpa only using hXiP.const_mul (a i)
        simpa only using hSp)
  · exact hUpper hSub hCenter hIndep a p hp

end NumStability.HDP.Scalar.Khintchine
