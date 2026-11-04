import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Euclidean covering-number notation

A small named wrapper for the internal covering number on finite-dimensional
real Euclidean space.
-/

open Set
open scoped NNReal

namespace NumStability.HDP.Metric

/-- The covering number of a set in finite-dimensional real Euclidean space,
with the ambient Euclidean metric understood. -/
noncomputable def euclideanCoveringNumber {n : ℕ}
    (K : Set (EuclideanSpace ℝ (Fin n))) (ε : ℝ≥0) : ℕ∞ :=
  _root_.Metric.coveringNumber ε K

@[simp]
theorem euclideanCoveringNumber_eq_coveringNumber {n : ℕ}
    (K : Set (EuclideanSpace ℝ (Fin n))) (ε : ℝ≥0) :
    euclideanCoveringNumber K ε = _root_.Metric.coveringNumber ε K := rfl

/-- A closed unit ball has internal covering number one at every radius
strictly larger than one. -/
theorem coveringNumber_unitClosedBall_eq_one
    {E : Type*} [NormedAddCommGroup E]
    (ε : ℝ≥0) (hε : 1 < ε) :
    _root_.Metric.coveringNumber ε (Metric.closedBall (0 : E) 1) = 1 := by
  have hcover :
      _root_.Metric.IsCover ε (Metric.closedBall (0 : E) 1) {0} := by
    intro x hx
    refine ⟨0, by simp, ?_⟩
    simp only [edist_dist, ENNReal.ofReal_le_coe]
    exact (Metric.mem_closedBall.1 hx).trans (by exact_mod_cast hε.le)
  apply le_antisymm
  · exact (hcover.coveringNumber_le_encard (by simp)).trans (by simp)
  · simp [Order.one_le_iff_pos]

end NumStability.HDP.Metric
