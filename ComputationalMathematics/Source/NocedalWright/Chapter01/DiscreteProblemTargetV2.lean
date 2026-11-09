import ComputationalMathematics.Optimization.Discrete.Domain

/-!
# Nocedal--Wright discrete optimization definition target, revision 2
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

open ComputationalMathematics.Optimization.Discrete

/-- A discrete optimization domain consists of finitely many candidate values
for the unknown, whatever the variable type. -/
def discreteDomainDefinitionTargetV2 : Prop :=
  ∀ {α : Type} (candidate : Set α),
    IsDiscreteDomain candidate ↔ candidate.Finite

end ComputationalMathematics.Source.NocedalWright.Chapter01
