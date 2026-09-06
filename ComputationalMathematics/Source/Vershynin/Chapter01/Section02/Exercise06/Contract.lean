import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable Chapter 1 source-facing declaration for Exercise 1.2.6. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory

/-- The Chebyshev bound obtained by applying Markov's inequality to the
squared centered random variable. -/
theorem hdp_01_hex_h1_d2_d6
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hInt : Integrable X μ)
    (hSqInt : Integrable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) μ)
    {t : ℝ} (ht : 0 < t) :
    μ.real {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} ≤
      NumStability.HDP.Scalar.Preliminaries.variance μ X / t ^ 2 :=
  NumStability.HDP.Scalar.Preliminaries.chebyshevEventBound hX hInt hSqInt ht

/-- Exercise 1.2.6 with its requested derivation exposed propositionally: the
absolute-deviation event is the threshold event for the squared centered
variable, Markov applies at threshold `t²`, and the resulting expectation is
the variance. -/
theorem hdp_01_hex_h1_d2_d6_derivation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X)
    (hInt : Integrable X μ)
    (hSqInt : Integrable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) μ)
    {t : ℝ} (ht : 0 < t) :
    let Y := fun ω =>
      (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2
    (Y ⁻¹' Set.Ici (t ^ 2) =
        {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t}) ∧
      (μ.real (Y ⁻¹' Set.Ici (t ^ 2)) ≤
        NumStability.HDP.Scalar.Preliminaries.expectation μ Y / t ^ 2) ∧
      (NumStability.HDP.Scalar.Preliminaries.expectation μ Y =
        NumStability.HDP.Scalar.Preliminaries.variance μ X) ∧
      (μ.real {ω |
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} ≤
        NumStability.HDP.Scalar.Preliminaries.variance μ X / t ^ 2) := by
  dsimp only
  have hY : Measurable
      (fun ω => (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) :=
    (hX.sub measurable_const).pow_const 2
  have hMarkov :=
    NumStability.HDP.Scalar.Preliminaries.markovInequalityFinite
      (X := fun ω =>
        (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2)
      hY (ae_of_all μ (fun ω => sq_nonneg _)) hSqInt (sq_pos_of_pos ht)
  have hEvent :
      (fun ω =>
        (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) ⁻¹'
          Set.Ici (t ^ 2) =
        {ω | |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| ≥ t} := by
    ext ω
    constructor
    · intro hω
      have hs : t ^ 2 ≤
          (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2 := hω
      have hs' : |t| ≤
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| :=
        (sq_le_sq).mp hs
      simpa [abs_of_pos ht] using hs'
    · intro hω
      have habs : t ≤
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| := hω
      have hs' : |t| ≤
          |X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X| := by
        simpa [abs_of_pos ht] using habs
      exact (sq_le_sq).mpr hs'
  refine ⟨hEvent, ?_, rfl, hdp_01_hex_h1_d2_d6 hX hInt hSqInt ht⟩
  simpa [NumStability.HDP.Scalar.Preliminaries.expectation] using hMarkov

end NumStability.HDP.Contract
