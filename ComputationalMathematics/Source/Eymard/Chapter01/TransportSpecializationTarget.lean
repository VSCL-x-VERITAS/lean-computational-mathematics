/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.CoordinateBalance
import Mathlib.Analysis.Calculus.ContDiff.Basic

/-!
# Zero-source transport specialization

The homogeneous equation of Example 1.1 is the general conservation law with
`q = u`, `F = u • v` and zero source. The manuscript's later specialization
prints a general spatial source; the second conjunct records the restriction
needed when the same supplied fields satisfy both equations.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume.CoordinateBalance

/-- The flux prescribed by a scalar state and a time-independent velocity. -/
def transportFlux (v : Point 2 → Point 2) (u : Point 2 → ℝ → ℝ)
    (x : Point 2) (t : ℝ) : Point 2 := u x t • v x

/-- The homogeneous conservative equation with its derivative applicability. -/
def HomogeneousTransportAt (v : Point 2 → Point 2)
    (u : Point 2 → ℝ → ℝ) (x : Point 2) (t : ℝ) : Prop :=
  PartialsExistAt u (transportFlux v u) x t ∧
    timePartial u x t + divergence (transportFlux v u) x t = 0

/-- Identification of the zero-source equation and the source restriction for
the same homogeneous state, at strictly positive interior times. -/
def transportSpecializationTarget : Prop :=
  ∀ (v : Point 2 → Point 2), ContDiff ℝ 1 v →
    ∀ (u : Point 2 → ℝ → ℝ),
      (∀ x t, 0 < t →
        (LocalLawAt u (transportFlux v u) (fun _ _ => 0) x t ↔
          HomogeneousTransportAt v u x t)) ∧
      (∀ (f : Point 2 → ℝ) x t, 0 < t →
        HomogeneousTransportAt v u x t →
        LocalLawAt u (transportFlux v u) (fun y _ => f y) x t →
        f x = 0)

end NumStability.Eymard.Chapter01
