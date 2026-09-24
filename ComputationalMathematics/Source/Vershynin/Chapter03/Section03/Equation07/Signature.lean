import ComputationalMathematics.HDP.Vector.GaussianNormConcentration

/-! Frozen proof-free signature for Equation (3.7). -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_7__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {n : ℕ} [Nonempty (Fin n)]
      {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ),
      (∀ i, Measurable (X i)) →
        NumStability.HDP.Vector.Gaussian.IsStandardNormal μ X →
          ∀ {t : ℝ}, 0 ≤ t →
            μ.real {ω |
                |NumStability.vecNorm2 (fun i => X i ω) -
                  Real.sqrt (n : ℝ)| ≥ t} ≤
              2 * Real.exp (-(c * t ^ 2))

end NumStability.HDP.Contract
