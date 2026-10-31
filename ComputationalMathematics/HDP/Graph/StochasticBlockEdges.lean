import ComputationalMathematics.HDP.Graph.StochasticBlock

/-!
# Canonical edges of the balanced stochastic-block model

The lexicographically oriented edge associated to two distinct vertices,
together with its community and symmetry laws.
-/

namespace NumStability.HDP.Graph.StochasticBlock

/-- The canonical unordered edge associated to two distinct vertices. -/
def edgeOfNe {k : ℕ} (i j : Vertex k) (hij : i ≠ j) : Edge k :=
  if h : toLex i < toLex j then
    ⟨(i, j), h⟩
  else
    ⟨(j, i), by
      have hle : toLex j ≤ toLex i := le_of_not_gt h
      have hne : toLex j ≠ toLex i := by
        intro hEq
        apply hij
        exact toLex.injective hEq.symm
      exact lt_of_le_of_ne hle hne⟩

/-- Canonical orientation preserves whether the vertices share a community. -/
theorem edgeOfNe_sameCommunity {k : ℕ}
    (i j : Vertex k) (hij : i ≠ j) :
    (edgeOfNe i j hij).1.1.1 = (edgeOfNe i j hij).1.2.1 ↔
      i.1 = j.1 := by
  simp only [edgeOfNe]
  split <;> simp [eq_comm]

/-- Swapping the vertices gives the same canonical edge. -/
theorem edgeOfNe_swap {k : ℕ}
    (i j : Vertex k) (hij : i ≠ j) (hji : j ≠ i) :
    edgeOfNe i j hij = edgeOfNe j i hji := by
  apply Subtype.ext
  simp only [edgeOfNe]
  by_cases hlt : toLex i < toLex j
  · have hnlt : ¬ toLex j < toLex i := not_lt_of_ge hlt.le
    simp [hlt, hnlt]
  · have hne : toLex j ≠ toLex i := by
      intro hEq
      apply hij
      exact toLex.injective hEq.symm
    have hgt : toLex j < toLex i := lt_of_le_of_ne (le_of_not_gt hlt) hne
    simp [hlt, hgt]

end NumStability.HDP.Graph.StochasticBlock
