import ComputationalMathematics.HDP.Vector.WhiteningSupplied

/-!
# Vershynin Chapter 4, supplied-family whitening norms

Both same-K reader-check bounds in the invertible first case of Theorem 4.7.1,
with the complete independent isotropic population-and-sample family supplied.
The raw moment and relative marginal hypotheses retain their source context.
Almost-sure factorization suffices for these norms; the separate audited
statement comparison leaves the author's empirical equality wording open.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped ENNReal NNReal BigOperators MatrixOrder

namespace NumStability.HDP.Contract

/-- Supplied-family form of both whitening norm conclusions. -/
theorem hdp_04_whitened_supplied_norms_chapter01_context
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m n : ℕ} (_hm : 0 < m)
    (X Z : Ω → Fin n → ℝ)
    (Xsample Zsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0) (_hK : 1 ≤ K)
    (hSG : NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
      (fun j ω ↦ X ω j) K)
    (hUnit : IsUnit (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j)))
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hZMeas : ∀ j, Measurable (fun ω ↦ Z ω j))
    (hZSampleMeas : ∀ i j, Measurable (fun ω ↦ Zsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (hIndep : iIndepFun (fun o : Option (Fin m) ↦
      (match o with | none => Z | some i => Zsample i : Ω → Fin n → ℝ)) μ)
    (_hIso : ∀ o : Option (Fin m),
      NumStability.HDP.Vector.Isotropy.IsIsotropic μ
        (fun j ω ↦ (match o with | none => Z | some i => Zsample i :
          Ω → Fin n → ℝ) ω j))
    (hPop : X =ᵐ[μ] (fun ω ↦
      (CFC.sqrt (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
        (fun j ω ↦ X ω j) : Matrix (Fin n) (Fin n) ℝ)).mulVec (Z ω)))
    (hSamples : ∀ i, Xsample i =ᵐ[μ] (fun ω ↦
      (CFC.sqrt (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
        (fun j ω ↦ X ω j) : Matrix (Fin n) (Fin n) ℝ)).mulVec (Zsample i ω))) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ (fun j ω ↦ Z ω j) ≤
        (K : ℝ≥0∞) ∧
      ∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
        (fun j ω ↦ Zsample i ω j) ≤ (K : ℝ≥0∞) := by
  exact NumStability.HDP.Vector.Whitening.supplied_first_case_whitening_norms_of_ae_factorization
    X Z Xsample Zsample K hSG hRelative hUnit hSampleMeas hZMeas hZSampleMeas
    hLaw hIndep hPop hSamples

end NumStability.HDP.Contract
