import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Stable Chapter 2 forwarding declaration for the exact Rademacher MGF. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

theorem hdp_02_hbody_h2_d2_hcosh_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hLaw : Measure.map X μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (lam a : ℝ) :
    (∫ ω, Real.exp (lam * (a * X ω)) ∂μ) =
        (Real.exp (lam * a) + Real.exp (-(lam * a))) / 2 ∧
      (∫ ω, Real.exp (lam * (a * X ω)) ∂μ) = Real.cosh (lam * a) := by
  have hmgf :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherWeightedMGFEqCosh
      hX hLaw lam a
  exact ⟨hmgf.trans (Real.cosh_eq (lam * a)), hmgf⟩

end NumStability.HDP.Contract
