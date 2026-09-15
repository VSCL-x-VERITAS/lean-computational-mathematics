import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Frozen contract signature for the Orlicz-function definition

This file is intentionally proof-free.
-/

noncomputable section

open Filter Set TopologicalSpace
open scoped Topology

namespace NumStability.HDP.Contract

def hdp_02_hdef_horlicz_hfunction__contract_type : Prop :=
  ∀ f : ℝ → ℝ,
    (∃ ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction,
        ψ.toFun = f) ↔
      (∀ x : ℝ, 0 ≤ x → 0 ≤ f x) ∧
      ConvexOn ℝ (Set.Ici 0) f ∧
      MonotoneOn f (Set.Ici 0) ∧
      f 0 = 0 ∧ Tendsto f atTop atTop

end NumStability.HDP.Contract
