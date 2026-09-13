/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Spatial derivative of the flux in the integral balance

Proof-free target for the fundamental-theorem-of-calculus rewrite (2.8).
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- The spatial flux derivative gives the same signed mass rate as the endpoints. -/
def integralFluxDerivativeTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ) (fluxDerivative : ℝ → ℝ)
    (a b t : ℝ), a ≤ b →
    IntervalIntegrable (fun x => q x t) volume a b →
    ContinuousOn (fun x => flux (q x t)) (Icc a b) →
    (∀ x ∈ Ioo a b, HasDerivAt (fun ξ => flux (q ξ t)) (fluxDerivative x) x) →
    IntervalIntegrable fluxDerivative volume a b →
    (HasDerivAt (fun τ => ∫ x in a..b, q x τ) (flux (q a t) - flux (q b t)) t ↔
      HasDerivAt (fun τ => ∫ x in a..b, q x τ) (-(∫ x in a..b, fluxDerivative x)) t)

end NumStability.Leveque02Tracer
