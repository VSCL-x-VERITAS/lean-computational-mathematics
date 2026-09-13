/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Fluid continuity from classical mass conservation

Every test section satisfies the actual incoming-minus-outgoing mass balance.
Actual derivatives of density and velocity identify the derivative of their
product, yielding the displayed continuity equation on the closed section.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- Classical mass conservation with flux density times velocity gives (2.32). -/
def fluidContinuityTarget : Prop :=
  ∀ (density velocity densityTime densitySpace velocitySpace : ℝ → ℝ → ℝ)
    (L R c d t : ℝ), L < R → t ∈ Ioo c d →
    ContinuousOn (Function.uncurry density) (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry velocity) (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry densityTime) (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry densitySpace) (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry velocitySpace) (Icc L R ×ˢ Icc c d) →
    (∀ τ ∈ Ioo c d, ∀ x ∈ Icc L R,
      HasDerivAt (density x) (densityTime x τ) τ) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => density ξ t) (densitySpace x t) (Icc L R) x) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => velocity ξ t) (velocitySpace x t) (Icc L R) x) →
    (∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      HasDerivAt (fun τ => ∫ x in a..b, density x τ)
        (density a t * velocity a t - density b t * velocity b t) t) →
    ∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => density ξ t * velocity ξ t)
        (densitySpace x t * velocity x t + density x t * velocitySpace x t)
        (Icc L R) x ∧
      densityTime x t +
        (densitySpace x t * velocity x t + density x t * velocitySpace x t) = 0

end NumStability.Leveque02Tracer
