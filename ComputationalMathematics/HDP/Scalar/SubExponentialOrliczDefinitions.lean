import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Source-level characterizations of the Orlicz definitions

This module exposes the fieldwise characterization of an Orlicz function and
the defining Luxemburg gauge and finite-gauge membership formulas used in
Section 2.7.1.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open scoped ENNReal Topology

namespace NumStability.HDP.Scalar.SubExponential

/-- A real function is the underlying function of the local Orlicz structure
exactly when it has the source's five defining properties on the nonnegative
half-line. -/
theorem exists_orliczFunction_toFun_iff (f : ℝ → ℝ) :
    (∃ ψ : OrliczFunction, ψ.toFun = f) ↔
      (∀ x : ℝ, 0 ≤ x → 0 ≤ f x) ∧
      ConvexOn ℝ (Set.Ici 0) f ∧
      MonotoneOn f (Set.Ici 0) ∧
      f 0 = 0 ∧ Tendsto f atTop atTop := by
  constructor
  · rintro ⟨ψ, rfl⟩
    exact ⟨ψ.nonnegative, ψ.convexOn_nonneg, ψ.monotoneOn_nonneg,
      ψ.map_zero, ψ.tendsto_atTop⟩
  · rintro ⟨hNonnegative, hConvex, hMonotone, hZero, hTop⟩
    exact ⟨{
      toFun := f
      nonnegative := hNonnegative
      convexOn_nonneg := hConvex
      monotoneOn_nonneg := hMonotone
      map_zero := hZero
      tendsto_atTop := hTop
    }, rfl⟩

/-- The Luxemburg gauge and finite-gauge member predicate unfold to the two
formulas printed in Section 2.7.1. -/
theorem orliczGauge_and_member_definitions
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) :
    orliczGauge ψ μ X =
        sInf {t : ℝ≥0∞ |
          t ≠ 0 ∧ t ≠ ∞ ∧
            (∫⁻ ω, ENNReal.ofReal (ψ (|X ω| / t.toReal)) ∂μ) ≤ 1} ∧
      (orliczMember ψ μ X ↔ orliczGauge ψ μ X < ∞) := by
  exact ⟨rfl, Iff.rfl⟩

end NumStability.HDP.Scalar.SubExponential
