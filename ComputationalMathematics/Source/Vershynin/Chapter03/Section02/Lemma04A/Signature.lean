import ComputationalMathematics.HDP.Vector.IsotropyMarginals

/-! Frozen contract signature for the first assertion of Lemma 3.2.4. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_lem_3_2_4a__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ), (∀ i, MemLp (X i) 2 μ) →
      NumStability.HDP.Vector.Isotropy.IsIsotropic μ X →
        (∫ ω, NumStability.vecNorm2Sq (fun i => X i ω) ∂μ) = n

end NumStability.HDP.Contract
