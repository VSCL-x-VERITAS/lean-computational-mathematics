import Mathlib.MeasureTheory.Measure.Real

/-!
# Contract: HDP Proposition 2.4.1 union-bound step

Source-facing name for the finite union bound used over all vertices in the
proof of Vershynin's Proposition 2.4.1.  The proof is direct Mathlib reuse.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-- The probability of at least one bad event is bounded by the sum of the
individual bad-event probabilities. -/
theorem hdp_02_hbody_h2_d4_hunion_hbound
    {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    (μ : Measure Ω) (Bad : ι → Set Ω) :
    μ.real (⋃ i, Bad i) ≤ ∑ i, μ.real (Bad i) :=
  measureReal_iUnion_fintype_le (μ := μ) Bad

/-- Combining the finite union bound with one common bound for every bad
event gives the `n`-times-one-vertex estimate used in Proposition 2.4.1. -/
theorem hdp_02_hbody_h2_d4_hunion_hbound_of_each_le
    {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    (μ : Measure Ω) (Bad : ι → Set Ω) (q : ℝ)
    (hBad : ∀ i, μ.real (Bad i) ≤ q) :
    μ.real (⋃ i, Bad i) ≤ ∑ i, μ.real (Bad i) ∧
      (∑ i, μ.real (Bad i)) ≤ Fintype.card ι * q := by
  constructor
  · exact hdp_02_hbody_h2_d4_hunion_hbound μ Bad
  · calc
      (∑ i, μ.real (Bad i)) ≤ ∑ _i : ι, q :=
        Finset.sum_le_sum fun i _hi => hBad i
      _ = Fintype.card ι * q := by simp

end NumStability.HDP.Contract
