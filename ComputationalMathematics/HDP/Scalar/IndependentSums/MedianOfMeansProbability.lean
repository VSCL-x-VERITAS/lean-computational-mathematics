import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import ComputationalMathematics.HDP.Scalar.IndependentSums.MedianOfMeans

/-!
# Probability amplification for odd medians

The measurable-indicator bridge from independent weak estimators to the
majority-tail estimate used in median-of-means.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Scalar.IndependentSums.MedianOfMeansProbability

/-- An odd median of independent weak estimators has failure probability at
most `δ` once the number of estimators meets the Hoeffding amplification
threshold. -/
theorem oddMedian_failure_probability_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (k : ℕ) {Z : Fin (2 * k + 1) → Ω → ℝ}
    (hZ : ∀ i, Measurable (Z i))
    (hIndep : iIndepFun Z μ)
    {center ε δ : ℝ}
    (hweak : ∀ i, μ.real {ω | ε ≤ |Z i ω - center|} ≤ 1 / 4)
    (hδ0 : 0 < δ) (hδ1 : δ < 1)
    (hNlarge : Real.log (1 / δ) / (2 * (1 / 4 : ℝ) ^ 2) ≤
      (Fintype.card (Fin (2 * k + 1)) : ℝ)) :
    μ.real {ω | ε ≤
      |MedianOfMeans.oddMedian k (fun i => Z i ω) - center|} ≤ δ := by
  let B : Set ℝ := {z | ε ≤ |z - center|}
  let I : ℝ → ℝ := B.indicator fun _ => 1
  let W : Fin (2 * k + 1) → Ω → ℝ := fun i => I ∘ Z i
  have hB : MeasurableSet B := by
    exact measurableSet_Ici.preimage ((measurable_id.sub measurable_const).abs)
  have hI : Measurable I := measurable_const.indicator hB
  have hW : ∀ i, Measurable (W i) := fun i => hI.comp (hZ i)
  have hIndepW : iIndepFun W μ := hIndep.comp (fun _ => I) (fun _ => hI)
  have hbound : ∀ i, ∀ᵐ ω ∂μ, W i ω ∈ Set.Icc 0 1 := by
    intro i
    filter_upwards [] with ω
    simp only [W, I, B, Function.comp_apply, Set.mem_Icc, Set.indicator]
    split_ifs <;> norm_num
  have hmean : ∀ i, (∫ y, W i y ∂μ) ≤ 1 / 2 - (1 / 4 : ℝ) := by
    intro i
    have hpre : MeasurableSet ((Z i) ⁻¹' B) := hB.preimage (hZ i)
    have hWI : W i = ((Z i) ⁻¹' B).indicator (fun _ => (1 : ℝ)) := by
      funext ω
      simp [W, I, B, Set.indicator]
    rw [hWI, integral_indicator_const (1 : ℝ) hpre]
    simp only [smul_eq_mul, mul_one]
    norm_num
    simpa [B] using hweak i
  have htail :=
    Hoeffding.majorityVoteHoeffding (W := W) hW hIndepW hbound hmean
      (δ := (1 / 4 : ℝ)) (ε := δ) (by norm_num) hδ0 hδ1
      (by simp) hNlarge
  have hsubset :
      {ω | ε ≤ |MedianOfMeans.oddMedian k (fun i => Z i ω) - center|} ⊆
        {ω | ∑ i, W i ω ≥
          (Fintype.card (Fin (2 * k + 1)) : ℝ) / 2} := by
    intro ω hω
    have hcount := MedianOfMeans.oddMedian_failure_implies_many_failures
      k (fun i => Z i ω) hω
    have hsum : ∑ i, W i ω =
        ((Finset.univ.filter fun i => ε ≤ |Z i ω - center|).card : ℝ) := by
      simp [W, I, B, Set.indicator]
    change (Fintype.card (Fin (2 * k + 1)) : ℝ) / 2 ≤ ∑ i, W i ω
    rw [hsum]
    apply (div_le_iff₀ (by norm_num : (0 : ℝ) < 2)).2
    have hcount' : (Fintype.card (Fin (2 * k + 1)) : ℝ) ≤
        2 * ((Finset.univ.filter fun i => ε ≤ |Z i ω - center|).card : ℝ) := by
      exact_mod_cast hcount
    simpa [mul_comm] using hcount'
  exact (measureReal_mono hsubset).trans htail

end NumStability.HDP.Scalar.IndependentSums.MedianOfMeansProbability
