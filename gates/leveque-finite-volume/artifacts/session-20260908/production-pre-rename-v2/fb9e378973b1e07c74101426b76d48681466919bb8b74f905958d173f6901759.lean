/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.Examples.HuberShock.Basic
import Mathlib.Analysis.Convex.Jensen

/-!
# Jump traces and local admissibility of the Huber shock

Distinct one-sided limits give a genuine jump. Equal fluxes, inward speeds,
and the Oleinik chord inequality are local facts; no full spacetime entropy
inequality or entropy uniqueness theorem is asserted here.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem stationary_shock_flux_and_speeds {t : ℝ} (ht : 1 ≤ t) :
    huberFlux t = huberFlux (-t) ∧ huberSlope t = 1 ∧ huberSlope (-t) = -1 := by
  refine ⟨?_, huberSlope_of_ge ht, huberSlope_of_le (by linarith)⟩
  rw [huberFlux_of_ge ht, huberFlux_of_le (by linarith : -t ≤ -1)]
  ring

/-- Distinct one-sided limits certify an actual jump, independently of the value at zero. -/
theorem shockState_jump_traces {t : ℝ} (ht : 1 ≤ t) :
    Tendsto (fun x => shockState x t) (𝓝[<] 0) (𝓝 t) ∧
    Tendsto (fun x => shockState x t) (𝓝[>] 0) (𝓝 (-t)) ∧ -t < t := by
  refine ⟨?_, ?_, by linarith⟩
  ·
    have hh : Tendsto (fun x : ℝ => t - x) (𝓝[<] 0) (𝓝 t) := by
      have hlinear : Continuous (fun y : ℝ => t - y) := continuous_const.sub continuous_id
      simpa only [sub_zero] using
        (hlinear.continuousAt (x := (0 : ℝ))).tendsto.mono_left
          (show 𝓝[<] (0 : ℝ) ≤ 𝓝 0 from inf_le_left)
    apply hh.congr'
    filter_upwards [self_mem_nhdsWithin] with x hx
    simp only [shockState_after ht, outerState, mem_Iio.mp hx, if_pos]
  · have hh : Tendsto (fun x : ℝ => -t - x) (𝓝[>] 0) (𝓝 (-t)) := by
      have hlinear : Continuous (fun y : ℝ => -t - y) := continuous_const.sub continuous_id
      simpa only [sub_zero] using
        (hlinear.continuousAt (x := (0 : ℝ))).tendsto.mono_left
          (show 𝓝[>] (0 : ℝ) ≤ 𝓝 0 from inf_le_left)
    apply hh.congr'
    filter_upwards [self_mem_nhdsWithin] with x hx
    simp only [shockState_after ht, outerState, if_neg (not_lt.mpr (le_of_lt (mem_Ioi.mp hx)))]

/-- A genuine discontinuity is present at every time at or after collapse. -/
theorem shockState_not_continuous_after {t : ℝ} (ht : 1 ≤ t) :
    ¬ ContinuousAt (fun x => shockState x t) 0 := by
  intro hc
  have hleft := (shockState_jump_traces ht).1
  have hboth := tendsto_nhds_unique hleft hc.continuousWithinAt.tendsto
  simp only [shockState_after ht, outerState, lt_self_iff_false, if_false, sub_zero] at hboth
  linarith

/-- The flux graph lies below the stationary shock chord between its two traces. -/
theorem stationary_shock_oleinik {t k : ℝ} (ht : 1 ≤ t) (hk : k ∈ Icc (-t) t) :
    huberFlux k ≤ huberFlux t := by
  have hh := huberFlux_convex.le_max_of_mem_Icc (mem_univ (-t)) (mem_univ t) hk
  simpa only [← (stationary_shock_flux_and_speeds ht).1, max_self] using hh


end

end NumStability.HuberShock
