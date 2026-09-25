/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergyModel
import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Correct endpoint sign for the heat-energy balance

The corrected bracket is the left Fourier flux minus the right Fourier flux.
With Fourier flux `-β qₓ`, this is the right endpoint value of `β qₓ`
minus its left endpoint value. The statement rewrites the conservation
balance; it does not independently assert conservation for every field.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The conserving Fourier endpoint difference has the bracket sign required
by equations (2.2) and (2.25), correcting the printed (2.24). -/
def correctedHeatBalanceTarget : Prop :=
  ∀ (temperature : ℝ → ℝ → ℝ) (capacity conductivity gradient : ℝ → ℝ)
    (a b t : ℝ), a < b →
    (∀ᶠ τ in 𝓝 t,
      IntervalIntegrable (fun x => thermalEnergyDensity capacity temperature x τ)
        volume a b) →
    (∀ x ∈ Icc a b,
      HasDerivAt (fun ξ => temperature ξ t) (gradient x) x) →
    (HasDerivAt (fun τ => ∫ x in a..b, thermalEnergyDensity capacity temperature x τ)
      (fourierHeatFlux (conductivity a) (gradient a) -
        fourierHeatFlux (conductivity b) (gradient b)) t ↔
      HasDerivAt (fun τ => ∫ x in a..b, thermalEnergyDensity capacity temperature x τ)
        (conductivity b * gradient b - conductivity a * gradient a) t)

end NumStability.Leveque02Tracer
