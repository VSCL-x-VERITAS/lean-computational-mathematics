import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Lemma 4.2.8: complete owner-qualified numerical chain

The extended-natural packing supremum and internal covering infimum are used
at both positive scales for arbitrary metric sets, including empty and infinite
sets. No finite optimizer is an input.
-/

noncomputable section

open scoped ENNReal NNReal

universe u

namespace NumStability.HDP.Contract

/-- The full numerical chain from Lemma 4.2.8 under the admitted ENat
convention, with strict separation and internal closed-ball covering. -/
def hdp_04_lemma_4_2_8_owner_qualified_numerical : Prop :=
  ∀ (T : Type u) [MetricSpace T] (K : Set T) (ε : ℝ≥0),
    0 < ε →
      Metric.packingNumber (2 * ε) K ≤ Metric.coveringNumber ε K ∧
        Metric.coveringNumber ε K ≤ Metric.packingNumber ε K

end NumStability.HDP.Contract
