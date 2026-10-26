/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.ForwardDifference
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.Analysis.Calculus.Deriv.Basic

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

/-- The local scalar Taylor illustration of derivative replacement by a forward
difference: the supplied second-derivative bound gives the error constant `M / 2`.
Regularity and the bound hold on the supplied open neighbourhood of the segment. -/
def forwardDifferenceTaylorBoundTarget : Prop :=
  ∀ (u : ℝ → ℝ) (x h M : ℝ) (U : Set ℝ),
    0 < h → IsOpen U → Set.Icc x (x + h) ⊆ U →
    ContDiffOn ℝ 2 u U →
    (∀ y ∈ U, |deriv (deriv u) y| ≤ M) →
    |NumStability.FiniteVolume.forwardDifferenceQuotient u x h - deriv u x| ≤ M * h / 2

end NumStability.Eymard.Chapter01
