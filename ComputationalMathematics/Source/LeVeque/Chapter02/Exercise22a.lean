/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aConservativePrimitive
import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aPrimitiveLinearization

/-!
# Exercise 2.2(a)
-/

namespace NumStability.Leveque02Tracer

/-- Smooth conservative Euler balances yield (2.122), whose first variation
about a constant positive-density state is the pressure-velocity acoustic
system (2.48). -/
theorem exercise22a : exercise22aTarget :=
  ⟨exercise22aConservativePrimitive, exercise22aPrimitiveLinearization⟩

end NumStability.Leveque02Tracer
