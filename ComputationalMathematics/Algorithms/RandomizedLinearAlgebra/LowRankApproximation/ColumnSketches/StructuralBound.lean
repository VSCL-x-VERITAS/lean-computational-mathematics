import ComputationalMathematics.Analysis.MatrixNorms.CoherentFamily
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.CompactSVD

/-! # Structural residual bound for rectangular column sketches

The interpolation argument is independent of a singular-value construction. It
needs a head/tail factorization, contractive outer factors, and a rectangular
right inverse of the sampled head coordinates. In particular, the sketch may
have more columns than the head dimension.
-/
namespace NumStability

private theorem rectMatMul_add_left_pi {m n p : ℕ}
    (A B : Fin m → Fin n → ℝ) (C : Fin n → Fin p → ℝ) :
    rectMatMul (A + B) C = rectMatMul A C + rectMatMul B C := by
  simpa only [Pi.add_apply] using rectMatMul_add_left A B C

private theorem rectMatMul_sub_left_pi {m n p : ℕ}
    (A B : Fin m → Fin n → ℝ) (C : Fin n → Fin p → ℝ) :
    rectMatMul (A - B) C = rectMatMul A C - rectMatMul B C := by
  simpa only [Pi.sub_apply] using rectMatMul_sub_left A B C

private theorem rectMatMul_sub_right_pi {m n p : ℕ}
    (A : Fin m → Fin n → ℝ) (B C : Fin n → Fin p → ℝ) :
    rectMatMul A (B - C) = rectMatMul A B - rectMatMul A C := by
  simpa only [Pi.sub_apply] using rectMatMul_sub_right A B C

/-- Algebraic interpolation error for a rectangular sketch. -/
theorem columnSketch_interpolation_error
    {m n k q r : ℕ}
    (A : Fin m → Fin n → ℝ) (H : Fin m → Fin k → ℝ)
    (U : Fin m → Fin q → ℝ) (T : Fin q → Fin q → ℝ)
    (V : Fin n → Fin k → ℝ) (W : Fin n → Fin q → ℝ)
    (Z : Fin n → Fin r → ℝ) (D : Fin r → Fin k → ℝ)
    (hA : A = rectMatMul H (finiteTranspose V) +
      rectMatMul (rectMatMul U T) (finiteTranspose W))
    (hD : rectMatMul (rectMatMul (finiteTranspose V) Z) D = idMatrix k) :
    A - rectMatMul (rectMatMul (rectMatMul A Z) D) (finiteTranspose V) =
      rectMatMul (rectMatMul U T) (finiteTranspose W) -
        rectMatMul (rectMatMul U
          (rectMatMul (rectMatMul T (rectMatMul (finiteTranspose W) Z)) D))
          (finiteTranspose V) := by
  have hhead : rectMatMul
      (rectMatMul (rectMatMul (rectMatMul H (finiteTranspose V)) Z) D)
      (finiteTranspose V) = rectMatMul H (finiteTranspose V) := by
    calc
      _ = rectMatMul (rectMatMul H
          (rectMatMul (rectMatMul (finiteTranspose V) Z) D)) (finiteTranspose V) := by
            simp only [rectMatMul_assoc]
      _ = rectMatMul H (finiteTranspose V) := by rw [hD, rectMatMul_id_right]
  have htail : rectMatMul
      (rectMatMul (rectMatMul (rectMatMul (rectMatMul U T) (finiteTranspose W)) Z) D)
      (finiteTranspose V) =
      rectMatMul (rectMatMul U
        (rectMatMul (rectMatMul T (rectMatMul (finiteTranspose W) Z)) D))
        (finiteTranspose V) := by
    simp only [rectMatMul_assoc]
  have hinterp : rectMatMul (rectMatMul (rectMatMul A Z) D) (finiteTranspose V) =
      rectMatMul H (finiteTranspose V) + rectMatMul (rectMatMul U
        (rectMatMul (rectMatMul T (rectMatMul (finiteTranspose W) Z)) D))
        (finiteTranspose V) := by
    rw [hA]
    simp only [rectMatMul_add_left_pi, hhead, htail]
  rw [hinterp, hA]
  ext i j
  simp only [Pi.add_apply, Pi.sub_apply]
  ring

/-- The structural column-sketch bound in every dimension-coherent unitarily
invariant norm family. The only inverse required is a rectangular right inverse
of the sampled head coordinates; the sketch width `r` is independent of `k`. -/
theorem columnSketch_structuralBound_of_rightInverse
    {m n k q r : ℕ}
    (N : ComplexMatrixUnitaryInvariantNormFamily)
    (A : Fin m → Fin n → ℝ) (H : Fin m → Fin k → ℝ)
    (U : Fin m → Fin q → ℝ) (T : Fin q → Fin q → ℝ)
    (V : Fin n → Fin k → ℝ) (W : Fin n → Fin q → ℝ)
    (Z : Fin n → Fin r → ℝ) (D : Fin r → Fin k → ℝ)
    (P : Fin m → Fin m → ℝ)
    (hA : A = rectMatMul H (finiteTranspose V) +
      rectMatMul (rectMatMul U T) (finiteTranspose W))
    (hD : rectMatMul (rectMatMul (finiteTranspose V) Z) D = idMatrix k)
    (hP : rectMatMul P (rectMatMul A Z) = rectMatMul A Z)
    (hPc : complexMatrixOp2 (realRectToCMatrix (idMatrix m - P)) ≤ 1)
    (hU : complexMatrixOp2 (realRectToCMatrix U) ≤ 1)
    (hV : complexMatrixOp2 (realRectToCMatrix (finiteTranspose V)) ≤ 1)
    (hW : complexMatrixOp2 (realRectToCMatrix (finiteTranspose W)) ≤ 1) :
    N.realNorm (A - rectMatMul P A) ≤ N.realNorm T +
      N.realNorm (rectMatMul (rectMatMul T (rectMatMul (finiteTranspose W) Z)) D) := by
  let C := rectMatMul (rectMatMul (rectMatMul A Z) D) (finiteTranspose V)
  let E := rectMatMul (rectMatMul T (rectMatMul (finiteTranspose W) Z)) D
  have hPC : rectMatMul P C = C := by
    dsimp [C]
    rw [← rectMatMul_assoc P (rectMatMul (rectMatMul A Z) D),
      ← rectMatMul_assoc P (rectMatMul A Z), hP]
  have hres : A - rectMatMul P A = rectMatMul (idMatrix m - P) (A - C) := by
    rw [rectMatMul_sub_left_pi, rectMatMul_id_left, rectMatMul_sub_right_pi, hPC]
    ext i j
    simp only [Pi.sub_apply]
    ring
  have herr : A - C = rectMatMul (rectMatMul U T) (finiteTranspose W) -
      rectMatMul (rectMatMul U E) (finiteTranspose V) :=
    columnSketch_interpolation_error A H U T V W Z D hA hD
  calc
    N.realNorm (A - rectMatMul P A)
        ≤ N.realNorm (A - C) := by
          rw [hres]
          exact N.realNorm_mul_left_contraction _ _ hPc
    _ ≤ N.realNorm (rectMatMul (rectMatMul U T) (finiteTranspose W)) +
          N.realNorm (rectMatMul (rectMatMul U E) (finiteTranspose V)) := by
          rw [herr]
          exact N.realNorm_sub_le _ _
    _ ≤ N.realNorm T + N.realNorm E := by
          apply add_le_add
          · exact (N.realNorm_mul_right_contraction _ _ hW).trans
              (N.realNorm_mul_left_contraction _ _ hU)
          · exact (N.realNorm_mul_right_contraction _ _ hV).trans
              (N.realNorm_mul_left_contraction _ _ hU)

/-- Surjectivity is the full-row-rank condition; it makes the canonical
Moore--Penrose inverse a right inverse, including the zero-row case. -/
theorem rectMoorePenrosePseudoinverse_rightInverse_of_surjective
    {k r : ℕ} (B : Fin k → Fin r → ℝ) (D : Fin r → Fin k → ℝ)
    (hMP : RectMoorePenrosePseudoinverse k r B D)
    (hB : Function.Surjective (rectMatMulVec B)) :
    rectMatMul B D = idMatrix k := by
  classical
  have hfix (y : Fin k → ℝ) : rectMatMulVec (rectMatMul B D) y = y := by
    obtain ⟨x, hx⟩ := hB y
    rw [← hx, ← rectMatMulVec_rectMatMul, hMP.reproduces_matrix]
  ext i j
  have hij := congrFun (hfix (fun t => if t = j then 1 else 0)) i
  simpa [rectMatMulVec, idMatrix] using hij

/-- The Moore--Penrose range projector is idempotent without a rank
assumption on the sketched matrix. -/
theorem rectMoorePenrosePseudoinverse_range_idempotent
    {m r : ℕ} (Y : Fin m → Fin r → ℝ) (D : Fin r → Fin m → ℝ)
    (hMP : RectMoorePenrosePseudoinverse m r Y D) :
    rectMatMul (rectMatMul Y D) (rectMatMul Y D) = rectMatMul Y D := by
  rw [← rectMatMul_assoc (rectMatMul Y D) Y D, hMP.reproduces_matrix]

/-- Canonical rectangular head pseudoinverse satisfies the interpolation
identity whenever the sampled head has full row rank. -/
theorem columnSketch_head_pseudoinverse_rightInverse
    {n k r : ℕ} (V : Fin n → Fin k → ℝ) (Z : Fin n → Fin r → ℝ)
    (hfull : Function.Surjective (rectMatMulVec (rectMatMul (finiteTranspose V) Z))) :
    rectMatMul (rectMatMul (finiteTranspose V) Z)
      (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse
        (rectMatMul (finiteTranspose V) Z)) = idMatrix k :=
  rectMoorePenrosePseudoinverse_rightInverse_of_surjective _ _
    (Ch14Ext.ch14ext_rectMoorePenrosePseudoinverse_certificate _) hfull

end NumStability
