import ComputationalMathematics.HDP.Optimization.GrothendieckGaussianMaximum

/-! Frozen proof-free signature for display (3.14). -/

noncomputable section

open MeasureTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_14__contract_type : Prop :=
  ∀ {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ),
    NumStability.HDP.Optimization.bipartiteUnitMaximum A =
        ∑ i, ∑ j, A i j * ∑ k,
          (NumStability.HDP.Optimization.bipartiteMaximizerRowDirection A i).1 k *
            (NumStability.HDP.Optimization.bipartiteMaximizerColumnDirection A j).1 k ∧
      (∑ i, ∑ j, A i j * ∑ k,
          (NumStability.HDP.Optimization.bipartiteMaximizerRowDirection A i).1 k *
            (NumStability.HDP.Optimization.bipartiteMaximizerColumnDirection A j).1 k) =
        ∫ g : Fin (m + n) → ℝ,
          ∑ i, ∑ j, A i j *
            NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k)
                (NumStability.HDP.Optimization.bipartiteMaximizerRowDirection A i).1 g *
              NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k)
                (NumStability.HDP.Optimization.bipartiteMaximizerColumnDirection A j).1 g
          ∂NumStability.standardGaussianVectorMeasure (m + n)

end NumStability.HDP.Contract
