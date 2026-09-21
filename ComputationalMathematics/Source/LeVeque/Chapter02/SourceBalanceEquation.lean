/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SourceBalanceEquationTarget

/-!
# Pointwise source balance

Actual derivative witnesses uniquely determine the time and spatial flux rates,
so the reusable balance-law predicate is equivalent to the displayed source
equation.
-/

namespace NumStability.Leveque02Tracer

/-- The classical balance-law predicate gives exactly equation (2.28). -/
theorem sourceBalanceEquation : sourceBalanceEquationTarget := by
  intro m q flux sourceDensity qt fluxDerivative x t hqt hflux
  constructor
  · rintro ⟨qt', fluxDerivative', hqt', hflux', hbalance⟩
    rw [hqt.unique hqt', hflux.unique hflux']
    exact hbalance
  · intro hbalance
    exact ⟨qt, fluxDerivative, hqt, hflux, hbalance⟩

end NumStability.Leveque02Tracer
