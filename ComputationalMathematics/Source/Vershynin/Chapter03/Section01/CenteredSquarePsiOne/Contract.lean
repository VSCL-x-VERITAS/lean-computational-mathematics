import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.CenteredSquarePsiOne.Signature

/-! Source-facing contract for the centered-square estimate in Theorem 3.1.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Theorem 3.1.1 proof, printed page 42: a sub-Gaussian coordinate with raw
second moment one has centered square controlled in `ψ₁` by a universal
multiple of its squared `ψ₂` gauge. -/
theorem hdp_03_body_3_1_square_centering :
    hdp_03_body_3_1_square_centering__contract_type :=
  NumStability.HDP.Vector.NormConcentration.centeredSquare_psiOneGauge_le

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen centered-square signature. -/
theorem hdp_03_body_3_1_square_centering__contract :
    hdp_03_body_3_1_square_centering__contract_type :=
  hdp_03_body_3_1_square_centering

end NumStability.HDP.Contract
