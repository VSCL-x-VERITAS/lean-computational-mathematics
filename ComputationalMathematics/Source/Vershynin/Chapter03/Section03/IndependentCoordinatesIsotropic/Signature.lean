import ComputationalMathematics.HDP.Vector.IndependentCoordinates
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Frozen contract signature for the independent-coordinate isotropy claim in Section 3.3.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
/-- A finite coordinate family has a product joint law, the transparent
source-facing form of mutual coordinate independence. -/
def hdp_03_body_3_3_independent_coordinates_isotropic__hasProductCoordinateLaw
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) : Prop :=
  Measure.map (fun ω i => X i ω) μ =
    Measure.pi (fun i => Measure.map (X i) μ)

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_independent_coordinates_isotropic__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ),
      (∀ i, MemLp (X i) 2 μ) →
        hdp_03_body_3_3_independent_coordinates_isotropic__hasProductCoordinateLaw μ X →
          (∀ i, ∫ ω, X i ω ∂μ = 0) →
            (∀ i, NumStability.HDP.Scalar.Preliminaries.variance μ (X i) = 1) →
              NumStability.HDP.Vector.Isotropy.IsIsotropic μ X

end NumStability.HDP.Contract
