import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Source-facing contract for Equation (1.4), the `L^p` triangle inequality. -/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- On the book's probability-space `L^p`, the `L^p` size satisfies the
triangle inequality for every extended exponent `p ≥ 1`, including `p = ∞`.

The `MemLp` hypotheses record the source's premise that `X` and `Y` belong to
`L^p`; the reusable inequality itself is valid under the weaker measurability
hypotheses extracted from them. -/
theorem hdp_01_heq_h1_d4_spec
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℝ} {p : ENNReal}
    (hp : 1 ≤ p) (hX : MemLp X p μ) (hY : MemLp Y p μ) :
    eLpNorm (X + Y) p μ ≤ eLpNorm X p μ + eLpNorm Y p μ :=
  NumStability.HDP.Scalar.Preliminaries.minkowskiEpnorm hX.1 hY.1 hp

end NumStability.HDP.Contract
