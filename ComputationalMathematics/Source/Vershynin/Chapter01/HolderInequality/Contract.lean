import ComputationalMathematics.HDP.Scalar.Preliminaries
/-! Source-facing exhaustive contract for the Chapter 1 Hölder inequality. -/

noncomputable section

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Scalar.Preliminaries

/-- Original bundled Hölder-model forwarding alias. -/
theorem hdp_01_hthm_hholder
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X Y : Ω → ℝ) :
    HolderModelData μ X Y :=
  holderModel μ X Y

/-- Hölder's inequality on the book's probability-space `L^p` classes.  The
first conjunct covers finite conjugate exponents; the other two retain the
`(1, ∞)` and `(∞, 1)` endpoints explicitly. -/
theorem hdp_01_hthm_hholder_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℝ} :
    (∀ {p q : ℝ}, p.HolderConjugate q →
      MemLp X (ENNReal.ofReal p) μ →
      MemLp Y (ENNReal.ofReal q) μ →
      ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        (∫ ω, ‖X ω‖ ^ p ∂μ) ^ (1 / p) *
          (∫ ω, ‖Y ω‖ ^ q ∂μ) ^ (1 / q)) ∧
    (MemLp X 1 μ → MemLp Y (⊤ : ENNReal) μ →
      ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        (eLpNorm X 1 μ).toReal * (eLpNorm Y (⊤ : ENNReal) μ).toReal) ∧
    (MemLp X (⊤ : ENNReal) μ → MemLp Y 1 μ →
      ‖expectation μ (fun ω => X ω * Y ω)‖ ≤
        (eLpNorm X (⊤ : ENNReal) μ).toReal * (eLpNorm Y 1 μ).toReal) := by
  exact ⟨fun hpq hX hY => holderIntegralBound hpq hX hY,
    holderEndpointOneTop, holderEndpointTopOne⟩

end NumStability.HDP.Contract
