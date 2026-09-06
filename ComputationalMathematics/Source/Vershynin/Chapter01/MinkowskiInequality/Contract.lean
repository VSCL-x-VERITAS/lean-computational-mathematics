import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Stable source-facing forwarding declaration for Minkowski's inequality. -/

namespace NumStability.HDP.Contract

open MeasureTheory

theorem hdp_01_hthm_hminkowski
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {p : ENNReal}
    (hX : AEStronglyMeasurable X μ) (hY : AEStronglyMeasurable Y μ)
    (hp : 1 ≤ p) :
    eLpNorm (X + Y) p μ ≤ eLpNorm X p μ + eLpNorm Y p μ :=
  NumStability.HDP.Scalar.Preliminaries.minkowskiEpnorm hX hY hp

end NumStability.HDP.Contract
