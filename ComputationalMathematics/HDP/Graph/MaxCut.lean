import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Data.Finset.Powerset

/-!
# Cuts in finite simple graphs

This file packages the elementary finite-graph notions used by the maximum-cut
application.  A bipartition is represented by one of its parts; the other part
is its complement.
-/

namespace NumStability.HDP.Graph

open SimpleGraph

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Whether an unordered pair has exactly one endpoint in `S`. -/
def EdgeCrosses (S : Finset V) : Sym2 V → Prop :=
  Sym2.lift ⟨fun u v ↦ (u ∈ S) ≠ (v ∈ S), fun _ _ ↦ propext (not_congr eq_comm)⟩

@[simp]
theorem edgeCrosses_mk_iff (S : Finset V) (u v : V) :
    EdgeCrosses S s(u, v) ↔ (u ∈ S) ≠ (v ∈ S) :=
  Iff.rfl

/-- The number of graph edges crossing the bipartition `S | Sᶜ`. -/
noncomputable def cutSize (G : SimpleGraph V) [DecidableRel G.Adj] (S : Finset V) : ℕ := by
  classical
  exact (G.edgeFinset.filter (EdgeCrosses S)).card

/-- The maximum number of edges crossing any bipartition of the vertices. -/
noncomputable def maxCut (G : SimpleGraph V) [DecidableRel G.Adj] : ℕ :=
  Finset.univ.powerset.sup (cutSize G)

theorem cutSize_le_maxCut (G : SimpleGraph V) [DecidableRel G.Adj] (S : Finset V) :
    cutSize G S ≤ maxCut G := by
  exact Finset.le_sup (f := cutSize G) (Finset.mem_powerset.mpr (Finset.subset_univ S))

/-- A maximum cut is attained because a finite graph has finitely many bipartitions. -/
theorem exists_cutSize_eq_maxCut (G : SimpleGraph V) [DecidableRel G.Adj] :
    ∃ S : Finset V, cutSize G S = maxCut G := by
  classical
  let P : Finset (Finset V) := Finset.univ.powerset
  obtain ⟨S, hS, hmax⟩ := P.exists_max_image (cutSize G) (Finset.powerset_nonempty _)
  refine ⟨S, le_antisymm (cutSize_le_maxCut G S) ?_⟩
  exact Finset.sup_le hmax

end NumStability.HDP.Graph
