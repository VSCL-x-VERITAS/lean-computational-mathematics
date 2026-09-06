import ComputationalMathematics.HDP.Scalar.IndependentSums.MedianOfMeansSample

/-! Source-facing Chapter 2 contract for Exercise 2.2.9(b). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Contract

/-- Exercise 2.2.9(b), with `n` observations in each of `2k+1` independent
blocks.  The explicit weak-estimate constant is `4`, and the amplification
constant is the one from Exercise 2.2.8. -/
theorem hdp_02_hex_h2_d2_d9b
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (n k : ℕ) (hn : 0 < n)
    {X : Fin (2 * k + 1) → Fin n → Ω → ℝ}
    (hMeas : ∀ j i, Measurable (X j i))
    (hLp : ∀ j i, MemLp (X j i) 2 μ)
    (hBlockIndep : iIndepFun (fun j ω i => X j i ω) μ)
    (hWithin : ∀ j, Pairwise ((· ⟂ᵢ[μ] ·) on X j))
    (hIdent : ∀ j i,
      IdentDistrib (X j i) (X ⟨0, by omega⟩ ⟨0, hn⟩) μ μ)
    {σ ε δ : ℝ}
    (hVar : Var[X ⟨0, by omega⟩ ⟨0, hn⟩; μ] = σ ^ 2)
    (hε : 0 < ε)
    (hnLarge : 4 * σ ^ 2 / ε ^ 2 ≤ (n : ℝ))
    (hδ0 : 0 < δ) (hδ1 : δ < 1)
    (hkLarge : Real.log (1 / δ) / (2 * (1 / 4 : ℝ) ^ 2) ≤
      (Fintype.card (Fin (2 * k + 1)) : ℝ)) :
    μ.real {ω | ε ≤
      |NumStability.HDP.Scalar.IndependentSums.MedianOfMeans.oddMedian k
          (fun j => (n : ℝ)⁻¹ * ∑ i, X j i ω) -
        ∫ y, X ⟨0, by omega⟩ ⟨0, hn⟩ y ∂μ|} ≤ δ :=
  NumStability.HDP.Scalar.IndependentSums.MedianOfMeansSample.iidBlockMedian_failure_le
    n k hn hMeas hLp hBlockIndep hWithin hIdent hVar hε hnLarge hδ0 hδ1 hkLarge

end NumStability.HDP.Contract
