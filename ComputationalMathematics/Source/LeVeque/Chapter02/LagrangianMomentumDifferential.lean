/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMomentumDifferentialTarget
import Mathlib.Tactic

/-!
# LeVeque equation (2.106): local Lagrangian momentum law
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- Localize the pressure-only momentum balance by differentiating the
upper mass-label bound of every physical subinterval. -/
theorem lagrangianMomentumDifferential : lagrangianMomentumDifferentialTarget := by
  intro initialDensity referenceLocation particlePosition eulerianVelocity
    lagrangianPressure lowerLabel upperLabel time label hlabel _ _ _ _ _
    hUcont hUmeas hpressure _ hinterchange hbalance
  let Urate : ℝ → ℝ := fun η =>
    deriv (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition η τ) time
  have hsection (b : ℝ) (hb : b ∈ Set.Ioo lowerLabel upperLabel) :
      (∫ η in label..b, Urate η) =
        lagrangianPressure label time - lagrangianPressure b time :=
    (hinterchange label hlabel b hb).unique (hbalance label hlabel b hb)
  have hlocal :
      (fun b => ∫ η in label..b, Urate η) =ᶠ[𝓝 label]
        (fun b => lagrangianPressure label time - lagrangianPressure b time) := by
    filter_upwards [isOpen_Ioo.mem_nhds hlabel] with b hb
    exact hsection b hb
  have hUintegral :
      HasDerivAt (fun b => ∫ η in label..b, Urate η) (Urate label) label :=
    intervalIntegral.integral_hasDerivAt_right (by simp) hUmeas hUcont
  have hPressureDiff :
      HasDerivAt (fun b => lagrangianPressure label time - lagrangianPressure b time)
        (-deriv (fun ζ => lagrangianPressure ζ time) label) label := by
    simpa using (hasDerivAt_const label (lagrangianPressure label time)).sub hpressure
  have heq : Urate label =
      -deriv (fun ζ => lagrangianPressure ζ time) label :=
    (hUintegral.congr_of_eventuallyEq hlocal.symm).unique hPressureDiff
  dsimp [Urate] at heq
  linarith

end NumStability.Leveque02Tracer
