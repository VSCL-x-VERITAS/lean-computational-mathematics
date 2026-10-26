/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictor
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42UnitCFL
import Mathlib.Tactic.Module

/-!
# LeVeque Chapter 4, Exercise 4.2(b): other unit-CFL methods

For scalar constant positive advection, both the Lax–Friedrichs update
and the two-step Lax–Wendroff/Richtmyer predictor flux reduce to the
same exact one-cell shift at Courant number one.
-/

namespace NumStability

/-- Physical flux for one-component constant-speed advection. -/
def leveque04_scalarLinearPhysicalFlux
    (speed : ℝ) (state : Fin 1 → ℝ) : Fin 1 → ℝ :=
  speed • state

/-- Lax–Friedrichs (4.20) becomes an exact one-cell shift at
positive-speed unit CFL. -/
theorem leveque04_exercise42_laxFriedrichs_unitShift
    (speed timeStep cellWidth : ℝ)
    (_hspeed : 0 < speed) (htime : 0 < timeStep)
    (hwidth : 0 < cellWidth) (hcfl : speed * timeStep = cellWidth)
    (old : ℤ → (Fin 1 → ℝ)) (i : ℤ) :
    leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep cellWidth
            (leveque04_scalarLinearPhysicalFlux speed)) old) i 0 =
      old (i - 1) 0 := by
  rw [leveque04_equation20 timeStep cellWidth
    (leveque04_scalarLinearPhysicalFlux speed) old i 0 htime hwidth]
  have hratio : speed * timeStep / cellWidth = 1 := by
    rw [hcfl, div_self hwidth.ne']
  simp only [leveque04_scalarLinearPhysicalFlux,
    Pi.smul_apply, smul_eq_mul]
  calc
    _ = (old (i - 1) 0 + old (i + 1) 0) / 2 -
        (speed * timeStep / cellWidth) / 2 *
          (old (i + 1) 0 - old (i - 1) 0) := by ring
    _ = old (i - 1) 0 := by rw [hratio]; ring

/-- At unit CFL the half-time Richtmyer predictor at a face is
the upwind state on the left. -/
theorem leveque04_richtmyerPredictor_unitCFL
    (speed timeStep cellWidth : ℝ)
    (hwidth : 0 < cellWidth) (hcfl : speed * timeStep = cellWidth)
    (left right : Fin 1 → ℝ) :
    leveque04_richtmyerPredictor timeStep cellWidth
      (leveque04_scalarLinearPhysicalFlux speed) left right = left := by
  have hratio : speed * timeStep / cellWidth = 1 := by
    rw [hcfl, div_self hwidth.ne']
  ext k
  rw [leveque04_equation23]
  simp only [leveque04_scalarLinearPhysicalFlux,
    Pi.smul_apply, smul_eq_mul]
  calc
    _ = (left k + right k) / 2 -
        (speed * timeStep / cellWidth) / 2 * (right k - left k) := by ring
    _ = left k := by rw [hratio]; ring

/-- The two-step Lax–Wendroff method in its Richtmyer form also
becomes the exact one-cell shift at unit CFL. -/
theorem leveque04_exercise42_richtmyer_unitShift
    (speed timeStep cellWidth : ℝ)
    (_hspeed : 0 < speed) (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = cellWidth)
    (old : ℤ → (Fin 1 → ℝ)) (i : ℤ) :
    leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux timeStep cellWidth
            (leveque04_scalarLinearPhysicalFlux speed)) old) i =
      old (i - 1) := by
  have hface (j : ℤ) :
      leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux timeStep cellWidth
            (leveque04_scalarLinearPhysicalFlux speed)) old j =
        speed • old (j - 1) := by
    simp only [leveque04_localInterfaceFlux,
      leveque04_richtmyerFlux]
    rw [leveque04_richtmyerPredictor_unitCFL speed timeStep
      cellWidth hwidth hcfl]
    rfl
  have hratio : timeStep / cellWidth * speed = 1 := by
    rw [show timeStep / cellWidth * speed =
      speed * timeStep / cellWidth by ring, hcfl, div_self hwidth.ne']
  simp only [leveque04_finiteVolumeUpdate,
    conservativeFluxDifferenceUpdateInt]
  rw [hface (i + 1), hface i]
  have hi : i + 1 - 1 = i := by omega
  rw [hi, smul_sub, smul_smul, smul_smul, hratio]
  simp

/-- Both methods preserve the exact translated cell averages at
positive-speed unit CFL, as in the setup of Exercise 4.2. -/
theorem leveque04_exercise42_otherMethods_exactAverages
    (speed timeStep cellWidth distance : ℝ)
    (hspeed : 0 < speed) (htime : 0 < timeStep)
    (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = cellWidth)
    (profile : ℝ → Fin 1 → ℝ) (i : ℤ) :
    let old := CFLUnitShift.averaged cellWidth hwidth profile distance
    leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep cellWidth
            (leveque04_scalarLinearPhysicalFlux speed)) old) i 0 =
        CFLUnitShift.averaged cellWidth hwidth profile
          (distance + speed * timeStep) i 0 ∧
      leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux timeStep cellWidth
            (leveque04_scalarLinearPhysicalFlux speed)) old) i =
        CFLUnitShift.averaged cellWidth hwidth profile
          (distance + speed * timeStep) i := by
  dsimp only
  constructor
  · rw [leveque04_exercise42_laxFriedrichs_unitShift speed timeStep
      cellWidth hspeed htime hwidth hcfl,
      hcfl, CFLUnitShift.averaged_eq_shift]
  · rw [leveque04_exercise42_richtmyer_unitShift speed timeStep
      cellWidth hspeed hwidth hcfl,
      hcfl, CFLUnitShift.averaged_eq_shift]

/-- Exercise 4.2(b), with a locally integrable physical profile and positive
mesh parameters. The unrestricted integral identities remain available in
`leveque04_exercise42_otherMethods_exactAverages`. -/
theorem leveque04_exercise42_otherMethods_exactAverages_integrable
    (speed timeStep cellWidth distance : ℝ)
    (hspeed : 0 < speed) (htime : 0 < timeStep) (hwidth : 0 < cellWidth)
    (hcfl : speed * timeStep = cellWidth) (profile : ℝ → Fin 1 → ℝ)
    (_hintegrable : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (i : ℤ) :
    let old := CFLUnitShift.averaged cellWidth hwidth profile distance
    leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux timeStep cellWidth
            (leveque04_scalarLinearPhysicalFlux speed)) old) i 0 =
        CFLUnitShift.averaged cellWidth hwidth profile (distance + speed * timeStep) i 0 ∧
      leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux timeStep cellWidth
            (leveque04_scalarLinearPhysicalFlux speed)) old) i =
        CFLUnitShift.averaged cellWidth hwidth profile (distance + speed * timeStep) i :=
  leveque04_exercise42_otherMethods_exactAverages speed timeStep cellWidth distance
    hspeed htime hwidth hcfl profile i

end NumStability
