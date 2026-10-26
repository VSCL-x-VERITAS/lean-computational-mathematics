/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42CertifiedAcousticSonic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift

/-!
# LeVeque Chapter 4, Exercise 4.2(d): exact sonic acoustic averages

Characteristic profiles translated at the two acoustic speeds give
exact physical cell averages. At sonic background velocity, one speed
is zero and the other has a unit-cell step under a suitable time step.
-/

namespace NumStability

/-- An arbitrary pair of characteristic profiles translated at their
respective signed physical speeds. -/
def leveque04_sonicTranslatedCoordinates
    (speeds : Fin 2 → ℝ) (profile : ℝ → Fin 2 → ℝ)
    (x t : ℝ) : Fin 2 → ℝ :=
  fun p => profile (x - speeds p * t) p

/-- Reconstruct the physical acoustic state from both translated
characteristic profiles. -/
noncomputable def leveque04_sonicAcousticField
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (background : ℝ) (profile : ℝ → Fin 2 → ℝ)
    (x t : ℝ) : Fin 2 → ℝ :=
  (leveque04_acousticEigenbasis density soundSpeed himpedance).equivFun.symm
    (leveque04_sonicTranslatedCoordinates
      (leveque04_acousticSpeeds background soundSpeed) profile x t)

/-- Every initial physical acoustic profile is recovered at time zero
by using its own characteristic coordinates. -/
theorem leveque04_sonicAcousticField_initial
    (density soundSpeed background : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (initial : ℝ → Fin 2 → ℝ) (x : ℝ) :
    leveque04_sonicAcousticField density soundSpeed himpedance background
      (fun ξ => (leveque04_acousticEigenbasis density soundSpeed
        himpedance).equivFun (initial ξ)) x 0 = initial x := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  unfold leveque04_sonicAcousticField leveque04_sonicTranslatedCoordinates
  simp only [mul_zero, sub_zero]
  change basis.equivFun.symm (basis.equivFun (initial x)) = initial x
  exact basis.equivFun.symm_apply_apply _

/-- Characteristic coordinates preserve local integrability of any
initial pressure--velocity profile. -/
theorem leveque04_sonicInitialCoordinates_intervalIntegrable
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (initial : ℝ → Fin 2 → ℝ)
    (hinitial : ∀ a b, IntervalIntegrable initial MeasureTheory.volume a b)
    (a b : ℝ) :
    IntervalIntegrable
      (fun x => (leveque04_acousticEigenbasis density soundSpeed
        himpedance).equivFun (initial x))
      MeasureTheory.volume a b := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  exact ⟨(basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
      (hinitial a b).1,
    (basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
      (hinitial a b).2⟩

/-- Local integrability is preserved by translating each of the two
characteristic profiles at its own speed. -/
theorem leveque04_sonicTranslatedCoordinates_intervalIntegrable
    (speeds : Fin 2 → ℝ) (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (t a b : ℝ) :
    IntervalIntegrable
      (fun x => leveque04_sonicTranslatedCoordinates speeds profile x t)
      MeasureTheory.volume a b := by
  apply (intervalIntegrable_pi_iff _ a b).2
  intro p
  have hshift := (hprofile (a - speeds p * t) (b - speeds p * t)).comp_sub_right
    (speeds p * t)
  have hvector : IntervalIntegrable
      (fun x => profile (x - speeds p * t)) MeasureTheory.volume a b := by
    simpa only [sub_add_cancel] using hshift
  exact (intervalIntegrable_pi_iff _ a b).1 hvector p

/-- The exact acoustic field is a rectangle conservation-law solution
for every pair of locally integrable characteristic profiles. -/
theorem leveque04_sonicAcousticField_rectangleSolution
    (density soundSpeed background : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b) :
    IsRectangleConservationLawSolution
      (leveque04_sonicAcousticField density soundSpeed himpedance
        background profile)
      (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2)
        density background).mulVec := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  let speeds := leveque04_acousticSpeeds background soundSpeed
  let coefficient := convectedLinearAcousticsMatrix
    (density * soundSpeed ^ 2) density background
  let mode (p : Fin 2) := eigenmodeTravelingWave
    (fun x => profile x p) (speeds p) (basis p)
  have hmode (p : Fin 2) :
      IsRectangleConservationLawSolution (mode p) coefficient.mulVec := by
    exact eigenmodeTravelingWave_isRectangleSolution coefficient
      (fun x => profile x p)
      (fun a b => (intervalIntegrable_pi_iff profile a b).1
        (hprofile a b) p)
      (speeds p) (basis p)
      (leveque04_acousticEigenbasis_eigen density soundSpeed
        background himpedance p)
  have hsum (x t : ℝ) :
      (∑ p, mode p x t) =
        leveque04_sonicAcousticField density soundSpeed himpedance
          background profile x t := by
    have hcoords (p : Fin 2) :
        basis.equivFun
            (leveque04_sonicAcousticField density soundSpeed
              himpedance background profile x t) p =
          profile (x - speeds p * t) p := by
      change basis.equivFun (basis.equivFun.symm
        (leveque04_sonicTranslatedCoordinates speeds profile x t)) p = _
      rw [basis.equivFun.apply_symm_apply]
      rfl
    rw [← basis.sum_equivFun
      (leveque04_sonicAcousticField density soundSpeed
        himpedance background profile x t)]
    apply Finset.sum_congr rfl
    intro p _
    simp only [mode, eigenmodeTravelingWave, travelingWave]
    rw [hcoords p]
  have hrect := finite_sum_isRectangleSolution coefficient mode hmode
  simpa only [coefficient, hsum] using hrect

/-- Physical cell averages of the exact acoustic field on the uniform
grid, for arbitrary background velocity. -/
noncomputable def leveque04_sonicExactCellAverage
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (background h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ) (t : ℝ) (j : ℤ) : Fin 2 → ℝ :=
  finiteVolumeCellAverageOn (CFLUnitShift.grid h hh)
    (fun x => leveque04_sonicAcousticField density soundSpeed
      himpedance background profile x t) j

/-- Changing to characteristic coordinates after physical cell
averaging gives scalar averages of the two translated profiles. -/
theorem leveque04_sonicExactCellAverage_coordinates
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (background h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (t : ℝ) (j : ℤ) (p : Fin 2) :
    (leveque04_acousticEigenbasis density soundSpeed himpedance).equivFun
      (leveque04_sonicExactCellAverage density soundSpeed himpedance
        background h hh profile t j) p =
      CFLUnitShift.averaged h hh profile
        (leveque04_acousticSpeeds background soundSpeed p * t) j p := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  let speeds := leveque04_acousticSpeeds background soundSpeed
  let coordinates := fun x => leveque04_sonicTranslatedCoordinates
    speeds profile x t
  have hcoord := leveque04_sonicTranslatedCoordinates_intervalIntegrable
    speeds profile hprofile t
    ((CFLUnitShift.grid h hh).cellLeft j)
    ((CFLUnitShift.grid h hh).cellRight j)
  have hfield : IntervalIntegrable
      (fun x => basis.equivFun.symm (coordinates x)) MeasureTheory.volume
      ((CFLUnitShift.grid h hh).cellLeft j)
      ((CFLUnitShift.grid h hh).cellRight j) := by
    exact ⟨(basis.equivFun.symm.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
        hcoord.1,
      (basis.equivFun.symm.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
        hcoord.2⟩
  change basis.equivFun
      (oneDimensionalCellAverage (fun x => basis.equivFun.symm (coordinates x))
        ((CFLUnitShift.grid h hh).cellLeft j)
        ((CFLUnitShift.grid h hh).cellRight j)) p = _
  rw [← oneDimensionalCellAverage_linearEquiv basis.equivFun
    (fun x => basis.equivFun.symm (coordinates x)) _ _ hfield]
  simp only [LinearEquiv.apply_symm_apply]
  rw [oneDimensionalCellAverage_apply coordinates _ _ hcoord p]
  have htranslated : IntervalIntegrable
      (fun x => profile (x - speeds p * t)) MeasureTheory.volume
      ((CFLUnitShift.grid h hh).cellLeft j)
      ((CFLUnitShift.grid h hh).cellRight j) := by
    have hshift := (hprofile
      (((CFLUnitShift.grid h hh).cellLeft j) - speeds p * t)
      (((CFLUnitShift.grid h hh).cellRight j) - speeds p * t)).comp_sub_right
        (speeds p * t)
    simpa only [sub_add_cancel] using hshift
  change oneDimensionalCellAverage
      (fun x => profile (x - speeds p * t) p)
      ((CFLUnitShift.grid h hh).cellLeft j)
      ((CFLUnitShift.grid h hh).cellRight j) = _
  rw [← oneDimensionalCellAverage_apply
    (fun x => profile (x - speeds p * t)) _ _ htranslated p]
  rfl

/-- A nonzero sonic background `u₀=c` admits exact Godunov cell-average
evolution: the stationary family stays in its cell and the `2c` family
shifts by one cell when `2c Δt=Δx`. -/
theorem leveque04_acousticGodunov_positiveSonic_exactCellAverages
    (density soundSpeed timeStep cellWidth : ℝ)
    (hspeed : 0 < soundSpeed) (hwidth : 0 < cellWidth)
    (himpedance : 0 < acousticImpedance density soundSpeed)
    (hcfl : 2 * soundSpeed * timeStep = cellWidth)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (t : ℝ) (i : ℤ) :
    let basis := leveque04_acousticEigenbasis density soundSpeed
      (ne_of_gt himpedance)
    let old := leveque04_sonicExactCellAverage density soundSpeed
      (ne_of_gt himpedance) soundSpeed cellWidth hwidth profile t
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density soundSpeed
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed soundSpeed
        (ne_of_gt himpedance)) basis
      (leveque04_acousticSpeeds soundSpeed soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed soundSpeed
        (ne_of_gt himpedance))
    conservativeFluxDifferenceUpdateInt (timeStep / cellWidth) old
        (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i =
      leveque04_sonicExactCellAverage density soundSpeed
        (ne_of_gt himpedance) soundSpeed cellWidth hwidth profile
        (t + timeStep) i := by
  let basis := leveque04_acousticEigenbasis density soundSpeed
    (ne_of_gt himpedance)
  let old := leveque04_sonicExactCellAverage density soundSpeed
    (ne_of_gt himpedance) soundSpeed cellWidth hwidth profile t
  have hratio : timeStep / cellWidth = 1 / (2 * soundSpeed) := by
    apply (div_eq_iff hwidth.ne').mpr
    field_simp [hspeed.ne']
    nlinarith [hcfl]
  have hselected := leveque04_acousticGodunov_positiveSonicShifts
    density soundSpeed hspeed (ne_of_gt himpedance) old i
  dsimp only at hselected ⊢
  rw [hratio]
  apply basis.equivFun.injective
  funext p
  fin_cases p
  · change basis.equivFun
        (conservativeFluxDifferenceUpdateInt (1 / (2 * soundSpeed)) old
          (rectangleRiemannInterfaceFlux
            (linearRectangleRiemannInterfaceFluxMethod
              (convectedLinearAcousticsMatrix
                (density * soundSpeed ^ 2) density soundSpeed)
              (leveque04_acoustic_hyperbolic density soundSpeed soundSpeed
                (ne_of_gt himpedance)) basis
              (leveque04_acousticSpeeds soundSpeed soundSpeed)
              (leveque04_acousticEigenbasis_eigen density soundSpeed
                soundSpeed (ne_of_gt himpedance))) old (fun _ => True.intro)) i) 0 =
      basis.equivFun
        (leveque04_sonicExactCellAverage density soundSpeed
          (ne_of_gt himpedance) soundSpeed cellWidth hwidth profile
          (t + timeStep) i) 0
    have hstationary :
        (soundSpeed - soundSpeed) * (t + timeStep) =
          (soundSpeed - soundSpeed) * t := by ring
    calc
      _ = basis.equivFun (old i) 0 := hselected.1
      _ = CFLUnitShift.averaged cellWidth hwidth profile
          ((soundSpeed - soundSpeed) * t) i 0 :=
        leveque04_sonicExactCellAverage_coordinates density soundSpeed
          (ne_of_gt himpedance) soundSpeed cellWidth hwidth profile
          hprofile t i 0
      _ = CFLUnitShift.averaged cellWidth hwidth profile
          ((soundSpeed - soundSpeed) * (t + timeStep)) i 0 := by
        rw [hstationary]
      _ = _ := (leveque04_sonicExactCellAverage_coordinates
        density soundSpeed (ne_of_gt himpedance) soundSpeed
        cellWidth hwidth profile hprofile (t + timeStep) i 0).symm
  · change basis.equivFun
        (conservativeFluxDifferenceUpdateInt (1 / (2 * soundSpeed)) old
          (rectangleRiemannInterfaceFlux
            (linearRectangleRiemannInterfaceFluxMethod
              (convectedLinearAcousticsMatrix
                (density * soundSpeed ^ 2) density soundSpeed)
              (leveque04_acoustic_hyperbolic density soundSpeed soundSpeed
                (ne_of_gt himpedance)) basis
              (leveque04_acousticSpeeds soundSpeed soundSpeed)
              (leveque04_acousticEigenbasis_eigen density soundSpeed
                soundSpeed (ne_of_gt himpedance))) old (fun _ => True.intro)) i) 1 =
      basis.equivFun
        (leveque04_sonicExactCellAverage density soundSpeed
          (ne_of_gt himpedance) soundSpeed cellWidth hwidth profile
          (t + timeStep) i) 1
    have htravel :
        (soundSpeed + soundSpeed) * (t + timeStep) =
          (soundSpeed + soundSpeed) * t + cellWidth := by
      nlinarith [hcfl]
    calc
      _ = basis.equivFun (old (i - 1)) 1 := hselected.2
      _ = CFLUnitShift.averaged cellWidth hwidth profile
          ((soundSpeed + soundSpeed) * t) (i - 1) 1 :=
        leveque04_sonicExactCellAverage_coordinates density soundSpeed
          (ne_of_gt himpedance) soundSpeed cellWidth hwidth profile
          hprofile t (i - 1) 1
      _ = CFLUnitShift.averaged cellWidth hwidth profile
          ((soundSpeed + soundSpeed) * t + cellWidth) i 1 := by
        exact (congrFun (CFLUnitShift.averaged_eq_shift cellWidth hwidth
          profile ((soundSpeed + soundSpeed) * t) i) 1).symm
      _ = CFLUnitShift.averaged cellWidth hwidth profile
          ((soundSpeed + soundSpeed) * (t + timeStep)) i 1 := by
        rw [htravel]
      _ = _ := (leveque04_sonicExactCellAverage_coordinates
        density soundSpeed (ne_of_gt himpedance) soundSpeed
        cellWidth hwidth profile hprofile (t + timeStep) i 1).symm

end NumStability
