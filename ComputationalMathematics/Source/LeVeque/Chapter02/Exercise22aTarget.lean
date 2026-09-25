/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aConservativePrimitiveTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aPrimitiveLinearizationTarget

/-!
# Exercise 2.2(a): nonlinear primitive equations and their linearization

The source prints (2.47) for the final pressure-velocity acoustics system.
Its pressure-velocity equations are numbered (2.48); (2.47) is written in
conservative density-momentum variables. The target uses the printed
pressure-velocity equations and records the numbering error separately.
-/

namespace NumStability.Leveque02Tracer

/-- The two derivations requested by Exercise 2.2(a), each with explicit
classical derivative hypotheses and its own state domain. -/
def exercise22aTarget : Prop :=
  exercise22aConservativePrimitiveTarget ∧
    exercise22aPrimitiveLinearizationTarget

end NumStability.Leveque02Tracer
