/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Topology.Instances.Real.Lemmas

/-!
# LeVeque Chapter 4: viscosity in the Lax–Friedrichs flux

The correction in (4.21) is the diffusion flux with coefficient
`beta = dx²/(2 dt)`. At a fixed positive mesh ratio `dt/dx`, this
coefficient tends to zero linearly with the cell width.
-/

namespace NumStability

/-- Artificial diffusion coefficient read from (4.21). -/
noncomputable def leveque04_laxFriedrichsViscosity
    (timeStep cellWidth : ℝ) : ℝ :=
  cellWidth ^ 2 / (2 * timeStep)

/-- The Lax–Friedrichs correction is exactly a discrete diffusion flux
with coefficient `dx²/(2dt)`. -/
theorem leveque04_laxFriedrichsFlux_eq_viscous
    {m : ℕ} (timeStep cellWidth : ℝ)
    (hwidth : 0 < cellWidth)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) :
    leveque04_laxFriedrichsFlux timeStep cellWidth
        physicalFlux left right =
      leveque04_centeredFlux physicalFlux left right -
        (leveque04_laxFriedrichsViscosity timeStep cellWidth /
          cellWidth) • (right - left) := by
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  have hcoeff : cellWidth / (2 * timeStep) =
      leveque04_laxFriedrichsViscosity timeStep cellWidth / cellWidth := by
    by_cases htime : timeStep = 0
    · subst timeStep
      simp [leveque04_laxFriedrichsViscosity]
    · simp only [leveque04_laxFriedrichsViscosity]
      field_simp [hne, htime]
  unfold leveque04_laxFriedrichsFlux
  rw [hcoeff]

/-- At fixed positive ratio `dt/dx=r`, the artificial diffusion
coefficient is `dx/(2r)`. -/
theorem leveque04_laxFriedrichsViscosity_fixedRatio
    (ratio cellWidth : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < cellWidth) :
    leveque04_laxFriedrichsViscosity (ratio * cellWidth) cellWidth =
      cellWidth / (2 * ratio) := by
  have hrne : ratio ≠ 0 := ne_of_gt hratio
  have hwne : cellWidth ≠ 0 := ne_of_gt hwidth
  unfold leveque04_laxFriedrichsViscosity
  field_simp

/-- Under any positive-width refinement with fixed positive mesh ratio,
the viscosity coefficient tends to zero. -/
theorem leveque04_laxFriedrichsViscosity_tendsto_zero
    (ratio : ℝ) (hratio : 0 < ratio)
    (cellWidth : ℕ → ℝ)
    (hwidth : ∀ n, 0 < cellWidth n)
    (hrefine : Filter.Tendsto cellWidth Filter.atTop (nhds 0)) :
    Filter.Tendsto
      (fun n => leveque04_laxFriedrichsViscosity
        (ratio * cellWidth n) (cellWidth n))
      Filter.atTop (nhds 0) := by
  have hlimit : Filter.Tendsto
      (fun n => cellWidth n / (2 * ratio))
      Filter.atTop (nhds 0) := by
    simpa only [zero_div] using hrefine.div_const (2 * ratio)
  have hfun :
      (fun n => leveque04_laxFriedrichsViscosity
        (ratio * cellWidth n) (cellWidth n)) =
        (fun n => cellWidth n / (2 * ratio)) := by
    funext n
    exact leveque04_laxFriedrichsViscosity_fixedRatio ratio
      (cellWidth n) hratio (hwidth n)
  rw [hfun]
  exact hlimit

end NumStability
