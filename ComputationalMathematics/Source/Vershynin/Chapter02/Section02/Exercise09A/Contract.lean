import ComputationalMathematics.HDP.Scalar.IndependentSums.SampleMeanChebyshev

/-! Source-facing Chapter 2 contract for Exercise 2.2.9(a). -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Contract

/-- Exercise 2.2.9(a) with the absolute sample-size constant `C = 4`. -/
theorem hdp_02_hex_h2_d2_d9a
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (N : ℕ) (hN : 0 < N)
    {X : Fin N → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X ⟨0, hN⟩) μ μ)
    {σ ε : ℝ}
    (hVar : Var[X ⟨0, hN⟩; μ] = σ ^ 2)
    (hε : 0 < ε)
    (hNlarge : 4 * σ ^ 2 / ε ^ 2 ≤ (N : ℝ)) :
    μ.real {ω | |(N : ℝ)⁻¹ * ∑ i, X i ω -
        ∫ y, X ⟨0, hN⟩ y ∂μ| ≥ ε} ≤ 1 / 4 :=
  NumStability.HDP.Scalar.IndependentSums.SampleMeanChebyshev.iidSampleMean_failure_le_quarter
      N hN hMeas hX hIndep hIdent hVar hε hNlarge

end NumStability.HDP.Contract
