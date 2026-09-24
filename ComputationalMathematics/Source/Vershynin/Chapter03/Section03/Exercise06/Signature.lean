import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen contract signature for Exercise 3.3.6. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_6__contract_type : Prop :=
  ∀ {m n : ℕ} {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) [IsProbabilityMeasure mu]
      (G : Fin m → Fin n → Omega → ℝ)
      (u v : EuclideanSpace ℝ (Fin n)),
    iIndepFun (fun i omega => fun j => G i j omega) mu →
      (∀ i, NumStability.HDP.Vector.Gaussian.IsStandardNormal mu (G i)) →
        ‖u‖ = 1 → ‖v‖ = 1 →
          (∑ j, u j * v j) = 0 →
            NumStability.HDP.Vector.Gaussian.IsStandardNormal mu
                (fun i omega => ∑ j, G i j omega * u j) ∧
              NumStability.HDP.Vector.Gaussian.IsStandardNormal mu
                (fun i omega => ∑ j, G i j omega * v j) ∧
              IndepFun
                (fun omega i => ∑ j, G i j omega * u j)
                (fun omega i => ∑ j, G i j omega * v j) mu

end NumStability.HDP.Contract
