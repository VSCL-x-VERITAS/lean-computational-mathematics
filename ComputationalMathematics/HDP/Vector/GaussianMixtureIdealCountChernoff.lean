import ComputationalMathematics.HDP.Vector.GaussianMixtureIdeal

/-!
# Canonical ideal-error count MGF and explicit exponential count-confidence thresholds.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- The canonical independent ideal-error indicators have the Poisson-type
MGF upper bound, with the existing Gaussian single-row probability parameter. -/
theorem canonicalIdealMarginErrorCount_mgf_le {m n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (lam : ℝ) (hlam : 0 ≤ lam) :
    let Count := fun ω : Fin m → ℝ × (Fin n → ℝ) =>
      (Set.ncard (idealMarginErrors (fun i => canonicalLabel ω i) mean
        (fun i => canonicalPoint mean ω i) (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)
    Integrable (fun ω => Real.exp (lam * Count ω)) (latentNoiseSampleMeasure m n) ∧
      (∫ ω, Real.exp (lam * Count ω) ∂(latentNoiseSampleMeasure m n)) ≤
        Real.exp ((Real.exp lam - 1) * (m : ℝ) *
          (4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64))) := by
  dsimp only
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let p := 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)
  let W : Fin m → (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun i => canonicalIdealMarginErrorIndicator mean i
  have hW : ∀ i, Measurable (W i) :=
    fun i => measurable_canonicalIdealMarginErrorIndicator mean i
  have hIndep : iIndepFun W μ := canonicalIdealMarginErrorIndicators_iIndep mean
  have hIntegrable : ∀ i, Integrable (W i) μ := by
    intro i
    apply (integrable_const (1 : ℝ)).mono' (hW i).aestronglyMeasurable
    filter_upwards [] with ω
    rw [Real.norm_eq_abs]
    have h := canonicalIdealMarginErrorIndicator_mem_Icc mean i ω
    exact abs_le.mpr ⟨by linarith [h.1], h.2⟩
  have hAffine : ∀ i,
      (fun ω => Real.exp (lam * W i ω)) =
        (fun ω => 1 + (Real.exp lam - 1) * W i ω) := by
    intro i
    funext ω
    dsimp [W, canonicalIdealMarginErrorIndicator, idealMarginErrorIndicator]
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
      (∫ ω, canonicalIdealMarginErrorIndicator mean i ω ∂(latentNoiseSampleMeasure m n))
      by rfl, integral_canonicalIdealMarginErrorIndicator]
    exact canonicalIdealMarginError_measure_le mean i hmean
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
      _ ≤ _ := by simpa only [add_comm] using Real.add_one_le_exp ((Real.exp lam - 1) * p)
  have hCount : (fun ω : Fin m → ℝ × (Fin n → ℝ) =>
      (Set.ncard (idealMarginErrors (fun i => canonicalLabel ω i) mean
        (fun i => canonicalPoint mean ω i) (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)) =
      (fun ω => ∑ i, W i ω) := by
    funext ω
    exact (sum_canonicalIdealMarginErrorIndicator_eq_ncard mean ω).symm
  have hCountValue : ∀ ω : Fin m → ℝ × (Fin n → ℝ),
      (Set.ncard (idealMarginErrors (fun i => canonicalLabel ω i) mean
        (fun i => canonicalPoint mean ω i) (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) =
      ∑ i, W i ω := fun ω => congrFun hCount ω
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
        dsimp [p]
        ring

/-- Ordinary exponential-Markov upper tail of the canonical ideal-error count,
using its already established model-specific MGF bound. -/
theorem canonicalIdealMarginErrorCount_exp_markov_le {m n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (lam t : ℝ) (hlam : 0 < lam) :
    (latentNoiseSampleMeasure m n).real
      {ω | t ≤ (Set.ncard (idealMarginErrors
        (fun i => canonicalLabel ω i) mean
        (fun i => canonicalPoint mean ω i)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)} ≤
      Real.exp (-(lam * t) + (Real.exp lam - 1) * (m : ℝ) *
        (4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64))) := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let Count : (Fin m → ℝ × (Fin n → ℝ)) → ℝ := fun ω =>
    (Set.ncard (idealMarginErrors
      (fun i => canonicalLabel ω i) mean
      (fun i => canonicalPoint mean ω i)
      (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)
  have hCount : Count = fun ω => ∑ i, canonicalIdealMarginErrorIndicator mean i ω := by
    funext ω
    exact (sum_canonicalIdealMarginErrorIndicator_eq_ncard mean ω).symm
  have hMeas : Measurable Count := by
    rw [hCount]
    exact Finset.measurable_sum Finset.univ fun i _ =>
      measurable_canonicalIdealMarginErrorIndicator mean i
  have hMGF := canonicalIdealMarginErrorCount_mgf_le (m := m) mean hmean lam hlam.le
  change μ.real {ω | t ≤ Count ω} ≤ _
  calc
    _ ≤ Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * Count ω) ∂μ) :=
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
        hMeas hlam hMGF.1
    _ ≤ Real.exp (-(lam * t)) *
        Real.exp ((Real.exp lam - 1) * (m : ℝ) *
          (4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64))) :=
      mul_le_mul_of_nonneg_left hMGF.2 (Real.exp_nonneg _)
    _ = _ := (Real.exp_add _ _).symm

/-- Ordinary ideal-error count tail with an exponent linear in the allowed
error fraction, under the explicit Gaussian one-row probability threshold. -/
theorem canonicalIdealMarginErrorCount_half_fraction_linear_tail {m n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (epsilon : ℝ)
    (hprob : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) ≤ epsilon / 8) :
    (latentNoiseSampleMeasure m n).real
      {ω | epsilon * m / 2 ≤ (Set.ncard (idealMarginErrors
        (fun i => canonicalLabel ω i) mean
        (fun i => canonicalPoint mean ω i)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)} ≤
      Real.exp (-(epsilon * m) / 4) := by
  let p : ℝ := 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)
  have hp : 0 ≤ p := by dsimp [p]; positivity
  have he : Real.exp 1 - 1 ≤ 2 := by linarith [Real.exp_one_lt_three]
  have hfactor : (Real.exp 1 - 1) * p ≤ epsilon / 4 := by
    calc
      _ ≤ 2 * p := mul_le_mul_of_nonneg_right he hp
      _ ≤ _ := by change p ≤ epsilon / 8 at hprob; linarith
  have htotal := mul_le_mul_of_nonneg_left hfactor (Nat.cast_nonneg m : (0 : ℝ) ≤ m)
  have hexponent :
      -(1 * (epsilon * m / 2)) + (Real.exp 1 - 1) * (m : ℝ) * p ≤
        -(epsilon * m) / 4 := by nlinarith
  have htail := canonicalIdealMarginErrorCount_exp_markov_le
    (m := m) mean hmean 1 (epsilon * m / 2) (by norm_num)
  exact htail.trans (Real.exp_le_exp.mpr hexponent)

/-- The ordinary linear count exponent meets the dimension confidence when
the explicit product epsilon*m is at least four times the dimension. -/
theorem canonicalIdealMarginErrorCount_half_fraction_dimension_tail {m n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (epsilon : ℝ)
    (hprob : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) ≤ epsilon / 8)
    (hsample : 4 * (n : ℝ) ≤ epsilon * m) :
    (latentNoiseSampleMeasure m n).real
      {ω | epsilon * m / 2 ≤ (Set.ncard (idealMarginErrors
        (fun i => canonicalLabel ω i) mean
        (fun i => canonicalPoint mean ω i)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)} ≤
      Real.exp (-(n : ℝ)) := by
  exact (canonicalIdealMarginErrorCount_half_fraction_linear_tail
    mean hmean epsilon hprob).trans (Real.exp_le_exp.mpr (by linarith))

end NumStability.HDP.Vector.GaussianMixture
