import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-!
# Zero-threshold boundary for the Bernoulli lower-tail bound

This module isolates the boundary case omitted by the positive-threshold
Chernoff optimization.  Keeping it separate avoids changing the shared
`Chernoff` audit dependency while the source-domain issue in Exercise 2.3.2 is
reviewed.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- The probability that an independent Bernoulli sum is zero is at most the
Poisson proxy `exp (-∑ i, p i)`. -/
theorem poissonBinomial_zeroThresholdBound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i)) :
    μ.real {ω | ∑ i, (if B i ω then (1 : ℝ) else 0) ≤ 0} ≤
      Real.exp (-(∑ i, (p i : ℝ))) := by
  classical
  have hevent :
      {ω | ∑ i, (if B i ω then (1 : ℝ) else 0) ≤ 0} =
        ⋂ i, B i ⁻¹' ({false} : Set Bool) := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_iInter, Set.mem_preimage,
      Set.mem_singleton_iff]
    constructor
    · intro hsum i
      have hnonneg : 0 ≤ ∑ i, (if B i ω then (1 : ℝ) else 0) :=
        Finset.sum_nonneg fun _ _ => by split <;> norm_num
      have hzero : ∑ i, (if B i ω then (1 : ℝ) else 0) = 0 :=
        le_antisymm hsum hnonneg
      have hi := (Finset.sum_eq_zero_iff_of_nonneg
        (fun i (_hi : i ∈ Finset.univ) => by
          split <;> norm_num)).mp hzero i (Finset.mem_univ i)
      by_contra hfalse
      have htrue : B i ω = true := Bool.eq_true_of_not_eq_false hfalse
      simp [htrue] at hi
    · intro hfalse
      simp [hfalse]
  have hprod := hB.measure_inter_preimage_eq_mul Finset.univ
    (sets := fun _ => ({false} : Set Bool))
    (fun _ _ => measurableSet_singleton false)
  have hprod' : μ (⋂ i, B i ⁻¹' ({false} : Set Bool)) =
      ∏ i, μ (B i ⁻¹' ({false} : Set Bool)) := by
    simpa using hprod
  have hcoord : ∀ i, μ.real (B i ⁻¹' ({false} : Set Bool)) = 1 - (p i : ℝ) := by
    intro i
    rw [Measure.real_def,
      ← Measure.map_apply_of_aemeasurable (hMeas i).aemeasurable
        (measurableSet_singleton false), (hLaw i).map_eq]
    rw [(PMF.bernoulli (p i) (hp i)).toMeasure_apply_singleton false
      (measurableSet_singleton false), PMF.bernoulli_apply]
    simp only [Bool.cond_false]
    change ((1 - p i : ℝ≥0) : ℝ) = 1 - (p i : ℝ)
    exact NNReal.coe_sub (hp i)
  rw [hevent, Measure.real_def, hprod', ENNReal.toReal_prod]
  simp_rw [← Measure.real_def, hcoord]
  calc
    ∏ i, (1 - (p i : ℝ)) ≤ ∏ i, Real.exp (-(p i : ℝ)) := by
      exact Finset.prod_le_prod
        (fun i _ => sub_nonneg.mpr (by exact_mod_cast hp i))
        (fun i _ => by simpa [sub_eq_add_neg, add_comm] using Real.add_one_le_exp (-(p i : ℝ)))
    _ = Real.exp (-(∑ i, (p i : ℝ))) := by
      rw [← Real.exp_sum]
      congr 1
      simp

end NumStability.HDP.Scalar.IndependentSums.Chernoff
