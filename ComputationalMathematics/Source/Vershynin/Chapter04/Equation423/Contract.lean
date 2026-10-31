import ComputationalMathematics.HDP.Matrix.FixedVectorNorm

/-!
# Vershynin Chapter 4, Equation (4.23)
-/

open Matrix WithLp

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.23): for a fixed vector `x`, setting
`Xᵢ=⟨Aᵢ,x⟩` expands the squared Euclidean norm of `Ax` as `∑ᵢ Xᵢ²`.
The identity does not require the source's unit-vector specialization. -/
theorem hdp_04_equation_4_23 {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (x : Fin n → ℝ) :
    ∃ X : Fin m → ℝ,
      (∀ i, X i = dotProduct (A i) x) ∧
      ‖(WithLp.toLp 2 (A.mulVec x) : EuclideanSpace ℝ (Fin m))‖ ^ 2 =
        ∑ i, (X i) ^ 2 := by
  refine ⟨fun i ↦ dotProduct (A i) x, fun _ ↦ rfl, ?_⟩
  exact NumStability.HDP.Matrix.norm_sq_toLp_mulVec A x

end NumStability.HDP.Contract
