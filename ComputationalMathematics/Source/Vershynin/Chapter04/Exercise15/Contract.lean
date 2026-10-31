import Mathlib.InformationTheory.Hamming

/-!
# Vershynin, Chapter 4, Exercise 4.2.15

Source-correspondence contract verifying that Hamming distance is a metric.
-/

open Finset

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Exercise 4.2.15: the Hamming
distance is a metric. Mathlib proves the stronger alphabet-generic result for
every finite coordinate type. -/
theorem hdp_04_hexercise_h4_d2_d15
    {ι : Type*} (β : ι → Type*) [Fintype ι] [∀ i, DecidableEq (β i)] :
    Nonempty {m : MetricSpace (Hamming β) // m.toDist = Hamming.instDist} ∧
      ∀ x y : ∀ i, β i, hammingDist x y = #{i | x i ≠ y i} := by
  exact ⟨⟨⟨Hamming.instMetricSpace, rfl⟩⟩, fun _ _ ↦ rfl⟩

end NumStability.HDP.Contract
