import ComputationalMathematics.HDP.Vector.GaussianMixtureSpectralAmplitude
import ComputationalMathematics.HDP.Vector.GaussianMixturePartitionRecovery

/-!
# Positive spectral scale and partition invariance

A small operator perturbation gives a positive clipped spectral amplitude.
Positive scaling preserves the strict-score partition and its exact error
indices and budgets, including the zero-score boundary.
-/

namespace NumStability.HDP.Vector.GaussianMixture

theorem spectralAmplitude_pos_of_operatorError_lt_meanNorm_sq {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean)
    (T : Matrix (Fin n) (Fin n) ℝ) (hT : T.IsHermitian)
    (herror : NumStability.realMatrixOperatorNorm (populationSecondMoment mean - T) <
      NumStability.vecNorm2 mean ^ 2) :
    0 < Real.sqrt (max (NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ - 1) 0) := by
  let r := NumStability.vecNorm2 mean
  let e := NumStability.realMatrixOperatorNorm (populationSecondMoment mean - T)
  let a := Real.sqrt (max (NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ - 1) 0)
  have hr : 0 < r := hmean
  have hdiv : e / r < r := by
    rw [div_lt_iff₀ hr]
    simpa only [pow_two] using herror
  have hbound : |a - r| ≤ e / r :=
    spectralAmplitude_sub_meanNorm_abs_le hn mean hmean T hT
  have hlower : -(e / r) ≤ a - r := (abs_le.mp hbound).1
  change 0 < a
  linarith


/-- A positive real scale preserves the strict positive score. -/
theorem pos_dotProduct_smul_iff_of_pos {n : ℕ} (c : ℝ) (hc : 0 < c)
    (v x : Fin n → ℝ) :
    0 < dotProduct (c • v) x ↔ 0 < dotProduct v x := by
  rw [smul_dotProduct, smul_eq_mul]
  exact mul_pos_iff_of_pos_left hc

/-- Positive rescaling preserves the exact literal error index set. -/
theorem partitionMisclassifiedIndices_smul_of_pos {m n : ℕ}
    (c : ℝ) (hc : 0 < c) (labels : Fin m → ℝ) (firstLabel : ℝ)
    (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) :
    partitionMisclassifiedIndices labels firstLabel (c • v) X =
      partitionMisclassifiedIndices labels firstLabel v X := by
  ext i
  change (¬ (0 < dotProduct (c • v) (X i) ↔ labels i = firstLabel)) ↔
    (¬ (0 < dotProduct v (X i) ↔ labels i = firstLabel))
  rw [pos_dotProduct_smul_iff_of_pos c hc]

/-- Positive rescaling preserves every up-to-swap error-budget guarantee. -/
theorem makesAtMostPartitionErrorsUpToSwap_smul_iff_of_pos {m n : ℕ}
    (c : ℝ) (hc : 0 < c) (labels : Fin m → ℝ)
    (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) (budget : ℝ) :
    MakesAtMostPartitionErrorsUpToSwap labels (c • v) X budget ↔
      MakesAtMostPartitionErrorsUpToSwap labels v X budget := by
  simp only [MakesAtMostPartitionErrorsUpToSwap,
    partitionMisclassifiedIndices_smul_of_pos c hc]

end NumStability.HDP.Vector.GaussianMixture
