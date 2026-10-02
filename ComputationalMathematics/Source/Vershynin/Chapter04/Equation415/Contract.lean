import ComputationalMathematics.HDP.Probability.FiniteUnion
import Mathlib.Analysis.SpecialFunctions.Exp

/-!
# Vershynin Chapter 4, Equation (4.15)
-/

noncomputable section

open MeasureTheory Set
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.15): union bounding the fixed-pair tail over nets
of sizes at most `9ⁿ` and `9ᵐ` gives the displayed `9ⁿ⁺ᵐ` probability bound. -/
theorem hdp_04_equation_4_15
    {Ω I J : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (N : Finset I) (M : Finset J)
    (Z : I → J → Ω → ℝ) (u c K : ℝ)
    (hn hm : ℕ) (hNcard : N.card ≤ 9 ^ hn) (hMcard : M.card ≤ 9 ^ hm)
    (hpair : ∀ x ∈ N, ∀ y ∈ M,
      μ {ω | u ≤ Z x y ω} ≤
        ENNReal.ofReal (2 * Real.exp (-c * u ^ 2 / K ^ 2))) :
    μ (⋃ x ∈ N, ⋃ y ∈ M, {ω | u ≤ Z x y ω}) ≤
      ((9 ^ (hn + hm) : ℕ) : ℝ≥0∞) *
        ENNReal.ofReal (2 * Real.exp (-c * u ^ 2 / K ^ 2)) := by
  have hcard : N.card * M.card ≤ 9 ^ (hn + hm) := by
    calc
      N.card * M.card ≤ 9 ^ hn * 9 ^ hm := Nat.mul_le_mul hNcard hMcard
      _ = 9 ^ (hn + hm) := by rw [pow_add]
  exact (NumStability.HDP.Probability.measure_biUnion_product_le
    μ N M (fun x y ↦ {ω | u ≤ Z x y ω}) _ hpair).trans
      (mul_le_mul_right' (by exact_mod_cast hcard) _)

end NumStability.HDP.Contract
