import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Vershynin, Chapter 4, Definition 4.2.4

Candidate source-correspondence wrapper for separated sets and packing numbers.
The packing-number codomain is subject to the Chapter 4 semantic audit.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Candidate contract for Vershynin, *High-Dimensional Probability*,
Definition 4.2.4: metric separation and the associated packing number. -/
theorem hdp_04_hdef_h4_d2_d4 {T : Type*} [MetricSpace T]
    {K N : Set T} {ε : ℝ≥0} :
    (Metric.IsSeparated ε N ↔
      ∀ x ∈ N, ∀ y ∈ N, x ≠ y → (ε : ℝ) < dist x y) ∧
    Metric.packingNumber ε K =
      ⨆ (C : Set T) (_ : C ⊆ K) (_ : Metric.IsSeparated ε C), C.encard := by
  constructor
  · simp [Metric.IsSeparated, Set.Pairwise, edist_dist]
  · rfl

end NumStability.HDP.Contract
