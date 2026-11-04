import ComputationalMathematics.HDP.Metric.EuclideanSphereCovering

/-!
# Vershynin Chapter 4, Equation (4.12)
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Equation (4.12): the two Euclidean unit spheres admit quarter-nets whose
cardinalities are bounded by `9^n` and `9^m`, respectively. -/
theorem hdp_04_equation_4_12 {m n : ℕ} (hm : 0 < m) (hn : 0 < n) :
    ∃ (N : Finset (EuclideanSpace ℝ (Fin n)))
      (M : Finset (EuclideanSpace ℝ (Fin m))),
      NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N ∧
      NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M ∧
      N.Nonempty ∧ M.Nonempty ∧ N.card ≤ 9 ^ n ∧ M.card ≤ 9 ^ m := by
  obtain ⟨N, hN, hNne, hNcard⟩ :=
    NumStability.HDP.Metric.exists_quarterNet_card_le_nine_pow n hn
  obtain ⟨M, hM, hMne, hMcard⟩ :=
    NumStability.HDP.Metric.exists_quarterNet_card_le_nine_pow m hm
  exact ⟨N, M, hN, hM, hNne, hMne, hNcard, hMcard⟩

end NumStability.HDP.Contract
