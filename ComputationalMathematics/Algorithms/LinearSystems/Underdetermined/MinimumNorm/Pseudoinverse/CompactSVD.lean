import ComputationalMathematics.Analysis.SingularValues.CompactSVD
import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.UnderdeterminedSpec
import ComputationalMathematics.Analysis.MatrixAlgebra

/-!
# Moore--Penrose inverses from compact singular-value decompositions

The existing reciprocal-diagonal construction and four-equation certificate
live below source correspondence. The canonical arbitrary-rank instance uses
the existing compact SVD, including rank zero. Historical public declaration
names are retained for supported source imports and callers.
-/

namespace NumStability

open scoped BigOperators

/-- The reciprocal diagonal appearing in Problem 20.3. -/
noncomputable def higham20Problem20_3ReciprocalDiagonal {r : Nat}
    (sigma : Fin r -> Real) : Fin r -> Fin r -> Real :=
  diagMatrix (fun k => (sigma k)⁻¹)
/-- The compact-SVD Moore--Penrose candidate
`V_r diag(sigma⁻¹) U_r^T`. -/
noncomputable def higham20Problem20_3SVDPseudoinverse {m n r : Nat}
    (U : Fin m -> Fin r -> Real) (sigma : Fin r -> Real)
    (V : Fin n -> Fin r -> Real) : Fin n -> Fin m -> Real :=
  rectMatMul
    (rectMatMul V (higham20Problem20_3ReciprocalDiagonal sigma))
    (finiteTranspose U)
private theorem higham20_rectMatMul_cancel_middle
    {a p q b : Nat}
    (X : Fin a -> Fin p -> Real)
    (L : Fin p -> Fin q -> Real) (R : Fin q -> Fin p -> Real)
    (Y : Fin p -> Fin b -> Real)
    (hLR : rectMatMul L R = idMatrix p) :
    rectMatMul (rectMatMul X L) (rectMatMul R Y) =
      rectMatMul X Y := by
  calc
    rectMatMul (rectMatMul X L) (rectMatMul R Y) =
        rectMatMul X (rectMatMul L (rectMatMul R Y)) :=
          rectMatMul_assoc X L (rectMatMul R Y)
    _ = rectMatMul X (rectMatMul (rectMatMul L R) Y) := by
          rw [rectMatMul_assoc L R Y]
    _ = rectMatMul X (rectMatMul (idMatrix p) Y) := by rw [hLR]
    _ = rectMatMul X Y := by rw [rectMatMul_id_left]
private theorem higham20_problem20_3_reciprocalDiagonal_left_inverse
    {r : Nat} (sigma : Fin r -> Real)
    (hsigma : forall k : Fin r, sigma k ≠ 0) :
    rectMatMul (higham20Problem20_3ReciprocalDiagonal sigma)
        (diagMatrix sigma) = idMatrix r := by
  simpa [higham20Problem20_3ReciprocalDiagonal, rectMatMul, diagMatrix,
    finiteMatMul, finiteDiagonal, idMatrix, finiteIdMatrix] using
    (finiteMatMul_finiteDiagonal_inv_self hsigma)
private theorem higham20_problem20_3_reciprocalDiagonal_right_inverse
    {r : Nat} (sigma : Fin r -> Real)
    (hsigma : forall k : Fin r, sigma k ≠ 0) :
    rectMatMul (diagMatrix sigma)
        (higham20Problem20_3ReciprocalDiagonal sigma) = idMatrix r := by
  simpa [higham20Problem20_3ReciprocalDiagonal, rectMatMul, diagMatrix,
    finiteMatMul, finiteDiagonal, idMatrix, finiteIdMatrix] using
    (finiteMatMul_finiteDiagonal_self_inv hsigma)
/-- Higham, *Accuracy and Stability of Numerical Algorithms*, 2nd ed.,
Chapter 20, Problem 20.3 (p. 405): for an arbitrary-rank compact SVD
`A = U_r diag(sigma) V_r^T`, replacing the nonzero singular values by their
reciprocals gives a matrix satisfying all four Moore--Penrose equations. -/
theorem higham20_problem20_3_compactSVD_moorePenrose
    {m n r : Nat} (A : Fin m -> Fin n -> Real)
    (U : Fin m -> Fin r -> Real) (sigma : Fin r -> Real)
    (V : Fin n -> Fin r -> Real)
    (hSVD : Higham20CompactRealSVD A U sigma V) :
    RectMoorePenrosePseudoinverse m n A
      (higham20Problem20_3SVDPseudoinverse U sigma V) := by
  let D : Fin r -> Fin r -> Real := diagMatrix sigma
  let Dinv : Fin r -> Fin r -> Real :=
    higham20Problem20_3ReciprocalDiagonal sigma
  let Aplus : Fin n -> Fin m -> Real :=
    higham20Problem20_3SVDPseudoinverse U sigma V
  have hsigma : forall k : Fin r, sigma k ≠ 0 :=
    fun k => ne_of_gt (hSVD.singularValue_pos k)
  have hDinvD : rectMatMul Dinv D = idMatrix r := by
    simpa [D, Dinv] using
      higham20_problem20_3_reciprocalDiagonal_left_inverse sigma hsigma
  have hDDinv : rectMatMul D Dinv = idMatrix r := by
    simpa [D, Dinv] using
      higham20_problem20_3_reciprocalDiagonal_right_inverse sigma hsigma
  have hA : rectMatMul (rectMatMul U D) (finiteTranspose V) = A := by
    simpa [D] using hSVD.factorization
  have hAplus :
      rectMatMul (rectMatMul V Dinv) (finiteTranspose U) = Aplus := by
    rfl
  have hAAplus :
      rectMatMul A Aplus = rectMatMul U (finiteTranspose U) := by
    rw [← hA, ← hAplus]
    calc
      rectMatMul
          (rectMatMul (rectMatMul U D) (finiteTranspose V))
          (rectMatMul (rectMatMul V Dinv) (finiteTranspose U)) =
          rectMatMul (rectMatMul U D)
            (rectMatMul Dinv (finiteTranspose U)) := by
              rw [rectMatMul_assoc V Dinv (finiteTranspose U)]
              exact higham20_rectMatMul_cancel_middle
                (rectMatMul U D) (finiteTranspose V) V
                (rectMatMul Dinv (finiteTranspose U))
                hSVD.right_columns_orthonormal
      _ = rectMatMul U (finiteTranspose U) := by
            exact higham20_rectMatMul_cancel_middle U D Dinv
              (finiteTranspose U) hDDinv
  have hAplusA :
      rectMatMul Aplus A = rectMatMul V (finiteTranspose V) := by
    rw [← hA, ← hAplus]
    calc
      rectMatMul
          (rectMatMul (rectMatMul V Dinv) (finiteTranspose U))
          (rectMatMul (rectMatMul U D) (finiteTranspose V)) =
          rectMatMul (rectMatMul V Dinv)
            (rectMatMul D (finiteTranspose V)) := by
              rw [rectMatMul_assoc U D (finiteTranspose V)]
              exact higham20_rectMatMul_cancel_middle
                (rectMatMul V Dinv) (finiteTranspose U) U
                (rectMatMul D (finiteTranspose V))
                hSVD.left_columns_orthonormal
      _ = rectMatMul V (finiteTranspose V) := by
            exact higham20_rectMatMul_cancel_middle V Dinv D
              (finiteTranspose V) hDinvD
  constructor
  · rw [hAAplus, ← hA]
    calc
      rectMatMul (rectMatMul U (finiteTranspose U))
          (rectMatMul (rectMatMul U D) (finiteTranspose V)) =
          rectMatMul U (rectMatMul D (finiteTranspose V)) := by
            rw [rectMatMul_assoc U D (finiteTranspose V)]
            exact higham20_rectMatMul_cancel_middle U (finiteTranspose U) U
              (rectMatMul D (finiteTranspose V))
              hSVD.left_columns_orthonormal
      _ = rectMatMul (rectMatMul U D) (finiteTranspose V) := by
            rw [rectMatMul_assoc]
  · change rectMatMul (rectMatMul Aplus A) Aplus = Aplus
    rw [hAplusA, ← hAplus]
    calc
      rectMatMul (rectMatMul V (finiteTranspose V))
          (rectMatMul (rectMatMul V Dinv) (finiteTranspose U)) =
          rectMatMul V (rectMatMul Dinv (finiteTranspose U)) := by
            rw [rectMatMul_assoc V Dinv (finiteTranspose U)]
            exact higham20_rectMatMul_cancel_middle V (finiteTranspose V) V
              (rectMatMul Dinv (finiteTranspose U))
              hSVD.right_columns_orthonormal
      _ = rectMatMul (rectMatMul V Dinv) (finiteTranspose U) := by
            rw [rectMatMul_assoc]
  · rw [hAAplus]
    exact rectMatMul_self_transpose_symmetric U
  · rw [hAplusA]
    exact rectMatMul_self_transpose_symmetric V

end NumStability

namespace NumStability.Ch14Ext

open NumStability

/-! ## Canonical arbitrary-rank Moore--Penrose target -/

/-- Canonical Moore--Penrose inverse obtained from the exact arbitrary-rank
right-Gram compact SVD. -/
noncomputable def ch14ext_rectMoorePenrosePseudoinverse {m n : ℕ}
    (A : Fin m → Fin n → ℝ) : Fin n → Fin m → ℝ :=
  higham20Problem20_3SVDPseudoinverse
    (ch14ext_compactSVDLeft A)
    (ch14ext_compactSVDSingularValues A)
    (ch14ext_compactSVDRight A)

theorem ch14ext_rectMoorePenrosePseudoinverse_certificate {m n : ℕ}
    (A : Fin m → Fin n → ℝ) :
    RectMoorePenrosePseudoinverse m n A
      (ch14ext_rectMoorePenrosePseudoinverse A) := by
  exact higham20_problem20_3_compactSVD_moorePenrose A
    (ch14ext_compactSVDLeft A)
    (ch14ext_compactSVDSingularValues A)
    (ch14ext_compactSVDRight A)
    (ch14ext_compactSVD_certificate A)

end NumStability.Ch14Ext
