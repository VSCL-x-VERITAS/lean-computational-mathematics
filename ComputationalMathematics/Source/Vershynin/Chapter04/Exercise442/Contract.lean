import ComputationalMathematics.HDP.Metric.SetNetApproximation

/-!
# Vershynin Chapter 4, Exercise 4.4.2
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.4.2: the supremum of the inner products of `x` with
any set-valued `ε`-net of the Euclidean unit sphere approximates `‖x‖₂`
within the factor `(1 - ε)⁻¹`. -/
theorem hdp_04_exercise_4_4_2 {n : ℕ}
    (hn : 0 < n) (x : EuclideanSpace ℝ (Fin n)) (ε : ℝ)
    (N : Set (EuclideanSpace ℝ (Fin n)))
    (hε0 : 0 < ε) (hε1 : ε < 1)
    (hN : NumStability.HDP.Metric.IsUnitSphereNet ε N) :
    sSup {a : ℝ | ∃ y ∈ N, a = inner ℝ x y} ≤ ‖x‖ ∧
      ‖x‖ ≤ (1 - ε)⁻¹ *
        sSup {a : ℝ | ∃ y ∈ N, a = inner ℝ x y} := by
  let i : Fin n := ⟨0, hn⟩
  let e : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single i 1
  have he : ‖e‖ = 1 := by simp [e]
  obtain ⟨y, hyN, _⟩ := hN.2 e he
  exact NumStability.HDP.Metric.sSup_inner_bounds_of_isUnitSphereNet
    x ε N hε0.le hε1 hN ⟨y, hyN⟩

end NumStability.HDP.Contract
