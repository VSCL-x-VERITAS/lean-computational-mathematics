import ComputationalMathematics.HDP.Scalar.SubGaussian.Basic

/-!
# Domination for the scalar `ψ₂` gauge

This module records the elementary monotonicity principle that pointwise
absolute-value domination can only decrease the exponential-square gauge.
It is useful when a random vector is obtained from another one by a bounded
radial contraction.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Scalar.SubGaussian

/-- Pointwise absolute-value domination preserves every admissible `ψ₂`
scale. -/
lemma psiTwoAdmissible_of_abs_le
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {X Y : Omega → ℝ}
    (hX : Measurable X)
    (hXY : ∀ omega, |X omega| ≤ |Y omega|) {t : ℝ≥0∞}
    (hYAdmissible : PsiTwoAdmissible mu Y t) :
    PsiTwoAdmissible mu X t := by
  rcases hYAdmissible with ⟨_, ht0, htTop, hYIntegrable, hYBound⟩
  have hPoint : ∀ omega,
      Real.exp (X omega ^ 2 / t.toReal ^ 2) ≤
        Real.exp (Y omega ^ 2 / t.toReal ^ 2) := by
    intro omega
    apply Real.exp_le_exp.mpr
    apply div_le_div_of_nonneg_right
    · exact (sq_le_sq).2 (hXY omega)
    · positivity
  have hXIntegrable :
      Integrable (fun omega ↦ Real.exp (X omega ^ 2 / t.toReal ^ 2)) mu := by
    refine hYIntegrable.mono' (by fun_prop) ?_
    filter_upwards [] with omega
    simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hPoint omega
  refine ⟨hX, ht0, htTop, hXIntegrable, ?_⟩
  exact (integral_mono_ae hXIntegrable hYIntegrable
    (Filter.Eventually.of_forall hPoint)).trans hYBound

/-- Pointwise absolute-value domination can only decrease the extended
`\psi_2` gauge. -/
theorem psiTwoGauge_le_of_abs_le
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {X Y : Omega → ℝ}
    (hX : Measurable X)
    (hXY : ∀ omega, |X omega| ≤ |Y omega|) :
    PsiTwoGauge mu X ≤ PsiTwoGauge mu Y := by
  unfold PsiTwoGauge
  apply sInf_le_sInf
  intro t ht
  exact psiTwoAdmissible_of_abs_le hX hXY ht

/-- Pointwise absolute-value domination can only decrease the source-facing
extended `\psi_2` norm. -/
theorem psiTwoNorm_le_of_abs_le
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {X Y : Omega → ℝ}
    (hX : Measurable X)
    (hXY : ∀ omega, |X omega| ≤ |Y omega|) :
    PsiTwoNorm mu X ≤ PsiTwoNorm mu Y := by
  simpa only [PsiTwoNorm] using psiTwoGauge_le_of_abs_le hX hXY

/-- A measurable random variable dominated in absolute value by a
sub-Gaussian one is sub-Gaussian. -/
theorem isSubGaussian_of_abs_le
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {X Y : Omega → ℝ}
    (hX : Measurable X)
    (hXY : ∀ omega, |X omega| ≤ |Y omega|)
    (hYSubGaussian : IsSubGaussian mu Y) :
    IsSubGaussian mu X := by
  apply (isSubGaussian_iff_psiTwoNorm_finite (μ := mu) (X := X)).2
  exact lt_of_le_of_lt (psiTwoNorm_le_of_abs_le hX hXY)
    ((isSubGaussian_iff_psiTwoNorm_finite (μ := mu) (X := Y)).1 hYSubGaussian)

/-- A measurable random variable with a deterministic finite absolute bound
is sub-Gaussian.  The scale `B / sqrt (log 2)` makes the defining exponential
square moment at most two. -/
theorem isSubGaussian_of_abs_le_const
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {X : Omega → ℝ} {B : ℝ} (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ omega, |X omega| ≤ B) : IsSubGaussian mu X := by
  let K : ℝ := B / Real.sqrt (Real.log 2)
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hsqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hlog
  have hK : 0 < K := div_pos hB hsqrt
  have hKsq : Real.log 2 * K ^ 2 = B ^ 2 := by
    dsimp [K]
    field_simp [ne_of_gt hsqrt]
    rw [Real.sq_sqrt hlog.le]
  have hPoint : ∀ omega, Real.exp (X omega ^ 2 / K ^ 2) ≤ 2 := by
    intro omega
    have hsq : X omega ^ 2 ≤ B ^ 2 := by
      exact (sq_le_sq).2 (by simpa [abs_of_pos hB] using hBound omega)
    have hquot : X omega ^ 2 / K ^ 2 ≤ Real.log 2 := by
      rw [div_le_iff₀ (sq_pos_of_pos hK)]
      rw [hKsq]
      exact hsq
    calc
      Real.exp (X omega ^ 2 / K ^ 2) ≤ Real.exp (Real.log 2) :=
        Real.exp_le_exp.mpr hquot
      _ = 2 := Real.exp_log (by norm_num)
  have hInt : Integrable (fun omega ↦ Real.exp (X omega ^ 2 / K ^ 2)) mu := by
    refine (MeasureTheory.integrable_const (μ := mu) (2 : ℝ)).mono'
      (by fun_prop) ?_
    filter_upwards [] with omega
    simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _),
      abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 2)] using hPoint omega
  refine ⟨hX, K, hK, hX, hK, hInt, ?_⟩
  calc
    (∫ omega, Real.exp (X omega ^ 2 / K ^ 2) ∂mu) ≤
        ∫ _omega, (2 : ℝ) ∂mu :=
      integral_mono_ae hInt (MeasureTheory.integrable_const (μ := mu) 2)
        (Filter.Eventually.of_forall hPoint)
    _ = 2 := by simp

/-- A measurable scalar random variable that is essentially bounded is
sub-Gaussian.  The bound is allowed to fail on a null set, as is appropriate
for hypotheses stated in terms of the support of the law. -/
theorem isSubGaussian_of_ae_abs_le_const
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu]
    {X : Omega → ℝ} {B : ℝ} (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ omega ∂mu, |X omega| ≤ B) : IsSubGaussian mu X := by
  let K : ℝ := B / Real.sqrt (Real.log 2)
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hsqrt : 0 < Real.sqrt (Real.log 2) := Real.sqrt_pos.2 hlog
  have hK : 0 < K := div_pos hB hsqrt
  have hKsq : Real.log 2 * K ^ 2 = B ^ 2 := by
    dsimp [K]
    field_simp [ne_of_gt hsqrt]
    rw [Real.sq_sqrt hlog.le]
  have hPoint : ∀ᵐ omega ∂mu, Real.exp (X omega ^ 2 / K ^ 2) ≤ 2 := by
    filter_upwards [hBound] with omega hBoundOmega
    have hsq : X omega ^ 2 ≤ B ^ 2 := by
      exact (sq_le_sq).2 (by simpa [abs_of_pos hB] using hBoundOmega)
    have hquot : X omega ^ 2 / K ^ 2 ≤ Real.log 2 := by
      rw [div_le_iff₀ (sq_pos_of_pos hK)]
      rw [hKsq]
      exact hsq
    calc
      Real.exp (X omega ^ 2 / K ^ 2) ≤ Real.exp (Real.log 2) :=
        Real.exp_le_exp.mpr hquot
      _ = 2 := Real.exp_log (by norm_num)
  have hInt : Integrable (fun omega ↦ Real.exp (X omega ^ 2 / K ^ 2)) mu := by
    refine (MeasureTheory.integrable_const (μ := mu) (2 : ℝ)).mono'
      (by fun_prop) ?_
    filter_upwards [hPoint] with omega hPointOmega
    simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _),
      abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 2)] using hPointOmega
  refine ⟨hX, K, hK, hX, hK, hInt, ?_⟩
  calc
    (∫ omega, Real.exp (X omega ^ 2 / K ^ 2) ∂mu) ≤
        ∫ _omega, (2 : ℝ) ∂mu :=
      integral_mono_ae hInt (MeasureTheory.integrable_const (μ := mu) 2) hPoint
    _ = 2 := by simp

/-- Admissibility of a `ψ₂` scale depends only on the scalar law. -/
lemma psiTwoAdmissible_iff_of_hasLaw
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {nu : Measure ℝ} {X : Omega → ℝ}
    (hX : Measurable X) (hLaw : HasLaw X nu mu) {t : ℝ≥0∞} :
    PsiTwoAdmissible mu X t ↔ PsiTwoAdmissible nu id t := by
  let f : ℝ → ℝ := fun x ↦ Real.exp (x ^ 2 / t.toReal ^ 2)
  have hf : Measurable f := by
    dsimp [f]
    fun_prop
  have hIntegrable : Integrable f nu ↔ Integrable (fun omega ↦ f (X omega)) mu := by
    rw [← hLaw.map_eq]
    exact integrable_map_measure hf.aestronglyMeasurable hX.aemeasurable
  have hIntegral : (∫ omega, f (X omega) ∂mu) = ∫ x, f x ∂nu :=
    hLaw.integral_comp hf.aestronglyMeasurable
  constructor
  · rintro ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨measurable_id, ht0, htTop, ?_, ?_⟩
    · exact hIntegrable.2 (by simpa [f] using hInt)
    · simpa [f] using hIntegral ▸ hBound
  · rintro ⟨_, ht0, htTop, hInt, hBound⟩
    refine ⟨hX, ht0, htTop, ?_, ?_⟩
    · exact hIntegrable.1 (by simpa [f] using hInt)
    · simpa [f] using hIntegral.symm ▸ hBound

/-- The scalar `ψ₂` gauge is invariant under passage to the canonical law. -/
theorem psiTwoGauge_eq_of_hasLaw
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {nu : Measure ℝ} {X : Omega → ℝ}
    (hX : Measurable X) (hLaw : HasLaw X nu mu) :
    PsiTwoGauge mu X = PsiTwoGauge nu id := by
  unfold PsiTwoGauge
  congr 1
  ext t
  exact psiTwoAdmissible_iff_of_hasLaw hX hLaw

/-- The source-facing scalar `ψ₂` norm is invariant under passage to the
canonical law. -/
theorem psiTwoNorm_eq_of_hasLaw
    {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} {nu : Measure ℝ} {X : Omega → ℝ}
    (hX : Measurable X) (hLaw : HasLaw X nu mu) :
    PsiTwoNorm mu X = PsiTwoNorm nu id := by
  simpa only [PsiTwoNorm] using psiTwoGauge_eq_of_hasLaw hX hLaw

/-- Measurable scalar random variables with the same law have the same
extended `ψ₂` norm. -/
theorem psiTwoNorm_eq_of_sameLaw
    {Omega Omega' : Type*} [MeasurableSpace Omega] [MeasurableSpace Omega']
    {mu : Measure Omega} {mu' : Measure Omega'} {nu : Measure ℝ}
    {X : Omega → ℝ} {Y : Omega' → ℝ}
    (hX : Measurable X) (hY : Measurable Y)
    (hXLaw : HasLaw X nu mu) (hYLaw : HasLaw Y nu mu') :
    PsiTwoNorm mu X = PsiTwoNorm mu' Y := by
  rw [psiTwoNorm_eq_of_hasLaw hX hXLaw, psiTwoNorm_eq_of_hasLaw hY hYLaw]

end NumStability.HDP.Scalar.SubGaussian
