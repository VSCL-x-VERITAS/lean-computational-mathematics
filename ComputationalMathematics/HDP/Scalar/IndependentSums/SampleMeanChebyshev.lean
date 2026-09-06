import ComputationalMathematics.HDP.Scalar.LimitTheorems
import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# Chebyshev sample-mean accuracy

Reusable finite-sample probability bounds obtained by combining the iid
sample-mean variance identity with Chebyshev's inequality.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Scalar.IndependentSums.SampleMeanChebyshev

/-- The exact Chebyshev failure bound for a nonempty iid sample mean. -/
theorem iidSampleMean_failure_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (N : ℕ) (hN : 0 < N)
    {X : Fin N → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X ⟨0, hN⟩) μ μ)
    {ε : ℝ} (hε : 0 < ε) :
    μ.real {ω | |(N : ℝ)⁻¹ * ∑ i, X i ω -
        ∫ y, X ⟨0, hN⟩ y ∂μ| ≥ ε} ≤
      (N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ] / ε ^ 2 := by
  let M : Ω → ℝ := fun ω => (N : ℝ)⁻¹ * ∑ i, X i ω
  have hM : MemLp M 2 μ := by
    dsimp [M]
    exact (memLp_finset_sum Finset.univ (fun i _ => hX i)).const_mul (N : ℝ)⁻¹
  have hMMeas : Measurable M := by
    dsimp [M]
    exact (Finset.measurable_sum Finset.univ (fun i _ => hMeas i)).const_mul _
  have hMean : (∫ ω, M ω ∂μ) = ∫ ω, X ⟨0, hN⟩ ω ∂μ := by
    dsimp [M]
    rw [integral_const_mul, integral_finset_sum]
    · simp_rw [fun i => (hIdent i).integral_eq]
      rw [Finset.sum_const, Finset.card_fin]
      field_simp
      simp [nsmul_eq_mul]
    · intro i _
      exact (hX i).integrable (by norm_num)
  have hChebyshev :=
    NumStability.HDP.Scalar.Preliminaries.chebyshevEventBound
      hMMeas (hM.integrable (by norm_num))
        (hM.sub (memLp_const _)).integrable_sq hε
  have hVariance :=
    NumStability.HDP.Scalar.LimitTheorems.iidSampleMeanVariance
      N hN hX hIndep hIdent
  change Var[M; μ] = _ at hVariance
  have hMean' : NumStability.HDP.Scalar.Preliminaries.expectation μ M =
      ∫ y, X ⟨0, hN⟩ y ∂μ := by
    simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hMean
  have hVariance' : NumStability.HDP.Scalar.Preliminaries.variance μ M =
      (N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ] := by
    calc
      NumStability.HDP.Scalar.Preliminaries.variance μ M = Var[M; μ] :=
        (variance_eq_integral hM.aemeasurable).symm
      _ = (N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ] := hVariance
  rw [hMean', hVariance'] at hChebyshev
  simpa [M] using hChebyshev

/-- Four variance units per squared accuracy suffice to make the sample-mean
failure probability at most one quarter. -/
theorem iidSampleMean_failure_le_quarter
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
        ∫ y, X ⟨0, hN⟩ y ∂μ| ≥ ε} ≤ 1 / 4 := by
  have htail := iidSampleMean_failure_le N hN hMeas hX hIndep hIdent hε
  rw [hVar] at htail
  have hNreal : 0 < (N : ℝ) := by exact_mod_cast hN
  have hεsq : 0 < ε ^ 2 := sq_pos_of_pos hε
  have hmul : 4 * σ ^ 2 ≤ (N : ℝ) * ε ^ 2 :=
    (div_le_iff₀ hεsq).mp hNlarge
  calc
    μ.real {ω | |(N : ℝ)⁻¹ * ∑ i, X i ω -
        ∫ y, X ⟨0, hN⟩ y ∂μ| ≥ ε} ≤
        (N : ℝ)⁻¹ * σ ^ 2 / ε ^ 2 := htail
    _ ≤ 1 / 4 := by
      rw [show (N : ℝ)⁻¹ * σ ^ 2 = σ ^ 2 / (N : ℝ) by
        simp [div_eq_mul_inv, mul_comm]]
      rw [div_le_iff₀ hεsq]
      rw [div_le_iff₀ hNreal]
      nlinarith

end NumStability.HDP.Scalar.IndependentSums.SampleMeanChebyshev
