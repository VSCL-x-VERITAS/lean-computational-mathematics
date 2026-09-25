/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassDifferentialTarget

/-!
# LeVeque equation (2.105): local Lagrangian mass conservation
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- Equality of the two integrated rates on every physical label interval
identifies their continuous integrands at each interior label. -/
theorem lagrangianMassDifferential : lagrangianMassDifferentialTarget := by
  intro initialDensity referenceLocation particlePosition eulerianVelocity eulerianDensity
    lowerLabel upperLabel time label hlabel _ _ _ _ _ _ hVcont hVmeas hUcont hUmeas
    _ hinterchange hintegral
  let Vrate : ℝ → ℝ := fun η =>
    deriv (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition η τ) time
  let Urate : ℝ → ℝ := fun η =>
    deriv (fun ζ => lagrangianParticleVelocity eulerianVelocity particlePosition ζ time) η
  have hrates (b : ℝ) (hb : b ∈ Set.Ioo lowerLabel upperLabel) :
      (∫ η in label..b, Vrate η) = ∫ η in label..b, Urate η := by
    exact (hinterchange label hlabel b hb).deriv.symm.trans
      (hintegral label hlabel b hb)
  have hlocal :
      (fun b => ∫ η in label..b, Vrate η) =ᶠ[𝓝 label]
        (fun b => ∫ η in label..b, Urate η) := by
    filter_upwards [isOpen_Ioo.mem_nhds hlabel] with b hb
    exact hrates b hb
  have hVderiv :
      HasDerivAt (fun b => ∫ η in label..b, Vrate η) (Vrate label) label :=
    intervalIntegral.integral_hasDerivAt_right (by simp) hVmeas hVcont
  have hUderiv :
      HasDerivAt (fun b => ∫ η in label..b, Urate η) (Urate label) label :=
    intervalIntegral.integral_hasDerivAt_right (by simp) hUmeas hUcont
  have heq : Vrate label = Urate label :=
    (hVderiv.congr_of_eventuallyEq hlocal.symm).unique hUderiv
  exact sub_eq_zero.mpr heq

end NumStability.Leveque02Tracer
