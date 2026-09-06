/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation04

/-!
# LeVeque Chapter 1: advection and one-way-wave identity

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), immediately after equation (1.4).
-/

namespace NumStability

/-- After renaming the unknown and the constant speed, equations (1.2) and
(1.4) have exactly the same pointwise mathematical specification. -/
theorem leveque01_advectionWaveIdentity
    (field : ℝ → ℝ → ℝ) (speed x t : ℝ) (_hspeed : 0 < speed) :
    leveque01_equation02_scalarAdvectionAt field speed x t ↔
      leveque01_equation04_oneWayWaveAt field speed x t :=
  Iff.rfl

end NumStability
