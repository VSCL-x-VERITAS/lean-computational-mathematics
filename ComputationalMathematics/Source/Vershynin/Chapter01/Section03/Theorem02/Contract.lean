import ComputationalMathematics.HDP.Scalar.CentralLimit
import ComputationalMathematics.Source.Vershynin.Chapter01.ConvergenceInDistribution.Contract

/-!
# Contract: HDP Theorem 1.3.2

Source-facing weak, pointwise-CDF, and closed-tail forms of the
Lindeberg–Lévy central limit theorem.
-/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory Filter Set Function ProbabilityTheory
open scoped Topology ENNReal BigOperators

/-- The reusable `Fin (N + 1)` normalization is the book's first-`N + 1`
range sum. -/
theorem normalizedIidSum_eq_hdp_01_hdef_hzn
    {Ω : Type*} (X : ℕ → Ω → ℝ) (m σ : ℝ) (N : ℕ) :
    NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum X m σ N =
      hdp_01_hdef_hzn X m σ (N + 1) := by
  funext ω
  unfold NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum
    hdp_01_hdef_hzn
  rw [Fin.sum_univ_eq_sum_range (fun i => X i ω - m) (N + 1)]
  simp only [Nat.cast_add, Nat.cast_one]

/-- The weak-convergence form of Theorem 1.3.2. -/
theorem hdp_01_hthm_h1_d3_d2_weak
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ) (hσ : 0 < σ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : iIndepFun X μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = m)
    (hVariance : Var[X 0; μ] = σ ^ 2) :
    Tendsto (fun N : ℕ =>
      NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
        (hdp_01_hdef_hzn X m σ (N + 1))
        (hdp_01_hdef_hzn_aemeasurable μ X m σ (N + 1)
          (fun i => (hX i).aemeasurable)))
      atTop (𝓝 hdp_01_hdef_hstandard_hnormal_probability) := by
  let P : ℕ → ProbabilityMeasure ℝ := fun N =>
    NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
      (hdp_01_hdef_hzn X m σ (N + 1))
      (hdp_01_hdef_hzn_aemeasurable μ X m σ (N + 1)
        (fun i => (hX i).aemeasurable))
  have hclt :=
    NumStability.HDP.Scalar.LimitTheorems.tendsto_probabilityLaw_normalizedIidSum
      X m σ hσ hX hIndep hIdent hMean hVariance
  have hseq : Tendsto P atTop
      (𝓝 (⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
        inferInstance⟩ : ProbabilityMeasure ℝ)) := by
    apply hclt.congr'
    filter_upwards with N
    dsimp [P]
    apply ProbabilityMeasure.toMeasure_injective
    change Measure.map
        (NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum X m σ N) μ =
      Measure.map (hdp_01_hdef_hzn X m σ (N + 1)) μ
    rw [normalizedIidSum_eq_hdp_01_hdef_hzn X m σ N]
  simpa [P, hdp_01_hdef_hstandard_hnormal_probability,
    hdp_01_hdef_hstandard_hnormal] using hseq

/-- The source's pointwise-CDF statement of Theorem 1.3.2. -/
theorem hdp_01_hthm_h1_d3_d2
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ) (hσ : 0 < σ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : iIndepFun X μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = m)
    (hVariance : Var[X 0; μ] = σ ^ 2) :
    hdp_01_hdef_hconvergence_hin_hdistribution_normalized_sum_pointwise_cdf
      μ X m σ hσ hX hIndep hIdent hMean hVariance := by
  intro t
  have hweak := hdp_01_hthm_h1_d3_d2_weak
    μ X m σ hσ hX hIndep hIdent hMean hVariance
  apply ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto hweak
  simp only [frontier_Iic]
  letI : NoAtoms (gaussianReal 0 1) := noAtoms_gaussianReal one_ne_zero
  simp [hdp_01_hdef_hstandard_hnormal_probability,
    hdp_01_hdef_hstandard_hnormal,
    NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw]

/-- The closed-tail formulation printed immediately after Theorem 1.3.2,
including the displayed standard-normal density integral. -/
theorem hdp_01_hthm_h1_d3_d2_tail
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ) (hσ : 0 < σ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : iIndepFun X μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = m)
    (hVariance : Var[X 0; μ] = σ ^ 2) (t : ℝ) :
    Tendsto (fun N : ℕ =>
      ((NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
        (hdp_01_hdef_hzn X m σ (N + 1))
        (hdp_01_hdef_hzn_aemeasurable μ X m σ (N + 1)
          (fun i => (hX i).aemeasurable)) : ProbabilityMeasure ℝ) : Measure ℝ)
          (Set.Ici t))
      atTop (𝓝 (ENNReal.ofReal (∫ x in Set.Ici t,
        (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x ^ 2) / 2)))) := by
  have hweak := hdp_01_hthm_h1_d3_d2_weak
    μ X m σ hσ hX hIndep hIdent hMean hVariance
  have ht := ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto
    hweak (E := Set.Ici t) (by
      simp only [frontier_Ici]
      letI : NoAtoms (gaussianReal 0 1) := noAtoms_gaussianReal one_ne_zero
      simp [hdp_01_hdef_hstandard_hnormal_probability,
        hdp_01_hdef_hstandard_hnormal,
        NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw])
  have htENN := ENNReal.continuous_coe.continuousAt.tendsto.comp ht
  have htail :
      ((hdp_01_hdef_hstandard_hnormal_probability : ProbabilityMeasure ℝ) :
          Measure ℝ) (Set.Ici t) =
        ENNReal.ofReal (∫ x in Set.Ici t,
          (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(x ^ 2) / 2)) := by
    change NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw
      (Set.Ici t) = _
    rw [NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
      gaussianReal_apply_eq_integral 0 one_ne_zero]
    rw [NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw_pdf]
  simpa [Function.comp_def, ProbabilityMeasure.coeFn_def,
    ENNReal.coe_toNNReal, measure_ne_top, htail] using htENN

end NumStability.HDP.Contract
