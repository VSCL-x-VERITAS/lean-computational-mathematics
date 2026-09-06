import ComputationalMathematics.HDP.Scalar.IndependentSums.MedianOfMeansProbability
import ComputationalMathematics.HDP.Scalar.IndependentSums.SampleMeanChebyshev

/-!
# Median of independent sample means

The block-sample instantiation of median amplification.  Independence is
expressed hierarchically: the block vectors are independent, and observations
within each block are pairwise independent and identically distributed.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Scalar.IndependentSums.MedianOfMeansSample

/-- Independent odd blocks of sufficiently large sample means yield an
`ε`-accurate median with probability at least `1-δ`. -/
theorem iidBlockMedian_failure_le
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
      |MedianOfMeans.oddMedian k
          (fun j => (n : ℝ)⁻¹ * ∑ i, X j i ω) -
        ∫ y, X ⟨0, by omega⟩ ⟨0, hn⟩ y ∂μ|} ≤ δ := by
  let j0 : Fin (2 * k + 1) := ⟨0, by omega⟩
  let i0 : Fin n := ⟨0, hn⟩
  let avg : (Fin n → ℝ) → ℝ := fun v => (n : ℝ)⁻¹ * ∑ i, v i
  let Z : Fin (2 * k + 1) → Ω → ℝ := fun j ω => avg (fun i => X j i ω)
  have havg : Measurable avg := by
    dsimp [avg]
    fun_prop
  have hZMeas : ∀ j, Measurable (Z j) := by
    intro j
    exact havg.comp (by fun_prop)
  have hZIndep : iIndepFun Z μ := by
    exact hBlockIndep.comp (fun _ => avg) (fun _ => havg)
  have hweak : ∀ j, μ.real {ω | ε ≤
      |Z j ω - ∫ y, X j0 i0 y ∂μ|} ≤ 1 / 4 := by
    intro j
    have hIdentBlock : ∀ i, IdentDistrib (X j i) (X j i0) μ μ := by
      intro i
      exact (hIdent j i).trans (hIdent j i0).symm
    have hVarBlock : Var[X j i0; μ] = σ ^ 2 := by
      calc
        Var[X j i0; μ] = Var[X j0 i0; μ] := (hIdent j i0).variance_eq
        _ = σ ^ 2 := by simpa [j0, i0] using hVar
    have htail := SampleMeanChebyshev.iidSampleMean_failure_le_quarter
      n hn (hMeas j) (hLp j) (hWithin j) hIdentBlock hVarBlock hε hnLarge
    have hMean : (∫ y, X j i0 y ∂μ) = ∫ y, X j0 i0 y ∂μ :=
      (hIdent j i0).integral_eq
    change μ.real {ω | ε ≤
      |(n : ℝ)⁻¹ * ∑ i, X j i ω - ∫ y, X j i0 y ∂μ|} ≤ 1 / 4 at htail
    rw [hMean] at htail
    simpa [Z, avg, ge_iff_le] using htail
  have htail := MedianOfMeansProbability.oddMedian_failure_probability_le
    k hZMeas hZIndep hweak hδ0 hδ1 hkLarge
  simpa [Z, avg, j0, i0, ge_iff_le] using htail

end NumStability.HDP.Scalar.IndependentSums.MedianOfMeansSample
