import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Power Orlicz functions

The canonical Orlicz function `x ↦ x ^ p` for `p ≥ 1`, together with its
identification with the classical `Lᵖ` gauge and finite space.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open scoped Topology ENNReal

namespace NumStability.HDP.Scalar.SubExponential

/-- The power Orlicz function `x ↦ x ^ p` for `p ≥ 1`. -/
noncomputable def powerOrliczFunction (p : NNReal) (hp : 1 ≤ p) : OrliczFunction where
  toFun := fun x => x ^ (p : ℝ)
  nonnegative := by
    intro x hx
    exact Real.rpow_nonneg hx _
  convexOn_nonneg := by
    exact convexOn_rpow (by exact_mod_cast hp)
  monotoneOn_nonneg := by
    apply Real.monotoneOn_rpow_Ici_of_exponent_nonneg
    positivity
  map_zero := by
    rw [Real.zero_rpow]
    positivity
  tendsto_atTop := by
    apply tendsto_rpow_atTop
    positivity

@[simp] theorem powerOrliczFunction_apply
    (p : NNReal) (hp : 1 ≤ p) (x : ℝ) :
    powerOrliczFunction p hp x = x ^ (p : ℝ) :=
  rfl

/-- For every `p ≥ 1`, the canonical power Orlicz function has exactly the
classical `Lᵖ` gauge and finite space. -/
theorem canonicalPowerOrliczCoincidence :
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) (p : NNReal) (hp : 1 ≤ p),
      (∀ X : Ω → ℝ,
        orliczGauge (powerOrliczFunction p hp) μ X = eLpNorm X (p : ℝ≥0∞) μ) ∧
      (∀ X : Ω → ℝ, AEStronglyMeasurable X μ →
        (orliczMember (powerOrliczFunction p hp) μ X ↔
          MemLp X (p : ℝ≥0∞) μ)) := by
  intro Ω _ μ p hp
  exact powerOrliczCoincidence (powerOrliczFunction p hp) μ p
    (lt_of_lt_of_le zero_lt_one hp) (by intro x hx; rfl)

end NumStability.HDP.Scalar.SubExponential
