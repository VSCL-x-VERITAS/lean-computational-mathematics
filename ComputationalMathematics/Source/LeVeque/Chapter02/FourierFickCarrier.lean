/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FourierFickCarrierTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FourierTemperatureGradient
import ComputationalMathematics.Source.LeVeque.Chapter02.FickFluxDensityGradient
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: FourierFickCarrier

Comparison of Fourier heat and Fick tracer constitutive fluxes.
-/

namespace NumStability.Leveque02Tracer

/-- The existing audited constitutive laws supply the paired typed result. -/
theorem fourierFickCarrier : fourierFickCarrierTarget := by
  intro h m x t temperatureGradient concentrationGradient hT hC
  obtain ⟨henergy, hflux⟩ :=
    fourierTemperatureGradient h.temperature h.capacity h.conductivity
      x t temperatureGradient hT
  have hmassflux :=
    fickFluxDensityGradient m.concentration (m.diffusivity x)
      x t concentrationGradient hC
  exact ⟨henergy, hflux, rfl, hmassflux⟩

/-- A smooth model witness showing the paired target has satisfiable gradient
hypotheses and independently valued carriers. This numerical example is not
a claim made by the source. -/
theorem fourierFickCarrier_example :
    ∃ (h : HeatMaterial) (m : TracerMaterial),
      HasDerivAt (fun ξ => h.temperature ξ 0) 1 0 ∧
      HasDerivAt (fun ξ => m.concentration ξ 0) 1 0 ∧
      (heatCarrierAt h 0 0).density = 2 ∧
      (heatCarrierAt h 0 0).flux = -3 ∧
      (tracerCarrierAt m 0 0).density = 4 ∧
      (tracerCarrierAt m 0 0).flux = -5 := by
  let h : HeatMaterial :=
    ⟨fun x _ => x + 1, fun _ => 2, fun _ => 3⟩
  let m : TracerMaterial :=
    ⟨fun x _ => x + 4, fun _ => 5⟩
  have hT : HasDerivAt (fun ξ => h.temperature ξ 0) 1 0 := by
    simpa [h] using (hasDerivAt_id (0 : ℝ)).add_const 1
  have hC : HasDerivAt (fun ξ => m.concentration ξ 0) 1 0 := by
    simpa [m] using (hasDerivAt_id (0 : ℝ)).add_const 4
  obtain ⟨hE, hF, hM, hG⟩ :=
    fourierFickCarrier h m 0 0 1 1 hT hC
  exact ⟨h, m, hT, hC, by simpa [h] using hE,
    by simpa [h] using hF, by simpa [m] using hM,
    by simpa [m] using hG⟩

end NumStability.Leveque02Tracer
