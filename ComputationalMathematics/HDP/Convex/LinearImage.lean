import ComputationalMathematics.HDP.Convex.Uniform
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv

/-!
# Linear images of normalized volume

This module proves that normalized Lebesgue measure on a finite-dimensional set
is transported to normalized Lebesgue measure on its image by an invertible
linear map.  The determinant scaling cancels during normalization.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Convex

/-- Conditioning commutes with a measurable equivalence when its pushforward
rescales the ambient measure by a nonzero finite constant. -/
theorem map_cond_of_measurableEquiv
    {α β : Type*} [MeasurableSpace α] [MeasurableSpace β]
    (e : α ≃ᵐ β) (μ : Measure α) (ν : Measure β) (s : Set α)
    (c : ℝ≥0∞) (hc0 : c ≠ 0) (hct : c ≠ ⊤)
    (hmap : Measure.map e μ = c • ν) :
    Measure.map e (ProbabilityTheory.cond μ s) =
      ProbabilityTheory.cond ν (e '' s) := by
  unfold ProbabilityTheory.cond
  rw [Measure.map_smul]
  have hrs :
      Measure.map e (μ.restrict s) = (Measure.map e μ).restrict (e '' s) := by
    rw [e.restrict_map]
    simp
  rw [hrs, hmap, Measure.restrict_smul, smul_smul]
  congr 1
  have hμs : μ s = c * ν (e '' s) := by
    calc
      μ s = Measure.map e μ (e '' s) := by
        rw [e.measurableEmbedding.map_apply, e.injective.preimage_image]
      _ = (c • ν) (e '' s) := by rw [hmap]
      _ = c * ν (e '' s) := by rw [Measure.smul_apply, smul_eq_mul]
  rw [hμs, ENNReal.mul_inv (Or.inl hc0) (Or.inl hct)]
  calc
    c⁻¹ * (ν (e '' s))⁻¹ * c = (ν (e '' s))⁻¹ * (c⁻¹ * c) := by ac_rfl
    _ = (ν (e '' s))⁻¹ := by rw [ENNReal.inv_mul_cancel hc0 hct, mul_one]

/-- An invertible matrix transports normalized Lebesgue measure on any set to
normalized Lebesgue measure on its linear image. -/
theorem map_uniformConvexBodyMeasure_matrix
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (hA : IsUnit A)
    (K : Set (Fin n → ℝ)) :
    Measure.map (Matrix.toLin' A) (uniformConvexBodyMeasure K) =
      uniformConvexBodyMeasure (Matrix.toLin' A '' K) := by
  letI := hA.invertible
  let e : (Fin n → ℝ) ≃ᵐ (Fin n → ℝ) :=
    (Matrix.toLinearEquiv' A inferInstance).toContinuousLinearEquiv.toHomeomorph.toMeasurableEquiv
  let c : ℝ≥0∞ := ENNReal.ofReal (abs (Matrix.det A)⁻¹)
  have hdet : Matrix.det A ≠ 0 := (Matrix.isUnit_det_of_invertible A).ne_zero
  have hc0 : c ≠ 0 := by
    apply ne_of_gt
    exact ENNReal.ofReal_pos.mpr (abs_pos.mpr (inv_ne_zero hdet))
  have hct : c ≠ ⊤ := ENNReal.ofReal_ne_top
  have hmap : Measure.map e volume = c • volume := by
    simpa [e, c] using Real.map_matrix_volume_pi_eq_smul_volume_pi hdet
  simpa [uniformConvexBodyMeasure, e] using
    map_cond_of_measurableEquiv e volume volume K c hc0 hct hmap

/-- The image under an invertible matrix of a vector with normalized-volume
law on a set has normalized-volume law on the corresponding linear image. -/
theorem HasLaw.matrix_mulVec_uniformConvexBodyMeasure
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} {μ : Measure Ω}
    {X : Ω → (Fin n → ℝ)} {K : Set (Fin n → ℝ)}
    (hX : HasLaw X (uniformConvexBodyMeasure K) μ)
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : IsUnit A) :
    HasLaw (fun ω => A.mulVec (X ω))
      (uniformConvexBodyMeasure (Matrix.toLin' A '' K)) μ := by
  letI := hA.invertible
  let e : (Fin n → ℝ) ≃ᵐ (Fin n → ℝ) :=
    (Matrix.toLinearEquiv' A inferInstance).toContinuousLinearEquiv.toHomeomorph.toMeasurableEquiv
  have he : HasLaw e
      (uniformConvexBodyMeasure (Matrix.toLin' A '' K))
      (uniformConvexBodyMeasure K) := by
    refine ⟨e.measurable.aemeasurable, ?_⟩
    simpa [e] using map_uniformConvexBodyMeasure_matrix A hA K
  simpa [e, Function.comp_def] using he.comp hX

end NumStability.HDP.Convex
