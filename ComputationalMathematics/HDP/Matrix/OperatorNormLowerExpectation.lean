import ComputationalMathematics.HDP.Vector.NormExpectation
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix
import ComputationalMathematics.HDP.Matrix.OperatorNormIntegrability
import ComputationalMathematics.HDP.Vector.SphericalSubGaussian

/-!
# Lower expectation bounds for rectangular random matrices

The deterministic row/column lower bounds and the Euclidean-norm expectation
estimate combine to give the optimal `√m + √n` lower order for random
matrices with independent unit-variance entries.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal BigOperators RealInnerProductSpace

namespace NumStability.HDP.Matrix

theorem realMatrixOperatorNorm_transpose {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    NumStability.realMatrixOperatorNorm A.transpose =
      NumStability.realMatrixOperatorNorm A := by
  have hadjoint : NumStability.realMatrixContinuousLinearMap A.transpose =
      (NumStability.realMatrixContinuousLinearMap A).adjoint := by
    apply ContinuousLinearMap.ext
    intro x
    change Matrix.toEuclideanLin A.transpose x =
      (Matrix.toEuclideanLin A).adjoint x
    rw [show Matrix.toEuclideanLin A.transpose =
        (Matrix.toEuclideanLin A).adjoint by
      simpa using Matrix.toEuclideanLin_conjTranspose_eq_adjoint A]
  unfold NumStability.realMatrixOperatorNorm
  rw [hadjoint]
  exact ContinuousLinearMap.adjointAux_norm _

theorem vecNorm2_column_le_realMatrixOperatorNorm
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (j : Fin n) :
    NumStability.vecNorm2 (fun i ↦ A i j) ≤
      NumStability.realMatrixOperatorNorm A := by
  classical
  let e : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single j 1
  have he : ‖e‖ = 1 := by simp [e]
  have h := ContinuousLinearMap.le_opNorm
    (NumStability.realMatrixContinuousLinearMap A) e
  rw [he, mul_one] at h
  have happly : Matrix.toEuclideanLin A e =
      WithLp.toLp 2 (fun i ↦ A i j) := by
    rw [Matrix.toLpLin_apply]
    change WithLp.toLp 2 (A.mulVec (Pi.single j 1)) =
      WithLp.toLp 2 (fun i ↦ A i j)
    rw [Matrix.mulVec_single_one]
    rfl
  rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
  simpa [NumStability.realMatrixContinuousLinearMap,
    NumStability.realMatrixOperatorNorm, happly] using h

theorem vecNorm2_row_le_realMatrixOperatorNorm
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin m) :
    NumStability.vecNorm2 (fun j ↦ A i j) ≤
      NumStability.realMatrixOperatorNorm A := by
  simpa [realMatrixOperatorNorm_transpose A] using
    (vecNorm2_column_le_realMatrixOperatorNorm A.transpose i)

/-- Unit-variance independent sub-Gaussian entries force the expected matrix
operator norm to have the optimal `√m + √n` order once both dimensions
dominate the entrywise `ψ₂` scale. -/
theorem exists_expected_operatorNorm_lower_bound_of_independent_unitVariance_entries :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ} (hm : 0 < m) (hn : 0 < n),
        letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
        letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
        (∀ ij : Fin m × Fin n, Measurable (fun ω ↦ A ω ij.1 ij.2)) →
        (∀ ij : Fin m × Fin n,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω ↦ A ω ij.1 ij.2) < ∞) →
        (∀ ij : Fin m × Fin n,
          Integrable (fun ω ↦ A ω ij.1 ij.2) μ) →
        (∀ ij : Fin m × Fin n,
          (∫ ω, A ω ij.1 ij.2 ^ 2 ∂μ) = 1) →
        iIndepFun (fun ij : Fin m × Fin n ↦
          fun ω ↦ A ω ij.1 ij.2) μ →
        let K := NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2)
        2 * C * K ^ 2 ≤ Real.sqrt (m : ℝ) →
        2 * C * K ^ 2 ≤ Real.sqrt (n : ℝ) →
        (Real.sqrt (m : ℝ) + Real.sqrt (n : ℝ)) / 4 ≤
          ∫ ω, NumStability.realMatrixOperatorNorm (A ω) ∂μ := by
  rcases NumStability.HDP.Vector.NormConcentration.expectationEuclideanNorm_abs_sub_sqrt_le with
    ⟨C, hC, hExp⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ m n hm hn
  letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  intro A hMeas hFinite hEntryInt hSecond hIndep
  have hOpInt : Integrable
      (fun ω ↦ NumStability.realMatrixOperatorNorm (A ω)) μ :=
    integrable_realMatrixOperatorNorm_of_entries A hEntryInt
  let X : Fin m × Fin n → Ω → ℝ :=
    fun ij ω ↦ A ω ij.1 ij.2
  let K : ℝ := NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
  dsimp only
  intro hmLarge hnLarge
  let i₀ : Fin m := ⟨0, hm⟩
  let j₀ : Fin n := ⟨0, hn⟩
  let Col : Fin m → Ω → ℝ := fun i ω ↦ A ω i j₀
  let Row : Fin n → Ω → ℝ := fun j ω ↦ A ω i₀ j
  let Kcol : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ Col
  let Krow : ℝ :=
    NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ Row
  have hK0 : 0 ≤ K := by
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
  have hKcol0 : 0 ≤ Kcol := by
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
  have hKrow0 : 0 ≤ Krow := by
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
  have hKcol : Kcol ≤ K := by
    unfold Kcol
    apply Finset.sup'_le Finset.univ_nonempty
    intro i _hi
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_toReal_le_max
      (μ := μ) (X := X) (i, j₀)
  have hKrow : Krow ≤ K := by
    unfold Krow
    apply Finset.sup'_le Finset.univ_nonempty
    intro j _hj
    exact NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_toReal_le_max
      (μ := μ) (X := X) (i₀, j)
  have hColIndep : iIndepFun Col μ := by
    exact hIndep.precomp (g := fun i : Fin m ↦ (i, j₀)) (by
      intro a b hab
      exact congrArg Prod.fst hab)
  have hRowIndep : iIndepFun Row μ := by
    exact hIndep.precomp (g := fun j : Fin n ↦ (i₀, j)) (by
      intro a b hab
      exact congrArg Prod.snd hab)
  have hColDev :
      |(∫ ω, NumStability.vecNorm2 (fun i ↦ Col i ω) ∂μ) -
          Real.sqrt (m : ℝ)| ≤ C * Kcol ^ 2 := by
    simpa [Col, Kcol] using hExp Col
      (fun i ↦ hMeas (i, j₀))
      (fun i ↦ hFinite (i, j₀))
      (fun i ↦ hSecond (i, j₀)) hColIndep
  have hRowDev :
      |(∫ ω, NumStability.vecNorm2 (fun j ↦ Row j ω) ∂μ) -
          Real.sqrt (n : ℝ)| ≤ C * Krow ^ 2 := by
    simpa [Row, Krow] using hExp Row
      (fun j ↦ hMeas (i₀, j))
      (fun j ↦ hFinite (i₀, j))
      (fun j ↦ hSecond (i₀, j)) hRowIndep
  have hColInt : Integrable
      (fun ω ↦ NumStability.vecNorm2 (fun i ↦ Col i ω)) μ := by
    apply hOpInt.mono'
    · apply Measurable.aestronglyMeasurable
      dsimp [Col, NumStability.vecNorm2, NumStability.vecNorm2Sq]
      exact Real.continuous_sqrt.measurable.comp
        (Finset.measurable_sum _ fun i _ ↦ (hMeas (i, j₀)).pow_const 2)
    · filter_upwards [] with ω
      rw [Real.norm_of_nonneg (NumStability.vecNorm2_nonneg _)]
      simpa [Col] using vecNorm2_column_le_realMatrixOperatorNorm (A ω) j₀
  have hRowInt : Integrable
      (fun ω ↦ NumStability.vecNorm2 (fun j ↦ Row j ω)) μ := by
    apply hOpInt.mono'
    · apply Measurable.aestronglyMeasurable
      dsimp [Row, NumStability.vecNorm2, NumStability.vecNorm2Sq]
      exact Real.continuous_sqrt.measurable.comp
        (Finset.measurable_sum _ fun j _ ↦ (hMeas (i₀, j)).pow_const 2)
    · filter_upwards [] with ω
      rw [Real.norm_of_nonneg (NumStability.vecNorm2_nonneg _)]
      simpa [Row] using vecNorm2_row_le_realMatrixOperatorNorm (A ω) i₀
  have hColLeOp :
      (∫ ω, NumStability.vecNorm2 (fun i ↦ Col i ω) ∂μ) ≤
        ∫ ω, NumStability.realMatrixOperatorNorm (A ω) ∂μ := by
    apply integral_mono hColInt hOpInt
    intro ω
    exact vecNorm2_column_le_realMatrixOperatorNorm (A ω) j₀
  have hRowLeOp :
      (∫ ω, NumStability.vecNorm2 (fun j ↦ Row j ω) ∂μ) ≤
        ∫ ω, NumStability.realMatrixOperatorNorm (A ω) ∂μ := by
    apply integral_mono hRowInt hOpInt
    intro ω
    exact vecNorm2_row_le_realMatrixOperatorNorm (A ω) i₀
  have hC0 : 0 ≤ C := le_trans zero_le_one hC
  have hColSq : Kcol ^ 2 ≤ K ^ 2 := by nlinarith
  have hRowSq : Krow ^ 2 ≤ K ^ 2 := by nlinarith
  have hColLower : Real.sqrt (m : ℝ) / 2 ≤
      ∫ ω, NumStability.vecNorm2 (fun i ↦ Col i ω) ∂μ := by
    have habs := neg_le_of_abs_le hColDev
    nlinarith [mul_le_mul_of_nonneg_left hColSq hC0]
  have hRowLower : Real.sqrt (n : ℝ) / 2 ≤
      ∫ ω, NumStability.vecNorm2 (fun j ↦ Row j ω) ∂μ := by
    have habs := neg_le_of_abs_le hRowDev
    nlinarith [mul_le_mul_of_nonneg_left hRowSq hC0]
  nlinarith [hColLower.trans hColLeOp, hRowLower.trans hRowLeOp]

end NumStability.HDP.Matrix
