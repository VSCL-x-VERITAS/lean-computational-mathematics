import ComputationalMathematics.HDP.Probability.FiniteUnion
import ComputationalMathematics.HDP.Vector.GaussianMixtureNoiseRowNormTail

/-!
# Exceptional Gaussian row-noise count union bounds with explicit radius and confidence thresholds.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- Any positive exceptional-noise count threshold forces an exceptional row,
so the existing finite union bound retains its explicit single-row probability. -/
theorem canonicalNoiseNormExceptionalCount_union_tail {m n : ℕ}
    (radius p threshold : ℝ) (hp : 0 ≤ p) (hthreshold : 0 < threshold)
    (hrow : ∀ i : Fin m, (latentNoiseSampleMeasure m n).real
      {ω | radius < NumStability.vecNorm2 (canonicalNoise ω i)} ≤ p) :
    (latentNoiseSampleMeasure m n).real
      {ω | threshold ≤ (Set.ncard
        {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)} ≤
      (m : ℝ) * p := by
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  let E : Fin m → Set (Fin m → ℝ × (Fin n → ℝ)) :=
    fun i ↦ {ω | radius < NumStability.vecNorm2 (canonicalNoise ω i)}
  have hunion : μ.real (⋃ i ∈ (Finset.univ : Finset (Fin m)), E i) ≤
      (Finset.univ : Finset (Fin m)).card * p :=
    NumStability.HDP.Probability.measureReal_biUnion_le
      (Finset.univ : Finset (Fin m)) E p hp (fun i _ ↦ hrow i)
  have hsubset :
      {ω | threshold ≤ (Set.ncard
        {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)} ⊆
      ⋃ i ∈ (Finset.univ : Finset (Fin m)), E i := by
    intro ω hcount
    by_contra hnotUnion
    simp only [Set.mem_iUnion, Finset.mem_univ, not_exists] at hnotUnion
    have hempty : {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} = ∅ := by
      ext i
      simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
      simpa [E] using hnotUnion i
    change threshold ≤ (Set.ncard
      {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ) at hcount
    rw [hempty] at hcount
    simp only [Set.ncard_empty, Nat.cast_zero] at hcount
    linarith
  exact (measureReal_mono hsubset (measure_ne_top _ _)).trans
    (by simpa [μ] using hunion)

/-- The existing uniform Gaussian-shell constant also controls any positive
noise-count threshold in the rare-event regime, without a sample-product premise. -/
theorem exists_canonicalNoise_norm_exceptional_count_union_dimension_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {m n : ℕ}, 0 < n → ∀ (t threshold : ℝ), 0 ≤ t → 0 < threshold →
        (m : ℝ) * (2 * Real.exp (-(c * t ^ 2))) ≤ Real.exp (-(n : ℝ)) →
        (latentNoiseSampleMeasure m n).real
          {ω | threshold ≤ (Set.ncard
            {i | Real.sqrt (n : ℝ) + t <
              NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ)} ≤
          Real.exp (-(n : ℝ)) := by
  obtain ⟨c, hc, htail⟩ := exists_canonicalNoise_row_norm_upper_tail
  refine ⟨c, hc, ?_⟩
  intro m n hn t threshold ht hthreshold hconfidence
  exact (canonicalNoiseNormExceptionalCount_union_tail
    (Real.sqrt (n : ℝ) + t) (2 * Real.exp (-(c * t ^ 2))) threshold
    (by positivity) hthreshold (fun i ↦ htail hn i t ht)).trans hconfidence

end NumStability.HDP.Vector.GaussianMixture
