import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen signature for Proposition 3.3.2, rotation invariance of the standard normal law. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_prop_3_3_2__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) (X : Fin n → Ω → ℝ)
      (U : Matrix.orthogonalGroup (Fin n) ℝ),
    NumStability.HDP.Vector.Gaussian.IsStandardNormal μ X →
      NumStability.HDP.Vector.Gaussian.IsStandardNormal μ
        (fun i ω ↦ Matrix.mulVec
          (U : Matrix (Fin n) (Fin n) ℝ)
          (fun j ↦ X j ω) i)

end NumStability.HDP.Contract
