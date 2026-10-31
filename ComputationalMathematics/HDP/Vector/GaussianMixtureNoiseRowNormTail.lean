import ComputationalMathematics.HDP.Vector.GaussianMixtureNoise

/-!
# Measurable canonical Gaussian row-noise norms and the existing uniform shell upper tail.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- The actual canonical Gaussian row-noise norm is measurable. -/
theorem measurable_canonicalNoiseNorm {m n : ℕ} (i : Fin m) :
    Measurable (fun ω : Fin m → ℝ × (Fin n → ℝ) =>
      NumStability.vecNorm2 (canonicalNoise ω i)) := by
  unfold NumStability.vecNorm2 NumStability.vecNorm2Sq canonicalNoise
  fun_prop

/-- One Gaussian-shell constant controls every canonical row's upper norm
tail, uniformly before all sample sizes and positive dimensions. -/
theorem exists_canonicalNoise_row_norm_upper_tail :
    ∃ c : ℝ, 0 < c ∧
      ∀ {m n : ℕ}, 0 < n → ∀ (i : Fin m) (t : ℝ), 0 ≤ t →
        (latentNoiseSampleMeasure m n).real
          {ω | Real.sqrt (n : ℝ) + t < NumStability.vecNorm2 (canonicalNoise ω i)} ≤
            2 * Real.exp (-(c * t ^ 2)) := by
  obtain ⟨c, hc, hTail⟩ :=
    NumStability.HDP.Vector.Gaussian.standardGaussianEuclideanNormDeviation_tail
  refine ⟨c, hc, ?_⟩
  intro m n hn i t ht
  letI : Nonempty (Fin n) := ⟨⟨0, hn⟩⟩
  let μ := latentNoiseSampleMeasure m n
  letI : IsProbabilityMeasure μ := ⟨by simp [μ, latentNoiseSampleMeasure]⟩
  have hMeas : ∀ j : Fin n, Measurable
      (fun ω : Fin m → ℝ × (Fin n → ℝ) => canonicalNoise ω i j) := by
    intro j
    unfold canonicalNoise
    fun_prop
  have hraw := hTail (μ := μ) (fun j ω => canonicalNoise ω i j) hMeas
    (canonicalNoise_isStandardNormal i) ht
  have hsubset :
      {ω : Fin m → ℝ × (Fin n → ℝ) |
        Real.sqrt (n : ℝ) + t < NumStability.vecNorm2 (canonicalNoise ω i)} ⊆
      {ω | t ≤ |NumStability.vecNorm2 (canonicalNoise ω i) - Real.sqrt (n : ℝ)|} := by
    intro ω hω
    have h := le_abs_self
      (NumStability.vecNorm2 (canonicalNoise ω i) - Real.sqrt (n : ℝ))
    change Real.sqrt (n : ℝ) + t < NumStability.vecNorm2 (canonicalNoise ω i) at hω
    change t ≤ |NumStability.vecNorm2 (canonicalNoise ω i) - Real.sqrt (n : ℝ)|
    linarith
  exact (measureReal_mono hsubset (measure_ne_top μ _)).trans hraw

end NumStability.HDP.Vector.GaussianMixture
