import ComputationalMathematics.Analysis.MatrixNorms.FrobeniusCoherentFamily
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.MoorePenroseStructuralBound
import ComputationalMathematics.Analysis.SingularValues.FullRightSVD

/-! # Drineas--Mahoney (2016), equation (9)

The top `k` and bottom `q` ordered right singular coordinates split all `k+q`
columns. Left singular coordinates are zero on null singular directions, so the
construction also covers wide, rank-deficient, and zero matrices. The sketch
width is arbitrary and the sampled head coordinates must have full row rank.
-/
namespace NumStability

/-- Equation (9) for any supplied ordered SVD, with zero left coordinates on
null singular directions. No restriction to a selected singular basis, sketch
width equal to `k`, or positive singular head is imposed. -/
theorem randNLA2016_equation09_structuralBound_of_svd
    {m k q r : ℕ} (N : ComplexMatrixUnitaryInvariantNormFamily)
    (A Ufull : Matrix (Fin m) (Fin (k + q)) ℝ)
    (sigma : Fin (k + q) → ℝ)
    (Vfull : Matrix (Fin (k + q)) (Fin (k + q)) ℝ)
    (hSVD : IsRealFullRightSVD A Ufull sigma Vfull)
    (Z : Fin (k + q) → Fin r → ℝ)
    (hfull : Function.Surjective
      (rectMatMulVec (rectMatMul (finiteTranspose (squareSVDHeadRight Vfull)) Z))) :
    N.realNorm (fun i j => A i j -
      rectMatMul (columnSketchMoorePenroseProjector A Z) A i j) ≤
      N.realNorm (squareSVDTailDiagonal sigma) +
        N.realNorm (rectMatMul
          (rectMatMul (squareSVDTailDiagonal sigma)
            (rectMatMul (finiteTranspose (squareSVDTailRight Vfull)) Z))
          (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse
            (rectMatMul (finiteTranspose (squareSVDHeadRight Vfull)) Z))) := by
  let H : Fin m → Fin k → ℝ := fun i a =>
    Ufull i (Fin.castAdd q a) * sigma (Fin.castAdd q a)
  let U : Fin m → Fin q → ℝ := fun i a => Ufull i (Fin.natAdd k a)
  have hdecomp : A = rectMatMul H (finiteTranspose (squareSVDHeadRight Vfull)) +
      rectMatMul (rectMatMul U (squareSVDTailDiagonal sigma))
        (finiteTranspose (squareSVDTailRight Vfull)) := by
    classical
    ext i j
    simpa [rectMatMul, H, U, finiteTranspose, squareSVDHeadRight,
      squareSVDTailRight, squareSVDTailDiagonal] using
      (hSVD.representation i j).trans (Fin.sum_univ_add _)
  have hU : complexMatrixOp2 (realRectToCMatrix U) ≤ 1 :=
    complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le U (by norm_num)
      (hSVD.left_subfamily_contraction (Fin.natAddEmb k))
  have hV : complexMatrixOp2
      (realRectToCMatrix (finiteTranspose (squareSVDHeadRight Vfull))) ≤ 1 := by
    rw [complexMatrixOp2_realRectToCMatrix_finiteTranspose_eq]
    exact complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le _ (by norm_num)
      (hSVD.right_subfamily_contraction (Fin.castAddEmb q))
  have hW : complexMatrixOp2
      (realRectToCMatrix (finiteTranspose (squareSVDTailRight Vfull))) ≤ 1 := by
    rw [complexMatrixOp2_realRectToCMatrix_finiteTranspose_eq]
    exact complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le _ (by norm_num)
      (hSVD.right_subfamily_contraction (Fin.natAddEmb k))
  exact columnSketch_moorePenrose_structuralBound N A H U
    (squareSVDTailDiagonal sigma) (squareSVDHeadRight Vfull)
    (squareSVDTailRight Vfull) Z hdecomp hfull hU hV hW

noncomputable def randNLAEquation09HeadRight {m k q : ℕ}
    (A : Matrix (Fin m) (Fin (k + q)) ℝ) : Fin (k + q) → Fin k → ℝ :=
  fun i a => realSVDRightCoordinates A i (Fin.castAdd q a)

noncomputable def randNLAEquation09TailRight {m k q : ℕ}
    (A : Matrix (Fin m) (Fin (k + q)) ℝ) : Fin (k + q) → Fin q → ℝ :=
  fun i a => realSVDRightCoordinates A i (Fin.natAdd k a)

noncomputable def randNLAEquation09TailSigma {m k q : ℕ}
    (A : Matrix (Fin m) (Fin (k + q)) ℝ) : Fin q → Fin q → ℝ :=
  fun a b => if a = b then rectSingularValue A (Fin.natAdd k a) else 0

/-- Equation (9), with canonical ordered singular coordinates and arbitrary
rectangular sketch width. `Function.Surjective` is full row rank of `V_kᵀ Z`.
All norms are evaluations of the same dimension-coherent unitarily invariant
family, and both projectors/inverses use the existing Moore--Penrose object. -/
theorem randNLA2016_equation09_structuralBound
    {m k q r : ℕ} (N : ComplexMatrixUnitaryInvariantNormFamily)
    (A : Matrix (Fin m) (Fin (k + q)) ℝ)
    (Z : Fin (k + q) → Fin r → ℝ)
    (hfull : Function.Surjective
      (rectMatMulVec (rectMatMul (finiteTranspose (randNLAEquation09HeadRight A)) Z))) :
    N.realNorm (fun i j => A i j -
      rectMatMul (columnSketchMoorePenroseProjector A Z) A i j) ≤
      N.realNorm (randNLAEquation09TailSigma A) +
        N.realNorm (rectMatMul
          (rectMatMul (randNLAEquation09TailSigma A)
            (rectMatMul (finiteTranspose (randNLAEquation09TailRight A)) Z))
          (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse
            (rectMatMul (finiteTranspose (randNLAEquation09HeadRight A)) Z))) := by
  let H : Fin m → Fin k → ℝ := fun i a =>
    realSVDLeftCoordinates A i (Fin.castAdd q a) * rectSingularValue A (Fin.castAdd q a)
  let U : Fin m → Fin q → ℝ := fun i a => realSVDLeftCoordinates A i (Fin.natAdd k a)
  have hdecomp : A = rectMatMul H (finiteTranspose (randNLAEquation09HeadRight A)) +
      rectMatMul (rectMatMul U (randNLAEquation09TailSigma A))
        (finiteTranspose (randNLAEquation09TailRight A)) := by
    classical
    ext i j
    simpa [rectMatMul, H, U, finiteTranspose,
      randNLAEquation09HeadRight, randNLAEquation09TailRight,
      randNLAEquation09TailSigma] using realSVDCoordinates_head_tail A i j
  have hU : complexMatrixOp2 (realRectToCMatrix U) ≤ 1 :=
    complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le U (by norm_num)
      (realSVDLeftCoordinates_subfamily_contraction A (Fin.natAddEmb k))
  have hV : complexMatrixOp2
      (realRectToCMatrix (finiteTranspose (randNLAEquation09HeadRight A))) ≤ 1 := by
    rw [complexMatrixOp2_realRectToCMatrix_finiteTranspose_eq]
    exact complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le _ (by norm_num)
      (realSVDRightCoordinates_subfamily_contraction A (Fin.castAddEmb q))
  have hW : complexMatrixOp2
      (realRectToCMatrix (finiteTranspose (randNLAEquation09TailRight A))) ≤ 1 := by
    rw [complexMatrixOp2_realRectToCMatrix_finiteTranspose_eq]
    exact complexMatrixOp2_realRectToCMatrix_le_of_rectOpNorm2Le _ (by norm_num)
      (realSVDRightCoordinates_subfamily_contraction A (Fin.natAddEmb k))
  exact columnSketch_moorePenrose_structuralBound N A H U
    (randNLAEquation09TailSigma A) (randNLAEquation09HeadRight A)
    (randNLAEquation09TailRight A) Z hdecomp hfull hU hV hW

end NumStability
