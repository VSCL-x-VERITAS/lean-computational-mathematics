import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-! # Exact Gram embedding criterion

Spectral control of a Gram residual is equivalent to the simultaneous squared
Euclidean norm criterion, including zero-dimensional coefficient spaces.
-/
namespace NumStability
open scoped BigOperators RealInnerProductSpace

theorem opNorm2_eq_realMatrixOperatorNorm {n : ℕ}
    (M : Matrix (Fin n) (Fin n) ℝ) : opNorm2 M = realMatrixOperatorNorm M := by
  unfold opNorm2 realMatrixOperatorNorm realMatrixContinuousLinearMap
  rw [Matrix.l2_opNorm_def]
  rfl

/-- Symmetric spectral bounds are exactly all-vector quadratic bounds. -/
theorem symmetric_opNorm2_le_iff_quadratic {n : ℕ}
    (M : Matrix (Fin n) (Fin n) ℝ) (hM : M.IsHermitian)
    {ε : ℝ} (hε : 0 ≤ ε) :
    opNorm2 M ≤ ε ↔
      ∀ x : Fin n → ℝ,
        |∑ i, x i * matMulVec n M x i| ≤ ε * vecNorm2Sq x := by
  constructor
  · intro h x
    exact (abs_vecInnerProduct_matMulVec_le_of_opNorm2Le M (by
      intro x
      exact (opNorm2Le_opNorm2 M x).trans
        (mul_le_mul_of_nonneg_right h (vecNorm2_nonneg x))) x)
  · intro h
    by_cases hn : n = 0
    · subst n
      apply opNorm2_le_of_opNorm2Le M hε
      intro x
      simp [vecNorm2, vecNorm2Sq]
    · have hnpos : 0 < n := Nat.pos_of_ne_zero hn
      obtain ⟨_, x, hx, hattain, _⟩ :=
        symmetricRealMatrixOperatorNorm_quadratic_characterization hnpos M hM
      rw [opNorm2_eq_realMatrixOperatorNorm, ← hattain]
      have hq : realMatrixQuadraticForm M x =
          ∑ i, x i * matMulVec n M (WithLp.ofLp x) i := by
        simp [realMatrixQuadraticForm, Matrix.toLpLin_apply, PiLp.inner_apply,
          real_inner_eq_re_inner, RCLike.inner_apply, Matrix.mulVec, dotProduct,
          matMulVec]
      have hnorm : vecNorm2Sq (WithLp.ofLp x) = 1 := by
        have hn := EuclideanSpace.norm_sq_eq x
        simpa [vecNorm2Sq, hx, Real.norm_eq_abs, sq_abs] using hn.symm
      simpa [hq, hnorm] using h (WithLp.ofLp x)

/-- The exact spectral Gram criterion is equivalent to simultaneous squared-norm control. -/
theorem gram_opNorm2_le_iff_squared_norm {t d : ℕ}
    (B : Matrix (Fin t) (Fin d) ℝ) {ε : ℝ} (hε : 0 ≤ ε) :
    opNorm2 (fun i j => rowSketchGram B i j - idMatrix d i j) ≤ ε ↔
      ∀ x : Fin d → ℝ,
        |vecNorm2Sq (B.mulVec x) - vecNorm2Sq x| ≤ ε * vecNorm2Sq x := by
  have hsym : Matrix.IsHermitian
      (fun i j => rowSketchGram B i j - idMatrix d i j) := by
    apply Matrix.IsHermitian.ext
    intro i j
    simp only [star_trivial, rowSketchGram]
    have hgram : (∑ k, B k j * B k i) = ∑ k, B k i * B k j := by
      apply Finset.sum_congr rfl
      intro k _
      exact mul_comm _ _
    rw [hgram]
    congr 1
    simp [idMatrix, eq_comm]
  rw [symmetric_opNorm2_le_iff_quadratic _ hsym hε]
  have hq (x : Fin d → ℝ) :
      (∑ i, x i * matMulVec d (fun i j => rowSketchGram B i j - idMatrix d i j) x i) =
        vecNorm2Sq (B.mulVec x) - vecNorm2Sq x := by
    have h₁ := vecNorm2Sq_rowSketch_linearCombination_eq_quadratic_rowSketchGram B x
    have h₂ := vecNorm2Sq_add_quadraticForm_sub_id_eq_quadraticForm (rowSketchGram B) x
    change vecNorm2Sq (B.mulVec x) = _ at h₁
    linarith
  simp_rw [hq]

open scoped Matrix.Norms.L2Operator in
/-- Reversing the sign of a square residual does not change its exact spectral norm. -/
theorem opNorm2_sub_rev {d : ℕ} (A B : Matrix (Fin d) (Fin d) ℝ) :
    opNorm2 (fun i j => A i j - B i j) = opNorm2 (fun i j => B i j - A i j) := by
  exact norm_sub_rev A B

end NumStability
