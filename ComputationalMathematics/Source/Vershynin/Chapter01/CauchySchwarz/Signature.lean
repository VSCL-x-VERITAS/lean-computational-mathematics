import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-! Frozen proof-free signature for Chapter 1 Cauchy--Schwarz. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_01_hthm_hcauchy_hschwarz__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ},
    MemLp X 2 μ → MemLp Y 2 μ →
      ‖∫ ω, X ω * Y ω ∂μ‖ ≤
        (eLpNorm X 2 μ).toReal * (eLpNorm Y 2 μ).toReal

end NumStability.HDP.Contract
