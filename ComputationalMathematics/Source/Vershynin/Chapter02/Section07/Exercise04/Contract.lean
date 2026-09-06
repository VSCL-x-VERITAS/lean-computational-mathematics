import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Exercise04.Signature

/-! Stable Chapter 2 source contract for Exercise 2.7.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Exercise 2.7.4: the property-(c) bound cannot be extended from
`0 <= lambda` to every `|lambda| <= K3⁻¹`. The constant-zero random variable
already violates the proposed bound at `K3 = 1` and `lambda = -1`. -/
theorem hdp_02_hex_h2_d7_d4_exact :
    let mu : Measure Real := Measure.dirac 0
    let X : Real -> Real := fun _ => 0
    let K3 : Real := 1
    IsProbabilityMeasure mu ∧ Measurable X ∧ 0 < K3 ∧
      (∀ lam : Real, 0 <= lam -> lam <= K3⁻¹ ->
        (∫ x, Real.exp (lam * |X x|) ∂mu) <= Real.exp (K3 * lam)) ∧
      ∃ lam : Real, lam < 0 ∧ |lam| <= K3⁻¹ ∧
        ¬ (∫ x, Real.exp (lam * |X x|) ∂mu) <= Real.exp (K3 * lam) := by
  dsimp only
  refine ⟨inferInstance, measurable_const, by norm_num, ?_, -1,
    by norm_num, by norm_num, ?_⟩
  · intro lam hLam0 hLam1
    simp only [abs_zero, mul_zero, Real.exp_zero, one_mul]
    rw [integral_dirac]
    exact Real.one_le_exp hLam0
  · simp only [abs_zero, mul_zero, Real.exp_zero, one_mul]
    rw [integral_dirac, Real.exp_neg]
    exact not_le.mpr ((inv_lt_one₀ (Real.exp_pos 1)).2
      (Real.one_lt_exp_iff.mpr (by norm_num)))

theorem hdp_02_hex_h2_d7_d4__contract :
    hdp_02_hex_h2_d7_d4__contract_type :=
  hdp_02_hex_h2_d7_d4_exact

end NumStability.HDP.Contract
