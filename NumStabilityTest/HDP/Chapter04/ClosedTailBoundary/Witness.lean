import NumStabilityTest.HDP.Chapter04.ClosedTailBoundary.Target

/-! Ordinary source-neutral diagnostic only. This theorem makes no assertion
about the author's zero-scale domain or the truth of Equation (4.15). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Diagnostics

open NumStability.HDP.Scalar.SubGaussian

/-- A zero-scale obstruction to the closed failure-event extension, while the
closed success event remains probability one for the same concrete matrix. -/
theorem zero_scale_closed_tail_step_boundary :
    Phase138Eq415BoundaryPreparation.zeroScaleClosedTailStepBoundary := by
  classical
  let μ : Measure Unit := Measure.dirac ()
  let entries : (Fin 1 × Fin 1) → Unit → ℝ := fun _ _ ↦ 0
  have hFinite : ∀ i, PsiTwoNorm μ (entries i) < ∞ := by
    intro i
    simp [entries, PsiTwoNorm, psiTwoGauge_zero]
  have hMax : psiTwoNormMax μ entries = 0 :=
    (psiTwoNormMax_eq_zero_iff_entries_ae_zero
      (fun _ ↦ measurable_const) hFinite).mpr (fun _ ↦ Filter.EventuallyEq.rfl)
  have hNorm : NumStability.realMatrixOperatorNorm
      (0 : Matrix (Fin 1) (Fin 1) ℝ) = 0 := by
    simp [NumStability.realMatrixOperatorNorm,
      NumStability.realMatrixContinuousLinearMap]
  have hExp : 2 * Real.exp (-((1 : ℝ) ^ 2)) < 1 := by
    norm_num only [one_pow]
    linarith [Real.exp_neg_one_lt_half]
  unfold Phase138Eq415BoundaryPreparation.zeroScaleClosedTailStepBoundary
  change IsProbabilityMeasure μ ∧
    (∀ i, Measurable (entries i) ∧ PsiTwoNorm μ (entries i) < ∞) ∧
    (∀ i, IsSubGaussian μ (entries i)) ∧
    (∀ i, Integrable (entries i) μ ∧ (∫ ω, entries i ω ∂μ) = 0) ∧
    iIndepFun entries μ ∧ psiTwoNormMax μ entries = 0 ∧
    (∀ _ω : Unit, NumStability.realMatrixOperatorNorm
      (0 : Matrix (Fin 1) (Fin 1) ℝ) = 0) ∧ _
  refine ⟨inferInstance, (fun i ↦ ⟨measurable_const, hFinite i⟩),
    (fun i ↦ isSubGaussian_iff_psiTwoNorm_finite.mpr (hFinite i)),
    ?_, iIndepFun.of_subsingleton, hMax, (fun _ ↦ hNorm), ?_⟩
  · intro i
    simp [entries]
  · intro C _hC
    dsimp only
    have hMaxActual : psiTwoNormMax (Measure.dirac ())
        (fun ij : Fin 1 × Fin 1 ↦ fun _ω : Unit ↦
          (0 : Matrix (Fin 1) (Fin 1) ℝ) ij.1 ij.2) = 0 := hMax
    simp only [hMaxActual, mul_zero, zero_mul, hNorm]
    have hEvent : μ.real {_ω : Unit | (0 : ℝ) ≤ 0} = 1 := by simp
    exact ⟨hEvent, hExp, by rw [hEvent]; exact not_le.mpr hExp, hEvent⟩

end NumStability.HDP.Diagnostics

end
