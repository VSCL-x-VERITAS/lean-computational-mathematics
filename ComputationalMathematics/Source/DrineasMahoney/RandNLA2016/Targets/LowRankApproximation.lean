import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.MoorePenroseStructuralBound
import ComputationalMathematics.Analysis.SingularValues.FullRightSVD

/-!
# Corrected source contract for the structural low-rank bound

The literal arbitrary-spanning-matrix wording preceding equation (9) on printed
page 88 of Drineas--Mahoney (2016) is false. This proposed corrected contract
requires compatible orthonormal right singular coordinates from one ordered SVD.
It does not assert that the printed wording was already correct or that the
correction has been admitted or independently reviewed.

The orthonormal SVD convention is explicit in Boutsidis--Mahoney--Drineas,
SODA09 §2.1 and corrected arXiv:0812.4293v2 §2.1. Mahoney--Drineas, *Structural
properties underlying high-quality Randomized Numerical Linear Algebra
algorithms* (2016), §§3.1--3.3, supplies the unsquared bound for every unitarily
invariant norm and arbitrary sketch width. Its printed tail-dimension and
undefined-`Y` defects are not adopted here. HMT11 Theorem 9.1 separately supports
oversampling and the zero-tail case, but states only spectral/Frobenius bounds.

The full right basis has `n = k + q` coordinates; left null coordinates are zero.
Thus the tail includes the null singular directions even for wide matrices.
All shapes use the same norm family, with exact isometric coherence. Full row
rank of the sampled head is surjectivity of its matrix-vector map. The explicit
`k ≤ r` retains the printed oversampling condition; it is also implied by that
surjectivity. No rank or positive-leading-singular-value restriction is imposed.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

/-- Corrected equation (9): compatible orthonormal singular coordinates,
arbitrary oversampling, and one coherent unitarily invariant norm family. -/
def correctedLowRankApproximationStructuralBound : Prop :=
  ∀ (m k q r : ℕ) (N : ComplexMatrixUnitaryInvariantNormFamily)
    (A Ufull : Matrix (Fin m) (Fin (k + q)) ℝ)
    (sigma : Fin (k + q) → ℝ)
    (Vfull : Matrix (Fin (k + q)) (Fin (k + q)) ℝ)
    (Z : Fin (k + q) → Fin r → ℝ),
    k ≤ r →
    IsRealFullRightSVD A Ufull sigma Vfull →
    Function.Surjective
      (rectMatMulVec (rectMatMul (finiteTranspose (squareSVDHeadRight Vfull)) Z)) →
    N.realNorm (fun i j => A i j -
      rectMatMul (columnSketchMoorePenroseProjector A Z) A i j) ≤
      N.realNorm (squareSVDTailDiagonal sigma) +
        N.realNorm (rectMatMul
          (rectMatMul (squareSVDTailDiagonal sigma)
            (rectMatMul (finiteTranspose (squareSVDTailRight Vfull)) Z))
          (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse
            (rectMatMul (finiteTranspose (squareSVDHeadRight Vfull)) Z)))

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
