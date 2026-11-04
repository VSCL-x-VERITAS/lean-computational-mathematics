import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Covering-number finiteness and precompactness

Reusable equivalences between total boundedness, compact closure in a complete
metric space, and finiteness of every positive-radius internal covering number.
-/

open Set
open scoped ENNReal NNReal Topology

namespace NumStability.HDP.Metric

variable {T : Type*} [MetricSpace T] {K : Set T}

/-- A set is totally bounded exactly when all of its positive-radius internal
covering numbers are finite. -/
theorem totallyBounded_iff_coveringNumber_lt_top :
    TotallyBounded K ↔
      ∀ ε : ℝ≥0, 0 < ε → Metric.coveringNumber ε K < ⊤ := by
  constructor
  · intro hK ε hε
    obtain ⟨N, hNK, hNfin, hNcover⟩ :=
      Metric.exists_finite_isCover_of_totallyBounded hε.ne' hK
    exact (hNcover.coveringNumber_le_encard hNK).trans_lt hNfin.encard_lt_top
  · intro hK
    rw [Metric.totallyBounded_iff]
    intro r hr
    let ε : ℝ≥0 := ⟨r / 2, by positivity⟩
    have hε : 0 < ε := by
      change 0 < r / 2
      positivity
    have hcovering : Metric.coveringNumber ε K ≠ ⊤ := (hK ε hε).ne
    obtain ⟨N, _hNK, hNfin, hNcover, _hcard⟩ :=
      Metric.exists_set_encard_eq_coveringNumber hcovering
    refine ⟨N, hNfin, ?_⟩
    intro x hx
    have hx' := (Metric.isCover_iff_subset_iUnion_closedBall.mp hNcover) hx
    simp only [Set.mem_iUnion, Metric.mem_closedBall] at hx'
    obtain ⟨y, hyN, hxy⟩ := hx'
    simp only [Set.mem_iUnion, Metric.mem_ball]
    exact ⟨y, hyN, hxy.trans_lt (by simpa [ε] using half_lt_self hr)⟩

/-- In a complete metric space, a set has compact closure exactly when all of
its positive-radius internal covering numbers are finite. -/
theorem isCompact_closure_iff_coveringNumber_lt_top [CompleteSpace T] :
    IsCompact (closure K) ↔
      ∀ ε : ℝ≥0, 0 < ε → Metric.coveringNumber ε K < ⊤ := by
  rw [isCompact_iff_totallyBounded_isComplete]
  simp only [isClosed_closure.isComplete, and_true]
  rw [totallyBounded_closure]
  exact totallyBounded_iff_coveringNumber_lt_top

end NumStability.HDP.Metric
