import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.SemidefiniteConvexity.Signature

/-! Every finite semidefinite program has a convex feasible set and a linear objective. -/

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_5_sdp_convex :
    hdp_03_body_3_5_sdp_convex__contract_type := by
  intro n m P
  refine ⟨P.feasibleSet_convex, ?_, ?_⟩
  · intro X Y
    exact NumStability.HDP.Optimization.matrixInner_add P.objective X Y
  · intro a X
    exact NumStability.HDP.Optimization.matrixInner_smul a P.objective X

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_5_sdp_convex__contract :
    hdp_03_body_3_5_sdp_convex__contract_type :=
  hdp_03_body_3_5_sdp_convex

end NumStability.HDP.Contract
