/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeatEnergyModel
import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFluxModel
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# The printed integral heat balance

This proof-free target preserves the endpoint order printed in (2.24).
The surrounding physical premise is energy conservation with rightward signed
Fourier flux. Both rates are actual derivatives of the same locally integrable
energy integral. The target deliberately does not replace the printed bracket
with a corrected sign; its source faithfulness must be audited independently.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The endpoint formula printed in (2.24), in the conserving Fourier model. -/
def printedHeatBalanceTarget : Prop :=
  ∀ (temperature : ℝ → ℝ → ℝ) (capacity conductivity gradient : ℝ → ℝ)
    (a b t : ℝ), a < b →
    (∀ᶠ τ in 𝓝 t,
      IntervalIntegrable (fun x => thermalEnergyDensity capacity temperature x τ)
        volume a b) →
    (∀ x ∈ Icc a b,
      HasDerivAt (fun ξ => temperature ξ t) (gradient x) x) →
    HasDerivAt (fun τ => ∫ x in a..b, thermalEnergyDensity capacity temperature x τ)
      (fourierHeatFlux (conductivity a) (gradient a) -
        fourierHeatFlux (conductivity b) (gradient b)) t →
    HasDerivAt (fun τ => ∫ x in a..b, thermalEnergyDensity capacity temperature x τ)
      (fourierHeatFlux (conductivity b) (gradient b) -
        fourierHeatFlux (conductivity a) (gradient a)) t

end NumStability.Leveque02Tracer
