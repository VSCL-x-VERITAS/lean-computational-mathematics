import ComputationalMathematics.HDP.Scalar.IndependentSums.HoeffdingNormalization

/-!
# Chapter 2 source contract: Hoeffding normalization

Stable source-facing statement for the complete coefficient normalization
reduction in the proof of Vershynin's Theorem 2.2.2.
-/

namespace NumStability.HDP.Contract

theorem hdp_02_hbody_h2_d2_hwlog_hnorm
    {ι Ω : Type*} [Fintype ι]
    (X : ι → Ω → ℝ) (a : ι → ℝ) (t : ℝ)
    (_ht : 0 ≤ t) :
    ((∑ i, (a i) ^ 2 = 0) ∧
        {ω | ∑ i, a i * X i ω ≥ t} = {ω | (0 : ℝ) ≥ t}) ∨
      ((0 < ∑ i, (a i) ^ 2) ∧
        (∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) ^ 2 = 1) ∧
        {ω | ∑ i, a i * X i ω ≥ t} =
          {ω | ∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) * X i ω ≥
            t / Real.sqrt (∑ j, (a j) ^ 2)}) := by
  exact
    NumStability.HDP.Scalar.IndependentSums.HoeffdingNormalization.weightedSum_ge_normalization_or_zero
      X a t

end NumStability.HDP.Contract
