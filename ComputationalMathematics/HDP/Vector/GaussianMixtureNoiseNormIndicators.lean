import ComputationalMathematics.HDP.Vector.GaussianMixtureNoiseRowNormTail

/-!
# Measurable independent indicators of exceptional canonical Gaussian row-noise norms.

Ordinary finite/model-specific prerequisites with explicit hypotheses.
No printed sample commitment or author convention is selected.
-/

noncomputable section
open Matrix MeasureTheory ProbabilityTheory Set
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- Indicator of a row whose actual canonical Gaussian noise norm exceeds
the explicit radius. -/
def canonicalNoiseNormExceptionalIndicator {m n : ℕ}
    (radius : ℝ) (i : Fin m) (ω : Fin m → ℝ × (Fin n → ℝ)) : ℝ :=
  ({ω : Fin m → ℝ × (Fin n → ℝ) |
    radius < NumStability.vecNorm2 (canonicalNoise ω i)}).indicator (fun _ => 1) ω

/-- The canonical exceptional-noise indicator is measurable. -/
theorem measurable_canonicalNoiseNormExceptionalIndicator {m n : ℕ}
    (radius : ℝ) (i : Fin m) :
    Measurable (canonicalNoiseNormExceptionalIndicator (n := n) radius i) := by
  exact measurable_const.indicator
    (measurableSet_lt measurable_const (measurable_canonicalNoiseNorm i))

/-- Every canonical exceptional-noise indicator lies in the unit interval. -/
theorem canonicalNoiseNormExceptionalIndicator_mem_Icc {m n : ℕ}
    (radius : ℝ) (i : Fin m) (ω : Fin m → ℝ × (Fin n → ℝ)) :
    canonicalNoiseNormExceptionalIndicator radius i ω ∈ Set.Icc 0 1 := by
  unfold canonicalNoiseNormExceptionalIndicator Set.indicator
  split_ifs <;> simp

/-- The exceptional-noise indicators inherit mutual independence from the
resolved independent canonical Gaussian noise rows. -/
theorem canonicalNoiseNormExceptionalIndicators_iIndep (m n : ℕ) (radius : ℝ) :
    iIndepFun
      (fun i : Fin m => canonicalNoiseNormExceptionalIndicator (n := n) radius i)
      (latentNoiseSampleMeasure m n) := by
  let f : (Fin n → ℝ) → ℝ :=
    ({z : Fin n → ℝ | radius < NumStability.vecNorm2 z}).indicator (fun _ => 1)
  have hNorm : Measurable (NumStability.vecNorm2 : (Fin n → ℝ) → ℝ) := by
    unfold NumStability.vecNorm2 NumStability.vecNorm2Sq
    fun_prop
  have hf : Measurable f := measurable_const.indicator
    (measurableSet_lt measurable_const hNorm)
  have h := (canonicalNoises_iIndep m n).comp (fun _ => f) (fun _ => hf)
  simpa [canonicalNoiseNormExceptionalIndicator, f, Function.comp_def, Set.indicator]
    using h

/-- The canonical row indicator's expectation is exactly the corresponding
exceptional-noise event probability. -/
theorem integral_canonicalNoiseNormExceptionalIndicator {m n : ℕ}
    (radius : ℝ) (i : Fin m) :
    (∫ ω, canonicalNoiseNormExceptionalIndicator (n := n) radius i ω
      ∂(latentNoiseSampleMeasure m n)) =
        (latentNoiseSampleMeasure m n).real
          {ω | radius < NumStability.vecNorm2 (canonicalNoise ω i)} := by
  letI : IsProbabilityMeasure (latentNoiseSampleMeasure m n) :=
    ⟨by simp [latentNoiseSampleMeasure]⟩
  exact integral_indicator_one
    (measurableSet_lt measurable_const (measurable_canonicalNoiseNorm i))

/-- The independent exceptional-noise indicators sum to the actual finite
number of rows exceeding the explicit noise radius. -/
theorem sum_canonicalNoiseNormExceptionalIndicator_eq_ncard {m n : ℕ}
    (radius : ℝ) (ω : Fin m → ℝ × (Fin n → ℝ)) :
    ∑ i, canonicalNoiseNormExceptionalIndicator radius i ω =
      (Set.ncard {i | radius < NumStability.vecNorm2 (canonicalNoise ω i)} : ℝ) := by
  classical
  unfold canonicalNoiseNormExceptionalIndicator
  rw [Set.ncard_eq_toFinset_card']
  simp only [Set.indicator, Set.mem_setOf_eq, Set.toFinset_setOf]
  calc
    (∑ i, if radius < NumStability.vecNorm2 (canonicalNoise ω i)
        then (1 : ℝ) else 0) =
      ((∑ i, if radius < NumStability.vecNorm2 (canonicalNoise ω i)
        then (1 : ℕ) else 0) : ℝ) := by norm_cast
    _ = _ := by
      norm_cast
      rw [Finset.sum_boole]
      rfl

end NumStability.HDP.Vector.GaussianMixture
