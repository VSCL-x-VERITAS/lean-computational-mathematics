import ComputationalMathematics.HDP.Graph.StochasticBlock

/-!
# Balanced stochastic-block signal decomposition

This additive module keeps the signal-complement decomposition separate from
the frozen stochastic-block core used by earlier audited source rows.
-/

noncomputable section

namespace NumStability.HDP.Graph.StochasticBlock

private theorem finTwo_eq_zero_or_one_decomposition (i : Fin 2) :
    i = 0 ∨ i = 1 := by
  rcases Nat.le_one_iff_eq_zero_or_eq_one.mp
      (Nat.le_of_lt_succ i.isLt) with h | h
  · exact Or.inl (Fin.ext h)
  · exact Or.inr (Fin.ext h)

/-- Every vector on two nonempty balanced communities splits into its
constant signal, signed-community signal, and a remainder whose coordinates
sum to zero on each community. -/
theorem exists_signal_complement_decomposition {k : ℕ}
    (hk : 0 < k) (x : Vertex k → ℝ) :
    ∃ a b : ℝ, ∃ y : Vertex k → ℝ,
      x = a • allOnes k + b • communitySign k + y ∧
        ∀ c : Fin 2, ∑ t : Fin k, y (c, t) = 0 := by
  let m₀ : ℝ := (∑ t : Fin k, x (0, t)) / k
  let m₁ : ℝ := (∑ t : Fin k, x (1, t)) / k
  let a : ℝ := (m₀ + m₁) / 2
  let b : ℝ := (m₀ - m₁) / 2
  let y : Vertex k → ℝ := x - a • allOnes k - b • communitySign k
  refine ⟨a, b, y, ?_, ?_⟩
  · funext i
    simp [y]
  · intro c
    rcases finTwo_eq_zero_or_one_decomposition c with rfl | rfl
    · have hab : a + b = m₀ := by dsimp [a, b]; ring
      have hkR : (k : ℝ) ≠ 0 := by exact_mod_cast Nat.ne_of_gt hk
      calc
        ∑ t : Fin k, y (0, t) =
            ∑ t : Fin k, (x (0, t) - (a + b)) := by
              apply Finset.sum_congr rfl
              intro t _
              simp [y, allOnes, communitySign]
              ring
        _ = (∑ t : Fin k, x (0, t)) - ∑ _t : Fin k, (a + b) :=
          by rw [Finset.sum_sub_distrib]
        _ = (∑ t : Fin k, x (0, t)) - (k : ℝ) * (a + b) := by
          simp
          ring
        _ = (∑ t : Fin k, x (0, t)) - (k : ℝ) * m₀ := by rw [hab]
        _ = 0 := by dsimp [m₀]; field_simp [hkR]; ring
    · have hab : a - b = m₁ := by dsimp [a, b]; ring
      have hkR : (k : ℝ) ≠ 0 := by exact_mod_cast Nat.ne_of_gt hk
      calc
        ∑ t : Fin k, y (1, t) =
            ∑ t : Fin k, (x (1, t) - (a - b)) := by
              apply Finset.sum_congr rfl
              intro t _
              simp [y, allOnes, communitySign]
              ring
        _ = (∑ t : Fin k, x (1, t)) - ∑ _t : Fin k, (a - b) :=
          by rw [Finset.sum_sub_distrib]
        _ = (∑ t : Fin k, x (1, t)) - (k : ℝ) * (a - b) := by
          simp
          ring
        _ = (∑ t : Fin k, x (1, t)) - (k : ℝ) * m₁ := by rw [hab]
        _ = 0 := by dsimp [m₁]; field_simp [hkR]; ring

end NumStability.HDP.Graph.StochasticBlock
