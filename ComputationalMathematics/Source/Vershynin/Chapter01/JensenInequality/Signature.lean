import Mathlib.Analysis.Convex.Integral

/-! Frozen proof-free signature for Jensen's inequality. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_01_hthm_hjensen__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {φ : ℝ → ℝ}
    (hφ : ConvexOn ℝ Set.univ φ)
    (hX : Integrable X μ)
    (hφX : Integrable (fun ω => φ (X ω)) μ),
    φ (∫ ω, X ω ∂μ) ≤
      ∫ ω, φ (X ω) ∂μ

end NumStability.HDP.Contract
