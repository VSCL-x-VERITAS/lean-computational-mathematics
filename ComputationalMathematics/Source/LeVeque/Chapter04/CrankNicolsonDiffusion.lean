/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation10DiffusionFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: Crank–Nicolson diffusion flux and equation (4.13)

The interface flux averages the spatially centered Fick fluxes from the old
and new levels. The equation is implicit in the new cell values; the algebra
below does not assert existence or stability of a solution.
-/

namespace NumStability

/-- The interface flux halfway between time levels, formed by averaging the
two discrete diffusion fluxes of (4.10). -/
noncomputable def leveque04_crankNicolsonInterfaceFlux
    (interfaceDiffusivity : ℤ → ℝ) (cellWidth : ℝ)
    (before after : ℤ → ℝ) (i : ℤ) : ℝ :=
  (leveque04_diffusionInterfaceFlux interfaceDiffusivity before cellWidth i +
    leveque04_diffusionInterfaceFlux interfaceDiffusivity after cellWidth i) / 2

/-- The time-centered flux displayed after (4.13), with one shared interface
coefficient at both time levels. -/
theorem leveque04_crankNicolson_flux
    (interfaceDiffusivity : ℤ → ℝ) (cellWidth : ℝ)
    (before after : ℤ → ℝ) (i : ℤ) (hwidth : 0 < cellWidth) :
    leveque04_crankNicolsonInterfaceFlux interfaceDiffusivity cellWidth
        before after i =
      -(1 / (2 * cellWidth)) *
        (interfaceDiffusivity i * (before i - before (i - 1)) +
          interfaceDiffusivity i * (after i - after (i - 1))) := by
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  simp only [leveque04_crankNicolsonInterfaceFlux,
    leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux]
  field_simp
  ring

/-- The implicit conservative update using the time-centered interface flux. -/
def IsLeveque04CrankNicolsonStep
    (timeStep cellWidth : ℝ) (interfaceDiffusivity before after : ℤ → ℝ) : Prop :=
  0 < cellWidth ∧ ∀ i,
    after i = conservativeFluxDifferenceUpdateInt (timeStep / cellWidth)
      before
      (leveque04_crankNicolsonInterfaceFlux interfaceDiffusivity cellWidth before after) i

/-- The conservative time-centered update expands to the right side of the
printed implicit diffusion equation (4.13). -/
theorem leveque04_crankNicolson_update_eq
    (timeStep cellWidth : ℝ) (interfaceDiffusivity before after : ℤ → ℝ)
    (i : ℤ) (hwidth : 0 < cellWidth) :
    conservativeFluxDifferenceUpdateInt (timeStep / cellWidth) before
        (leveque04_crankNicolsonInterfaceFlux interfaceDiffusivity cellWidth before after) i =
      before i + timeStep / (2 * cellWidth ^ 2) *
        (interfaceDiffusivity (i + 1) * (before (i + 1) - before i) -
          interfaceDiffusivity i * (before i - before (i - 1)) +
          interfaceDiffusivity (i + 1) * (after (i + 1) - after i) -
          interfaceDiffusivity i * (after i - after (i - 1))) := by
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  simp only [conservativeFluxDifferenceUpdateInt, smul_eq_mul,
    leveque04_crankNicolsonInterfaceFlux,
    leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux,
    add_sub_cancel_right]
  field_simp
  ring

/-- Equation (4.13) is exactly the conservative update with the
Crank–Nicolson flux, for positive cell width. -/
theorem leveque04_equation13_iff
    (timeStep cellWidth : ℝ) (interfaceDiffusivity before after : ℤ → ℝ)
    (hwidth : 0 < cellWidth) :
    IsLeveque04CrankNicolsonStep timeStep cellWidth
        interfaceDiffusivity before after ↔
      ∀ i, after i = before i + timeStep / (2 * cellWidth ^ 2) *
        (interfaceDiffusivity (i + 1) * (before (i + 1) - before i) -
          interfaceDiffusivity i * (before i - before (i - 1)) +
          interfaceDiffusivity (i + 1) * (after (i + 1) - after i) -
          interfaceDiffusivity i * (after i - after (i - 1))) := by
  simp only [IsLeveque04CrankNicolsonStep, hwidth, true_and,
    leveque04_crankNicolson_update_eq timeStep cellWidth
      interfaceDiffusivity before after _ hwidth]

end NumStability
