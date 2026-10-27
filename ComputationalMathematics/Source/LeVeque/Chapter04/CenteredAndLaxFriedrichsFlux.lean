/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.LocalNumericalFlux
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LaxFriedrichsFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredScalarAdvection

/-!
# LeVeque Chapter 4, equations (4.18)–(4.21)

The centered flux is the arithmetic mean of the physical fluxes on the two
sides of an interface. The Lax–Friedrichs flux adds a scaled state jump.
Both are inserted into the same conservative flux-difference update.
-/

namespace NumStability

/-- The centered numerical flux displayed in (4.18). -/
theorem leveque04_equation18 {m : ℕ}
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) (k : Fin m) :
    leveque04_centeredFlux physicalFlux left right k =
      (physicalFlux left k + physicalFlux right k) / 2 := by
  simp [leveque04_centeredFlux, Pi.smul_apply, smul_eq_mul, div_eq_mul_inv]
  ring

/-- Inserting the centered flux into the conservative step cancels the
physical flux at the middle cell, giving the three-point formula (4.19). -/
theorem leveque04_equation19 {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (cellAverage : ℤ → (Fin m → ℝ)) (i : ℤ) (k : Fin m)
    (hwidth : 0 < cellWidth) :
    leveque04_finiteVolumeUpdate timeStep cellWidth cellAverage
        (leveque04_localInterfaceFlux (leveque04_centeredFlux physicalFlux)
          cellAverage) i k =
      cellAverage i k - timeStep / (2 * cellWidth) *
        (physicalFlux (cellAverage (i + 1)) k -
          physicalFlux (cellAverage (i - 1)) k) := by
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_finiteVolumeUpdate, conservativeFluxDifferenceUpdateInt,
    leveque04_localInterfaceFlux, leveque04_centeredFlux,
    Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    add_sub_cancel_right]
  field_simp
  ring

/-- The numerical interface flux displayed in (4.21). -/
theorem leveque04_equation21 {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) (k : Fin m) :
    leveque04_laxFriedrichsFlux timeStep cellWidth physicalFlux left right k =
      (physicalFlux left k + physicalFlux right k) / 2 -
        cellWidth / (2 * timeStep) * (right k - left k) := by
  simp [leveque04_laxFriedrichsFlux, leveque04_centeredFlux,
    Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- With positive time step and cell width, the Lax–Friedrichs interface
flux yields the three-point update (4.20). -/
theorem leveque04_equation20 {m : ℕ}
    (timeStep cellWidth : ℝ)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (cellAverage : ℤ → (Fin m → ℝ)) (i : ℤ) (k : Fin m)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    leveque04_finiteVolumeUpdate timeStep cellWidth cellAverage
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep cellWidth physicalFlux)
          cellAverage) i k =
      (cellAverage (i - 1) k + cellAverage (i + 1) k) / 2 -
        timeStep / (2 * cellWidth) *
          (physicalFlux (cellAverage (i + 1)) k -
            physicalFlux (cellAverage (i - 1)) k) := by
  have htne : timeStep ≠ 0 := ne_of_gt htime
  have hxne : cellWidth ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_finiteVolumeUpdate, conservativeFluxDifferenceUpdateInt,
    leveque04_localInterfaceFlux, leveque04_laxFriedrichsFlux,
    leveque04_centeredFlux, Pi.sub_apply, Pi.add_apply, Pi.smul_apply,
    smul_eq_mul, add_sub_cancel_right]
  field_simp
  ring

/-- The actual centered finite-volume step for scalar advection, represented
in the unique component of a `Fin 1` state. -/
noncomputable def leveque04_centeredScalarAdvectionStep
    (timeStep cellWidth speed : ℝ) (q : ℤ → ℝ) (i : ℤ) : ℝ :=
  centeredScalarAdvectionStep timeStep cellWidth speed q i

/-- Scalar constant-speed advection specialization of (4.19). -/
theorem leveque04_centeredScalarAdvectionStep_eq
    (timeStep cellWidth speed : ℝ) (q : ℤ → ℝ) (i : ℤ)
    (hwidth : 0 < cellWidth) :
    leveque04_centeredScalarAdvectionStep timeStep cellWidth speed q i =
      q i - timeStep / (2 * cellWidth) *
        (speed * q (i + 1) - speed * q (i - 1)) := by
  change leveque04_finiteVolumeUpdate timeStep cellWidth
    (fun j (_ : Fin 1) => q j)
    (leveque04_localInterfaceFlux
      (leveque04_centeredFlux (fun state : Fin 1 → ℝ => speed • state))
      (fun j (_ : Fin 1) => q j)) i 0 = _
  rw [leveque04_equation19
    timeStep cellWidth (fun state : Fin 1 → ℝ => speed • state)
    (fun j (_ : Fin 1) => q j) i 0 hwidth]
  simp only [Pi.smul_apply, smul_eq_mul]

/-- The centered scalar advection stencil on page 73, with speed factored out. -/
theorem leveque04_centeredScalarAdvectionStep_ftcs
    (timeStep cellWidth speed : ℝ) (q : ℤ → ℝ) (i : ℤ)
    (hwidth : 0 < cellWidth) :
    leveque04_centeredScalarAdvectionStep timeStep cellWidth speed q i =
      q i - speed * timeStep / (2 * cellWidth) *
        (q (i + 1) - q (i - 1)) := by
  rw [leveque04_centeredScalarAdvectionStep_eq timeStep cellWidth speed q i hwidth]
  ring

/-- The displayed forward-time centered-space equation is an exact identity
for the numerical step. This does not assert exactness for PDE samples. -/
theorem leveque04_centeredScalarAdvectionStep_residual_zero
    (timeStep cellWidth speed : ℝ) (q : ℤ → ℝ) (i : ℤ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth) :
    (leveque04_centeredScalarAdvectionStep timeStep cellWidth speed q i - q i) /
        timeStep +
      speed * ((q (i + 1) - q (i - 1)) / (2 * cellWidth)) = 0 := by
  rw [leveque04_centeredScalarAdvectionStep_eq timeStep cellWidth speed q i hwidth]
  have hdt : timeStep ≠ 0 := ne_of_gt htime
  have hdx : cellWidth ≠ 0 := ne_of_gt hwidth
  field_simp
  ring

end NumStability
