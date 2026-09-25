/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumFluxModel
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Smooth local momentum conservation

LeVeque (2.34) follows from the interval momentum law (2.33) on every
subinterval. The time and space witnesses below are actual derivatives of
momentum density and total flux, so the zero residual is the displayed PDE.
The closed-section version uses within derivatives at spatial endpoints.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- Every-subinterval momentum balance and classical regularity imply
`(rho*u)_t + (rho*u^2+p)_x = 0` on the modeled section. -/
def localMomentumEquationTarget : Prop :=
  ∀ (density velocity pressure momentumTime : ℝ → ℝ → ℝ)
    (fluxDerivative : ℝ → ℝ) (L R c d t : ℝ),
    L < R → t ∈ Ioo c d →
    ContinuousOn (Function.uncurry (fluidMomentumDensity density velocity))
      (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry momentumTime) (Icc L R ×ˢ Icc c d) →
    (∀ τ ∈ Ioo c d, ∀ x ∈ Icc L R,
      HasDerivAt (fluidMomentumDensity density velocity x)
        (momentumTime x τ) τ) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt
        (fun ξ => fluidMomentumFlux density velocity pressure ξ t)
        (fluxDerivative x) (Icc L R) x) →
    ContinuousOn fluxDerivative (Icc L R) →
    (∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      HasDerivAt (fun τ => fluidSectionMomentum density velocity a b τ)
        (fluidMomentumFlux density velocity pressure a t -
          fluidMomentumFlux density velocity pressure b t) t) →
    ∀ x ∈ Icc L R, momentumTime x t + fluxDerivative x = 0

end NumStability.Leveque02Tracer
