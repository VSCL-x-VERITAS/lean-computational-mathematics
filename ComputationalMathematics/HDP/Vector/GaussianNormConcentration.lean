import ComputationalMathematics.HDP.Vector.Gaussian
import ComputationalMathematics.HDP.Vector.NormConcentration

/-!
# Euclidean norm concentration for standard Gaussian vectors

This module specializes the reusable independent-coordinate norm tail to the
canonical standard-Gaussian vector law.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.Gaussian

private theorem psiTwoGauge_eq_of_hasLaw
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {ν : Measure ℝ}
    (hXmeas : Measurable X) (hX : HasLaw X ν μ) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X =
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge ν id := by
  unfold NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
  congr 1
  ext t
  unfold NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible
  let f : ℝ → ℝ := fun x => Real.exp (x ^ 2 / t.toReal ^ 2)
  have hf : Measurable f := by
    dsimp [f]
    fun_prop
  have hInt : Integrable f ν ↔ Integrable (f ∘ X) μ := by
    rw [← hX.map_eq]
    exact integrable_map_measure hf.aestronglyMeasurable hX.aemeasurable
  have hIntegral : (∫ ω, f (X ω) ∂μ) = ∫ x, f x ∂ν := by
    simpa [Function.comp_def] using hX.integral_comp hf.aestronglyMeasurable
  constructor
  · rintro ⟨_, ht0, htTop, hXi, hXbound⟩
    refine ⟨measurable_id, ht0, htTop, ?_, ?_⟩
    · exact hInt.mpr (by simpa [f, Function.comp_def] using hXi)
    · calc
        (∫ x : ℝ, Real.exp (id x ^ 2 / t.toReal ^ 2) ∂ν) =
            ∫ x, f x ∂ν := by simp [f]
        _ = ∫ ω, f (X ω) ∂μ := hIntegral.symm
        _ ≤ 2 := by simpa [f] using hXbound
  · rintro ⟨_, ht0, htTop, hνi, hνbound⟩
    refine ⟨hXmeas, ht0, htTop, ?_, ?_⟩
    · have := hInt.mp (by simpa [f] using hνi)
      simpa [f, Function.comp_def] using this
    · calc
        (∫ ω, Real.exp (X ω ^ 2 / t.toReal ^ 2) ∂μ) =
            ∫ ω, f (X ω) ∂μ := by rfl
        _ = ∫ x, f x ∂ν := hIntegral
        _ ≤ 2 := by simpa [f] using hνbound

/-- The maximum exact ψ₂ norm of standard-Gaussian coordinates is at most
the explicit one-dimensional bound two. -/
theorem standardGaussian_psiTwoNormMax_le_two
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} [Nonempty (Fin n)]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i)) (hX : IsStandardNormal μ X) :
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X ≤ 2 := by
  unfold NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
  apply Finset.sup'_le Finset.univ_nonempty
  intro i _
  have hCoord := (isStandardNormal_iff_iIndepFun_hasLaw.mp hX).2 i
  have hGauge :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) ≤
        ENNReal.ofReal 2 := by
    rw [psiTwoGauge_eq_of_hasLaw (hMeas i) hCoord]
    exact NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul.1
  simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
    (ENNReal.toReal_mono ENNReal.ofReal_ne_top hGauge)

private theorem integral_standardGaussian_sq :
    (∫ x : ℝ, x ^ 2 ∂gaussianReal 0 1) = 1 := by
  have hv := variance_id_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal))
  change Var[(fun x : ℝ => x); gaussianReal 0 1] = ((1 : NNReal) : ℝ) at hv
  rw [variance_of_integral_eq_zero measurable_id'.aemeasurable (by simp)] at hv
  norm_num at hv ⊢
  exact hv

/-- A standard Gaussian vector lies in a dimension-independent shell around
the square root of its dimension with a sub-Gaussian tail. -/
theorem standardGaussianEuclideanNormDeviation_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {n : ℕ} [Nonempty (Fin n)]
        {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        (X : Fin n → Ω → ℝ),
        (∀ i, Measurable (X i)) → IsStandardNormal μ X →
          ∀ {t : ℝ}, 0 ≤ t →
            μ.real {ω |
                |NumStability.vecNorm2 (fun i => X i ω) -
                  Real.sqrt (n : ℝ)| ≥ t} ≤
              2 * Real.exp (-(c * t ^ 2)) := by
  rcases NumStability.HDP.Vector.NormConcentration.euclideanNormDeviation_tail with
    ⟨c₀, hc₀, hTail⟩
  let c := c₀ / 16
  have hc : 0 < c := div_pos hc₀ (by norm_num)
  refine ⟨c, hc, ?_⟩
  intro n _ Ω _ μ _ X hMeas hX t ht
  have hCoord := isStandardNormal_iff_iIndepFun_hasLaw.mp hX
  have hFinite : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) < ∞ := by
    intro i
    rw [psiTwoGauge_eq_of_hasLaw (hMeas i) (hCoord.2 i)]
    exact NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_finite.1
  have hSecond : ∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1 := by
    intro i
    calc
      (∫ ω, X i ω ^ 2 ∂μ) = ∫ x : ℝ, x ^ 2 ∂gaussianReal 0 1 := by
        simpa [Function.comp_def] using
          (hCoord.2 i).integral_comp
            (by fun_prop : AEStronglyMeasurable (fun x : ℝ => x ^ 2)
              (gaussianReal 0 1))
      _ = 1 := integral_standardGaussian_sq
  let K := NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  have hKnonneg : 0 ≤ K := by
    dsimp [K]
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
  have hKpos : 0 < K := by
    have hLower :=
      NumStability.HDP.Vector.NormConcentration.one_le_scaled_psiTwoNormMax_sq
        X hMeas hFinite hSecond
    by_contra hNot
    have hKzero : K = 0 := le_antisymm (le_of_not_gt hNot) hKnonneg
    rw [show NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X = K by rfl,
      hKzero] at hLower
    norm_num at hLower
  have hKle : K ≤ 2 := standardGaussian_psiTwoNormMax_le_two hMeas hX
  have hKsq : K ^ 2 ≤ 4 := by nlinarith
  have hKfour : K ^ 4 ≤ 16 := by
    nlinarith [sq_nonneg (K ^ 2), mul_self_le_mul_self (sq_nonneg K) hKsq]
  have hKfourPos : 0 < K ^ 4 := pow_pos hKpos 4
  have hBound := hTail X hMeas hFinite hSecond hCoord.1 ht
  refine hBound.trans ?_
  apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
  apply neg_le_neg
  have hRatio : c₀ * t ^ 2 / 16 ≤ c₀ * t ^ 2 / K ^ 4 :=
    div_le_div_of_nonneg_left (mul_nonneg hc₀.le (sq_nonneg t)) hKfourPos hKfour
  calc
    c * t ^ 2 = c₀ * t ^ 2 / 16 := by dsimp [c]; ring
    _ ≤ c₀ * t ^ 2 / K ^ 4 := hRatio

/-- Equation (3.11): a canonical standard-Gaussian vector falls below half
the square-root dimension with exponentially small probability. -/
theorem standardGaussianEuclideanNorm_lowerHalf_tail :
    ∃ c : ℝ, 0 < c ∧ ∀ {n : ℕ}, 0 < n →
      (NumStability.standardGaussianVectorMeasure n).real
          {x | NumStability.vecNorm2 x < Real.sqrt n / 2} ≤
        2 * Real.exp (-(c * n)) := by
  rcases standardGaussianEuclideanNormDeviation_tail with ⟨c₀, hc₀, hTail⟩
  let c : ℝ := c₀ / 4
  have hc : 0 < c := div_pos hc₀ (by norm_num)
  refine ⟨c, hc, ?_⟩
  intro n hn
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  let mu := NumStability.standardGaussianVectorMeasure n
  let s : ℝ := Real.sqrt n
  have hs : 0 ≤ s := Real.sqrt_nonneg _
  have hsSq : s ^ 2 = (n : ℝ) := by
    dsimp [s]
    exact Real.sq_sqrt (by positivity)
  have hStandard : IsStandardNormal mu
      (fun i (x : Fin n → ℝ) ↦ x i) := by
    simpa [mu] using
      (ProbabilityTheory.HasLaw.id
        (μ := NumStability.standardGaussianVectorMeasure n))
  have hDeviation := hTail
    (X := fun i (x : Fin n → ℝ) ↦ x i)
    (fun _ ↦ measurable_pi_apply _)
    hStandard (t := s / 2) (by positivity)
  have hsub : {x : Fin n → ℝ | NumStability.vecNorm2 x < s / 2} ⊆
      {x | |NumStability.vecNorm2 x - s| ≥ s / 2} := by
    intro x hx
    change NumStability.vecNorm2 x < s / 2 at hx
    change |NumStability.vecNorm2 x - s| ≥ s / 2
    have hxnorm := NumStability.vecNorm2_nonneg x
    rw [abs_of_nonpos (by linarith)]
    linarith
  calc
    mu.real {x | NumStability.vecNorm2 x < s / 2} ≤
        mu.real {x | |NumStability.vecNorm2 x - s| ≥ s / 2} :=
      MeasureTheory.measureReal_mono hsub
    _ ≤ 2 * Real.exp (-(c₀ * (s / 2) ^ 2)) := by
      simpa [mu, s] using hDeviation
    _ = 2 * Real.exp (-(c * n)) := by
      congr 2
      dsimp [c]
      rw [show (s / 2) ^ 2 = s ^ 2 / 4 by ring, hsSq]
      ring

end NumStability.HDP.Vector.Gaussian
