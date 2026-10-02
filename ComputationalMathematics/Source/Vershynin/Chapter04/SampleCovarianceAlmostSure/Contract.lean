import ComputationalMathematics.HDP.Vector.CovarianceEstimation

/-!
# Vershynin Chapter 4, almost-sure sample covariance convergence
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- The entrywise law-of-large-numbers statement in Section 4.7: the sample
covariance matrices converge almost surely to the population second-moment
matrix. -/
theorem hdp_04_sample_covariance_almost_sure
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ}
    (X : ℕ → Ω → Fin n → ℝ)
    (hInt : ∀ a b, Integrable (fun ω ↦ X 0 ω a * X 0 ω b) μ)
    (hIndep : Pairwise (fun i j ↦ IndepFun (X i) (X j) μ))
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ, ∀ a b,
      Filter.Tendsto
        (fun m ↦
          NumStability.HDP.Vector.Covariance.sequenceSampleCovariance X m ω a b)
        Filter.atTop
        (nhds (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
          (fun i ω ↦ X 0 ω i) a b)) :=
  NumStability.HDP.Vector.Covariance.sequenceSampleCovariance_tendsto_secondMomentMatrix_ae
    X hInt hIndep hIdent

end NumStability.HDP.Contract
