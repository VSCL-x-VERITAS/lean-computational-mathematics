/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.InitialProfileModel

/-!
# Proof-free target for LeVeque equation (2.15)

Equality to the prescribed initial profile means pointwise equality at each
real spatial position on the infinite line. This target does not assert
existence, uniqueness, regularity, or satisfaction of an evolution equation.
-/

namespace NumStability.Leveque02Tracer

/-- The source's pointwise initial-data condition and its function form. -/
def initialProfileTarget : Prop :=
  ∀ (field : ℝ → ℝ → ℝ) (initial : ℝ → ℝ) (initialTime : ℝ),
    HasInitialProfile field initial initialTime ↔
      ∀ x : ℝ, field x initialTime = initial x

end NumStability.Leveque02Tracer
