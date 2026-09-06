import ComputationalMathematics.Analysis.Equidistribution.AddCircle
import NumStability.Analysis.Equidistribution.AddCircle

/-! Moving an anonymous instance must preserve its existing public name and registration. -/

#check NumStability.instFactLtRealOfNat_numStability
#synth Fact (0 < (1 : ℝ))

example : Fact (0 < (1 : ℝ)) := NumStability.instFactLtRealOfNat_numStability

example : (0 : ℝ) < 1 := NumStability.instFactLtRealOfNat_numStability.out

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  if env.contains `NumStability.instFactLtRealOfNat_computationalMathematics then
    throwError "the module move introduced a replacement public instance name"
  let priority ← liftCoreM <| Meta.getInstancePriority? `NumStability.instFactLtRealOfNat_numStability
  unless priority == some 1000 do
    throwError "the preserved instance must retain its default registration priority"
