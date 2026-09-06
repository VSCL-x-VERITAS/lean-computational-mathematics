import ComputationalMathematics.HDP.Scalar.Preliminaries

/-! Stable Chapter 1 forwarding theorem for the real `L²` Cauchy--Schwarz bound. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

theorem hdp_01_hthm_hcauchy_hschwarz
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : MemLp X 2 μ) (hY : MemLp Y 2 μ) :
    ‖NumStability.HDP.Scalar.Preliminaries.expectation μ
        (fun ω => X ω * Y ω)‖ ≤
      (eLpNorm X 2 μ).toReal * (eLpNorm Y 2 μ).toReal :=
  NumStability.HDP.Scalar.Preliminaries.cauchySchwarzIntegralBound hX hY

end NumStability.HDP.Contract
