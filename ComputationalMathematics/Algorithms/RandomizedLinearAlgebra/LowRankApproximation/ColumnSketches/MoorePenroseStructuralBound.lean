import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.StructuralBound
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.SharpProjector

/-! # Canonical Moore--Penrose structural bound

Both pseudoinverses are the existing arbitrary-rank compact-SVD construction.
No invertibility or column independence is required of the sketch itself.
-/
namespace NumStability

/-- The orthogonal projector onto the columns of a rectangular sketch. -/
noncomputable def columnSketchMoorePenroseProjector {m n r : ℕ}
    (A : Fin m → Fin n → ℝ) (Z : Fin n → Fin r → ℝ) : Fin m → Fin m → ℝ :=
  rectMatMul (rectMatMul A Z)
    (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse (rectMatMul A Z))

/-- Rectangular-pseudoinverse form of the structural sketch bound. -/
theorem columnSketch_moorePenrose_structuralBound
    {m n k q r : ℕ}
    (N : ComplexMatrixUnitaryInvariantNormFamily)
    (A : Fin m → Fin n → ℝ) (H : Fin m → Fin k → ℝ)
    (U : Fin m → Fin q → ℝ) (T : Fin q → Fin q → ℝ)
    (V : Fin n → Fin k → ℝ) (W : Fin n → Fin q → ℝ)
    (Z : Fin n → Fin r → ℝ)
    (hA : A = rectMatMul H (finiteTranspose V) +
      rectMatMul (rectMatMul U T) (finiteTranspose W))
    (hfull : Function.Surjective (rectMatMulVec (rectMatMul (finiteTranspose V) Z)))
    (hU : complexMatrixOp2 (realRectToCMatrix U) ≤ 1)
    (hV : complexMatrixOp2 (realRectToCMatrix (finiteTranspose V)) ≤ 1)
    (hW : complexMatrixOp2 (realRectToCMatrix (finiteTranspose W)) ≤ 1) :
    N.realNorm (A - rectMatMul (columnSketchMoorePenroseProjector A Z) A) ≤
      N.realNorm T + N.realNorm
        (rectMatMul (rectMatMul T (rectMatMul (finiteTranspose W) Z))
          (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse
            (rectMatMul (finiteTranspose V) Z))) := by
  let Y := rectMatMul A Z
  let Yplus := Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse Y
  have hMP := Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse_certificate Y
  have hfix : rectMatMul (columnSketchMoorePenroseProjector A Z) Y = Y :=
    hMP.reproduces_matrix
  have hidem : ∀ i j, preconditionRows
      (columnSketchMoorePenroseProjector A Z)
      (columnSketchMoorePenroseProjector A Z) i j =
        columnSketchMoorePenroseProjector A Z i j := by
    intro i j
    exact congrFun (congrFun
      (rectMoorePenrosePseudoinverse_range_idempotent Y Yplus hMP) i) j
  have hc : complexMatrixOp2
      (realRectToCMatrix (idMatrix m - columnSketchMoorePenroseProjector A Z)) ≤ 1 :=
    complexMatrixOp2_realRectToCMatrix_matSub_id_le_one_of_symmetric_idempotent
      (columnSketchMoorePenroseProjector A Z) hMP.range_projection_symmetric hidem
  exact columnSketch_structuralBound_of_rightInverse N A H U T V W Z _ _ hA
    (columnSketch_head_pseudoinverse_rightInverse V Z hfull) hfix hc hU hV hW

end NumStability
