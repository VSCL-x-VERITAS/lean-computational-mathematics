/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticsMatrixTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsMatrixTarget

/-! The primitive linearization has the pressure-velocity coordinate form (2.48), not the literal matrix of (2.47). The two coordinate systems remain physically related. -/

namespace NumStability.Leveque02Tracer

/-- The printed equation-number and variable mismatch in Exercise 2.2(a). -/
def exercise22aNumberingDiscrepancyTarget : Prop :=
  exercise22aTarget ∧
    fluidFluxJacobian (fluidConservedState 1 0) 2 ≠
      convectedLinearAcousticsMatrix 2 1 0

end NumStability.Leveque02Tracer
