import ComputationalMathematics.Analysis.SingularValues.CourantFischer
import Mathlib.Analysis.InnerProductSpace.Symmetric
import Mathlib.LinearAlgebra.Matrix.Rank

/-!
# Rectangular real isometries

Equivalent Gram, range-projection, norm, and singular-value characterizations
of a rectangular real isometry.
-/

namespace NumStability

open scoped InnerProductSpace RealInnerProductSpace

noncomputable section

/-- A real square matrix is an orthogonal projection when its Euclidean linear
map is idempotent and its range is orthogonal to its kernel. -/
def IsRealOrthogonalProjectionMatrix {m : ℕ}
    (P : Matrix (Fin m) (Fin m) ℝ) : Prop :=
  IsIdempotentElem (Matrix.toEuclideanLin P) ∧
    LinearMap.range (Matrix.toEuclideanLin P) ⟂
      LinearMap.ker (Matrix.toEuclideanLin P)

/-- A rectangular real matrix preserves every Euclidean norm. -/
def IsRealMatrixIsometry {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) : Prop :=
  ∀ x : EuclideanSpace ℝ (Fin n),
    ‖Matrix.toEuclideanLin A x‖ = ‖x‖

/-- The ordinary right Gram identity is equivalent to preservation of every
Euclidean norm. -/
theorem transpose_mul_self_eq_one_iff_isRealMatrixIsometry {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    A.transpose * A = 1 ↔ IsRealMatrixIsometry A := by
  let T := Matrix.toEuclideanLin A
  constructor
  · intro hGram
    have hcomp : T.adjoint.comp T = LinearMap.id := by
      rw [show T.adjoint = Matrix.toEuclideanLin A.transpose by
        simpa [T] using
          (Matrix.toEuclideanLin_conjTranspose_eq_adjoint A).symm]
      rw [← Matrix.toLpLin_mul_same]
      rw [hGram, Matrix.toLpLin_one]
    exact (LinearMap.norm_map_iff_inner_map_map T).2 fun x y => by
      calc
        inner ℝ (T x) (T y) = inner ℝ x (T.adjoint (T y)) :=
          (LinearMap.adjoint_inner_right T x (T y)).symm
        _ = inner ℝ x y := by
          rw [← LinearMap.comp_apply, hcomp, LinearMap.id_apply]
  · intro hIso
    have hinner : ∀ x y,
        inner ℝ (T x) (T y) = inner ℝ x y :=
      (LinearMap.norm_map_iff_inner_map_map T).1 hIso
    have hcomp : T.adjoint.comp T = LinearMap.id := by
      apply LinearMap.ext
      intro x
      apply ext_inner_left ℝ
      intro y
      calc
        inner ℝ y (T.adjoint (T x)) = inner ℝ (T y) (T x) :=
          LinearMap.adjoint_inner_right T y (T x)
        _ = inner ℝ y x := hinner y x
    apply Matrix.toEuclideanLin.injective
    simpa only [Matrix.toLpLin_mul_same, Matrix.toLpLin_one,
      show Matrix.toEuclideanLin A.transpose = T.adjoint by
        simpa [T] using Matrix.toEuclideanLin_conjTranspose_eq_adjoint A] using hcomp

/-- The right Gram identity makes the left Gram matrix an orthogonal
projection having rank equal to the number of columns. -/
theorem transpose_mul_self_eq_one_implies_projection_rank {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (hGram : A.transpose * A = 1) :
    IsRealOrthogonalProjectionMatrix (A * A.transpose) ∧
      (A * A.transpose).rank = n := by
  let P : Matrix (Fin m) (Fin m) ℝ := A * A.transpose
  have hPmat : P * P = P := by
    dsimp [P]
    calc
      (A * A.transpose) * (A * A.transpose) =
          A * ((A.transpose * A) * A.transpose) := by
            simp only [Matrix.mul_assoc]
      _ = A * ((1 : Matrix (Fin n) (Fin n) ℝ) * A.transpose) := by rw [hGram]
      _ = A * A.transpose := by rw [Matrix.one_mul]
  have hPid : IsIdempotentElem (Matrix.toEuclideanLin P) := by
    rw [IsIdempotentElem, Module.End.mul_eq_comp,
      ← Matrix.toLpLin_mul_same, hPmat]
  have hPHerm : P.IsHermitian := by
    simp [P, Matrix.IsHermitian]
  have hPsymm : (Matrix.toEuclideanLin P).IsSymmetric :=
    Matrix.isHermitian_iff_isSymmetric.mp hPHerm
  refine ⟨⟨hPid,
    (LinearMap.IsIdempotentElem.isSymmetric_iff_isOrtho_range_ker hPid).mp hPsymm⟩, ?_⟩
  rw [Matrix.rank_self_mul_transpose]
  rw [← Matrix.rank_transpose_mul_self A, hGram, Matrix.rank_one]
  simp

/-- Conversely, if `A Aᵀ` is an orthogonal projection of full column rank,
then the columns of `A` are orthonormal. -/
theorem projection_rank_implies_transpose_mul_self_eq_one {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (hP : IsRealOrthogonalProjectionMatrix (A * A.transpose))
    (hPrank : (A * A.transpose).rank = n) :
    A.transpose * A = 1 := by
  let P : Matrix (Fin m) (Fin m) ℝ := A * A.transpose
  have hPid : IsIdempotentElem (Matrix.toEuclideanLin P) := hP.1
  have hPmat : P * P = P := by
    apply Matrix.toEuclideanLin.injective
    simpa only [Matrix.toLpLin_mul_same, Module.End.mul_eq_comp] using hPid
  have hPidPlain : IsIdempotentElem P.mulVecLin := by
    rw [IsIdempotentElem, Module.End.mul_eq_comp,
      ← Matrix.mulVecLin_mul, hPmat]
  have hArank : A.rank = n := by
    rw [← Matrix.rank_self_mul_transpose A]
    exact hPrank
  have hRangeLe : LinearMap.range P.mulVecLin ≤
      LinearMap.range A.mulVecLin := by
    rw [show P.mulVecLin = A.mulVecLin.comp A.transpose.mulVecLin by
      simp [P, Matrix.mulVecLin_mul]]
    exact LinearMap.range_comp_le_range _ _
  have hRangeFinrank : Module.finrank ℝ (LinearMap.range P.mulVecLin) =
      Module.finrank ℝ (LinearMap.range A.mulVecLin) := by
    change P.rank = A.rank
    simp [P, hPrank, hArank]
  have hRange : LinearMap.range P.mulVecLin =
      LinearMap.range A.mulVecLin :=
    Submodule.eq_of_le_of_finrank_eq hRangeLe hRangeFinrank
  have hKerFinrank : Module.finrank ℝ (LinearMap.ker A.mulVecLin) = 0 := by
    have hsum := LinearMap.finrank_range_add_finrank_ker A.mulVecLin
    rw [show Module.finrank ℝ (LinearMap.range A.mulVecLin) = n by exact hArank] at hsum
    have hdomain : Module.finrank ℝ (Fin n → ℝ) = n := by simp
    rw [hdomain] at hsum
    omega
  have hAinj : Function.Injective A.mulVec := by
    exact LinearMap.ker_eq_bot.mp
      (Submodule.finrank_eq_zero.mp hKerFinrank)
  apply Matrix.mulVec_injective
  funext x
  apply hAinj
  have hAxRange : A.mulVec x ∈ LinearMap.range P.mulVecLin := by
    rw [hRange]
    exact ⟨x, rfl⟩
  have hPfix : P.mulVec (A.mulVec x) = A.mulVec x :=
    (LinearMap.IsIdempotentElem.mem_range_iff hPidPlain).mp hAxRange
  rw [Matrix.one_mulVec]
  rw [← Matrix.mulVec_mulVec]
  rw [← Matrix.mulVec_mulVec] at hPfix
  simpa only [P, Matrix.mul_assoc] using hPfix

/-- The four characterizations in the rectangular-isometry exercise. -/
theorem realMatrix_isometry_characterizations {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    let gramIdentity : Prop := A.transpose * A = 1
    let rangeProjection : Prop :=
      IsRealOrthogonalProjectionMatrix (A * A.transpose) ∧
        (A * A.transpose).rank = n + 1
    let normIsometry : Prop := IsRealMatrixIsometry A
    let allSingularValuesOne : Prop :=
      ∀ i : Fin (n + 1), rectCourantFischerSingularValue A i = 1
    (gramIdentity ↔ rangeProjection) ∧
      (rangeProjection ↔ normIsometry) ∧
      (normIsometry ↔ allSingularValuesOne) := by
  dsimp only
  have hGramIso := transpose_mul_self_eq_one_iff_isRealMatrixIsometry A
  have hGramProj : (A.transpose * A = 1) ↔
      IsRealOrthogonalProjectionMatrix (A * A.transpose) ∧
        (A * A.transpose).rank = n + 1 := by
    constructor
    · exact transpose_mul_self_eq_one_implies_projection_rank A
    · intro h
      exact projection_rank_implies_transpose_mul_self_eq_one A h.1 h.2
  refine ⟨hGramProj, hGramProj.symm.trans hGramIso, ?_⟩
  constructor
  · intro hIso i
    have hBounds := rectCourantFischer_extremeSingularValues_areOptimalBounds A
    have hsmax : rectCourantFischerSingularValue A (0 : Fin (n + 1)) ≤ 1 :=
      hBounds.2.1 1 (by intro x; simp [hIso x])
    have hsmin : 1 ≤ rectCourantFischerSingularValue A (Fin.last n) :=
      hBounds.2.2 1 (by intro x; simp [hIso x])
    have hmaxi := rectCourantFischerSingularValue_antitone A (Fin.zero_le i)
    have himin := rectCourantFischerSingularValue_antitone A (Fin.le_last i)
    linarith
  · intro hAll x
    have hBounds :=
      (rectCourantFischer_extremeSingularValues_areOptimalBounds A).1 x
    rw [hAll (Fin.last n), hAll (0 : Fin (n + 1))] at hBounds
    exact le_antisymm (by simpa using hBounds.2) (by simpa using hBounds.1)

end

end NumStability
