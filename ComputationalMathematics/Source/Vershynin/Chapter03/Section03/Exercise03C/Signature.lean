import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen contract signature for Exercise 3.3.3(c). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_3c__contract_type : Prop :=
  ∀ {m n : ℕ} {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) [IsProbabilityMeasure mu]
      (G : Fin m → Fin n → Omega → ℝ)
      (u : EuclideanSpace ℝ (Fin n)),
    iIndepFun (fun i omega => fun j => G i j omega) mu →
      (∀ i, NumStability.HDP.Vector.Gaussian.IsStandardNormal mu (G i)) →
        ‖u‖ = 1 →
          NumStability.HDP.Vector.Gaussian.IsStandardNormal mu
            (fun i omega => ∑ j, G i j omega * u j)

end NumStability.HDP.Contract
