/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aNumberingDiscrepancyTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22a
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: Exercise22aNumberingDiscrepancy

Proof witness for the printed coordinate and equation-number mismatch.
-/

namespace NumStability.Leveque02Tracer

theorem exercise22aNumberingDiscrepancy :
    exercise22aNumberingDiscrepancyTarget := by
  constructor
  · exact exercise22a
  · intro h
    have h01 := congrArg (fun M : Matrix (Fin 2) (Fin 2) ℝ => M 0 1) h
    norm_num [fluidFluxJacobian, fluidConservedState,
      convectedLinearAcousticsMatrix] at h01


/-- The literal density/momentum matrix (2.47) differs from the pressure/velocity matrix. -/
theorem exercise22aPrintedMatrixMismatch :
    fluidFluxJacobian (fluidConservedState 1 0) 2 ≠
      convectedLinearAcousticsMatrix 2 1 0 :=
  exercise22aNumberingDiscrepancy.2

/-- The pressure/velocity primitive equations themselves remain valid. -/
theorem exercise22aCorrectedPrimitive : exercise22aTarget :=
  exercise22aNumberingDiscrepancy.1
end NumStability.Leveque02Tracer
