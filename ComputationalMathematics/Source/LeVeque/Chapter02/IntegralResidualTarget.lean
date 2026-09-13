/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Integrated classical conservation residual

Proof-free target for (2.9), with local continuity and actual partial derivatives
supporting differentiation under the spatial integral.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- The integral balance and classical time differentiation give zero integrated residual. -/
def integralResidualTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ) (qt : ℝ → ℝ → ℝ)
    (fluxDerivative : ℝ → ℝ) (a b c d t : ℝ), a ≤ b → t ∈ Ioo c d →
    ContinuousOn (Function.uncurry q) (Icc a b ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry qt) (Icc a b ×ˢ Icc c d) →
    (∀ τ ∈ Ioo c d, ∀ x ∈ Icc a b, HasDerivAt (q x) (qt x τ) τ) →
    (∀ x ∈ Ioo a b, HasDerivAt (fun ξ => flux (q ξ t)) (fluxDerivative x) x) →
    IntervalIntegrable fluxDerivative volume a b →
    HasDerivAt (fun τ => ∫ x in a..b, q x τ) (-(∫ x in a..b, fluxDerivative x)) t →
    ∫ x in a..b, (qt x t + fluxDerivative x) = 0

end NumStability.Leveque02Tracer
