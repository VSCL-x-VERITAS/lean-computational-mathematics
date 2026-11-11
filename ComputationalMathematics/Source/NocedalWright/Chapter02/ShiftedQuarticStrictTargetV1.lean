import Mathlib.Topology.MetricSpace.Basic

/-!
Proof-free target for the shifted-quartic example on printed page 13 of
Nocedal and Wright, *Numerical Optimization*, second edition.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The shifted quartic has a strict local minimum at two. -/
def shiftedQuarticStrictTargetV1 : Prop :=
  ∃ U : Set ℝ, IsOpen U ∧ (2 : ℝ) ∈ U ∧
    ∀ x ∈ U, x ≠ (2 : ℝ) →
      (((2 : ℝ) - 2) ^ 4) < (x - 2) ^ 4

end ComputationalMathematics.Source.NocedalWright.Chapter02
