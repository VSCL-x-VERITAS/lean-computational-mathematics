import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding.Basic
import ComputationalMathematics.HDP.Vector.GaussianMixtureNoiseNormIndicators

/-!
# MGF, exponential Markov and explicit linear count tails for exceptional Gaussian noise norms.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- The actual exceptional-noise row count has the Poisson-type MGF bound
whenever every row's exceptional probability is at most the explicit p. -/
theorem canonicalNoiseNormExceptionalCount_mgf_le {m n : ℕ}
    (radius p : ℝ)
    (hp : ∀ i : Fin m, (latentNoiseSampleMeasure m n).real
      {ω | radius < NumStability.vecNorm2 (canonicalNoise ω i)} ≤ p)
    (lam : ℝ) (hlam : 0 ≤ lam) :
    let Count := fun ω : Fin m → ℝ × (Fin n → ℝ) =>
      (Set.ncard {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)
    Integrable (fun ω => Real.exp (lam * Count ω)) (latentNoiseSampleMeasure m n) ∧
      (∫ ω, Real.exp (lam * Count ω) ∂(latentNoiseSampleMeasure m n)) ≤
        Real.exp ((Real.exp lam - 1) * (m : ℝ) * p) := by
  dsimp only
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let W : Fin m → (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun i => canonicalNoiseNormExceptionalIndicator radius i
  have hW : ∀ i, Measurable (W i) :=
    fun i => measurable_canonicalNoiseNormExceptionalIndicator radius i
  have hIndep : iIndepFun W μ :=
    canonicalNoiseNormExceptionalIndicators_iIndep m n radius
  have hIntegrable : ∀ i, Integrable (W i) μ := by
    intro i
    apply (integrable_const (1 : ℝ)).mono' (hW i).aestronglyMeasurable
    filter_upwards [] with ω
    rw [Real.norm_eq_abs]
    have h := canonicalNoiseNormExceptionalIndicator_mem_Icc radius i ω
    exact abs_le.mpr ⟨by linarith [h.1], h.2⟩
  have hAffine : ∀ i,
      (fun ω => Real.exp (lam * W i ω)) =
        (fun ω => 1 + (Real.exp lam - 1) * W i ω) := by
    intro i
    funext ω
    dsimp [W, canonicalNoiseNormExceptionalIndicator, Set.indicator]
    split_ifs
    · simp only [mul_one]
      ring
    · simp
  have hExp : ∀ i, Integrable (fun ω => Real.exp (lam * W i ω)) μ := by
    intro i
    rw [hAffine i]
    exact (integrable_const (1 : ℝ)).add ((hIntegrable i).const_mul _)
  have hMean : ∀ i, (∫ ω, W i ω ∂μ) ≤ p := by
    intro i
    rw [show (∫ ω, W i ω ∂μ) =
      (∫ ω, canonicalNoiseNormExceptionalIndicator radius i ω
        ∂(latentNoiseSampleMeasure m n)) by rfl,
      integral_canonicalNoiseNormExceptionalIndicator]
    exact hp i
  have hcoefficient : 0 ≤ Real.exp lam - 1 := by
    linarith [Real.add_one_le_exp lam]
  have hFactor : ∀ i, (∫ ω, Real.exp (lam * W i ω) ∂μ) ≤
      Real.exp ((Real.exp lam - 1) * p) := by
    intro i
    calc
      _ = 1 + (Real.exp lam - 1) * (∫ ω, W i ω ∂μ) := by
        rw [hAffine i, integral_add (integrable_const (1 : ℝ))
          ((hIntegrable i).const_mul _), integral_const_mul]
        simp
      _ ≤ 1 + (Real.exp lam - 1) * p := by
        have h := mul_le_mul_of_nonneg_left (hMean i) hcoefficient
        linarith
      _ ≤ _ := by
        simpa only [add_comm] using Real.add_one_le_exp ((Real.exp lam - 1) * p)
  have hCountValue : ∀ ω : Fin m → ℝ × (Fin n → ℝ),
      (Set.ncard {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ) =
        ∑ i, W i ω := by
    intro ω
    exact (sum_canonicalNoiseNormExceptionalIndicator_eq_ncard radius ω).symm
  simp_rw [hCountValue]
  refine ⟨?_, ?_⟩
  · have h := hIndep.integrable_exp_mul_sum (t := lam) hW
      (s := Finset.univ) (fun i _ => hExp i)
    simpa only [Finset.sum_apply] using h
  · calc
      _ = ∏ i, ∫ ω, Real.exp (lam * W i ω) ∂μ := by
        simpa only [one_mul] using
          (NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
            (μ := μ) (X := W) lam (fun _ => 1) hIndep
            (fun i => by simpa only [one_mul] using hExp i))
      _ ≤ ∏ _i : Fin m, Real.exp ((Real.exp lam - 1) * p) :=
        Finset.prod_le_prod (fun _ _ => integral_nonneg (fun _ => Real.exp_nonneg _))
          (fun i _ => hFactor i)
      _ = _ := by
        rw [← Real.exp_sum]
        simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
        congr 1
        ring

/-- Exponential Markov applied to the actual independent exceptional-noise
count, retaining the explicit per-row probability bound. -/
theorem canonicalNoiseNormExceptionalCount_exp_markov_le {m n : ℕ}
    (radius p : ℝ)
    (hp : ∀ i : Fin m, (latentNoiseSampleMeasure m n).real
      {ω | radius < NumStability.vecNorm2 (canonicalNoise ω i)} ≤ p)
    (lam t : ℝ) (hlam : 0 < lam) :
    (latentNoiseSampleMeasure m n).real
      {ω | t ≤ (Set.ncard
        {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)} ≤
      Real.exp (-(lam * t) + (Real.exp lam - 1) * (m : ℝ) * p) := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let Count : (Fin m → ℝ × (Fin n → ℝ)) → ℝ := fun ω =>
    (Set.ncard {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)
  have hCount : Count =
      fun ω => ∑ i, canonicalNoiseNormExceptionalIndicator radius i ω := by
    funext ω
    exact (sum_canonicalNoiseNormExceptionalIndicator_eq_ncard radius ω).symm
  have hMeas : Measurable Count := by
    rw [hCount]
    exact Finset.measurable_sum Finset.univ fun i _ =>
      measurable_canonicalNoiseNormExceptionalIndicator radius i
  have hMGF := canonicalNoiseNormExceptionalCount_mgf_le
    (m := m) radius p hp lam hlam.le
  change μ.real {ω | t ≤ Count ω} ≤ _
  calc
    _ ≤ Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * Count ω) ∂μ) :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
        hMeas hlam hMGF.1
    _ ≤ Real.exp (-(lam * t)) *
        Real.exp ((Real.exp lam - 1) * (m : ℝ) * p) :=
      mul_le_mul_of_nonneg_left hMGF.2 (Real.exp_nonneg _)
    _ = _ := (Real.exp_add _ _).symm

/-- Explicit per-row probability control yields an exceptional-noise count
tail with exponent linear in the allowed fraction. -/
theorem canonicalNoiseNormExceptionalCount_half_fraction_linear_tail {m n : ℕ}
    (radius p epsilon : ℝ) (hp : 0 ≤ p)
    (hrow : ∀ i : Fin m, (latentNoiseSampleMeasure m n).real
      {ω | radius < NumStability.vecNorm2 (canonicalNoise ω i)} ≤ p)
    (hprob : p ≤ epsilon / 8) :
    (latentNoiseSampleMeasure m n).real
      {ω | epsilon * m / 2 ≤ (Set.ncard
        {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)} ≤
      Real.exp (-(epsilon * m) / 4) := by
  have he : Real.exp 1 - 1 ≤ 2 := by linarith [Real.exp_one_lt_three]
  have hfactor : (Real.exp 1 - 1) * p ≤ epsilon / 4 := by
    calc
      _ ≤ 2 * p := mul_le_mul_of_nonneg_right he hp
      _ ≤ _ := by linarith
  have htotal := mul_le_mul_of_nonneg_left hfactor (Nat.cast_nonneg m : (0 : ℝ) ≤ m)
  have hexponent :
      -(1 * (epsilon * m / 2)) + (Real.exp 1 - 1) * (m : ℝ) * p ≤
        -(epsilon * m) / 4 := by nlinarith
  have htail := canonicalNoiseNormExceptionalCount_exp_markov_le
    (m := m) radius p hrow 1 (epsilon * m / 2) (by norm_num)
  exact htail.trans (Real.exp_le_exp.mpr hexponent)

/-- The exceptional-noise count's explicit sample product threshold gives
the dimension confidence exp(-n). -/
theorem canonicalNoiseNormExceptionalCount_half_fraction_dimension_tail {m n : ℕ}
    (radius p epsilon : ℝ) (hp : 0 ≤ p)
    (hrow : ∀ i : Fin m, (latentNoiseSampleMeasure m n).real
      {ω | radius < NumStability.vecNorm2 (canonicalNoise ω i)} ≤ p)
    (hprob : p ≤ epsilon / 8) (hsample : 4 * (n : ℝ) ≤ epsilon * m) :
    (latentNoiseSampleMeasure m n).real
      {ω | epsilon * m / 2 ≤ (Set.ncard
        {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)} ≤
      Real.exp (-(n : ℝ)) := by
  exact (canonicalNoiseNormExceptionalCount_half_fraction_linear_tail
    radius p epsilon hp hrow hprob).trans (Real.exp_le_exp.mpr (by linarith))

/-- One uniform Gaussian-shell constant gives dimension confidence for the
actual noise-count event, under explicit row-probability and sample thresholds. -/
theorem exists_canonicalNoise_norm_exceptional_count_dimension_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {m n : ℕ}, 0 < n → ∀ (t epsilon : ℝ), 0 ≤ t →
        2 * Real.exp (-(c * t ^ 2)) ≤ epsilon / 8 →
        4 * (n : ℝ) ≤ epsilon * m →
        (latentNoiseSampleMeasure m n).real
          {ω | epsilon * m / 2 ≤ (Set.ncard
            {i | Real.sqrt (n : ℝ) + t <
              NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)} ≤
          Real.exp (-(n : ℝ)) := by
  obtain ⟨c, hc, hTail⟩ := exists_canonicalNoise_row_norm_upper_tail
  refine ⟨c, hc, ?_⟩
  intro m n hn t epsilon ht hprob hsample
  exact canonicalNoiseNormExceptionalCount_half_fraction_dimension_tail
    (Real.sqrt (n : ℝ) + t) (2 * Real.exp (-(c * t ^ 2))) epsilon
    (by positivity) (fun i => hTail hn i t ht) hprob hsample

end NumStability.HDP.Vector.GaussianMixture
