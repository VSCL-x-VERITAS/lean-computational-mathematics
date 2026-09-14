import Mathlib.Probability.Moments.SubGaussian

/-!
# McDiarmid and bounded-differences infrastructure

Reusable martingale-difference foundations for the bounded-differences
inequality. Mathlib's conditional sub-Gaussian Azuma--Hoeffding theorem is the
canonical tail producer; this module records the exact `cᵢ² / 4` normalization
that yields McDiarmid's exponent `exp (-2t² / ∑ i, cᵢ²)`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal ProbabilityTheory

namespace NumStability.HDP.Scalar.IndependentSums.McDiarmid

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-- Variance proxy `∑ i < n, c i ^ 2` in the bounded-differences exponent. -/
def boundedDifferencesVarianceSum (c : ℕ → ℝ) (n : ℕ) : ℝ :=
  ∑ i ∈ Finset.range n, c i ^ 2

/-- The conditional sub-Gaussian proxy `c i ^ 2 / 4` for an increment whose
conditional range has deterministic length `c i`. -/
def boundedDifferencesSubgaussianProxy (c : ℕ → ℝ) (i : ℕ) : ℝ≥0 :=
  ⟨c i ^ 2 / 4, by positivity⟩

/-- Insert the deterministic dummy-coordinate width used by the shifted
product-space model. -/
def shiftedBoundedDifferenceConstants (c : ℕ → ℝ) : ℕ → ℝ
  | 0 => 0
  | n + 1 => c n

@[simp]
lemma shiftedBoundedDifferenceConstants_zero (c : ℕ → ℝ) :
    shiftedBoundedDifferenceConstants c 0 = 0 := rfl

@[simp]
lemma shiftedBoundedDifferenceConstants_succ (c : ℕ → ℝ) (n : ℕ) :
    shiftedBoundedDifferenceConstants c (n + 1) = c n := rfl

lemma shiftedBoundedDifferenceConstants_nonneg {c : ℕ → ℝ}
    (hc : ∀ i, 0 ≤ c i) :
    ∀ i, 0 ≤ shiftedBoundedDifferenceConstants c i
  | 0 => by simp
  | n + 1 => hc n

lemma boundedDifferencesVarianceSum_shifted_succ (c : ℕ → ℝ) (N : ℕ) :
    boundedDifferencesVarianceSum (shiftedBoundedDifferenceConstants c) (N + 1) =
      boundedDifferencesVarianceSum c N := by
  induction N with
  | zero =>
      simp [boundedDifferencesVarianceSum]
  | succ N ih =>
      have hprev :
          ∑ i ∈ Finset.range (N + 1), shiftedBoundedDifferenceConstants c i ^ 2 =
            ∑ i ∈ Finset.range N, c i ^ 2 := by
        simpa [boundedDifferencesVarianceSum] using ih
      calc
        boundedDifferencesVarianceSum (shiftedBoundedDifferenceConstants c) (N + 2)
            = (∑ i ∈ Finset.range (N + 1),
                shiftedBoundedDifferenceConstants c i ^ 2) +
                shiftedBoundedDifferenceConstants c (N + 1) ^ 2 := by
              simp [boundedDifferencesVarianceSum, Finset.sum_range_succ]
        _ = (∑ i ∈ Finset.range N, c i ^ 2) + c N ^ 2 := by
              rw [hprev]
              simp
        _ = boundedDifferencesVarianceSum c (N + 1) := by
              simp [boundedDifferencesVarianceSum, Finset.sum_range_succ]

/-- Conditional Hoeffding lemma for a bounded martingale difference. If each
regular conditional law sees `X` in one fixed interval and with conditional
mean zero, then `X` has the corresponding conditional sub-Gaussian proxy. -/
theorem hasCondSubgaussianMGF_of_cond_mem_Icc_of_cond_integral_eq_zero
    {Ω : Type*} {mΩ : MeasurableSpace Ω} [StandardBorelSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m : MeasurableSpace Ω} {hm : m ≤ mΩ}
    {X : Ω → ℝ} {a b : ℝ}
    (hXm : AEMeasurable X μ)
    (hglobal : ∀ᵐ ω ∂μ, X ω ∈ Set.Icc a b)
    (hcondMeas : ∀ᵐ ω' ∂(μ.trim hm),
      AEMeasurable X ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'))
    (hcondBound : ∀ᵐ ω' ∂(μ.trim hm),
      ∀ᵐ ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'),
        X ω ∈ Set.Icc a b)
    (hcondMean : ∀ᵐ ω' ∂(μ.trim hm),
      ∫ ω, X ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω') = 0) :
    @HasCondSubgaussianMGF Ω m mΩ hm inferInstance X ((‖b - a‖₊ / 2) ^ 2) μ
      inferInstance := by
  refine ⟨?_, ?_⟩
  · intro t
    rw [@condExpKernel_comp_trim Ω m mΩ inferInstance μ inferInstance hm]
    exact integrable_exp_mul_of_mem_Icc hXm hglobal
  · filter_upwards [hcondMeas, hcondBound, hcondMean] with ω' hXm' hb hm0 t
    haveI : IsProbabilityMeasure
        ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω') := by
      infer_instance
    exact (hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero
      (μ := ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'))
      (X := X) (a := a) (b := b) hXm' hb hm0).mgf_le t

/-- Conditional Hoeffding lemma with a past-dependent interval location. The
length `c` is deterministic, while each regular conditional law may use its
own left endpoint. -/
theorem hasCondSubgaussianMGF_of_cond_exists_mem_Icc_length_of_cond_integral_eq_zero
    {Ω : Type*} {mΩ : MeasurableSpace Ω} [StandardBorelSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m : MeasurableSpace Ω} {hm : m ≤ mΩ}
    {X : Ω → ℝ} {c : ℝ}
    (_hc : 0 ≤ c)
    (hXm : AEMeasurable X μ)
    (hglobalAbs : ∀ᵐ ω ∂μ, |X ω| ≤ c)
    (hcondMeas : ∀ᵐ ω' ∂(μ.trim hm),
      AEMeasurable X ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'))
    (hcondBound : ∀ᵐ ω' ∂(μ.trim hm),
      ∃ a : ℝ, ∀ᵐ ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'),
        X ω ∈ Set.Icc a (a + c))
    (hcondMean : ∀ᵐ ω' ∂(μ.trim hm),
      ∫ ω, X ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω') = 0) :
    @HasCondSubgaussianMGF Ω m mΩ hm inferInstance X ((‖c‖₊ / 2) ^ 2) μ
      inferInstance := by
  refine ⟨?_, ?_⟩
  · intro t
    rw [@condExpKernel_comp_trim Ω m mΩ inferInstance μ inferInstance hm]
    have hIcc : ∀ᵐ ω ∂μ, X ω ∈ Set.Icc (-c) c := by
      filter_upwards [hglobalAbs] with ω hω
      simpa [Set.mem_Icc, abs_le] using hω
    exact integrable_exp_mul_of_mem_Icc hXm hIcc
  · filter_upwards [hcondMeas, hcondBound, hcondMean] with ω' hXm' hbound hm0 t
    rcases hbound with ⟨a, hb⟩
    haveI : IsProbabilityMeasure
        ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω') := by
      infer_instance
    have h :=
      (hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero
        (μ := ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'))
        (X := X) (a := a) (b := a + c) hXm' hb hm0).mgf_le t
    simpa [show a + c - a = c by ring] using h

/-- A nonempty real-valued family of pairwise diameter at most `c` lies in an
interval of length exactly `c`. -/
lemma exists_Icc_length_of_pairwise_abs_sub_le {α : Type*} [Nonempty α]
    {g : α → ℝ} {c : ℝ} (_hc : 0 ≤ c)
    (hdiam : ∀ x y, |g x - g y| ≤ c) :
    ∃ a : ℝ, ∀ x, g x ∈ Set.Icc a (a + c) := by
  let S : Set ℝ := Set.range g
  have hSnonempty : S.Nonempty := Set.range_nonempty g
  let x0 : α := Classical.choice inferInstance
  have hbddBelow : BddBelow S := by
    refine ⟨g x0 - c, ?_⟩
    rintro y ⟨x, rfl⟩
    have h := hdiam x0 x
    have h' : g x0 - g x ≤ c :=
      (le_abs_self (g x0 - g x)).trans h
    linarith
  refine ⟨sInf S, ?_⟩
  intro x
  constructor
  · exact csInf_le hbddBelow ⟨x, rfl⟩
  · have hlower : g x - c ∈ lowerBounds S := by
      intro y hy
      rcases hy with ⟨z, rfl⟩
      have h := hdiam x z
      have h' : g x - g z ≤ c :=
        (le_abs_self (g x - g z)).trans h
      linarith
    have hle : g x - c ≤ sInf S :=
      le_csInf hSnonempty hlower
    linarith

/-- If a centered random variable is almost surely contained in an interval of
length `c`, then it is almost surely bounded in absolute value by `c`. -/
lemma ae_abs_le_of_mem_Icc_length_of_integral_eq_zero {Ω : Type*} [MeasurableSpace Ω]
    {ν : Measure Ω} [IsProbabilityMeasure ν] {X : Ω → ℝ} {a c : ℝ}
    (hXm : AEMeasurable X ν)
    (hb : ∀ᵐ ω ∂ν, X ω ∈ Set.Icc a (a + c))
    (hmean : ∫ ω, X ω ∂ν = 0) :
    ∀ᵐ ω ∂ν, |X ω| ≤ c := by
  have hboundAbs : ∀ᵐ ω ∂ν, ‖X ω‖ ≤ max |a| |a + c| := by
    filter_upwards [hb] with ω hω
    rw [Real.norm_eq_abs]
    exact abs_le_max_abs_abs hω.1 hω.2
  have hXint : Integrable X ν := by
    exact Integrable.of_bound hXm.aestronglyMeasurable (max |a| |a + c|) hboundAbs
  have hge : a ≤ ∫ ω, X ω ∂ν := by
    calc
      a = ∫ _ω : Ω, a ∂ν := by simp
      _ ≤ ∫ ω, X ω ∂ν := by
        exact integral_mono_ae (integrable_const a) hXint (hb.mono fun _ω hω => hω.1)
  have hle : ∫ ω, X ω ∂ν ≤ a + c := by
    calc
      ∫ ω, X ω ∂ν ≤ ∫ _ω : Ω, a + c ∂ν := by
        exact integral_mono_ae hXint (integrable_const (a + c)) (hb.mono fun _ω hω => hω.2)
      _ = a + c := by simp
  have haNonpos : a ≤ 0 := by simpa [hmean] using hge
  have hzeroLeAc : 0 ≤ a + c := by simpa [hmean] using hle
  filter_upwards [hb] with ω hω
  rw [abs_le]
  constructor
  · linarith [hω.1, hzeroLeAc]
  · linarith [hω.2, haNonpos]

/-- Conditional interval ranges of deterministic length and zero conditional
mean imply the corresponding global absolute bound. -/
lemma ae_abs_le_of_cond_exists_mem_Icc_length_of_cond_integral_eq_zero
    {Ω : Type*} {mΩ : MeasurableSpace Ω} [StandardBorelSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m : MeasurableSpace Ω} {hm : m ≤ mΩ}
    {X : Ω → ℝ} {c : ℝ}
    (hXm : @Measurable Ω ℝ mΩ (borel ℝ) X)
    (hcondMeas : ∀ᵐ ω' ∂(μ.trim hm),
      AEMeasurable X ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'))
    (hcondBound : ∀ᵐ ω' ∂(μ.trim hm),
      ∃ a : ℝ, ∀ᵐ ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'),
        X ω ∈ Set.Icc a (a + c))
    (hcondMean : ∀ᵐ ω' ∂(μ.trim hm),
      ∫ ω, X ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω') = 0) :
    ∀ᵐ ω ∂μ, |X ω| ≤ c := by
  let K : @Kernel Ω Ω m mΩ := @condExpKernel Ω mΩ inferInstance μ inferInstance m
  have hcondAbs : ∀ᵐ ω' ∂(μ.trim hm), ∀ᵐ ω ∂K ω', |X ω| ≤ c := by
    filter_upwards [hcondMeas, hcondBound, hcondMean] with ω' hXm' hbound hmean
    rcases hbound with ⟨a, ha⟩
    exact @ae_abs_le_of_mem_Icc_length_of_integral_eq_zero Ω mΩ (K ω') _ X a c
      hXm' ha hmean
  have hmeasSet : @MeasurableSet Ω mΩ {ω | |X ω| ≤ c} := by
    change @MeasurableSet Ω mΩ ((fun ω => |X ω|) ⁻¹' Set.Iic c)
    have habs : @Measurable Ω ℝ mΩ (borel ℝ) (fun ω => |X ω|) :=
      @Measurable.comp Ω ℝ ℝ mΩ (borel ℝ) (borel ℝ) abs X measurable_abs hXm
    exact habs measurableSet_Iic
  have hcomp : ∀ᵐ ω ∂(K ∘ₘ μ.trim hm), |X ω| ≤ c := by
    exact @Measure.ae_comp_of_ae_ae Ω Ω m mΩ (μ.trim hm) K (fun ω => |X ω| ≤ c)
      hmeasSet hcondAbs
  have hmeasure : K ∘ₘ μ.trim hm = μ := by
    dsimp [K]
    exact @ProbabilityTheory.condExpKernel_comp_trim Ω m mΩ inferInstance μ inferInstance hm
  rw [← hmeasure]
  exact hcomp

/-- Conditional Hoeffding with past-dependent interval locations, deriving the
global absolute bound from measurable increments and conditional centering. -/
theorem hasCondSubgaussianMGF_of_cond_exists_mem_Icc_length_of_cond_integral_eq_zero_of_measurable
    {Ω : Type*} {mΩ : MeasurableSpace Ω} [StandardBorelSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m : MeasurableSpace Ω} {hm : m ≤ mΩ}
    {X : Ω → ℝ} {c : ℝ}
    (hc : 0 ≤ c)
    (hXm : @Measurable Ω ℝ mΩ (borel ℝ) X)
    (hcondMeas : ∀ᵐ ω' ∂(μ.trim hm),
      AEMeasurable X ((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'))
    (hcondBound : ∀ᵐ ω' ∂(μ.trim hm),
      ∃ a : ℝ, ∀ᵐ ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω'),
        X ω ∈ Set.Icc a (a + c))
    (hcondMean : ∀ᵐ ω' ∂(μ.trim hm),
      ∫ ω, X ω ∂((@condExpKernel Ω mΩ inferInstance μ inferInstance m) ω') = 0) :
    @HasCondSubgaussianMGF Ω m mΩ hm inferInstance X ((‖c‖₊ / 2) ^ 2) μ
      inferInstance := by
  have hglobal := ae_abs_le_of_cond_exists_mem_Icc_length_of_cond_integral_eq_zero
    (μ := μ) (m := m) (hm := hm) (X := X) (c := c)
    hXm hcondMeas hcondBound hcondMean
  exact hasCondSubgaussianMGF_of_cond_exists_mem_Icc_length_of_cond_integral_eq_zero
    (μ := μ) (m := m) (hm := hm) (X := X) (c := c)
    hc hXm.aemeasurable hglobal hcondMeas hcondBound hcondMean

/-- Integrating an almost-sure pointwise difference bound preserves it. -/
lemma abs_integral_sub_integral_le_of_ae_abs_sub_le {α : Type*} [MeasurableSpace α]
    {ν : Measure α} [IsProbabilityMeasure ν] {f g : α → ℝ} {c : ℝ}
    (hf : Integrable f ν) (hg : Integrable g ν)
    (hfg : ∀ᵐ x ∂ν, |f x - g x| ≤ c) :
    |(∫ x, f x ∂ν) - ∫ x, g x ∂ν| ≤ c := by
  have hdiff : Integrable (fun x => f x - g x) ν := hf.sub hg
  have habs : Integrable (fun x => |f x - g x|) ν := hdiff.abs
  calc
    |(∫ x, f x ∂ν) - ∫ x, g x ∂ν| = |∫ x, f x - g x ∂ν| := by
      rw [integral_sub hf hg]
    _ ≤ ∫ x, |f x - g x| ∂ν := abs_integral_le_integral_abs
    _ ≤ ∫ _x : α, c ∂ν := by
      exact integral_mono_ae habs (integrable_const c) hfg
    _ = c := by simp

/-- Azuma--Hoeffding in the normalization used by McDiarmid's inequality.

This is the concentration engine for HDP Theorem 2.9.1. The remaining
foundation is to show that the Doob exposure increments of a
coordinate-bounded function satisfy the conditional sub-Gaussian hypotheses. -/
theorem martingaleDifference_upperTail
    [StandardBorelSpace Ω] [IsProbabilityMeasure μ]
    {Y : ℕ → Ω → ℝ} {ℱ : Filtration ℕ ‹MeasurableSpace Ω›}
    {c : ℕ → ℝ} {n : ℕ} {t : ℝ}
    (h_adapted : StronglyAdapted ℱ Y)
    (h0 : HasSubgaussianMGF (Y 0) (boundedDifferencesSubgaussianProxy c 0) μ)
    (h_subG : ∀ i < n - 1,
      HasCondSubgaussianMGF (ℱ i) (ℱ.le i) (Y (i + 1))
        (boundedDifferencesSubgaussianProxy c (i + 1)) μ)
    (ht : 0 ≤ t) :
    μ.real {ω | t ≤ ∑ i ∈ Finset.range n, Y i ω}
      ≤ Real.exp (-2 * t ^ 2 / boundedDifferencesVarianceSum c n) := by
  have htail :=
    ProbabilityTheory.measure_sum_ge_le_of_hasCondSubgaussianMGF
      (μ := μ) (Y := Y) (cY := boundedDifferencesSubgaussianProxy c)
      (ℱ := ℱ) h_adapted h0 n h_subG ht
  calc
    μ.real {ω | t ≤ ∑ i ∈ Finset.range n, Y i ω}
        ≤ Real.exp (-t ^ 2 /
          (2 * ∑ i ∈ Finset.range n, boundedDifferencesSubgaussianProxy c i)) := htail
    _ = Real.exp (-2 * t ^ 2 / boundedDifferencesVarianceSum c n) := by
      congr 1
      have hsumProxy :
          ((∑ i ∈ Finset.range n, boundedDifferencesSubgaussianProxy c i : ℝ≥0) : ℝ)
            = boundedDifferencesVarianceSum c n / 4 := by
        calc
          ((∑ i ∈ Finset.range n, boundedDifferencesSubgaussianProxy c i : ℝ≥0) : ℝ)
              = ∑ i ∈ Finset.range n,
                  ((boundedDifferencesSubgaussianProxy c i : ℝ≥0) : ℝ) := by
            simp
          _ = ∑ i ∈ Finset.range n, c i ^ 2 / 4 := by
            refine Finset.sum_congr rfl ?_
            intro i _hi
            rfl
          _ = boundedDifferencesVarianceSum c n / 4 := by
            dsimp [boundedDifferencesVarianceSum]
            rw [Finset.sum_div]
      rw [hsumProxy]
      ring

end NumStability.HDP.Scalar.IndependentSums.McDiarmid
