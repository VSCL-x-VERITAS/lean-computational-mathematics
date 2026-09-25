/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelModel

/-!
# Proof-free target for LeVeque equation (2.102)
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- The initial particle label is the oriented integral of initial density
from the reference point to that particle's initial physical location. -/
def lagrangianMassLabelTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation x : ℝ),
    IntervalIntegrable initialDensity volume referenceLocation x →
      lagrangianMassLabel initialDensity referenceLocation x =
        ∫ s in referenceLocation..x, initialDensity s

end NumStability.Leveque02Tracer
