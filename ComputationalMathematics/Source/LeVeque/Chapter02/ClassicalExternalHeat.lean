/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ClassicalExternalHeatTarget
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Tactic.Linarith

/-!
# Classical external-source heat equation

Constant-coefficient differentiation identifies the Fourier flux derivative.
Substituting that derivative in the prescribed-source energy balance gives
the displayed equation of Section 2.5.1.
-/

namespace NumStability.Leveque02Tracer

/-- Fourier balance with prescribed production yields the classical source heat equation. -/
theorem classicalExternalHeat : classicalExternalHeatTarget := by
  intro temperature source gradient conductivity qt qxx fluxDerivative x t spaceDomain
    _hopen _hx _htime _hspace hgradient hflux hbalance
  have hfourier : HasDerivAt
      (fun ξ => fourierHeatFlux conductivity (gradient ξ)) (-(conductivity * qxx)) x := by
    simpa only [fourierHeatFlux] using (hgradient.const_mul conductivity).neg
  have hvalue : fluxDerivative = -(conductivity * qxx) := hflux.unique hfourier
  rw [hvalue] at hbalance
  linarith

end NumStability.Leveque02Tracer
