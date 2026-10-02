import ComputationalMathematics.HDP.Scalar.SubGaussian.Basic
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Bilinear tails for matrices with independent sub-Gaussian entries

This module packages the fixed-vector concentration step used in the standard
operator-norm bound for a matrix with independent centered sub-Gaussian
entries.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators RealInnerProductSpace

namespace NumStability.HDP.Matrix

/-- Expand a real matrix bilinear form as a weighted sum of its entries. -/
theorem realMatrix_bilinear_eq_weighted_entry_sum {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (x : EuclideanSpace ℝ (Fin n)) (y : EuclideanSpace ℝ (Fin m)) :
    inner ℝ (Matrix.toEuclideanLin A x) y =
      ∑ ij : Fin m × Fin n, (x ij.2 * y ij.1) * A ij.1 ij.2 := by
  rw [Fintype.sum_prod_type]
  simp only [Matrix.toEuclideanLin_apply, PiLp.inner_apply, Matrix.mulVec,
    dotProduct]
  apply Finset.sum_congr rfl
  intro i _hi
  change y i * (∑ j, A i j * x j) = _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _hj
  ring

/-- The coefficient vector of a bilinear form between unit vectors has
Euclidean norm one. -/
theorem sum_sq_bilinear_entry_coefficients_eq_one {m n : ℕ}
    (x : EuclideanSpace ℝ (Fin n)) (y : EuclideanSpace ℝ (Fin m))
    (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    ∑ ij : Fin m × Fin n, (x ij.2 * y ij.1) ^ 2 = 1 := by
  rw [Fintype.sum_prod_type]
  simp_rw [mul_pow, ← Finset.sum_mul]
  have hx' : ∑ j, x j ^ 2 = 1 := by
    have h := congrArg (fun z : ℝ => z ^ 2) hx
    simpa [EuclideanSpace.norm_eq,
      Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)] using h
  have hy' : ∑ i, y i ^ 2 = 1 := by
    have h := congrArg (fun z : ℝ => z ^ 2) hy
    simpa [EuclideanSpace.norm_eq,
      Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)] using h
  rw [hx']
  simpa using hy'

/-- There is an absolute positive exponent constant for every fixed bilinear
form of a matrix with independent centered sub-Gaussian entries. The scale is
the maximum intrinsic `ψ₂` norm of an entry. -/
theorem exists_fixed_bilinear_tail_of_independent_subGaussian_entries :
    ∃ c : ℝ, 0 < c ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ}
        [Nonempty (Fin m)] [Nonempty (Fin n)],
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
        (∀ ij : Fin m × Fin n,
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω => A ω ij.1 ij.2)) →
        (∀ ij : Fin m × Fin n,
          Integrable (fun ω => A ω ij.1 ij.2) μ ∧
            (∫ ω, A ω ij.1 ij.2 ∂μ) = 0) →
        iIndepFun (fun ij : Fin m × Fin n =>
          fun ω => A ω ij.1 ij.2) μ →
        ∀ (x : EuclideanSpace ℝ (Fin n))
          (y : EuclideanSpace ℝ (Fin m)),
          ‖x‖ = 1 → ‖y‖ = 1 →
          ∀ {u : ℝ}, 0 ≤ u →
            μ.real {ω | |inner ℝ (Matrix.toEuclideanLin (A ω) x) y| ≥ u} ≤
              2 * Real.exp
                (-(c * u ^ 2 /
                  (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
                    (fun ij : Fin m × Fin n =>
                      fun ω => A ω ij.1 ij.2)) ^ 2)) := by
  rcases NumStability.HDP.Scalar.SubGaussian.independentWeightedCenteredSubGaussianTailPsiTwo with
    ⟨c, hc, htail⟩
  refine ⟨c, hc, ?_⟩
  intro Ω instΩ μ instμ m n instm instn A hSub hCenter hIndep x y hx hy u hu
  let X : Fin m × Fin n → Ω → ℝ := fun ij ω => A ω ij.1 ij.2
  let a : Fin m × Fin n → ℝ := fun ij => x ij.2 * y ij.1
  have hcoeff : ∑ ij, a ij ^ 2 = 1 := by
    simpa [a] using sum_sq_bilinear_entry_coefficients_eq_one x y hx hy
  have h := htail (X := X) (fun ij => hSub ij) (fun ij => hCenter ij)
    (by simpa [X] using hIndep) a hu
  have hevent :
      {ω | |∑ ij, a ij * X ij ω| ≥ u} =
        {ω | |inner ℝ (Matrix.toEuclideanLin (A ω) x) y| ≥ u} := by
    ext ω
    simp only [Set.mem_setOf_eq]
    rw [realMatrix_bilinear_eq_weighted_entry_sum]
  rw [← hevent]
  simpa [X, a, hcoeff] using h

end NumStability.HDP.Matrix
