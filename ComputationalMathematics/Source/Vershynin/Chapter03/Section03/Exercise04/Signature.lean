import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen contract signature for Exercise 3.3.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_4__contract_type : Prop :=
  ∀ {n : ℕ} {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) (X : Omega → EuclideanSpace ℝ (Fin n)),
    AEMeasurable X mu →
      (HasGaussianLaw X mu ↔
        ∀ theta : EuclideanSpace ℝ (Fin n),
          HasGaussianLaw (fun omega => innerSL ℝ theta (X omega)) mu)

end NumStability.HDP.Contract
