import ComputationalMathematics.Analysis.OperatorNorms.RealComplexification

/-!
# Integrability of finite-matrix operator norms

For a finite random matrix, entrywise integrability implies integrability of
the Euclidean operator norm.  The proof bounds the operator norm by the
Frobenius norm and then by the entrywise `ℓ₁` sum.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators RealInnerProductSpace

namespace NumStability.HDP.Matrix

/-- The matrix-to-continuous-linear-map construction is linear when the
matrix space carries its ordinary pointwise vector-space structure. -/
noncomputable def realMatrixContinuousLinearMapLinear (m n : ℕ) :
    (Fin m → Fin n → ℝ) →ₗ[ℝ]
      (EuclideanSpace ℝ (Fin n) →L[ℝ] EuclideanSpace ℝ (Fin m)) where
  toFun := NumStability.realMatrixContinuousLinearMap
  map_add' A B := by
    ext x i
    change (∑ j, (A i j + B i j) * x.ofLp j) =
      (∑ j, A i j * x.ofLp j) + ∑ j, B i j * x.ofLp j
    simp only [add_mul, Finset.sum_add_distrib]
  map_smul' c A := by
    ext x i
    change (∑ j, (c * A i j) * x.ofLp j) = c * ∑ j, A i j * x.ofLp j
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _hj
    ring

/-- Continuous version of `realMatrixContinuousLinearMapLinear`. -/
noncomputable def realMatrixContinuousLinearMapContinuous (m n : ℕ) :
    (Fin m → Fin n → ℝ) →L[ℝ]
      (EuclideanSpace ℝ (Fin n) →L[ℝ] EuclideanSpace ℝ (Fin m)) :=
  (realMatrixContinuousLinearMapLinear m n).toContinuousLinearMap

/-- The Euclidean operator norm is continuous in the finitely many real
matrix entries. -/
theorem continuous_realMatrixOperatorNorm (m n : ℕ) :
    Continuous (fun A : Fin m → Fin n → ℝ =>
      NumStability.realMatrixOperatorNorm A) := by
  simpa [NumStability.realMatrixOperatorNorm,
    realMatrixContinuousLinearMapContinuous,
    realMatrixContinuousLinearMapLinear] using
      (realMatrixContinuousLinearMapContinuous m n).continuous.norm

/-- The Frobenius norm is at most the sum of the absolute values of all
matrix entries. -/
theorem frobNormRect_le_entrywise_abs_sum {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.frobNormRect A ≤ ∑ i, ∑ j, |A i j| := by
  let S : ℝ := ∑ i, ∑ j, |A i j|
  have hS : 0 ≤ S := by
    dsimp [S]
    positivity
  have hentry (i : Fin m) (j : Fin n) : |A i j| ≤ S := by
    dsimp [S]
    exact (Finset.single_le_sum
      (fun i _ => Finset.sum_nonneg fun j _ => abs_nonneg (A i j))
      (Finset.mem_univ i)).trans' (Finset.single_le_sum
        (fun j _ => abs_nonneg (A i j)) (Finset.mem_univ j))
  have hsq : NumStability.frobNormRect A ^ 2 ≤ S ^ 2 := by
    rw [NumStability.frobNormRect_sq]
    unfold NumStability.frobNormSqRect
    calc
      (∑ i, ∑ j, A i j ^ 2) ≤ ∑ i, ∑ j, |A i j| * S := by
        gcongr with i hi j hj
        calc
          A i j ^ 2 = |A i j| * |A i j| := by rw [← sq_abs]; ring
          _ ≤ |A i j| * S :=
            mul_le_mul_of_nonneg_left (hentry i j) (abs_nonneg _)
      _ = ∑ i, (∑ j, |A i j|) * S := by
        apply Finset.sum_congr rfl
        intro i _hi
        rw [Finset.sum_mul]
      _ = (∑ i, ∑ j, |A i j|) * S := by
        rw [Finset.sum_mul]
      _ = S ^ 2 := by
        change S * S = S ^ 2
        ring
  nlinarith [NumStability.frobNormRect_nonneg A]

/-- A finite random matrix with integrable entries has integrable Euclidean
operator norm. -/
theorem integrable_realMatrixOperatorNorm_of_entries
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {m n : ℕ} (A : Ω → (Fin m → Fin n → ℝ))
    (hInt : ∀ ij : Fin m × Fin n,
      Integrable (fun ω => A ω ij.1 ij.2) μ) :
    Integrable (fun ω => NumStability.realMatrixOperatorNorm (A ω)) μ := by
  have hAmeas : AEMeasurable A μ := by
    apply aemeasurable_pi_lambda
    intro i
    apply aemeasurable_pi_lambda
    intro j
    exact (hInt (i, j)).aestronglyMeasurable.aemeasurable
  have hMeas : AEStronglyMeasurable
      (fun ω => NumStability.realMatrixOperatorNorm (A ω)) μ :=
    ((continuous_realMatrixOperatorNorm m n).measurable.comp_aemeasurable
      hAmeas).aestronglyMeasurable
  have hSum : Integrable (fun ω => ∑ i, ∑ j, |A ω i j|) μ := by
    apply integrable_finset_sum
    intro i _hi
    apply integrable_finset_sum
    intro j _hj
    exact (hInt (i, j)).abs
  apply hSum.mono' hMeas
  filter_upwards [] with ω
  rw [Real.norm_eq_abs, abs_of_nonneg]
  · exact (NumStability.realMatrixOperatorNorm_le_frobNormRect (A ω)).trans
      (frobNormRect_le_entrywise_abs_sum (A ω))
  · exact norm_nonneg _

end NumStability.HDP.Matrix
