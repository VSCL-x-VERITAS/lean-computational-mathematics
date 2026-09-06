import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Definition05.Signature

/-! Stable Chapter 2 source contract for Definition 2.7.5. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

/-- Definition 2.7.5: finiteness of the property-(c) gauge is equivalent to
satisfying any one of Proposition 2.7.1(a)--(d), and that gauge is the infimum
of the positive property-(c) scales.  Display (2.21)'s distinct property-(d)
infimum remains represented by `hdp_02_heq_h2_d21_exact`. -/
theorem hdp_02_hdef_h2_d7_d5_exact :
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
      (PsiOnePropertyThreeGauge mu X < (⊤ : ENNReal) ↔
        ∃ i : SubExponentialPropertyKind, ∃ K : Real,
          0 < K ∧ SubExponentialProperty mu X i K) ∧
        PsiOnePropertyThreeGauge mu X =
          sInf {t : ENNReal | PsiOnePropertyThreeAdmissible mu X t} := by
  intro Omega _ mu _ X
  constructor
  · constructor
    · intro hGauge
      obtain ⟨K, hK, hProperty⟩ := psiOnePropertyThreeGauge_finite_iff.mp hGauge
      exact ⟨.absoluteMGF, K, hK, hProperty⟩
    · rintro ⟨i, K, hK, hProp⟩
      obtain ⟨C, hC, hAll⟩ := subExponentialCharacterization_uniform
      obtain ⟨K3, hK3, hK3Bound, hProperty⟩ :=
        (hAll (mu := mu) (X := X)).1 i .absoluteMGF hK hProp
      exact psiOnePropertyThreeGauge_finite_iff.mpr ⟨K3, hK3, hProperty⟩
  · rfl

theorem hdp_02_hdef_h2_d7_d5__contract :
    hdp_02_hdef_h2_d7_d5__contract_type :=
  hdp_02_hdef_h2_d7_d5_exact

end NumStability.HDP.Contract
