import ComputationalMathematics.Source.Vershynin.Chapter02.Section03.Exercise02.Contract
import ComputationalMathematics.Source.Vershynin.Chapter02.Section03.Exercise02.ZeroBoundary.Contract

/-!
# Effective-domain form of Exercise 2.3.2

The printed display uses a real quotient and real power on the larger domain
`t < μ`. This contract keeps the displayed Chernoff formula on its positive
domain and states the zero and negative threshold cases without assigning a
meaning to the source's undefined expressions.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Exercise 2.3.2 on the effective domain of its printed real expression,
with the exact boundary behavior stated separately. -/
theorem hdp_02_hex_h2_d3_d2_effectiveDomain
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ} (htμ : t < ∑ i, (p i : ℝ)) :
    (0 < t →
      μ.real {ω | ∑ i, (if B i ω then (1 : ℝ) else 0) ≤ t} ≤
        Real.exp (-(∑ i, (p i : ℝ))) *
          ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t)) ∧
    (t = 0 →
      μ.real {ω | ∑ i, (if B i ω then (1 : ℝ) else 0) ≤ t} ≤
        Real.exp (-(∑ i, (p i : ℝ)))) ∧
    (t < 0 →
      μ.real {ω | ∑ i, (if B i ω then (1 : ℝ) else 0) ≤ t} = 0) := by
  refine ⟨fun ht => hdp_02_hex_h2_d3_d2_source hp hB hLaw hMeas ht htμ,
    ?_, ?_⟩
  · intro ht
    subst t
    exact hdp_02_hex_h2_d3_d2_zero hp hB hLaw hMeas
  · intro ht
    have hsum_nonneg : ∀ ω,
        0 ≤ ∑ i, (if B i ω then (1 : ℝ) else 0) := by
      intro ω
      exact Finset.sum_nonneg fun _ _ => by split <;> norm_num
    have hset :
        {ω | ∑ i, (if B i ω then (1 : ℝ) else 0) ≤ t} = (∅ : Set Ω) := by
      ext ω
      simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false]
      exact iff_false_intro (not_le_of_gt (lt_of_lt_of_le ht (hsum_nonneg ω)))
    rw [hset]
    simp

end NumStability.HDP.Contract
