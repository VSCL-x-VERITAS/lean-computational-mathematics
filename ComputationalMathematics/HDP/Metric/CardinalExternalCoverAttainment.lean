import Mathlib.SetTheory.Cardinal.Order
import Mathlib.Topology.MetricSpace.Cover

/-!
# Exact-cardinal attainment for ambient covers

Every set in a pseudoemetric space has an ambient cover of least exact
cardinality at every nonnegative radius. The whole set supplies an admissible
cover, and the well-founded order on cardinals supplies its minimum. Empty
sets, radius zero, and infinite cardinalities need no separate assumptions.
This ordinary result selects no source convention for an infinite numerical
covering value.
-/

open scoped NNReal

universe u

namespace NumStability.HDP.Metric

/-- An ambient cover of minimum exact cardinality exists for every set and
every nonnegative radius in a pseudoemetric space. -/
theorem exists_isCover_cardinalMk_minimum
    {X : Type u} [PseudoEMetricSpace X] (ε : ℝ≥0) (K : Set X) :
    ∃ C : Set X, _root_.Metric.IsCover ε K C ∧
      ∀ D : Set X, _root_.Metric.IsCover ε K D → Cardinal.mk C ≤ Cardinal.mk D := by
  let S : Set Cardinal.{u} :=
    {c | ∃ C : Set X, _root_.Metric.IsCover ε K C ∧ Cardinal.mk C = c}
  have hnonempty : S.Nonempty :=
    ⟨Cardinal.mk K, K, _root_.Metric.IsCover.refl ε K, rfl⟩
  have hmin : IsLeast S (sInf S) := isLeast_csInf hnonempty
  obtain ⟨C, hcover, hcard⟩ := hmin.1
  refine ⟨C, hcover, ?_⟩
  intro D hD
  rw [hcard]
  exact hmin.2 (show Cardinal.mk D ∈ S from ⟨D, hD, rfl⟩)

end NumStability.HDP.Metric
