import ComputationalMathematics.Analysis.MatrixAlgebra

/-!
# Vershynin Chapter 4: singular-value vector norm comparison

Thin source contract for the finite-vector norm inequality used to compare the
operator and Frobenius norms through the singular-value vector.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Chapter 4, p. 77, inline check: for the `r`-component
singular-value vector, its infinity and Euclidean norms satisfy
`‖s‖∞ ≤ ‖s‖₂ ≤ sqrt r * ‖s‖∞`. -/
theorem hdp_04_singular_vector_norm_comparison_check {r : ℕ}
    (s : Fin r → ℝ) :
    NumStability.infNormVec s ≤ NumStability.vecNorm2 s ∧
      NumStability.vecNorm2 s ≤
        Real.sqrt (r : ℝ) * NumStability.infNormVec s := by
  refine ⟨NumStability.infNormVec_le_vecNorm2 s, ?_⟩
  exact NumStability.vecNorm2_le_sqrt_card_mul_of_abs_le s
    (NumStability.infNormVec_nonneg s)
    (fun i => NumStability.abs_le_infNormVec s i)

end NumStability.HDP.Contract
