import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
Cross-split stable API for `HDP-01-DEF-EXPECTATION-VARIANCE`.

The semantic producer owns the Bochner-integral definitions and centered
variable lemma; this leaf forwards the integrable probability-space model.

Section 1.1 prints the two quantities

  `E X`   and   `Var(X) = E(X - E X)^2`,

and its footnote 1 states that `E X` *is, by definition, the Lebesgue integral
of the function `X : Ω → ℝ`*.  The printed passage fixes no exceptional-value
convention for a non-integrable variable, so the source contract below is
stated on the module-owned finite-Lebesgue-integral definability domain
recorded in `module/instructions.md`: `Integrable X μ` for the ordinary
expectation and `MemLp X 2 μ` for the variance.  Those premises are exactly the
conditions that make the displayed real expressions meaningful; they are
declared meaning conditions, not proof conveniences.

Each printed quantity carries its own domain as a hypothesis of its own
conjunct, so neither clause is restricted by the other's domain.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing expectation/variance data for an integrable variable. -/
noncomputable def hdp_01_hdef_hexpectation_hvariance
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Integrable X μ) :
    NumStability.HDP.Scalar.Preliminaries.ExpectationVarianceModelData μ X hX :=
  NumStability.HDP.Scalar.Preliminaries.expectationVarianceModel μ X hX

/-- The book's Section 1.1 definitions of expectation and variance, read on the
declared finite-Lebesgue-integral definability domain.

The first conjunct is footnote 1: on the integrable domain `E X` is the
Lebesgue integral of `X`.  The second conjunct is the printed formula
`Var(X) = E(X - E X)^2`, together with the fact that square-integrability makes
its outer expectation an ordinary finite Lebesgue integral rather than a
totalized value. -/
theorem hdp_01_hdef_hexpectation_hvariance_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) :
    (Integrable X μ →
        NumStability.HDP.Scalar.Preliminaries.expectation μ X = ∫ ω, X ω ∂μ) ∧
      (MemLp X 2 μ →
        Integrable (fun ω =>
            (X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2) μ ∧
          NumStability.HDP.Scalar.Preliminaries.variance μ X =
            NumStability.HDP.Scalar.Preliminaries.expectation μ
              (fun ω =>
                (X ω -
                  NumStability.HDP.Scalar.Preliminaries.expectation μ X) ^ 2)) := by
  refine ⟨fun _ => rfl, fun hX => ⟨?_, rfl⟩⟩
  have hXc :
      MemLp (fun ω =>
        X ω - NumStability.HDP.Scalar.Preliminaries.expectation μ X) 2 μ := by
    simpa using
      hX.sub (memLp_const (NumStability.HDP.Scalar.Preliminaries.expectation μ X))
  exact hXc.integrable_sq

end NumStability.HDP.Contract
