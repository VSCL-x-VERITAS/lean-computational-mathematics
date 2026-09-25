/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ZeroAdvectionStationaryProfileTarget
import Mathlib.Analysis.Calculus.MeanValue

/-!
# Zero-velocity advection before diffusion
-/

namespace NumStability.Leveque02Tracer

/-- With no advection, the time derivative vanishes and the initial scalar
profile remains unchanged. -/
theorem zeroAdvectionStationaryProfile : zeroAdvectionStationaryProfileTarget := by
  intro q hpde
  have htime (x t : ℝ) : HasDerivAt (fun τ => q x τ) 0 t := by
    rcases hpde x t with ⟨qt, qx, hqt, _hqx, hequation⟩
    have hzero : qt = 0 := by simpa using hequation
    simpa [hzero] using hqt
  refine ⟨htime, ?_⟩
  intro x t
  exact is_const_of_deriv_eq_zero
    (fun τ => (htime x τ).differentiableAt)
    (fun τ => (htime x τ).deriv) t 0

end NumStability.Leveque02Tracer
