import ComputationalMathematics.HDP.Vector.MarginalVariance

/-! Frozen contract signature for the marginal-variance characterization in Section 3.2.3. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_marginal_isotropy__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ), (∀ i, MemLp (X i) 2 μ) →
      NumStability.HDP.Vector.Covariance.meanVector μ X = 0 →
      (NumStability.HDP.Vector.Isotropy.IsIsotropic μ X ↔
        ∀ x : Fin n → ℝ,
          variance (fun ω => ∑ i, X i ω * x i) μ = ∑ i, (x i) ^ 2)

end NumStability.HDP.Contract
