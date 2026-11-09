import ComputationalMathematics.Optimization.Discrete.Domain

/-!
# Discrete optimization domains

A discrete problem has a finite set of candidate values. Constraints select a
feasible subset of those candidates. The variable type is unrestricted, so it
can include numeric vectors and combinatorial objects alike.
-/

namespace ComputationalMathematics.Optimization.Discrete

/-- A candidate/feasible-set presentation of a discrete optimization problem.
The objective function is independent of this classification. -/
def IsDiscreteProblem {α : Type*} (candidate feasible : Set α) : Prop :=
  IsDiscreteDomain candidate ∧ feasible ⊆ candidate

end ComputationalMathematics.Optimization.Discrete
