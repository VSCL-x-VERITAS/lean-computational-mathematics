import ComputationalMathematics.HDP.Vector.GaussianPolar

/-! Frozen contract signature for Exercise 3.3.7(a). -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_7a__contract_type : Prop :=
  ∀ {d : ℕ} {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) (X : Fin (d + 1) → Omega → ℝ),
    NumStability.HDP.Vector.Gaussian.IsStandardNormal mu X →
      IndepFun
        (fun omega =>
          NumStability.HDP.Vector.Gaussian.gaussianRadius d (fun i => X i omega))
        (fun omega =>
          NumStability.gaussianUnitDirection d (fun i => X i omega)) mu

end NumStability.HDP.Contract
