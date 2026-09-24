import ComputationalMathematics.HDP.Optimization.SemidefiniteProgram
import ComputationalMathematics.HDP.Tensor.Specializations

/-! Frozen proof-free signature for display (3.19). -/

namespace NumStability.HDP.Contract

open scoped BigOperators

set_option linter.style.nameCheck false in
def hdp_03_eq_3_19__contract_type : Prop :=
  ∀ {n : ℕ} (A X : Matrix (Fin n) (Fin n) ℝ),
    NumStability.HDP.Optimization.matrixInner A X =
        Matrix.trace (A.transpose * X) ∧
      NumStability.HDP.Optimization.matrixInner A X =
        ∑ i, ∑ j, A i j * X i j

end NumStability.HDP.Contract
