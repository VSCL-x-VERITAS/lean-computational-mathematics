import ComputationalMathematics.HDP.Vector.IsotropyPairs

/-! Frozen contract signature for the second assertion of Lemma 3.2.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_lem_3_2_4b__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X Y : Fin n → Ω → ℝ),
      (∀ i, MemLp (X i) 2 μ) → (∀ i, MemLp (Y i) 2 μ) →
        NumStability.HDP.Vector.Isotropy.IsIsotropic μ X →
          NumStability.HDP.Vector.Isotropy.IsIsotropic μ Y →
            (fun ω i => X i ω) ⟂ᵢ[μ] (fun ω i => Y i ω) →
              (∫ ω, (∑ i, X i ω * Y i ω) ^ 2 ∂μ) = n

end NumStability.HDP.Contract
