import ComputationalMathematics.HDP.Vector.CenteredPairs

/-! Frozen contract signature for Exercise 3.2.6. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_2_6__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X Y : Fin n → Ω → ℝ),
      (∀ i, MemLp (X i) 2 μ) → (∀ i, MemLp (Y i) 2 μ) →
        NumStability.HDP.Vector.Covariance.meanVector μ X = 0 →
          NumStability.HDP.Vector.Covariance.meanVector μ Y = 0 →
            NumStability.HDP.Vector.Isotropy.IsIsotropic μ X →
              NumStability.HDP.Vector.Isotropy.IsIsotropic μ Y →
                (fun ω i => X i ω) ⟂ᵢ[μ] (fun ω i => Y i ω) →
                  (∫ ω, NumStability.vecNorm2Sq (fun i => X i ω - Y i ω) ∂μ) =
                    2 * n

end NumStability.HDP.Contract
