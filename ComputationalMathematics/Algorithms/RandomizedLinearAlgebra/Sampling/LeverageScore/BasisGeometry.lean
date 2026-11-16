import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core
import Mathlib.LinearAlgebra.Matrix.Rank

/-! # Basis invariance and deterministic subspace geometry

These facts distinguish equality of column spaces from equality of projectors:
the latter is derived from orthonormality and the former. -/
namespace NumStability
open scoped BigOperators

/-- The matrix form of orthonormal columns. -/
theorem hasOrthonormalColumns_transpose_mul {m n : ℕ}
    (U : Matrix (Fin m) (Fin n) ℝ) (hU : HasOrthonormalColumns U) :
    U.transpose * U = 1 := by
  ext j k
  exact hU j k

/-- An orthonormal frame's projector fixes every vector in its column space. -/
theorem orthonormal_projector_fixes_range {m n : ℕ}
    (U : Matrix (Fin m) (Fin n) ℝ) (hU : HasOrthonormalColumns U)
    (x : Fin m → ℝ) (hx : x ∈ Set.range U.mulVec) :
    (U * U.transpose).mulVec x = x := by
  rcases hx with ⟨q, rfl⟩
  rw [Matrix.mulVec_mulVec, Matrix.mul_assoc,
    hasOrthonormalColumns_transpose_mul U hU, Matrix.mul_one]

/-- Equality of column spaces of orthonormal frames implies equality of their
orthogonal projectors. The frame widths need not be supplied as equal. -/
theorem orthonormal_projector_eq_of_range_eq {m n p : ℕ}
    (U : Matrix (Fin m) (Fin n) ℝ) (V : Matrix (Fin m) (Fin p) ℝ)
    (hU : HasOrthonormalColumns U) (hV : HasOrthonormalColumns V)
    (hspan : Set.range U.mulVec = Set.range V.mulVec) :
    U * U.transpose = V * V.transpose := by
  have hfixUV : (U * U.transpose) * V = V := by
    ext i j
    have hcol : (fun i => V i j) ∈ Set.range V.mulVec := by
      refine ⟨Pi.single j 1, ?_⟩
      rw [Matrix.mulVec_single_one]; rfl
    have hx := orthonormal_projector_fixes_range U hU _ (hspan.symm ▸ hcol)
    exact congrFun hx i
  have hfixVU : (V * V.transpose) * U = U := by
    ext i j
    have hcol : (fun i => U i j) ∈ Set.range U.mulVec := by
      refine ⟨Pi.single j 1, ?_⟩
      rw [Matrix.mulVec_single_one]; rfl
    have hx := orthonormal_projector_fixes_range V hV _ (hspan ▸ hcol)
    exact congrFun hx i
  have hprod : (U * U.transpose) * (V * V.transpose) = V * V.transpose := by
    rw [← Matrix.mul_assoc, hfixUV]
  have hprod' : (V * V.transpose) * (U * U.transpose) = U * U.transpose := by
    rw [← Matrix.mul_assoc, hfixVU]
  calc
    U * U.transpose = ((V * V.transpose) * (U * U.transpose)).transpose := by
      rw [hprod']; simp
    _ = (U * U.transpose) * (V * V.transpose) := by simp [Matrix.transpose_mul]
    _ = V * V.transpose := hprod

/-- Leverage scores and their normalized row probabilities depend only on the
subspace, for any two orthonormal frames spanning that subspace. -/
theorem leverageScore_and_probability_eq_of_range_eq {m n p : ℕ}
    (U : Matrix (Fin m) (Fin n) ℝ) (V : Matrix (Fin m) (Fin p) ℝ)
    (hU : HasOrthonormalColumns U) (hV : HasOrthonormalColumns V)
    (hspan : Set.range U.mulVec = Set.range V.mulVec) :
    (∀ i, leverageScore U i = leverageScore V i) ∧
      (∀ i, leverageScoreProb U i = leverageScoreProb V i) := by
  have hp := orthonormal_projector_eq_of_range_eq U V hU hV hspan
  have hscore : ∀ i, leverageScore U i = leverageScore V i := by
    intro i
    simpa [Matrix.mul_apply, leverageScore, rowNormSq, pow_two] using
      congrFun (congrFun hp i) i
  refine ⟨hscore, ?_⟩
  intro i
  have hden : rowSqNormProbDen U = rowSqNormProbDen V := by
    change (∑ i, rowNormSq U i) = ∑ i, rowNormSq V i
    exact Finset.sum_congr rfl (fun i _ => hscore i)
  change rowNormSq U i / rowSqNormProbDen U = rowNormSq V i / rowSqNormProbDen V
  rw [hden, show rowNormSq U i = rowNormSq V i from hscore i]

/-- An operator bound for the coordinate Gram defect preserves squared norms
of every vector in the frame's subspace. This is the deterministic consequence
of an embedding event; it does not assume or assert its sampling probability. -/
theorem subspace_geometry_of_gram_error {m n r : ℕ}
    (U : Matrix (Fin m) (Fin n) ℝ) (S : Matrix (Fin r) (Fin m) ℝ)
    (hU : HasOrthonormalColumns U) {ε : ℝ}
    (hgram : opNorm2Le (fun j k => rowSketchGram (S * U) j k - idMatrix n j k) ε)
    (y : Fin m → ℝ) (hy : y ∈ Set.range U.mulVec) :
    (1 - ε) * vecNorm2Sq y ≤ vecNorm2Sq (S.mulVec y) ∧
      vecNorm2Sq (S.mulVec y) ≤ (1 + ε) * vecNorm2Sq y := by
  rcases hy with ⟨q, rfl⟩
  have hnorm : vecNorm2Sq (U.mulVec q) = vecNorm2Sq q :=
    hasOrthonormalColumns_vecNorm2Sq_mul_vec_eq U hU q
  have hquad := abs_vecInnerProduct_matMulVec_le_of_opNorm2Le _ hgram q
  have hrepr : vecNorm2Sq (S.mulVec (U.mulVec q)) =
      vecNorm2Sq q + ∑ j, q j *
        matMulVec n (fun j k => rowSketchGram (S * U) j k - idMatrix n j k) q j := by
    rw [Matrix.mulVec_mulVec]
    exact (vecNorm2Sq_rowSketch_linearCombination_eq_quadratic_rowSketchGram
      (S * U) q).trans
        (vecNorm2Sq_add_quadraticForm_sub_id_eq_quadraticForm
          (rowSketchGram (S * U)) q).symm
  rw [hnorm, hrepr]
  constructor <;> nlinarith [(abs_le.mp hquad).1, (abs_le.mp hquad).2]

/-- If the Gram defect is strictly less than one, the sketch is injective on
its entire subspace. -/
theorem subspace_injective_of_gram_error {m n r : ℕ}
    (U : Matrix (Fin m) (Fin n) ℝ) (S : Matrix (Fin r) (Fin m) ℝ)
    (hU : HasOrthonormalColumns U) {ε : ℝ} (hε : ε < 1)
    (hgram : opNorm2Le (fun j k => rowSketchGram (S * U) j k - idMatrix n j k) ε) :
    Set.InjOn S.mulVec (Set.range U.mulVec) := by
  rintro y ⟨q, rfl⟩ z ⟨v, rfl⟩ heq
  have hy : U.mulVec (q - v) ∈ Set.range U.mulVec := ⟨q - v, rfl⟩
  have hzero : S.mulVec (U.mulVec (q - v)) = 0 := by
    rw [Matrix.mulVec_sub, Matrix.mulVec_sub, heq, sub_self]
  have hbound := (subspace_geometry_of_gram_error U S hU hgram _ hy).1
  rw [hzero] at hbound
  have hn : vecNorm2Sq (U.mulVec (q - v)) = 0 := by
    have hn0 := vecNorm2Sq_nonneg (U.mulVec (q - v))
    have hz : vecNorm2Sq (0 : Fin r → ℝ) = 0 := by simp [vecNorm2Sq]
    rw [hz] at hbound
    nlinarith
  have hn' : vecNorm2 (U.mulVec (q - v)) = 0 := by
    rw [vecNorm2, hn, Real.sqrt_zero]
  have hv := (vecNorm2_eq_zero_iff _).mp hn'
  ext i
  have hi := hv i
  rw [Matrix.mulVec_sub, Pi.sub_apply] at hi
  exact sub_eq_zero.mp hi

/-- A linear sketch injective on a matrix's column space preserves its rank. -/
theorem matrix_rank_mul_eq_of_injective_on_range {m n r : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (S : Matrix (Fin r) (Fin m) ℝ)
    (hS : Set.InjOn S.mulVec (Set.range A.mulVec)) :
    (S * A).rank = A.rank := by
  let W := LinearMap.range A.mulVecLin
  let L : W →ₗ[ℝ] (Fin r → ℝ) := S.mulVecLin.comp W.subtype
  have hL : Function.Injective L := by
    intro x y hxy
    apply Subtype.ext
    exact hS x.property y.property hxy
  have hrange : LinearMap.range L = LinearMap.range (S * A).mulVecLin := by
    ext x
    constructor
    · rintro ⟨⟨y, hy⟩, hx⟩
      rcases hy with ⟨q, rfl⟩
      exact ⟨q, by simpa [L, Matrix.mulVec_mulVec] using hx⟩
    · rintro ⟨q, hq⟩
      refine ⟨⟨A.mulVec q, ⟨q, rfl⟩⟩, ?_⟩
      simpa [L, Matrix.mulVec_mulVec] using hq
  change Module.finrank ℝ (LinearMap.range (S * A).mulVecLin) =
    Module.finrank ℝ W
  rw [← hrange]
  exact LinearMap.finrank_range_of_inj hL

/-- A Gram embedding of an orthonormal basis preserves the rank of every
matrix with the same column space, including rank-deficient input matrices. -/
theorem matrix_rank_preserved_of_gram_error {m n d r : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (U : Matrix (Fin m) (Fin d) ℝ)
    (S : Matrix (Fin r) (Fin m) ℝ) (hU : HasOrthonormalColumns U)
    (hspan : Set.range A.mulVec = Set.range U.mulVec)
    {ε : ℝ} (hε : ε < 1)
    (hgram : opNorm2Le (fun j k => rowSketchGram (S * U) j k - idMatrix d j k) ε) :
    (S * A).rank = A.rank := by
  apply matrix_rank_mul_eq_of_injective_on_range
  rw [hspan]
  exact subspace_injective_of_gram_error U S hU hε hgram

/-- Reversing a matrix difference preserves an operator norm bound. -/
theorem opNorm2Le_sub_rev {n : ℕ} (A B : Matrix (Fin n) (Fin n) ℝ)
    {ε : ℝ} (h : opNorm2Le (fun i j => A i j - B i j) ε) :
    opNorm2Le (fun i j => B i j - A i j) ε := by
  intro x
  have hneg : matMulVec n (fun i j => B i j - A i j) x =
      fun i => -(matMulVec n (fun i j => A i j - B i j) x i) := by
    ext i
    simp only [matMulVec, sub_mul, Finset.sum_sub_distrib]
    ring
  rw [hneg, vecNorm2_neg]
  exact h x

end NumStability
