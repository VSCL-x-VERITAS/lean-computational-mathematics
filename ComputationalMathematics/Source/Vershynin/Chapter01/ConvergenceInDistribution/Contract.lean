import ComputationalMathematics.HDP.Scalar.LimitTheorems
import ComputationalMathematics.Source.Vershynin.Chapter01.StandardNormal.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.StandardizedSum.Contract
/-!
# Contract: HDP Chapter 1 convergence in distribution

Source-facing wrapper for the weak-convergence notion for real random
variables used in Vershynin, *High-Dimensional Probability* (first edition,
2018), Chapter 1.  The mathematics lives in
`NumStability.HDP.Scalar.LimitTheorems`; this module only exposes the stable
source-facing name.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open ProbabilityTheory

/-- Chapter 1's weak-convergence definition for real random variables. -/
noncomputable def hdp_01_hdef_hconvergence_hin_hdistribution
    {Ω ι : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (l : Filter ι) (Z : Ω → ℝ)
    (hX : ∀ i, AEMeasurable (X i) μ) (hZ : AEMeasurable Z μ) : Prop :=
  NumStability.HDP.Scalar.LimitTheorems.convergenceInDistribution μ X l Z hX hZ

/--
The literal pointwise-CDF criterion printed after Theorem 1.3.2.  This is kept
separate from weak convergence because the two notions agree in this form only
at continuity points of the limiting CDF.
-/
noncomputable def hdp_01_hdef_hconvergence_hin_hdistribution_pointwise_cdf
    {Ω ι : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (l : Filter ι) (Z : Ω → ℝ)
    (hX : ∀ i, AEMeasurable (X i) μ) (hZ : AEMeasurable Z μ) : Prop :=
  ∀ t : ℝ, Filter.Tendsto
    (fun i ↦
      NumStability.HDP.Scalar.LimitTheorems.probabilityLaw (X i) (hX i) (Set.Iic t))
    l
    (nhds
      (NumStability.HDP.Scalar.LimitTheorems.probabilityLaw Z hZ (Set.Iic t)))

/-- The literal printed CDF criterion, exposed as a theorem-level audit surface. -/
theorem hdp_01_hdef_hconvergence_hin_hdistribution_pointwise_cdf_spec
    {Ω ι : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (l : Filter ι) (Z : Ω → ℝ)
    (hX : ∀ i, AEMeasurable (X i) μ) (hZ : AEMeasurable Z μ) :
    hdp_01_hdef_hconvergence_hin_hdistribution_pointwise_cdf μ X l Z hX hZ ↔
      ∀ t : ℝ, Filter.Tendsto
        (fun i ↦
          NumStability.HDP.Scalar.LimitTheorems.probabilityLaw (X i) (hX i) (Set.Iic t))
        l
        (nhds
          (NumStability.HDP.Scalar.LimitTheorems.probabilityLaw Z hZ (Set.Iic t))) :=
  Iff.rfl

/--
Weak convergence gives CDF convergence at a threshold where the limiting law
has no atom.  The missing singleton hypothesis is the standard
continuity-point qualification omitted by the printed prose.
-/
theorem hdp_01_hdef_hconvergence_hin_hdistribution_cdf_at_continuity_point
    {Ω ι : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (l : Filter ι) (Z : Ω → ℝ)
    (hX : ∀ i, AEMeasurable (X i) μ) (hZ : AEMeasurable Z μ)
    (hweak : hdp_01_hdef_hconvergence_hin_hdistribution μ X l Z hX hZ)
    (t : ℝ)
    (ht : NumStability.HDP.Scalar.LimitTheorems.probabilityLaw Z hZ {t} = 0) :
    Filter.Tendsto
      (fun i ↦
        NumStability.HDP.Scalar.LimitTheorems.probabilityLaw (X i) (hX i) (Set.Iic t))
      l
      (nhds
        (NumStability.HDP.Scalar.LimitTheorems.probabilityLaw Z hZ (Set.Iic t))) := by
  apply MeasureTheory.ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto hweak
  simpa only [frontier_Iic] using ht

/-- Weak convergence to an atomless law satisfies the book's all-threshold CDF criterion. -/
theorem hdp_01_hdef_hconvergence_hin_hdistribution_pointwise_cdf_of_no_atoms
    {Ω ι : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (l : Filter ι) (Z : Ω → ℝ)
    (hX : ∀ i, AEMeasurable (X i) μ) (hZ : AEMeasurable Z μ)
    (hweak : hdp_01_hdef_hconvergence_hin_hdistribution μ X l Z hX hZ)
    (hnoAtoms : ∀ t : ℝ,
      NumStability.HDP.Scalar.LimitTheorems.probabilityLaw Z hZ {t} = 0) :
    hdp_01_hdef_hconvergence_hin_hdistribution_pointwise_cdf
      μ X l Z hX hZ := by
  intro t
  exact hdp_01_hdef_hconvergence_hin_hdistribution_cdf_at_continuity_point
    μ X l Z hX hZ hweak t (hnoAtoms t)

/-!
The source-specific boundary below retains the generic reusable definitions
above, but restores the exact context inherited from Theorem 1.3.2: iid
finite-variance variables, the positive standard deviation, the normalized
sums, natural-number convergence to infinity, and the standard-normal limit.
-/

/--
The literal pointwise-CDF meaning of convergence in distribution for the
normalized sums in Theorem 1.3.2.  The source omits the usual continuity-point
qualification; this declaration intentionally preserves that printed wording.
-/
noncomputable def
    hdp_01_hdef_hconvergence_hin_hdistribution_normalized_sum_pointwise_cdf
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ)
    (_hσ : 0 < σ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (_hIndep : ProbabilityTheory.iIndepFun X μ)
    (_hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (_hMean : ∫ ω, X 0 ω ∂μ = m)
    (_hVariance : Var[X 0; μ] = σ ^ 2) : Prop :=
  ∀ t : ℝ, Filter.Tendsto
    (fun N : ℕ ↦
      NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
        (hdp_01_hdef_hzn X m σ (N + 1))
        (hdp_01_hdef_hzn_aemeasurable μ X m σ (N + 1)
          (fun i ↦ (hX i).aemeasurable))
        (Set.Iic t))
    Filter.atTop
    (nhds (hdp_01_hdef_hstandard_hnormal_probability (Set.Iic t)))

/-- The exact source-specific pointwise-CDF criterion as a theorem audit surface. -/
theorem
    hdp_01_hdef_hconvergence_hin_hdistribution_normalized_sum_pointwise_cdf_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ)
    (hσ : 0 < σ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = m)
    (hVariance : Var[X 0; μ] = σ ^ 2) :
    hdp_01_hdef_hconvergence_hin_hdistribution_normalized_sum_pointwise_cdf
        μ X m σ hσ hX hIndep hIdent hMean hVariance ↔
      ∀ t : ℝ, Filter.Tendsto
        (fun N : ℕ ↦
          NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
            (hdp_01_hdef_hzn X m σ (N + 1))
            (hdp_01_hdef_hzn_aemeasurable μ X m σ (N + 1)
              (fun i ↦ (hX i).aemeasurable))
            (Set.Iic t))
        Filter.atTop
        (nhds (hdp_01_hdef_hstandard_hnormal_probability (Set.Iic t))) :=
  Iff.rfl

end NumStability.HDP.Contract
