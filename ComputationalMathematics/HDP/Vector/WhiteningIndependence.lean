import ComputationalMathematics.HDP.Vector.Whitening

/-!
# Independence under linear whitening

A linear transformation with a left inverse preserves mutual independence in
both directions on the original measure space. Principal inverse square-root
whitening is a special case, including whitening by the actual invertible raw
population second moment under sub-Gaussian moment guarantees.
-/

noncomputable section
set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped MatrixOrder

namespace NumStability.HDP.Vector.Whitening

/-- A fixed real matrix with a left inverse preserves family independence
in both directions, for an arbitrary measure and arbitrary index type. -/
theorem iIndepFun_mulVec_iff_of_left_inverse
    {Ω ι : Type*} [MeasurableSpace Ω] (μ : Measure Ω) {n r : ℕ}
    (B : Matrix (Fin r) (Fin n) ℝ) (P : Matrix (Fin n) (Fin r) ℝ)
    (hPB : P * B = 1) (Xsample : ι → Ω → Fin n → ℝ) :
    iIndepFun (fun i ω ↦ B.mulVec (Xsample i ω)) μ ↔
      iIndepFun Xsample μ := by
  constructor
  · intro h
    have hRecovered := h.comp (fun _ ↦ fun x ↦ P.mulVec x)
      (fun _ ↦ measurable_mulVec P)
    simpa only [Function.comp_def, Matrix.mulVec_mulVec, hPB,
      Matrix.one_mulVec] using hRecovered
  · intro h
    exact h.comp (fun _ ↦ fun x ↦ B.mulVec x)
      (fun _ ↦ measurable_mulVec B)

/-- A left-invertible deterministic transformation cannot turn a dependent
input family into an independent family on the same measure space. -/
theorem not_iIndepFun_mulVec_of_not_iIndepFun_left_inverse
    {Ω ι : Type*} [MeasurableSpace Ω] (μ : Measure Ω) {n r : ℕ}
    (B : Matrix (Fin r) (Fin n) ℝ) (P : Matrix (Fin n) (Fin r) ℝ)
    (hPB : P * B = 1) (Xsample : ι → Ω → Fin n → ℝ)
    (hDependent : ¬ iIndepFun Xsample μ) :
    ¬ iIndepFun (fun i ω ↦ B.mulVec (Xsample i ω)) μ := by
  intro h
  exact hDependent ((iIndepFun_mulVec_iff_of_left_inverse
    μ B P hPB Xsample).mp h)


/-- Principal inverse square-root whitening preserves independence in both
directions on the original measure space. -/
theorem iIndepFun_canonical_inverse_whitening_iff
    {Ω ι : Type*} [MeasurableSpace Ω] (μ : Measure Ω) {n : ℕ}
    (Sigma : Matrix (Fin n) (Fin n) ℝ) (hPSD : Sigma.PosSemidef)
    (hUnit : IsUnit Sigma) (Xsample : ι → Ω → Fin n → ℝ) :
    iIndepFun (fun i ω ↦ (CFC.sqrt Sigma)⁻¹.mulVec (Xsample i ω)) μ ↔
      iIndepFun Xsample μ := by
  let S := CFC.sqrt Sigma
  have hS : IsUnit S := (positive_squareRoot_factor Sigma hPSD).2.mpr hUnit
  have hLeft : S * S⁻¹ = 1 :=
    Matrix.mul_nonsing_inv S ((Matrix.isUnit_iff_isUnit_det S).mp hS)
  exact iIndepFun_mulVec_iff_of_left_inverse μ S⁻¹ S hLeft Xsample

/-- For the actual invertible raw population second moment, independence
of the whitened samples is equivalent to independence of the input samples. -/
theorem canonical_raw_population_whitening_samples_independent_iff_original
    {Ω ι : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → Fin n → ℝ) (Xsample : ι → Ω → Fin n → ℝ)
    (hSG : SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hUnit : IsUnit (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j))) :
    let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
    iIndepFun (fun i ω ↦ (CFC.sqrt Sigma)⁻¹.mulVec (Xsample i ω)) μ ↔
      iIndepFun Xsample μ := by
  let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
  have hPSD : Sigma.PosSemidef :=
    Covariance.secondMomentMatrix_posSemidef _ (coordinate_memLp_of_subGaussian hSG)
  exact iIndepFun_canonical_inverse_whitening_iff μ Sigma hPSD hUnit Xsample

end NumStability.HDP.Vector.Whitening
