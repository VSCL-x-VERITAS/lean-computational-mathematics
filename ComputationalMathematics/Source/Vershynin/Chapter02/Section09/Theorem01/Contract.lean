import ComputationalMathematics.Source.Vershynin.Chapter02.Section09.Theorem01.Signature

/-! Stable source wrapper for Vershynin, Theorem 2.9.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

theorem hdp_02_hthm_h2_d9_d1_exact :
    hdp_02_hthm_h2_d9_d1__contract_type := by
  intro X _ _ μ _ f c N t _hN hmeas hdep hbd hc ht
  let c' : ℕ → ℝ := fun i => if i < N then c i else 0
  have hc' : ∀ i, 0 ≤ c' i := by
    intro i
    by_cases hi : i < N
    · simp [c', hi, (hc i hi).le]
    · simp [c', hi]
  have hbd' :
      NumStability.HDP.Scalar.IndependentSums.McDiarmid.SeqBoundedDifferences f c' N := by
    intro i hi x y hxy
    simpa [c', hi] using hbd i hi x y hxy
  have htail :=
    NumStability.HDP.Scalar.IndependentSums.McDiarmid.mcdiarmid_shifted_boundedDifferences
      (X := X) μ hdep hbd'
        (NumStability.HDP.Scalar.IndependentSums.McDiarmid.shiftedFunction_measurable hmeas)
        hc' ht.le
  have hsum :
      NumStability.HDP.Scalar.IndependentSums.McDiarmid.boundedDifferencesVarianceSum c' N =
        ∑ i ∈ Finset.range N, c i ^ 2 := by
    unfold NumStability.HDP.Scalar.IndependentSums.McDiarmid.boundedDifferencesVarianceSum
    apply Finset.sum_congr rfl
    intro i hi
    simp [c', Finset.mem_range.mp hi]
  simpa [NumStability.HDP.Scalar.IndependentSums.McDiarmid.shiftedFunction, hsum] using htail

theorem hdp_02_hthm_h2_d9_d1__contract :
    hdp_02_hthm_h2_d9_d1__contract_type :=
  hdp_02_hthm_h2_d9_d1_exact

end NumStability.HDP.Contract
