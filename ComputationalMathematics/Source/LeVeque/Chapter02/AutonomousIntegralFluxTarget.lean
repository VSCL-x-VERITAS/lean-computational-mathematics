/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Autonomous endpoint flux in the integral conservation law

Proof-free target for the rewrite from (2.2) to (2.6).
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- Substituting the autonomous endpoint fluxes rewrites the same mass derivative. -/
def autonomousIntegralFluxTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ) (leftFlux rightFlux : ℝ → ℝ)
    (a b t : ℝ), a ≤ b →
    IntervalIntegrable (fun x => q x t) volume a b →
    leftFlux t = flux (q a t) → rightFlux t = flux (q b t) →
    (HasDerivAt (fun τ => ∫ x in a..b, q x τ) (leftFlux t - rightFlux t) t ↔
      HasDerivAt (fun τ => ∫ x in a..b, q x τ) (flux (q a t) - flux (q b t)) t)

end NumStability.Leveque02Tracer
