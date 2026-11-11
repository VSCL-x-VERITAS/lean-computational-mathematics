import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise21GradientTargetV1
import Mathlib.Topology.Order.LocalExtr

/-!
Proof-free unique-local-minimizer target for Chapter 2 Exercise 2.1.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The book's weak open-neighborhood local-minimum criterion, specialized
to the fixed Rosenbrock objective. -/
def rosenbrockLocalMinV1 (z : EuclideanSpace ℝ (Fin 2)) : Prop :=
  ∃ N : Set (EuclideanSpace ℝ (Fin 2)),
    IsOpen N ∧ z ∈ N ∧
      ∀ x ∈ N, rosenbrockObjectiveV1 z ≤ rosenbrockObjectiveV1 x

/-- Exercise 2.1: (1,1) is the only weak local minimizer on ℝ². -/
def exercise21UniqueLocalMinimizerTargetV1 : Prop :=
  let xstar : EuclideanSpace ℝ (Fin 2) :=
    EuclideanSpace.single 0 1 + EuclideanSpace.single 1 1
  rosenbrockLocalMinV1 xstar ∧
    ∀ z : EuclideanSpace ℝ (Fin 2), rosenbrockLocalMinV1 z → z = xstar

end ComputationalMathematics.Source.NocedalWright.Chapter02
