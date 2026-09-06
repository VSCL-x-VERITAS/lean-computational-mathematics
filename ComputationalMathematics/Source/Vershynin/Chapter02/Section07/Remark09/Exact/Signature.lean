import ComputationalMathematics.Source.Vershynin.Chapter02.Section05.Proposition02.Signature
import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Proposition01.Signature
import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Signature

/-!
# Exact frozen signature for Remark 2.7.9

The remark combines a local Taylor explanation with the exact standard-normal
MGF, the two characterization results it explicitly cites, and the `Exp(1)`
large-positive-parameter counterexample.  This file assembles those clauses
without introducing a dependency cycle in the reusable scalar modules.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

universe u

def hdp_02_hrem_h2_d7_d9_exact__contract_type : Prop :=
  hdp_02_hrem_h2_d7_d9_local__contract_type.{u} ∧
  (∀ lam : ℝ,
    (∫ x, Real.exp (lam * x) ∂(gaussianReal 0 1)) =
      Real.exp (lam ^ 2 / 2)) ∧
  hdp_02_hprop_h2_d5_d2__contract_type.{u, u} ∧
  hdp_02_hprop_h2_d7_d1__contract_type.{u}

end NumStability.HDP.Contract
