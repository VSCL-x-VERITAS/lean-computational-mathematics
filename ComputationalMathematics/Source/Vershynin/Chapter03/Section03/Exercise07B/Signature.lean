import ComputationalMathematics.HDP.Vector.GaussianPolar

/-! Frozen contract signature for Exercise 3.3.7(b). -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_7b__contract_type : Prop :=
  ∀ {d : ℕ} {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) (X : Fin (d + 1) → Omega → ℝ),
    NumStability.HDP.Vector.Gaussian.IsStandardNormal mu X →
      HasLaw (fun omega =>
          NumStability.gaussianUnitDirection d (fun i => X i omega))
        (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure (d + 1)) mu

end NumStability.HDP.Contract
