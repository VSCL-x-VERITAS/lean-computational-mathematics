import ComputationalMathematics.HDP.Vector.Moments
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.ExpectedSquaredNorm.Signature

/-! Source-facing contract for the expected squared norm identity in Section 3.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open NumStability.HDP.Scalar.Preliminaries

namespace NumStability.HDP.Contract

/-- Section 3.1, printed page 42: a random vector with independent, centered,
unit-variance coordinates has expected squared Euclidean norm equal to its
dimension. Independence is retained from the source context, although the
linearity calculation itself only uses the coordinate second moments. -/
theorem hdp_03_body_3_1_norm_square_mean
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {n : ℕ}
    (X : Fin n → Ω → ℝ)
    (_hIndep : iIndepFun X μ)
    (_hMeas : ∀ i, Measurable (X i))
    (hMean : ∀ i, expectation μ (X i) = 0)
    (hVar : ∀ i, variance μ (X i) = 1) :
    expectation μ (fun ω => NumStability.vecNorm2Sq (fun i => X i ω)) = n := by
  have hInt : ∀ i, Integrable (fun ω => (X i ω) ^ 2) μ := by
    intro i
    have hi := hVar i
    unfold NumStability.HDP.Scalar.Preliminaries.variance at hi
    rw [hMean i] at hi
    simpa [expectation] using integrable_of_integral_eq_one hi
  unfold expectation
  apply NumStability.HDP.Vector.Moments.expectation_vecNorm2Sq_eq_card μ X hInt
  intro i
  have hi := hVar i
  unfold NumStability.HDP.Scalar.Preliminaries.variance at hi
  rw [hMean i] at hi
  simpa [expectation] using hi

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.1 identity signature. -/
theorem hdp_03_body_3_1_norm_square_mean__contract :
    hdp_03_body_3_1_norm_square_mean__contract_type := by
  intro Ω _ μ _ n X hIndep hMeas hMean hVar
  exact hdp_03_body_3_1_norm_square_mean X hIndep hMeas hMean hVar

end NumStability.HDP.Contract
