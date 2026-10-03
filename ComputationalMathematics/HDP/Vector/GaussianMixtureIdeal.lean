import ComputationalMathematics.HDP.Vector.GaussianMixtureConcentration
import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding.Basic
import ComputationalMathematics.HDP.Probability.FiniteUnion

/-!
# Ideal-direction classification in the symmetric Gaussian mixture

This file isolates the second probabilistic input to spectral clustering:
classification by the population direction.  It records the almost-sure
Rademacher support and a dimension-free Gaussian tail for a fixed noise
projection.
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators RealInnerProductSpace

namespace NumStability.HDP.Vector.GaussianMixture

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- The real Rademacher law is concentrated on `{-1, 1}`. -/
theorem rademacher_ae_eq_neg_one_or_one :
    ∀ᵐ z ∂rademacherPMF.toMeasure, z = -1 ∨ z = 1 := by
  rw [show rademacherPMF.toMeasure =
      Measure.map rademacherValue fairBernoulliPMF.toMeasure by
    simpa [rademacherPMF] using
      (PMF.toMeasure_map rademacherValue fairBernoulliPMF
        (measurable_of_countable rademacherValue)).symm]
  apply (ae_map_iff
    (measurable_of_countable rademacherValue).aemeasurable
    ((measurableSet_singleton (-1 : ℝ)).union
      (measurableSet_singleton (1 : ℝ)))).2
  refine Filter.Eventually.of_forall ?_
  intro b
  change rademacherValue b = -1 ∨ rademacherValue b = 1
  cases b <;> simp [rademacherValue]

/-- Every canonical latent label has the Rademacher law. -/
theorem canonicalLabel_hasLaw (m n : ℕ) (i : Fin m) :
    HasLaw (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalLabel ω i)
      rademacherPMF.toMeasure (latentNoiseSampleMeasure m n) := by
  simpa [canonicalLabel] using
    (latentSign_hasLaw n).fun_comp (canonicalRow_hasLaw m n i)

/-- All labels in a finite canonical sample lie in `{-1,1}` almost surely. -/
theorem canonicalLabels_ae_eq_neg_one_or_one (m n : ℕ) :
    ∀ᵐ ω ∂latentNoiseSampleMeasure m n,
      ∀ i, canonicalLabel ω i = -1 ∨ canonicalLabel ω i = 1 := by
  rw [ae_all_iff]
  intro i
  exact ((canonicalLabel_hasLaw m n i).ae_iff (by fun_prop)).2
    rademacher_ae_eq_neg_one_or_one

/-- The projection of a canonical noise row on a nonzero deterministic
direction has `ψ₂` norm at most twice the Euclidean length of that direction. -/
theorem canonicalNoise_projection_psiTwoNorm_le {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
        (latentNoiseSampleMeasure m n)
        (fun ω ↦ dotProduct mean (canonicalNoise ω i)) ≤
      ENNReal.ofReal (2 * NumStability.vecNorm2 mean) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  by_cases hmean : NumStability.vecNorm2 mean = 0
  · have hz : mean = 0 := by
      exact funext ((NumStability.vecNorm2_eq_zero_iff mean).mp hmean)
    subst mean
    have hzero :
        (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦
          dotProduct (0 : Fin n → ℝ) (canonicalNoise ω i)) = 0 := by
      funext ω
      simp [dotProduct]
    rw [hzero]
    change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (latentNoiseSampleMeasure m n) (fun _ ↦ (0 : ℝ)) ≤
      ENNReal.ofReal (2 * NumStability.vecNorm2 (0 : Fin n → ℝ))
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_zero]
    simp [NumStability.vecNorm2, NumStability.vecNorm2Sq]
  · let r : ℝ := NumStability.vecNorm2 mean
    have hr : 0 < r := lt_of_le_of_ne (NumStability.vecNorm2_nonneg mean)
      (Ne.symm hmean)
    let u : NumStability.HDP.Vector.SubGaussian.UnitDirection n :=
      ⟨r⁻¹ • mean, by
        dsimp [r]
        change NumStability.vecNorm2
          (fun j ↦ (NumStability.vecNorm2 mean)⁻¹ * mean j) = 1
        rw [NumStability.vecNorm2_smul, abs_inv,
          abs_of_nonneg (NumStability.vecNorm2_nonneg mean),
          inv_mul_cancel₀ hmean]⟩
    have hNoiseLaw : HasLaw
        (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalNoise ω i)
        (NumStability.standardGaussianVectorMeasure n)
        (latentNoiseSampleMeasure m n) := by
      have hSnd : HasLaw (fun z : ℝ × (Fin n → ℝ) ↦ z.2)
          (NumStability.standardGaussianVectorMeasure n)
          (latentNoiseObservationMeasure n) :=
        MeasureTheory.measurePreserving_snd.hasLaw
      simpa [canonicalNoise] using hSnd.fun_comp (canonicalRow_hasLaw m n i)
    have hUnitLaw :=
      (NumStability.HDP.Vector.Gaussian.unitWeightedGaussianLaw u).fun_comp
        hNoiseLaw
    have hNoiseMeas : Measurable
        (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦ canonicalNoise ω i) := by
      unfold canonicalNoise
      fun_prop
    have hUnitMeas : Measurable
        (fun ω : Fin m → ℝ × (Fin n → ℝ) ↦
          ∑ j, u.1 j * canonicalNoise ω i j) := by
      exact Finset.measurable_sum Finset.univ fun j _hj ↦
        measurable_const.mul ((measurable_pi_apply j).comp hNoiseMeas)
    have hUnitPsi :
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
            (latentNoiseSampleMeasure m n)
            (fun ω ↦ ∑ j, u.1 j * canonicalNoise ω i j) ≤
          ENNReal.ofReal 2 := by
      rw [NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_hasLaw
        hUnitMeas hUnitLaw]
      simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
        NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul.1
    have hPoint :
        (fun ω ↦ dotProduct mean (canonicalNoise ω i)) =
          fun ω ↦ r * ∑ j, u.1 j * canonicalNoise ω i j := by
      funext ω
      dsimp [u, r, dotProduct]
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _hj
      field_simp [hmean]
    rw [hPoint]
    change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        (latentNoiseSampleMeasure m n)
        (fun ω ↦ r * ∑ j, u.1 j * canonicalNoise ω i j) ≤
      ENNReal.ofReal (2 * NumStability.vecNorm2 mean)
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero hr.ne']
    change ENNReal.ofReal |r| *
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (latentNoiseSampleMeasure m n)
          (fun ω ↦ ∑ j, u.1 j * canonicalNoise ω i j) ≤ _
    calc
      ENNReal.ofReal |r| *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
            (latentNoiseSampleMeasure m n)
            (fun ω ↦ ∑ j, u.1 j * canonicalNoise ω i j) ≤
          ENNReal.ofReal |r| * ENNReal.ofReal 2 :=
        mul_le_mul_right hUnitPsi _
      _ = ENNReal.ofReal (2 * NumStability.vecNorm2 mean) := by
        rw [← ENNReal.ofReal_mul (abs_nonneg r)]
        congr 1
        rw [abs_of_pos hr]
        dsimp [r]
        ring

/-- A fixed canonical Gaussian-noise projection has the expected two-sided
Gaussian tail at half the squared signal length. -/
theorem canonicalNoise_projection_halfSignal_tail {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m)
    (hmean : 0 < NumStability.vecNorm2 mean) :
    (latentNoiseSampleMeasure m n).real
        {ω | NumStability.vecNorm2 mean ^ 2 / 2 ≤
          |dotProduct mean (canonicalNoise ω i)|} ≤
      4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  let X : (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun ω ↦ dotProduct mean (canonicalNoise ω i)
  let r : ℝ := NumStability.vecNorm2 mean
  have hX : Measurable X := by
    dsimp [X, dotProduct, canonicalNoise]
    fun_prop
  have hr : 0 < r := by simpa [r] using hmean
  have hK : 0 < 2 * r := by positivity
  have hu : 0 ≤ r ^ 2 / 2 := by positivity
  have hPsi :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (latentNoiseSampleMeasure m n) X ≤ ENNReal.ofReal (2 * r) := by
    simpa [X, r] using canonicalNoise_projection_psiTwoNorm_le mean i
  have hNegPsi :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
          (latentNoiseSampleMeasure m n) (fun ω ↦ -X ω) ≤
        ENNReal.ofReal (2 * r) := by
    unfold NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm
    rw [show (fun ω ↦ -X ω) = (fun ω ↦ (-1 : ℝ) * X ω) by
      funext ω
      ring]
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero
      (by norm_num : (-1 : ℝ) ≠ 0)]
    simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using hPsi
  have hUpper :=
    NumStability.HDP.Scalar.SubGaussian.oneSidedTail_le_of_psiTwoNorm_le
      hX hK hPsi hu
  have hLower :=
    NumStability.HDP.Scalar.SubGaussian.oneSidedTail_le_of_psiTwoNorm_le
      hX.neg hK hNegPsi hu
  have hsubset :
      {ω | r ^ 2 / 2 ≤ |X ω|} ⊆
        {ω | r ^ 2 / 2 ≤ X ω} ∪ {ω | r ^ 2 / 2 ≤ -X ω} := by
    intro ω hω
    simp only [Set.mem_setOf_eq, Set.mem_union]
    by_cases hx : 0 ≤ X ω
    · exact Or.inl (by simpa [abs_of_nonneg hx] using hω)
    · exact Or.inr (by simpa [abs_of_neg (lt_of_not_ge hx)] using hω)
  calc
    (latentNoiseSampleMeasure m n).real
        {ω | NumStability.vecNorm2 mean ^ 2 / 2 ≤
          |dotProduct mean (canonicalNoise ω i)|} =
        (latentNoiseSampleMeasure m n).real
          {ω | r ^ 2 / 2 ≤ |X ω|} := by rfl
    _ ≤ (latentNoiseSampleMeasure m n).real
        ({ω | r ^ 2 / 2 ≤ X ω} ∪ {ω | r ^ 2 / 2 ≤ -X ω}) :=
      measureReal_mono hsubset (measure_ne_top _ _)
    _ ≤ (latentNoiseSampleMeasure m n).real {ω | r ^ 2 / 2 ≤ X ω} +
        (latentNoiseSampleMeasure m n).real {ω | r ^ 2 / 2 ≤ -X ω} :=
      measureReal_union_le _ _
    _ ≤ 2 * (2 * Real.exp (-(r ^ 2 / 2) ^ 2 /
          (4 * (2 * r) ^ 2))) := by linarith
    _ = 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) := by
      have hexponent :
          -(r ^ 2 / 2) ^ 2 / (4 * (2 * r) ^ 2) = -(r ^ 2) / 64 := by
        field_simp [hr.ne']
        ring
      rw [hexponent]
      dsimp [r]
      ring

/-- Classifying a canonical mixture row by the population direction can fail
at half the signal margin only when the one-dimensional Gaussian noise
projection is at least half the squared signal length. -/
theorem canonicalIdealMarginError_ae_subset_noiseTail {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m) :
    { ω | canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
        NumStability.vecNorm2 mean ^ 2 / 2 } ≤ᵐ[
      latentNoiseSampleMeasure m n]
      { ω | NumStability.vecNorm2 mean ^ 2 / 2 ≤
        |dotProduct mean (canonicalNoise ω i)| } := by
  filter_upwards [((canonicalLabel_hasLaw m n i).ae_iff (by fun_prop)).2
    rademacher_ae_eq_neg_one_or_one] with ω hlabel herror
  have hsq :
      (∑ j, mean j * mean j) = NumStability.vecNorm2 mean ^ 2 := by
    rw [show (∑ j, mean j * mean j) = ∑ j, mean j ^ 2 by
      apply Finset.sum_congr rfl
      intro j _hj
      ring]
    exact (NumStability.vecNorm2_sq mean).symm
  change canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
      NumStability.vecNorm2 mean ^ 2 / 2 at herror
  change NumStability.vecNorm2 mean ^ 2 / 2 ≤
      |dotProduct mean (canonicalNoise ω i)|
  rcases hlabel with hlabel | hlabel
  · change (ω i).1 = -1 at hlabel
    change (ω i).1 * dotProduct mean (canonicalPoint mean ω i) ≤
      NumStability.vecNorm2 mean ^ 2 / 2 at herror
    rw [hlabel] at herror
    have hformula :
        dotProduct mean (canonicalPoint mean ω i) =
          -NumStability.vecNorm2 mean ^ 2 +
            dotProduct mean (canonicalNoise ω i) := by
      simp only [canonicalPoint, mixtureMap, canonicalNoise, dotProduct, hlabel]
      simp_rw [mul_add]
      rw [Finset.sum_add_distrib]
      rw [show (∑ x, mean x * (-1 * mean x)) =
          -(∑ x, mean x * mean x) by
        rw [← Finset.sum_neg_distrib]
        apply Finset.sum_congr rfl
        intro j _hj
        ring]
      rw [hsq]
    rw [hformula] at herror
    have hz : NumStability.vecNorm2 mean ^ 2 / 2 ≤
        dotProduct mean (canonicalNoise ω i) := by linarith
    exact hz.trans (le_abs_self _)
  · change (ω i).1 = 1 at hlabel
    change (ω i).1 * dotProduct mean (canonicalPoint mean ω i) ≤
      NumStability.vecNorm2 mean ^ 2 / 2 at herror
    rw [hlabel] at herror
    have hformula :
        dotProduct mean (canonicalPoint mean ω i) =
          NumStability.vecNorm2 mean ^ 2 +
            dotProduct mean (canonicalNoise ω i) := by
      simp only [canonicalPoint, mixtureMap, canonicalNoise, dotProduct, hlabel,
        one_mul]
      simp_rw [mul_add]
      rw [Finset.sum_add_distrib, hsq]
    rw [hformula] at herror
    have hz : NumStability.vecNorm2 mean ^ 2 / 2 ≤
        -dotProduct mean (canonicalNoise ω i) := by linarith
    exact hz.trans (neg_le_abs _)

/-- One canonical row violates the population-direction half-signal margin
with probability at most the corresponding Gaussian projection tail. -/
theorem canonicalIdealMarginError_measure_le {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m)
    (hmean : 0 < NumStability.vecNorm2 mean) :
    (latentNoiseSampleMeasure m n).real
        { ω | canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
          NumStability.vecNorm2 mean ^ 2 / 2 } ≤
      4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  have hmono :
      latentNoiseSampleMeasure m n
          { ω | canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
            NumStability.vecNorm2 mean ^ 2 / 2 } ≤
        latentNoiseSampleMeasure m n
          { ω | NumStability.vecNorm2 mean ^ 2 / 2 ≤
            |dotProduct mean (canonicalNoise ω i)| } :=
    measure_mono_ae (canonicalIdealMarginError_ae_subset_noiseTail mean i)
  calc
    (latentNoiseSampleMeasure m n).real
        { ω | canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
          NumStability.vecNorm2 mean ^ 2 / 2 } ≤
        (latentNoiseSampleMeasure m n).real
          { ω | NumStability.vecNorm2 mean ^ 2 / 2 ≤
            |dotProduct mean (canonicalNoise ω i)| } := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top _ _) hmono
    _ ≤ 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) :=
      canonicalNoise_projection_halfSignal_tail mean i hmean

/-- A large-signal alternative to the additive Hoeffding bound below.  If the
ideal-margin error count crosses any positive threshold, at least one row is
an ideal-margin error.  A finite union bound therefore retains the small
single-row Gaussian probability instead of replacing it by a deviation bound
that depends only on the target fraction. -/
theorem canonicalIdealMarginErrorCount_union_tail {m n : ℕ}
    (hm : 0 < m) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) {ε : ℝ}
    (hε : 0 < ε) :
    (latentNoiseSampleMeasure m n).real
        {ω | ε * m ≤
          (Set.ncard (idealMarginErrors
            (fun i ↦ canonicalLabel ω i) mean
            (fun i ↦ canonicalPoint mean ω i)
            (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)} ≤
      (m : ℝ) *
        (4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ :=
    ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let E : Fin m → Set (Fin m → ℝ × (Fin n → ℝ)) :=
    fun i ↦
      {ω | canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
        NumStability.vecNorm2 mean ^ 2 / 2}
  let p : ℝ := 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)
  have hp : 0 ≤ p := by
    dsimp [p]
    positivity
  have hrow : ∀ i ∈ (Finset.univ : Finset (Fin m)), μ.real (E i) ≤ p := by
    intro i _hi
    simpa [μ, E, p] using canonicalIdealMarginError_measure_le mean i hmean
  have hunion : μ.real (⋃ i ∈ (Finset.univ : Finset (Fin m)), E i) ≤
      (Finset.univ : Finset (Fin m)).card * p :=
    NumStability.HDP.Probability.measureReal_biUnion_le
      (Finset.univ : Finset (Fin m)) E p hp hrow
  have hsubset :
      {ω | ε * m ≤
          (Set.ncard (idealMarginErrors
            (fun i ↦ canonicalLabel ω i) mean
            (fun i ↦ canonicalPoint mean ω i)
            (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)} ⊆
        ⋃ i ∈ (Finset.univ : Finset (Fin m)), E i := by
    intro ω hcount
    by_contra hnotUnion
    simp only [Set.mem_iUnion, Finset.mem_univ, not_exists] at hnotUnion
    have hnotError : ∀ i,
        ¬ (canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
          NumStability.vecNorm2 mean ^ 2 / 2) := by
      intro i
      simpa [E] using hnotUnion i
    have hempty :
        idealMarginErrors (fun i ↦ canonicalLabel ω i) mean
            (fun i ↦ canonicalPoint mean ω i)
            (NumStability.vecNorm2 mean ^ 2 / 2) = ∅ := by
      ext i
      simp [idealMarginErrors, hnotError i]
    change ε * (m : ℝ) ≤
      (Set.ncard (idealMarginErrors (fun i ↦ canonicalLabel ω i) mean
        (fun i ↦ canonicalPoint mean ω i)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) at hcount
    rw [hempty] at hcount
    simp only [Set.ncard_empty, Nat.cast_zero] at hcount
    have hmReal : 0 < (m : ℝ) := by exact_mod_cast hm
    have : 0 < ε * (m : ℝ) := mul_pos hε hmReal
    linarith
  calc
    μ.real
        {ω | ε * m ≤
          (Set.ncard (idealMarginErrors
            (fun i ↦ canonicalLabel ω i) mean
            (fun i ↦ canonicalPoint mean ω i)
            (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ)} ≤
        μ.real (⋃ i ∈ (Finset.univ : Finset (Fin m)), E i) :=
      measureReal_mono hsubset (measure_ne_top _ _)
    _ ≤ (Finset.univ : Finset (Fin m)).card * p := hunion
    _ = (m : ℝ) *
        (4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) := by
      simp [p]

/-- The `0`-`1` observable for a row lying inside the population-direction
half-signal error margin. -/
def idealMarginErrorIndicator {n : ℕ} (mean : Fin n → ℝ)
    (z : ℝ × (Fin n → ℝ)) : ℝ :=
  if z.1 * dotProduct mean (mixtureMap mean z) ≤
      NumStability.vecNorm2 mean ^ 2 / 2 then 1 else 0

/-- The rowwise ideal-margin error indicator on the canonical product
sample. -/
def canonicalIdealMarginErrorIndicator {m n : ℕ} (mean : Fin n → ℝ)
    (i : Fin m) (ω : Fin m → ℝ × (Fin n → ℝ)) : ℝ :=
  idealMarginErrorIndicator mean (ω i)

theorem measurable_idealMarginErrorIndicator {n : ℕ}
    (mean : Fin n → ℝ) : Measurable (idealMarginErrorIndicator mean) := by
  let f : (ℝ × (Fin n → ℝ)) → ℝ := fun z ↦
    z.1 * dotProduct mean (mixtureMap mean z)
  have hf : Measurable f := by
    dsimp [f, mixtureMap, dotProduct]
    fun_prop
  have hs : MeasurableSet
      {z | f z ≤ NumStability.vecNorm2 mean ^ 2 / 2} :=
    measurableSet_le hf measurable_const
  exact Measurable.ite hs measurable_const measurable_const

theorem measurable_canonicalIdealMarginErrorIndicator {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m) :
    Measurable (canonicalIdealMarginErrorIndicator mean i) := by
  exact (measurable_idealMarginErrorIndicator mean).comp (measurable_pi_apply i)

theorem canonicalIdealMarginErrorIndicator_mem_Icc {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m)
    (ω : Fin m → ℝ × (Fin n → ℝ)) :
    canonicalIdealMarginErrorIndicator mean i ω ∈ Set.Icc 0 1 := by
  unfold canonicalIdealMarginErrorIndicator idealMarginErrorIndicator
  split_ifs <;> simp

/-- The integral of the row indicator is the probability of the corresponding
ideal-margin error event. -/
theorem integral_canonicalIdealMarginErrorIndicator {m n : ℕ}
    (mean : Fin n → ℝ) (i : Fin m) :
    (∫ ω, canonicalIdealMarginErrorIndicator mean i ω
        ∂(latentNoiseSampleMeasure m n)) =
      (latentNoiseSampleMeasure m n).real
        { ω | canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
          NumStability.vecNorm2 mean ^ 2 / 2 } := by
  have hset : MeasurableSet
      { ω : Fin m → ℝ × (Fin n → ℝ) |
        canonicalLabel ω i * dotProduct mean (canonicalPoint mean ω i) ≤
          NumStability.vecNorm2 mean ^ 2 / 2 } := by
    apply measurableSet_le
    · unfold canonicalLabel canonicalPoint mixtureMap dotProduct
      fun_prop
    · fun_prop
  rw [← integral_indicator_one hset]
  apply integral_congr_ae
  filter_upwards [] with ω
  simp only [canonicalIdealMarginErrorIndicator, idealMarginErrorIndicator,
    canonicalLabel, canonicalPoint, Set.indicator, Set.mem_setOf_eq]
  split_ifs <;> rfl

/-- The canonical row-error indicators inherit independence from the product
sample. -/
theorem canonicalIdealMarginErrorIndicators_iIndep {m n : ℕ}
    (mean : Fin n → ℝ) :
    iIndepFun (fun i ↦ canonicalIdealMarginErrorIndicator mean i)
      (latentNoiseSampleMeasure m n) := by
  have h := (canonicalRows_iIndep m n).comp
    (fun _i z ↦ idealMarginErrorIndicator mean z)
    (fun _i ↦ measurable_idealMarginErrorIndicator mean)
  simpa [canonicalIdealMarginErrorIndicator, Function.comp_def] using h

/-- The sum of the canonical row indicators is exactly the number of rows in
the population-direction half-signal error margin. -/
theorem sum_canonicalIdealMarginErrorIndicator_eq_ncard {m n : ℕ}
    (mean : Fin n → ℝ) (ω : Fin m → ℝ × (Fin n → ℝ)) :
    ∑ i, canonicalIdealMarginErrorIndicator mean i ω =
      (Set.ncard (idealMarginErrors
        (fun i ↦ canonicalLabel ω i) mean
        (fun i ↦ canonicalPoint mean ω i)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) := by
  classical
  unfold canonicalIdealMarginErrorIndicator idealMarginErrorIndicator
  rw [Set.ncard_eq_toFinset_card']
  simp only [idealMarginErrors, canonicalLabel, canonicalPoint,
    Set.toFinset_setOf]
  calc
    (∑ i, if (ω i).1 * dotProduct mean (mixtureMap mean (ω i)) ≤
          NumStability.vecNorm2 mean ^ 2 / 2 then (1 : ℝ) else 0) =
        ((∑ i, if (ω i).1 * dotProduct mean (mixtureMap mean (ω i)) ≤
          NumStability.vecNorm2 mean ^ 2 / 2 then (1 : ℕ) else 0) : ℝ) := by
      norm_cast
    _ = _ := by
      norm_cast
      rw [Finset.sum_boole]
      rfl

/-- Hoeffding concentration for the number of canonical rows that violate
the population-direction half-signal margin.  The single-row error parameter
is the explicit Gaussian tail proved above. -/
theorem canonicalIdealMarginErrorCount_hoeffding {m n : ℕ}
    (hm : 0 < m) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) {ε : ℝ}
    (hε : 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64) < ε) :
    (latentNoiseSampleMeasure m n).real
        { ω | ε * m ≤
          (Set.ncard (idealMarginErrors
            (fun i ↦ canonicalLabel ω i) mean
            (fun i ↦ canonicalPoint mean ω i)
            (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) } ≤
      Real.exp (-2 * (m : ℝ) *
        (ε - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  let p : ℝ := 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)
  let N : ℝ := m
  let W : Fin m → (Fin m → ℝ × (Fin n → ℝ)) → ℝ :=
    fun i ↦ canonicalIdealMarginErrorIndicator mean i
  have hN : 0 < N := by
    dsimp [N]
    exact_mod_cast hm
  have hpε : p < ε := by simpa [p] using hε
  have hW : ∀ i, Measurable (W i) := fun i ↦ by
    simpa [W] using measurable_canonicalIdealMarginErrorIndicator mean i
  have hIndep : iIndepFun W (latentNoiseSampleMeasure m n) := by
    simpa [W] using canonicalIdealMarginErrorIndicators_iIndep mean
  have hbound : ∀ i, ∀ᵐ ω ∂(latentNoiseSampleMeasure m n),
      W i ω ∈ Set.Icc 0 1 := by
    intro i
    exact Filter.Eventually.of_forall
      (canonicalIdealMarginErrorIndicator_mem_Icc mean i)
  have hmeanW : ∀ i,
      (∫ ω, W i ω ∂(latentNoiseSampleMeasure m n)) ≤ p := by
    intro i
    rw [show (∫ ω, W i ω ∂(latentNoiseSampleMeasure m n)) =
        (∫ ω, canonicalIdealMarginErrorIndicator mean i ω
          ∂(latentNoiseSampleMeasure m n)) by rfl,
      integral_canonicalIdealMarginErrorIndicator]
    simpa [p] using canonicalIdealMarginError_measure_le mean i hmean
  have htail := boundedIndependentHoeffding
    (X := W) (m := fun _ ↦ (0 : ℝ)) (M := fun _ ↦ (1 : ℝ))
    (t := N * (ε - p)) hW hIndep hbound
      (mul_pos hN (sub_pos.mpr hpε))
    (by simpa [N] using hN)
  let A : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    { ω | ε * N ≤
      (Set.ncard (idealMarginErrors
        (fun i ↦ canonicalLabel ω i) mean
        (fun i ↦ canonicalPoint mean ω i)
        (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) }
  let C : Set (Fin m → ℝ × (Fin n → ℝ)) :=
    { ω | N * (ε - p) ≤
      ∑ i, (W i ω - ∫ y, W i y ∂(latentNoiseSampleMeasure m n)) }
  have hsumMean :
      ∑ i, (∫ y, W i y ∂(latentNoiseSampleMeasure m n)) ≤ N * p := by
    calc
      ∑ i, (∫ y, W i y ∂(latentNoiseSampleMeasure m n)) ≤
          ∑ _i : Fin m, p := Finset.sum_le_sum fun i _hi ↦ hmeanW i
      _ = N * p := by simp [N]
  have hAC : A ⊆ C := by
    intro ω hω
    change N * (ε - p) ≤
      ∑ i, (W i ω - ∫ y, W i y ∂(latentNoiseSampleMeasure m n))
    rw [Finset.sum_sub_distrib]
    have hcount : ∑ i, W i ω =
        (Set.ncard (idealMarginErrors
          (fun i ↦ canonicalLabel ω i) mean
          (fun i ↦ canonicalPoint mean ω i)
          (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) := by
      simpa [W] using sum_canonicalIdealMarginErrorIndicator_eq_ncard mean ω
    rw [hcount]
    change ε * N ≤ _ at hω
    linarith
  have hmono :
      (latentNoiseSampleMeasure m n).real A ≤
        (latentNoiseSampleMeasure m n).real C :=
    measureReal_mono hAC (measure_ne_top _ _)
  have htailC :
      (latentNoiseSampleMeasure m n).real C ≤
        Real.exp (-2 * (N * (ε - p)) ^ 2 / N) := by
    simpa [C, N, W] using htail
  calc
    (latentNoiseSampleMeasure m n).real
        { ω | ε * m ≤
          (Set.ncard (idealMarginErrors
            (fun i ↦ canonicalLabel ω i) mean
            (fun i ↦ canonicalPoint mean ω i)
            (NumStability.vecNorm2 mean ^ 2 / 2)) : ℝ) } =
        (latentNoiseSampleMeasure m n).real A := by rfl
    _ ≤ (latentNoiseSampleMeasure m n).real C := hmono
    _ ≤ Real.exp (-2 * (N * (ε - p)) ^ 2 / N) := htailC
    _ = Real.exp (-2 * (m : ℝ) *
        (ε - 4 * Real.exp (-(NumStability.vecNorm2 mean ^ 2) / 64)) ^ 2) := by
      congr 1
      dsimp [N, p]
      field_simp [ne_of_gt hN]

end NumStability.HDP.Vector.GaussianMixture
