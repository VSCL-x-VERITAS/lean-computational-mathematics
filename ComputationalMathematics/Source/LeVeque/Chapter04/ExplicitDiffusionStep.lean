/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation10DiffusionFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, equations (4.11) and (4.12): explicit diffusion update

Substituting the two neighboring diffusion interface fluxes into the
conservative update yields (4.11). A constant interface coefficient gives the
standard centered second difference (4.12).
-/

namespace NumStability

/-- Conservative forward-time update using the Chapter 4 diffusion flux at
the left and right faces of cell `i`. -/
noncomputable def leveque04_explicitDiffusionStep
    (timeStep cellWidth : ℝ)
    (interfaceDiffusivity cellAverage : ℤ → ℝ) (i : ℤ) : ℝ :=
  conservativeFluxDifferenceUpdateInt (timeStep / cellWidth) cellAverage
    (leveque04_diffusionInterfaceFlux interfaceDiffusivity cellAverage cellWidth) i

/-- Expanded variable-coefficient explicit diffusion formula (4.11). -/
theorem leveque04_equation11
    (timeStep cellWidth : ℝ)
    (interfaceDiffusivity cellAverage : ℤ → ℝ) (i : ℤ)
    (hwidth : 0 < cellWidth) :
    leveque04_explicitDiffusionStep timeStep cellWidth
        interfaceDiffusivity cellAverage i =
      cellAverage i + timeStep / cellWidth ^ 2 *
        (interfaceDiffusivity (i + 1) *
            (cellAverage (i + 1) - cellAverage i) -
          interfaceDiffusivity i *
            (cellAverage i - cellAverage (i - 1))) := by
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_explicitDiffusionStep,
    conservativeFluxDifferenceUpdateInt, smul_eq_mul,
    leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux,
    add_sub_cancel_right]
  field_simp
  ring

/-- With constant diffusivity, (4.11) is the centered second-difference
update displayed as (4.12). -/
theorem leveque04_equation12
    (timeStep cellWidth diffusivity : ℝ)
    (cellAverage : ℤ → ℝ) (i : ℤ) (hwidth : 0 < cellWidth) :
    leveque04_explicitDiffusionStep timeStep cellWidth
        (fun _ => diffusivity) cellAverage i =
      cellAverage i + timeStep * diffusivity / cellWidth ^ 2 *
        (cellAverage (i - 1) - 2 * cellAverage i + cellAverage (i + 1)) := by
  rw [leveque04_equation11 timeStep cellWidth _ cellAverage i hwidth]
  ring

end NumStability
