/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ForwardCauchy
import ComputationalMathematics.Source.LeVeque.Chapter02.AdvectionCauchy
import ComputationalMathematics.Source.LeVeque.Chapter02.WholeLineAdvectionIVPTarget

/-!
# LeVeque's whole-line advection formula

The characteristic argument yields the formula for every forward classical
solution continuous to its initial trace. The paired existence theorem covers
differentiable initial profiles.
-/

namespace NumStability.Leveque02Tracer

theorem wholeLineAdvectionFormula : wholeLineAdvectionFormulaTarget := by
  intro initial velocity initialTime
  dsimp
  constructor
  · intro x
    simp
  · intro field hcont hdiff hpde hinitial x t ht
    rw [forward_characteristic_unique hcont hdiff hpde ht, hinitial]

theorem wholeLineAdvectionIVP : wholeLineAdvectionIVPTarget :=
  ⟨advectionCauchy, wholeLineAdvectionFormula⟩

end NumStability.Leveque02Tracer
