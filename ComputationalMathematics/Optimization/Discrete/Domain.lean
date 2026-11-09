import Mathlib.Data.Set.Finite.Basic

/-!
# Finite candidate domains for discrete optimization
-/

namespace ComputationalMathematics.Optimization.Discrete

/-- The finite-domain characteristic of a discrete optimization problem. -/
def IsDiscreteDomain {α : Type*} (candidate : Set α) : Prop :=
  candidate.Finite

end ComputationalMathematics.Optimization.Discrete
