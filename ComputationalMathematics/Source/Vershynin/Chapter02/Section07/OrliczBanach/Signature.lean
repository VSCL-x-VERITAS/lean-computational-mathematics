import ComputationalMathematics.HDP.Scalar.SubExponentialOrliczComplete

/-!
# Frozen contract signature for the Orlicz-space completeness assertion

This file is intentionally proof-free. It spells out that the finite-gauge
Orlicz space carries both its normed real-vector-space structure and a complete
metric structure, hence is a Banach space.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

def hdp_02_hbody_h2_d7_horlicz_hbanach__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (ψ : OrliczFunction),
    Nonempty (NormedSpace ℝ (orliczAEEqSpace ψ μ)) ∧
      Nonempty (CompleteSpace (orliczAEEqSpace ψ μ))

end NumStability.HDP.Contract
