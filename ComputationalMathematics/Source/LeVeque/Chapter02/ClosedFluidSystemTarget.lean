/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MassFluxContinuityTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LocalMomentumEquationTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.BarotropicPressureModel

/-!
# The closed mass and momentum system

LeVeque (2.38) combines the smooth mass and momentum conservation laws after
setting pressure to `P(ρ)`. The derivative witnesses are actual time and space
derivatives; both balances must hold on every test section. The pressure law
is used directly, without a quotient or a pressure-slope assumption.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- The two conservative equations of (2.38), on the modeled section. -/
def closedFluidSystemTarget : Prop :=
  ∀ (density velocity : ℝ → ℝ → ℝ) (pressureLaw : ℝ → ℝ)
    (densityTime massFluxSpace momentumTime momentumFluxSpace : ℝ → ℝ → ℝ)
    (L R c d t : ℝ), L < R → t ∈ Ioo c d →
    ContinuousOn (Function.uncurry density) (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry densityTime) (Icc L R ×ˢ Icc c d) →
    (∀ τ ∈ Ioo c d, ∀ x ∈ Icc L R,
      HasDerivAt (density x) (densityTime x τ) τ) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => density ξ t * velocity ξ t)
        (massFluxSpace x t) (Icc L R) x) →
    ContinuousOn (fun x => massFluxSpace x t) (Icc L R) →
    (∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      HasDerivAt (fun τ => ∫ x in a..b, density x τ)
        (density a t * velocity a t - density b t * velocity b t) t) →
    ContinuousOn (Function.uncurry (fluidMomentumDensity density velocity))
      (Icc L R ×ˢ Icc c d) →
    ContinuousOn (Function.uncurry momentumTime) (Icc L R ×ˢ Icc c d) →
    (∀ τ ∈ Ioo c d, ∀ x ∈ Icc L R,
      HasDerivAt (fluidMomentumDensity density velocity x)
        (momentumTime x τ) τ) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt
        (fun ξ => fluidMomentumFlux density velocity
          (barotropicPressure pressureLaw density) ξ t)
        (momentumFluxSpace x t) (Icc L R) x) →
    ContinuousOn (fun x => momentumFluxSpace x t) (Icc L R) →
    (∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      HasDerivAt (fun τ => fluidSectionMomentum density velocity a b τ)
        (fluidMomentumFlux density velocity (barotropicPressure pressureLaw density) a t -
          fluidMomentumFlux density velocity (barotropicPressure pressureLaw density) b t) t) →
    ∀ x ∈ Icc L R,
      HasDerivAt (density x) (densityTime x t) t ∧
      HasDerivWithinAt (fun ξ => density ξ t * velocity ξ t)
        (massFluxSpace x t) (Icc L R) x ∧
      densityTime x t + massFluxSpace x t = 0 ∧
      HasDerivAt (fun τ => density x τ * velocity x τ)
        (momentumTime x t) t ∧
      HasDerivWithinAt
        (fun ξ => density ξ t * velocity ξ t ^ 2 +
          pressureLaw (density ξ t))
        (momentumFluxSpace x t) (Icc L R) x ∧
      momentumTime x t + momentumFluxSpace x t = 0

end NumStability.Leveque02Tracer
