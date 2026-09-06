import ComputationalMathematics.Source.Vershynin.Chapter02.Equation22.Signature

/-! Stable Chapter 2 source contract for Equation (2.22). -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

/-- Equation (2.22): after normalizing both `psi_2` scales to one, both
quadratic exponential moments are at most two. -/
theorem hdp_02_heq_h2_d22_exact :
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu] {X Y : Omega -> Real},
      SubGaussian.PsiTwoAdmissible mu X 1 ->
        SubGaussian.PsiTwoAdmissible mu Y 1 ->
          (∫ omega, Real.exp (X omega ^ 2) ∂mu) ≤ 2 ∧
            (∫ omega, Real.exp (Y omega ^ 2) ∂mu) ≤ 2 := by
  intro Omega _ mu _ X Y hX hY
  exact ⟨by simpa using hX.2.2.2.2, by simpa using hY.2.2.2.2⟩

theorem hdp_02_heq_h2_d22__contract :
    hdp_02_heq_h2_d22__contract_type :=
  hdp_02_heq_h2_d22_exact

end NumStability.HDP.Contract
