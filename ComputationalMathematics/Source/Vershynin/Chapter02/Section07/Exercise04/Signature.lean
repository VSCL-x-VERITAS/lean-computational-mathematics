import ComputationalMathematics.HDP.Scalar.SubExponential

/-! Frozen contract for Exercise 2.7.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d7_d4__contract_type : Prop :=
  let mu : Measure Real := Measure.dirac 0
  let X : Real -> Real := fun _ => 0
  let K3 : Real := 1
  IsProbabilityMeasure mu ∧ Measurable X ∧ 0 < K3 ∧
    (∀ lam : Real, 0 <= lam -> lam <= K3⁻¹ ->
      (∫ x, Real.exp (lam * |X x|) ∂mu) <= Real.exp (K3 * lam)) ∧
    ∃ lam : Real, lam < 0 ∧ |lam| <= K3⁻¹ ∧
      ¬ (∫ x, Real.exp (lam * |X x|) ∂mu) <= Real.exp (K3 * lam)

end NumStability.HDP.Contract
