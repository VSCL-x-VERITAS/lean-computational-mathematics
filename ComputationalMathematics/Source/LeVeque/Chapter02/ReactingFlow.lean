/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReactingFlowTarget
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Tactic.FinCases

/-!
# Radioactive conversion in a common advective flow

The actual advective flux derivative is the common velocity times the state
derivative. The existing vector balance then yields the two species equations
(2.29), with equal first-species loss and second-species gain.
-/

namespace NumStability.Leveque02Tracer

/-- The vector radioactive balance is equivalent to the two displayed species equations. -/
theorem reactingFlow : reactingFlowTarget := by
  intro q spatialDerivative velocity decayRate x t hspace
  constructor
  · rintro ⟨timeDerivative, fluxDerivative, htime, hflux, hbalance⟩
    have hvalue : fluxDerivative = velocity • spatialDerivative :=
      hflux.unique (hspace.const_smul velocity)
    rw [hvalue] at hbalance
    exact ⟨timeDerivative, htime,
      by simpa using congrFun hbalance 0,
      by simpa using congrFun hbalance 1⟩
  · rintro ⟨timeDerivative, htime, hfirst, hsecond⟩
    refine ⟨timeDerivative, velocity • spatialDerivative, htime,
      hspace.const_smul velocity, ?_⟩
    ext i
    fin_cases i <;> simp_all

end NumStability.Leveque02Tracer
