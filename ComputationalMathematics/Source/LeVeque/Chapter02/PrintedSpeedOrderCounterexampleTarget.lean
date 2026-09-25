/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticWaveSpeedsModel

/-!
# Counterexample to the unqualified P/S speed order in Chapter 2

The displayed positive-modulus hypotheses allow a compressional speed below
the shear speed. A stronger material restriction is needed for the order.
-/

namespace NumStability.Leveque02Tracer

/-- Under the displayed positive density and modulus assumptions, a concrete
material has a slower P-wave than S-wave. -/
def printedSpeedOrderCounterexampleTarget : Prop :=
  let density : ℝ := 1
  let shearModulus : ℝ := 1
  let lameLambda : ℝ := -(3 / 2)
  0 < density ∧ 0 < shearModulus ∧
    0 < lameLambda + 2 * shearModulus ∧
    compressionalWaveSpeed lameLambda shearModulus density <
      shearWaveSpeed shearModulus density

end NumStability.Leveque02Tracer
