import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Measure.Real

/-!
# Finite union bounds
-/

noncomputable section

open MeasureTheory Set
open scoped ENNReal

namespace NumStability.HDP.Probability

/-- A finite union is bounded by the number of indices times a uniform event
bound. -/
theorem measure_biUnion_le
    {Ω I : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (N : Finset I) (E : I → Set Ω) (p : ℝ≥0∞)
    (hE : ∀ i ∈ N, μ (E i) ≤ p) :
    μ (⋃ i ∈ N, E i) ≤ N.card * p := by
  calc
    μ (⋃ i ∈ N, E i) ≤ ∑ i ∈ N, μ (E i) := measure_biUnion_finset_le N _
    _ ≤ ∑ _i ∈ N, p := by
      gcongr with i hi
      exact hE i hi
    _ = N.card * p := by simp

/-- Real-valued form of `measure_biUnion_le` for a finite measure. -/
theorem measureReal_biUnion_le
    {Ω I : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsFiniteMeasure μ]
    (N : Finset I) (E : I → Set Ω) (p : ℝ) (hp : 0 ≤ p)
    (hE : ∀ i ∈ N, μ.real (E i) ≤ p) :
    μ.real (⋃ i ∈ N, E i) ≤ N.card * p := by
  have hE' : ∀ i ∈ N, μ (E i) ≤ ENNReal.ofReal p := by
    intro i hi
    rw [← ofReal_measureReal]
    exact ENNReal.ofReal_le_ofReal (hE i hi)
  have hbound := measure_biUnion_le μ N E (ENNReal.ofReal p) hE'
  rw [Measure.real_def]
  calc
    (μ (⋃ i ∈ N, E i)).toReal ≤
        ((N.card : ℝ≥0∞) * ENNReal.ofReal p).toReal :=
      ENNReal.toReal_mono (by finiteness) hbound
    _ = N.card * p := by
      rw [ENNReal.toReal_mul, ENNReal.toReal_natCast,
        ENNReal.toReal_ofReal hp]

/-- A two-index finite union is bounded by the number of index pairs times a
uniform event bound. -/
theorem measure_biUnion_product_le
    {Ω I J : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (N : Finset I) (M : Finset J)
    (E : I → J → Set Ω) (p : ℝ≥0∞)
    (hE : ∀ i ∈ N, ∀ j ∈ M, μ (E i j) ≤ p) :
    μ (⋃ i ∈ N, ⋃ j ∈ M, E i j) ≤ (N.card * M.card) * p := by
  calc
    μ (⋃ i ∈ N, ⋃ j ∈ M, E i j) ≤
        ∑ i ∈ N, μ (⋃ j ∈ M, E i j) := measure_biUnion_finset_le N _
    _ ≤ ∑ i ∈ N, ∑ j ∈ M, μ (E i j) := by
      gcongr with i hi
      exact measure_biUnion_finset_le M _
    _ ≤ ∑ _i ∈ N, ∑ _j ∈ M, p := by
      gcongr with i hi j hj
      exact hE i hi j hj
    _ = (N.card * M.card) * p := by
      simp [mul_assoc]

end NumStability.HDP.Probability
