import ComputationalMathematics.HDP.Scalar.IndependentSums.Bernstein
import ComputationalMathematics.Source.Vershynin.Chapter02.Section08.BernsteinProofDisplays.Signature

/-! Source-facing forms of equations (2.23) and (2.24) in Bernstein's proof. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential
open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-- Equation (2.23), printed page 36: exponential Markov followed by
factorization of the MGF of the independent sum.  The extended nonnegative
integrals preserve the source's large-`λ` cases, where an individual MGF can
be infinite. -/
theorem hdp_02_heq_h2_d23
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ}
    (hne : (Finset.univ : Finset ι).Nonempty)
    (hX : ∀ i, Measurable (X i))
    (hCenter : ∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0)
    (hSubExp : ∀ i, PsiOneGauge μ (X i) < ∞)
    (hIndep : iIndepFun X μ)
    {lam t : ℝ} (hlam : 0 < lam)
    (ht : 0 ≤ t) :
    μ {ω | ∑ i, X i ω ≥ t} ≤
      ENNReal.ofReal (Real.exp (-(lam * t))) *
        ∏ i, ∫⁻ ω, ENNReal.ofReal (Real.exp (lam * X i ω)) ∂μ := by
  let S : Ω → ℝ := fun ω ↦ ∑ i, X i ω
  let Y : Ω → ℝ := fun ω ↦ Real.exp (lam * S ω)
  let Z : ι → Ω → ℝ≥0∞ :=
    fun i ω ↦ ENNReal.ofReal (Real.exp (lam * X i ω))
  have hS : Measurable S := by
    dsimp [S]
    exact Finset.measurable_sum Finset.univ (fun i _ ↦ hX i)
  have hY : Measurable Y := by
    dsimp [Y]
    fun_prop
  have hNonneg : ∀ᵐ ω ∂μ, 0 ≤ Y ω :=
    Filter.Eventually.of_forall (fun ω ↦ (Real.exp_pos _).le)
  have hMarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityExtended
      (X := Y) hY hNonneg (Real.exp_pos (lam * t))
  have hEvent : {ω | ∑ i, X i ω ≥ t} = Y ⁻¹' Set.Ici (Real.exp (lam * t)) := by
    ext ω
    change (∑ i, X i ω) ≥ t ↔ Real.exp (lam * t) ≤ Real.exp (lam * S ω)
    rw [Real.exp_le_exp]
    dsimp [S]
    constructor <;> intro h <;> nlinarith
  have hZ : ∀ i, Measurable (Z i) := by
    intro i
    dsimp [Z]
    fun_prop
  have hIndepZ : iIndepFun Z μ := by
    have h := hIndep.comp
      (fun _ x ↦ ENNReal.ofReal (Real.exp (lam * x)))
      (fun _ ↦ by fun_prop)
    simpa [Z, Function.comp_def] using h
  have hPoint : ∀ ω, ENNReal.ofReal (Y ω) = ∏ i, Z i ω := by
    intro ω
    have hexp : Y ω = ∏ i, Real.exp (lam * X i ω) := by
      dsimp [Y, S]
      rw [show lam * ∑ i, X i ω = ∑ i, lam * X i ω by
        simpa using Finset.mul_sum (Finset.univ : Finset ι) (fun i ↦ X i ω) lam]
      simpa using (Real.exp_sum (Finset.univ : Finset ι)
        (fun i ↦ lam * X i ω))
    rw [hexp]
    simp only [Z]
    classical
    induction (Finset.univ : Finset ι) using Finset.induction_on with
    | empty => simp
    | @insert a s ha ih =>
        rw [Finset.prod_insert ha, Finset.prod_insert ha]
        rw [ENNReal.ofReal_mul (Real.exp_pos _).le, ih]
  have hFactor :
      (∫⁻ ω, ENNReal.ofReal (Y ω) ∂μ) =
        ∏ i, ∫⁻ ω, Z i ω ∂μ := by
    calc
      (∫⁻ ω, ENNReal.ofReal (Y ω) ∂μ) =
          ∫⁻ ω, ∏ i, Z i ω ∂μ := by
            apply lintegral_congr
            exact hPoint
      _ = ∏ i, ∫⁻ ω, Z i ω ∂μ := by
        simpa using
          (ProbabilityTheory.lintegral_prod_eq_prod_lintegral_of_indepFun
            (Finset.univ : Finset ι) Z hIndepZ hZ)
  rw [hEvent]
  calc
    μ (Y ⁻¹' Set.Ici (Real.exp (lam * t))) ≤
        (∫⁻ ω, ENNReal.ofReal (Y ω) ∂μ) /
          ENNReal.ofReal (Real.exp (lam * t)) := hMarkov
    _ = ENNReal.ofReal (Real.exp (-(lam * t))) *
          ∏ i, ∫⁻ ω, Z i ω ∂μ := by
      rw [hFactor, ENNReal.div_eq_inv_mul]
      congr 1
      rw [← ENNReal.ofReal_inv_of_pos (Real.exp_pos (lam * t))]
      congr 1
      rw [← Real.exp_neg]
    _ = ENNReal.ofReal (Real.exp (-(lam * t))) *
          ∏ i, ∫⁻ ω, ENNReal.ofReal (Real.exp (lam * X i ω)) ∂μ := by
      rfl

/-- Equation (2.24) and the estimate immediately following it, printed page 36:
global absolute constants put the family-wide `λ` range inside every local
MGF window and bound the `i`-th MGF using its individual `ψ₁` gauge. -/
theorem hdp_02_heq_h2_d24 :
    ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ} (hne : (Finset.univ : Finset ι).Nonempty),
        (∀ i, Measurable (X i)) →
          (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
          (∀ i, PsiOneGauge μ (X i) < ∞) →
          iIndepFun X μ →
          ∀ {lam : ℝ},
            let K := Finset.univ.sup' hne
              (fun i => (PsiOneGauge μ (X i)).toReal)
            0 < K → |lam| ≤ c / K →
              ∀ i, Integrable (fun ω ↦ Real.exp (lam * X i ω)) μ ∧
                (∫ ω, Real.exp (lam * X i ω) ∂μ) ≤
                  Real.exp
                    (C * lam ^ 2 * (PsiOneGauge μ (X i)).toReal ^ 2) := by
  let A : ℝ := 4096 * (Real.exp 1) ^ 4
  have hA : 0 < A := by
    dsimp [A]
    positivity
  refine ⟨A⁻¹, A ^ 2, inv_pos.mpr hA, sq_pos_of_pos hA, ?_⟩
  intro ι Ω _ _ μ _ X hne hMeas hCenter hSubExp _ lam
  dsimp only
  set K : ℝ := Finset.univ.sup' hne
    (fun i => (PsiOneGauge μ (X i)).toReal) with hKdef
  intro hK hlam i
  let κ : ℝ := (PsiOneGauge μ (X i)).toReal
  have hκnonneg : 0 ≤ κ := ENNReal.toReal_nonneg
  have hκle : κ ≤ K := by
    dsimp [κ]
    rw [hKdef]
    exact Finset.le_sup'
      (fun j => (PsiOneGauge μ (X j)).toReal) (Finset.mem_univ i)
  by_cases hκ0 : κ = 0
  · have hGaugeZero : PsiOneGauge μ (X i) = 0 := by
      have hκ0' : (PsiOneGauge μ (X i)).toReal = 0 := by
        simpa [κ] using hκ0
      rw [← ENNReal.ofReal_toReal (hSubExp i).ne, hκ0']
      simp
    have hZero : X i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) :=
      (psiOneGauge_eq_zero_iff_ae_eq_zero (hMeas i)).mp hGaugeZero
    have hExpAE : (fun ω ↦ Real.exp (lam * X i ω)) =ᵐ[μ]
        (fun _ : Ω => (1 : ℝ)) := by
      filter_upwards [hZero] with ω hω
      simp [hω]
    have hInt : Integrable (fun ω ↦ Real.exp (lam * X i ω)) μ := by
      exact (integrable_const (1 : ℝ)).congr hExpAE.symm
    refine ⟨hInt, ?_⟩
    calc
      (∫ ω, Real.exp (lam * X i ω) ∂μ) = 1 := by
        rw [integral_congr_ae hExpAE]
        simp
      _ ≤ Real.exp (A ^ 2 * lam ^ 2 * (PsiOneGauge μ (X i)).toReal ^ 2) := by
        have hκ0' : (PsiOneGauge μ (X i)).toReal = 0 := by
          simpa [κ] using hκ0
        simp [hκ0']
  · have hκ : 0 < κ := lt_of_le_of_ne hκnonneg (Ne.symm hκ0)
    have hGauge : PsiOneGauge μ (X i) ≤ ENNReal.ofReal κ := by
      rw [← ENNReal.ofReal_toReal (hSubExp i).ne]
    have hLocal := psiOneGaugeToLinearMGF_le
      (hMeas i) hκ (hCenter i) hGauge
    have hAκ : 0 < A * κ := mul_pos hA hκ
    have hden : A * κ ≤ A * K := mul_le_mul_of_nonneg_left hκle hA.le
    have hInv : (A * K)⁻¹ ≤ (A * κ)⁻¹ := by
      simpa [one_div] using one_div_le_one_div_of_le hAκ hden
    have hWindow : |lam| ≤ (A * κ)⁻¹ := by
      calc
        |lam| ≤ A⁻¹ / K := hlam
        _ = (A * K)⁻¹ := by
          rw [div_eq_mul_inv, mul_inv_rev]
          ring
        _ ≤ (A * κ)⁻¹ := hInv
    have hMGF := hLocal.2.2.2.2 lam (by simpa [A, κ] using hWindow)
    refine ⟨hMGF.1, hMGF.2.trans_eq ?_⟩
    congr 1
    dsimp [A, κ]
    ring

/-- Equation (2.24) with its nonnegative denominator cleared.  This is
equivalent to the printed window when the maximum `ψ₁` gauge is positive and
also expresses the correct unbounded window for the all-zero family. -/
theorem hdp_02_heq_h2_d24_effectiveWindow :
    hdp_02_heq_h2_d24_effectiveWindow__contract_type := by
  obtain ⟨c, C, hc, hC, hbound⟩ := hdp_02_heq_h2_d24
  refine ⟨c, C, hc, hC, ?_⟩
  intro ι Ω _ _ μ _ X hne hMeas hCenter hSubExp hIndep lam
  dsimp only
  set K : ℝ := Finset.univ.sup' hne
    (fun i => (PsiOneGauge μ (X i)).toReal) with hKdef
  intro hlam i
  have hκle : (PsiOneGauge μ (X i)).toReal ≤ K := by
    rw [hKdef]
    exact Finset.le_sup'
      (fun j => (PsiOneGauge μ (X j)).toReal) (Finset.mem_univ i)
  by_cases hK0 : K = 0
  · have hκ0 : (PsiOneGauge μ (X i)).toReal = 0 := by
      apply le_antisymm
      · simpa [hK0] using hκle
      · exact ENNReal.toReal_nonneg
    have hGaugeZero : PsiOneGauge μ (X i) = 0 := by
      rw [← ENNReal.ofReal_toReal (hSubExp i).ne, hκ0]
      simp
    have hZero : X i =ᵐ[μ] (fun _ : Ω => (0 : ℝ)) :=
      (psiOneGauge_eq_zero_iff_ae_eq_zero (hMeas i)).mp hGaugeZero
    have hExpAE : (fun ω ↦ Real.exp (lam * X i ω)) =ᵐ[μ]
        (fun _ : Ω => (1 : ℝ)) := by
      filter_upwards [hZero] with ω hω
      simp [hω]
    have hInt : Integrable (fun ω ↦ Real.exp (lam * X i ω)) μ :=
      (integrable_const (1 : ℝ)).congr hExpAE.symm
    refine ⟨hInt, ?_⟩
    calc
      (∫ ω, Real.exp (lam * X i ω) ∂μ) = 1 := by
        rw [integral_congr_ae hExpAE]
        simp
      _ ≤ Real.exp (C * lam ^ 2 * (PsiOneGauge μ (X i)).toReal ^ 2) := by
        simp [hκ0]
  · have hKpos : 0 < K :=
      lt_of_le_of_ne (ENNReal.toReal_nonneg.trans hκle) (Ne.symm hK0)
    exact hbound hne hMeas hCenter hSubExp hIndep hKpos
      ((le_div_iff₀ hKpos).2 hlam) i

end NumStability.HDP.Contract
