import ComputationalMathematics.HDP.Metric.NormDeviationNet

/-!
# Vershynin Chapter 4, Exercise 4.4.4
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- The finite squared-deviation estimate suggested by the hint to Exercise
4.4.4.  It is retained as a proof-level corollary, not as the source-facing
displayed statement. -/
theorem hdp_04_exercise_4_4_4_finite_squared_hint
    {m n : ℕ} (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ)
    (μ ε : ℝ) (N : Finset (EuclideanSpace ℝ (Fin n)))
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : NumStability.HDP.Metric.IsFiniteUnitSphereNet ε N)
    (hNnonempty : N.Nonempty) :
    ∃ x ∈ N,
      (∀ y ∈ N,
        |‖Matrix.toEuclideanLin A y‖ ^ 2 - μ| ≤
          |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ|) ∧
      (∀ u : EuclideanSpace ℝ (Fin n), ‖u‖ = 1 →
        |‖Matrix.toEuclideanLin A u‖ ^ 2 - μ| ≤
          (1 - 2 * ε)⁻¹ * |‖Matrix.toEuclideanLin A x‖ ^ 2 - μ|) := by
  exact NumStability.HDP.Metric.exists_net_norm_sq_deviation_max_bounds
    hn A μ ε N hε0 hεhalf hN hNnonempty

/-- Vershynin, Exercise 4.4.4: for any set-valued `ε`-net of the unit
sphere, the uniform unsquared norm deviation is controlled by the supremum on
the net.  The source writes an unspecified absolute constant `C`; `3` is an
explicit valid choice. -/
theorem hdp_04_exercise_4_4_4_three
    {m n : ℕ} (hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ)
    (μ ε : ℝ) (N : Set (EuclideanSpace ℝ (Fin n)))
    (hε0 : 0 ≤ ε) (hεhalf : ε < 1 / 2)
    (hN : NumStability.HDP.Metric.IsUnitSphereNet ε N) :
    ∀ u : EuclideanSpace ℝ (Fin n), ‖u‖ = 1 →
      |‖Matrix.toEuclideanLin A u‖ - μ| ≤
        3 * (1 - 2 * ε)⁻¹ *
          sSup {a : ℝ | ∃ x ∈ N, a = |‖Matrix.toEuclideanLin A x‖ - μ|} := by
  exact NumStability.HDP.Metric.norm_deviation_le_three_mul_inv_mul_sSup_net
    hn A μ ε N hε0 hεhalf hN

/-- Vershynin, Exercise 4.4.4, with the absolute constant quantified before
all matrix dimensions and data.  The preceding theorem supplies the explicit
universal choice `C = 3`. -/
theorem hdp_04_exercise_4_4_4 :
    ∃ C : ℝ, 0 < C ∧
      ∀ {m n : ℕ} (_hn : 0 < n) (A : Matrix (Fin m) (Fin n) ℝ)
        (μ ε : ℝ) (N : Set (EuclideanSpace ℝ (Fin n))),
        0 ≤ ε → ε < 1 / 2 →
        NumStability.HDP.Metric.IsUnitSphereNet ε N →
        ∀ u : EuclideanSpace ℝ (Fin n), ‖u‖ = 1 →
          |‖Matrix.toEuclideanLin A u‖ - μ| ≤
            C * (1 - 2 * ε)⁻¹ *
              sSup {a : ℝ | ∃ x ∈ N, a = |‖Matrix.toEuclideanLin A x‖ - μ|} := by
  refine ⟨3, by norm_num, ?_⟩
  intro m n hn A μ ε N hε0 hεhalf hN u hu
  exact hdp_04_exercise_4_4_4_three hn A μ ε N hε0 hεhalf hN u hu

end NumStability.HDP.Contract
