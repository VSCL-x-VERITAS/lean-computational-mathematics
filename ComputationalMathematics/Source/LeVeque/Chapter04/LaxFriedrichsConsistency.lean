/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsViscosity
import Mathlib.Topology.Algebra.Module.Basic
import Mathlib.Tactic.Module

/-!
# LeVeque Chapter 4: consistency of the Lax–Friedrichs interface flux

With positive fixed `dt/dx`, the numerical correction has a fixed
coefficient multiplying the adjacent state jump. It vanishes when
the two interface states converge to a common state, so the numerical
flux converges to the physical flux there.
-/

namespace NumStability

/-- At fixed mesh ratio the Lax–Friedrichs correction has a coefficient
independent of the absolute mesh width. -/
theorem leveque04_laxFriedrichsFlux_fixedRatio
    {m : ℕ} (ratio cellWidth : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < cellWidth)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    leveque04_laxFriedrichsFlux (ratio * cellWidth) cellWidth
        physicalFlux left right =
      leveque04_centeredFlux physicalFlux left right -
        (1 / (2 * ratio)) • (right - left) := by
  have hrne : ratio ≠ 0 := ne_of_gt hratio
  have hwne : cellWidth ≠ 0 := ne_of_gt hwidth
  have hcoeff : cellWidth / (2 * (ratio * cellWidth)) =
      1 / (2 * ratio) := by
    field_simp
  unfold leveque04_laxFriedrichsFlux
  rw [hcoeff]

/-- Equal left and right states return the physical flux. -/
theorem leveque04_laxFriedrichsFlux_equalStates
    {m : ℕ} (ratio cellWidth : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < cellWidth)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (state : Fin m → ℝ) :
    leveque04_laxFriedrichsFlux (ratio * cellWidth) cellWidth
      physicalFlux state state = physicalFlux state := by
  rw [leveque04_laxFriedrichsFlux_fixedRatio ratio cellWidth
    hratio hwidth]
  simp only [sub_self, smul_zero, sub_zero,
    leveque04_centeredFlux]
  module

/-- On any fixed-ratio refinement, converging adjacent states give the
correct physical interface flux for a flux law continuous at the state. -/
theorem leveque04_laxFriedrichsFlux_consistent
    {m : ℕ} (ratio : ℝ) (hratio : 0 < ratio)
    (cellWidth : ℕ → ℝ) (hwidth : ∀ n, 0 < cellWidth n)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (state : Fin m → ℝ) (hflux : ContinuousAt physicalFlux state)
    (left right : ℕ → (Fin m → ℝ))
    (hleft : Filter.Tendsto left Filter.atTop (nhds state))
    (hright : Filter.Tendsto right Filter.atTop (nhds state)) :
    Filter.Tendsto
      (fun n => leveque04_laxFriedrichsFlux
        (ratio * cellWidth n) (cellWidth n)
        physicalFlux (left n) (right n))
      Filter.atTop (nhds (physicalFlux state)) := by
  have hfleft := hflux.tendsto.comp hleft
  have hfright := hflux.tendsto.comp hright
  have hlimit : Filter.Tendsto
      (fun n => (1 / 2 : ℝ) •
          (physicalFlux (left n) + physicalFlux (right n)) -
        (1 / (2 * ratio)) • (right n - left n))
      Filter.atTop
      (nhds ((1 / 2 : ℝ) •
          (physicalFlux state + physicalFlux state) -
        (1 / (2 * ratio)) • (state - state))) :=
    (tendsto_const_nhds.smul (hfleft.add hfright)).sub
      (tendsto_const_nhds.smul (hright.sub hleft))
  have htarget : (1 / 2 : ℝ) •
      (physicalFlux state + physicalFlux state) -
        (1 / (2 * ratio)) • (state - state) = physicalFlux state := by
    module
  simpa only [leveque04_laxFriedrichsFlux_fixedRatio ratio
      (cellWidth _) hratio (hwidth _),
    leveque04_centeredFlux, htarget] using hlimit

end NumStability
