import ComputationalMathematics.Source.Vershynin.Chapter01.Section03.Theorem02.Contract
import ComputationalMathematics.Source.Vershynin.Chapter01.BernoulliAndBinomial.Contract

/-!
# Contract: HDP Equation (1.7)

The de Moivre–Laplace specialization of the iid central limit theorem.
-/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory Filter ProbabilityTheory
open scoped Topology BigOperators NNReal

/-- The exact `sqrt (N p (1-p))` normalization displayed in (1.7), indexed
by the positive sample size `N + 1`. -/
noncomputable def hdp_01_heq_h1_d7_normalizedSum
    {Ω : Type*} (X : ℕ → Ω → ℝ) (p : ℝ≥0) (N : ℕ) : Ω → ℝ :=
  fun ω =>
    (Real.sqrt ((N + 1 : ℝ) * p.toReal * (1 - p.toReal)))⁻¹ *
      ∑ i ∈ Finset.range (N + 1), (X i ω - p.toReal)

theorem hdp_01_heq_h1_d7_normalizedSum_aemeasurable
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (p : ℝ≥0) (N : ℕ)
    (hX : ∀ i, AEMeasurable (X i) μ) :
    AEMeasurable (hdp_01_heq_h1_d7_normalizedSum X p N) μ := by
  unfold hdp_01_heq_h1_d7_normalizedSum
  apply AEMeasurable.const_mul
  exact (Finset.range (N + 1)).aemeasurable_fun_sum fun i _ =>
    (hX i).sub aemeasurable_const

/-- Equation (1.7): iid variables with Bernoulli mean and variance obey the
de Moivre–Laplace normal limit. The moment hypotheses expose exactly the two
Bernoulli identities established by `hdp_01_hdef_hbernoulli`. -/
theorem hdp_01_heq_h1_d7
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (p : ℝ≥0) (hp0 : 0 < p) (hp1 : p < 1)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : iIndepFun X μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = p.toReal)
    (hVariance : Var[X 0; μ] = p.toReal * (1 - p.toReal)) :
    Tendsto (fun N : ℕ =>
      NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
        (hdp_01_heq_h1_d7_normalizedSum X p N)
        (hdp_01_heq_h1_d7_normalizedSum_aemeasurable
          μ X p N (fun i => (hX i).aemeasurable)))
      atTop (𝓝 hdp_01_hdef_hstandard_hnormal_probability) := by
  have hpR0 : (0 : ℝ) < p.toReal := by exact_mod_cast hp0
  have hpR1 : p.toReal < 1 := by exact_mod_cast hp1
  have hpvar : 0 < p.toReal * (1 - p.toReal) := mul_pos hpR0 (sub_pos.mpr hpR1)
  have hσ : 0 < Real.sqrt (p.toReal * (1 - p.toReal)) :=
    Real.sqrt_pos.mpr hpvar
  have hVariance' :
      Var[X 0; μ] = (Real.sqrt (p.toReal * (1 - p.toReal))) ^ 2 := by
    rw [Real.sq_sqrt hpvar.le]
    exact hVariance
  have hclt := hdp_01_hthm_h1_d3_d2_weak μ X p.toReal
    (Real.sqrt (p.toReal * (1 - p.toReal))) hσ
    hX hIndep hIdent hMean hVariance'
  have hEq (N : ℕ) :
      hdp_01_hdef_hzn X p.toReal
          (Real.sqrt (p.toReal * (1 - p.toReal))) (N + 1) =
        hdp_01_heq_h1_d7_normalizedSum X p N := by
    funext ω
    unfold hdp_01_hdef_hzn hdp_01_heq_h1_d7_normalizedSum
    congr 2
    rw [← Real.sqrt_mul hpvar.le]
    congr 1
    push_cast
    ring
  apply hclt.congr'
  filter_upwards with N
  apply ProbabilityMeasure.toMeasure_injective
  change Measure.map
      (hdp_01_hdef_hzn X p.toReal
        (Real.sqrt (p.toReal * (1 - p.toReal))) (N + 1)) μ =
    Measure.map (hdp_01_heq_h1_d7_normalizedSum X p N) μ
  rw [hEq N]

end NumStability.HDP.Contract
