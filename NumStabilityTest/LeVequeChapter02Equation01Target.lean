/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Equation01

/-!
# Statement audit target for LeVeque (2.1)

This proof-free proposition exposes the current notation correspondence for
independent source and effective-domain review. Its existence does not certify
that the correspondence captures the physical interpretation in the source.
-/

namespace NumStabilityTest

def leveque02Equation01Target : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ),
    NumStability.leveque02Equation01SectionMass q x₁ x₂ t =
      ∫ x in x₁..x₂, q x t

end NumStabilityTest
