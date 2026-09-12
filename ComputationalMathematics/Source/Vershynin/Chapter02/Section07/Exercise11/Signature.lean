import ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm

/-!
# Frozen contract signature for Exercise 2.7.11

This file is intentionally proof-free. It records that the Luxemburg
functional is a norm on the finite Orlicz space by spelling out its four norm
laws on almost-everywhere equivalence classes.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

def hdp_02_hex_h2_d7_d11__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (ψ : OrliczFunction),
    (∀ X : orliczAEEqSpace ψ μ, 0 ≤ ‖X‖) ∧
      (∀ X : orliczAEEqSpace ψ μ, ‖X‖ = 0 ↔ X = 0) ∧
      (∀ X Y : orliczAEEqSpace ψ μ, ‖X + Y‖ ≤ ‖X‖ + ‖Y‖) ∧
      (∀ (c : ℝ) (X : orliczAEEqSpace ψ μ), ‖c • X‖ = |c| * ‖X‖)

end NumStability.HDP.Contract
