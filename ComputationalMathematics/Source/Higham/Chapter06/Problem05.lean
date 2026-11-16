-- Source/Higham/Chapter06/Problem05.lean
--
-- Higham Chapter 6, Problem 6.5 source-facing theorem package.

import ComputationalMathematics.Analysis.MatrixNorms.SquareContraction

/-!
# Higham Chapter 6, Problem 6.5

Formalizes Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed.,
Problem 6.5: its Frobenius/operator product inequality and unitarily invariant
norm argument built from monomial unitary matrices.
-/

namespace NumStability

open scoped BigOperators
open scoped ComplexOrder
open ENNReal


/-- Higham Problem 6.5, complex Frobenius/operator-2 product inequality:
    `||ABC||_F <= ||A||_2 ||B||_F ||C||_2`. -/
theorem highamProblem65_complexFrobenius_triple_mul_le
    {m n p q : ℕ}
    (A : CMatrix m n) (B : CMatrix n p) (C : CMatrix p q) :
    complexMatrixFrobenius (complexMatrixMul (complexMatrixMul A B) C) <=
      complexMatrixOp2 A * complexMatrixFrobenius B * complexMatrixOp2 C := by
  have hright :=
    complexMatrixFrobenius_mul_le_mul_op2 (complexMatrixMul A B) C
  have hleft := complexMatrixFrobenius_mul_le_op2_mul A B
  calc
    complexMatrixFrobenius (complexMatrixMul (complexMatrixMul A B) C)
        <= complexMatrixFrobenius (complexMatrixMul A B) * complexMatrixOp2 C := hright
    _ <= (complexMatrixOp2 A * complexMatrixFrobenius B) * complexMatrixOp2 C :=
        mul_le_mul_of_nonneg_right hleft (complexMatrixOp2_nonneg C)
    _ = complexMatrixOp2 A * complexMatrixFrobenius B * complexMatrixOp2 C := by ring

/-- Higham Problem 6.5 in the fixed-shape operator-ideal API:
    `|||A B C||| <= ||A||_2 |||B||| ||C||_2` for
    `A : m x m`, `B : m x n`, and `C : n x n`. -/
theorem highamProblem65_fixedOperatorIdealNorm_triple_mul_le
    {m n : ℕ} (xi : ComplexMatrixFixedOperatorIdealNorm m n)
    (A : CMatrix m m) (B : CMatrix m n) (C : CMatrix n n) :
    xi.norm (complexMatrixMul (complexMatrixMul A B) C) <=
      complexMatrixOp2 A * xi.norm B * complexMatrixOp2 C := by
  have hright :
      xi.norm (complexMatrixMul (complexMatrixMul A B) C) <=
        xi.norm (complexMatrixMul A B) * complexMatrixOp2 C :=
    xi.right_mul_le (complexMatrixMul A B) C
  have hleft :
      xi.norm (complexMatrixMul A B) <= complexMatrixOp2 A * xi.norm B :=
    xi.left_mul_le A B
  calc
    xi.norm (complexMatrixMul (complexMatrixMul A B) C)
        <= xi.norm (complexMatrixMul A B) * complexMatrixOp2 C := hright
    _ <= (complexMatrixOp2 A * xi.norm B) * complexMatrixOp2 C :=
        mul_le_mul_of_nonneg_right hleft (complexMatrixOp2_nonneg C)
    _ = complexMatrixOp2 A * xi.norm B * complexMatrixOp2 C := by ring

/-- Higham Problem 6.5 for a bare fixed-shape unitarily invariant norm:
    `|||A B C||| <= ||A||_2 |||B||| ||C||_2`. -/
theorem highamProblem65_fixedUnitaryInvariantNorm_triple_mul_le
    {m n : ℕ} (ξ : ComplexMatrixFixedUnitaryInvariantNorm m n)
    (A : CMatrix m m) (B : CMatrix m n) (C : CMatrix n n) :
    ξ.norm (complexMatrixMul (complexMatrixMul A B) C) <=
      complexMatrixOp2 A * ξ.norm B * complexMatrixOp2 C :=
  highamProblem65_fixedOperatorIdealNorm_triple_mul_le
    (ξ.toOperatorIdealNormOfSVD) A B C

/-- Higham Problem 6.5 in the explicit shape-changing operator-ideal
    norm-family API:
    `|||ABC||| <= ||A||_2 |||B||| ||C||_2`.

    For a bare fixed-shape unitarily invariant norm, use the fixed-shape API
    above. For a dimension-uniform family, the missing mathematical foundation
    is a padding-coherence theorem plus the fixed-shape contraction argument. -/
theorem highamProblem65_operatorIdealNorm_triple_mul_le
    (ξ : ComplexMatrixOperatorIdealNormFamily) {m n p q : ℕ}
    (A : CMatrix m n) (B : CMatrix n p) (C : CMatrix p q) :
    ξ.norm (complexMatrixMul (complexMatrixMul A B) C) <=
      complexMatrixOp2 A * ξ.norm B * complexMatrixOp2 C := by
  have hright :
      ξ.norm (complexMatrixMul (complexMatrixMul A B) C) <=
        ξ.norm (complexMatrixMul A B) * complexMatrixOp2 C :=
    ξ.right_mul_le (complexMatrixMul A B) C
  have hleft :
      ξ.norm (complexMatrixMul A B) <= complexMatrixOp2 A * ξ.norm B :=
    ξ.left_mul_le A B
  calc
    ξ.norm (complexMatrixMul (complexMatrixMul A B) C)
        <= ξ.norm (complexMatrixMul A B) * complexMatrixOp2 C := hright
    _ <= (complexMatrixOp2 A * ξ.norm B) * complexMatrixOp2 C :=
        mul_le_mul_of_nonneg_right hleft (complexMatrixOp2_nonneg C)
    _ = complexMatrixOp2 A * ξ.norm B * complexMatrixOp2 C := by ring
end NumStability
