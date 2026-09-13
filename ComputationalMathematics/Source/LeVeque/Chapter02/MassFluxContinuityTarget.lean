/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Continuity for the actual mass flux

Classical regularity is imposed on density and its actual mass flux. Velocity
need not have an independent derivative where multiplication by density removes
its irregularity, including vacuum. All test sections carry actual mass balance.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- The actual mass-flux derivative gives the continuity equation (2.32). -/
def massFluxContinuityTarget : Prop :=
  ∀ (density velocity densityTime : ℝ → ℝ → ℝ) (fluxDerivative : ℝ → ℝ)
    (L R c d t : ℝ), L < R → t ∈ Ioo c d →
    ContinuousOn (Function.uncurry density) (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry densityTime) (Icc L R ×ˢ Icc c d) →
    (∀ τ ∈ Ioo c d, ∀ x ∈ Icc L R,
      HasDerivAt (density x) (densityTime x τ) τ) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => density ξ t * velocity ξ t)
        (fluxDerivative x) (Icc L R) x) →
    ContinuousOn fluxDerivative (Icc L R) →
    (∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      HasDerivAt (fun τ => ∫ x in a..b, density x τ)
        (density a t * velocity a t - density b t * velocity b t) t) →
    ∀ x ∈ Icc L R, densityTime x t + fluxDerivative x = 0

end NumStability.Leveque02Tracer
