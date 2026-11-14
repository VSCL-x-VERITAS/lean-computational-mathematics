/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic
import Mathlib.Analysis.InnerProductSpace.StarOrder
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Defect square-root intertwining

The first identity of Bhatia, Matrix Analysis (1997), Exercise I.3.6,
printed page 11 / PDF page 23. Square roots use the positive functional
calculus on the two contraction defects; the norm is the Hilbert operator norm.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Bhatia I.3.6: a contraction intertwines its prescribed positive defect roots. -/
noncomputable def contractionDefectIntertwining : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    letI : CompleteSpace H := FiniteDimensional.complete ℂ H
    ∀ (A : H →L[ℂ] H),
      ‖A‖ ≤ 1 →
        star A * CFC.sqrt (1 - A * star A) =
          CFC.sqrt (1 - star A * A) * star A

end NumStability.Bhatia.Chapter01.Targets
