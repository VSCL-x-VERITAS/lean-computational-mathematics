/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42CertifiedAcousticZero
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates

/-!
# LeVeque Chapter 4, Exercise 4.2: acoustic characteristic cell averages

The exact constant-coefficient solution translates the left and right
characteristic profiles in opposite directions. The coordinatewise
averages inherit exact one-cell shifts at sound-speed Courant one.
-/

namespace NumStability

/-- The left-going translation of a scalar coordinate has an exact
one-cell right-index shift when its travel distance is one width. -/
theorem leveque04_averaged_leftShift
    (h : ℝ) (hh : 0 < h) (profile : ℝ → Fin 2 → ℝ)
    (distance : ℝ) (j : ℤ) :
    CFLUnitShift.averaged h hh profile (distance - h) j =
      CFLUnitShift.averaged h hh profile distance (j + 1) := by
  have hshift := CFLUnitShift.averaged_eq_shift h hh profile
    (distance - h) (j + 1)
  simpa only [sub_add_cancel, add_sub_cancel_right] using hshift.symm

/-- Exact averages of the two characteristic profiles at travel
distance `distance`; coordinate zero moves left, coordinate one right. -/
noncomputable def leveque04_acousticCharacteristicAverages
    (h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ) (distance : ℝ) (j : ℤ) : Fin 2 → ℝ :=
  ![CFLUnitShift.averaged h hh profile (-distance) j 0,
    CFLUnitShift.averaged h hh profile distance j 1]

/-- The two coordinate cell averages at the next unit-CFL time are
exactly the opposing one-cell shifts of the previous averages. -/
theorem leveque04_acousticCharacteristicAverages_unitShift
    (h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ) (distance : ℝ) (j : ℤ) :
    leveque04_acousticCharacteristicAverages h hh profile (distance + h) j 0 =
        leveque04_acousticCharacteristicAverages h hh profile distance (j + 1) 0 ∧
      leveque04_acousticCharacteristicAverages h hh profile (distance + h) j 1 =
        leveque04_acousticCharacteristicAverages h hh profile distance (j - 1) 1 := by
  constructor
  · dsimp [leveque04_acousticCharacteristicAverages]
    have hshift := leveque04_averaged_leftShift h hh profile
      (-distance) j
    have hneg : -(distance + h) = -distance - h := by ring
    rw [hneg]
    exact congrFun hshift 0
  · dsimp [leveque04_acousticCharacteristicAverages]
    exact congrFun (CFLUnitShift.averaged_eq_shift h hh profile
      distance j) 1

/-- The coordinate form of the exact acoustic field translated by
distance `c t` from its initial characteristic profiles. -/
def leveque04_acousticTranslatedCoordinates
    (profile : ℝ → Fin 2 → ℝ) (distance x : ℝ) : Fin 2 → ℝ :=
  ![profile (x + distance) 0, profile (x - distance) 1]

/-- The acoustic state recovered from two characteristic profiles at
physical time `t`, with opposite travel distances `c t`. -/
noncomputable def leveque04_acousticCharacteristicField
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (profile : ℝ → Fin 2 → ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  (leveque04_acousticEigenbasis density soundSpeed himpedance).equivFun.symm
    (leveque04_acousticTranslatedCoordinates profile (soundSpeed * t) x)

/-- Every initial pressure--velocity profile is recovered at time zero
by choosing its two acoustic characteristic coordinates. -/
theorem leveque04_acousticCharacteristicField_initial
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (initial : ℝ → Fin 2 → ℝ) (x : ℝ) :
    leveque04_acousticCharacteristicField density soundSpeed himpedance
        (fun ξ => (leveque04_acousticEigenbasis density soundSpeed
          himpedance).equivFun (initial ξ)) x 0 = initial x := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  simp only [leveque04_acousticCharacteristicField,
    leveque04_acousticTranslatedCoordinates,
    mul_zero, add_zero, sub_zero]
  change basis.equivFun.symm (basis.equivFun (initial x)) = initial x
  exact basis.equivFun.symm_apply_apply _

/-- The characteristic coordinates of any locally integrable initial
pressure--velocity profile remain locally integrable. -/
theorem leveque04_acousticCharacteristicProfile_intervalIntegrable
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

/-- Differentiable characteristic profiles give an actual classical
solution of the zero-background physical acoustics system. -/
theorem leveque04_acousticCharacteristicField_solves
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (profile : ℝ → Fin 2 → ℝ)
    (hdiff : ∀ p y, DifferentiableAt ℝ (fun x => profile x p) y)
    (x t : ℝ) :
    IsConstantCoefficientLinearSystemSolutionAt
      (leveque04_acousticCharacteristicField density soundSpeed
        himpedance profile)
      (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2)
        density 0) x t := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  have hcoords (ξ τ : ℝ) :
      basis.equivFun
          (leveque04_acousticCharacteristicField density soundSpeed
            himpedance profile ξ τ) =
        leveque04_acousticTranslatedCoordinates profile
          (soundSpeed * τ) ξ := by
    change basis.equivFun (basis.equivFun.symm _) = _
    exact basis.equivFun.apply_symm_apply _
  apply (constantCoefficientSystem_iff_eigenbasisAdvection
    (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2) density 0)
    basis (leveque04_acousticSpeeds 0 soundSpeed)
    (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
    (leveque04_acousticCharacteristicField density soundSpeed himpedance
      profile) x t).2
  intro p
  fin_cases p
  · simp only [hcoords, leveque04_acousticTranslatedCoordinates,
      leveque04_acousticSpeeds, zero_sub] at ⊢
    have hderiv : HasDerivAt (fun ξ => profile ξ 0)
        (deriv (fun ξ => profile ξ 0) (x + soundSpeed * t))
        (x - (-soundSpeed) * t) := by
      convert (hdiff 0 (x + soundSpeed * t)).hasDerivAt using 1 <;> ring
    have htravel := travelingWave_isLinearAdvectionSolutionAt
      (-soundSpeed) x t hderiv
    have hfun : travelingWave (fun ξ => profile ξ 0) (-soundSpeed) =
        (fun ξ τ => profile (ξ + soundSpeed * τ) 0) := by
      funext ξ τ
      simp [travelingWave, neg_mul, sub_neg_eq_add]
    rw [hfun] at htravel
    exact htravel
  · simp only [hcoords, leveque04_acousticTranslatedCoordinates,
      leveque04_acousticSpeeds, zero_add] at ⊢
    have htravel := travelingWave_isLinearAdvectionSolutionAt
      soundSpeed x t
      ((hdiff 1 (x - soundSpeed * t)).hasDerivAt)
    simpa [travelingWave] using htravel

/-- For arbitrary locally integrable profiles, the same translated
acoustic field is an exact rectangle conservation-law solution. This
includes discontinuous initial data whose classical derivatives need
not exist. -/
theorem leveque04_acousticCharacteristicField_rectangleSolution
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b) :
    IsRectangleConservationLawSolution
      (leveque04_acousticCharacteristicField density soundSpeed
        himpedance profile)
      (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2)
        density 0).mulVec := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  let speeds := leveque04_acousticSpeeds 0 soundSpeed
  let coefficient := convectedLinearAcousticsMatrix
    (density * soundSpeed ^ 2) density 0
  let mode (p : Fin 2) := eigenmodeTravelingWave
    (fun x => profile x p) (speeds p) (basis p)
  have hmode (p : Fin 2) :
      IsRectangleConservationLawSolution (mode p) coefficient.mulVec := by
    exact eigenmodeTravelingWave_isRectangleSolution coefficient
      (fun x => profile x p)
      (fun a b => (intervalIntegrable_pi_iff profile a b).1
        (hprofile a b) p)
      (speeds p) (basis p)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0
        himpedance p)
  have hsum (x t : ℝ) :
      (∑ p, mode p x t) =
        leveque04_acousticCharacteristicField density soundSpeed
          himpedance profile x t := by
    have hcoords (p : Fin 2) :
        basis.equivFun
            (leveque04_acousticCharacteristicField density soundSpeed
              himpedance profile x t) p =
          profile (x - speeds p * t) p := by
      change basis.equivFun (basis.equivFun.symm
        (leveque04_acousticTranslatedCoordinates profile
          (soundSpeed * t) x)) p = _
      rw [basis.equivFun.apply_symm_apply]
      fin_cases p <;>
        simp [leveque04_acousticTranslatedCoordinates,
          speeds, leveque04_acousticSpeeds, neg_mul, sub_neg_eq_add]
    rw [← basis.sum_equivFun
      (leveque04_acousticCharacteristicField density soundSpeed
        himpedance profile x t)]
    apply Finset.sum_congr rfl
    intro p _
    simp only [mode, eigenmodeTravelingWave, travelingWave]
    rw [hcoords p]
  have hrect := finite_sum_isRectangleSolution coefficient mode hmode
  simpa only [coefficient, hsum] using hrect

/-- Locally integrable initial characteristic profiles remain locally
integrable after their two opposite translations. -/
theorem leveque04_acousticTranslatedCoordinates_intervalIntegrable
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (distance left right : ℝ) :
    IntervalIntegrable
      (leveque04_acousticTranslatedCoordinates profile distance)
      MeasureTheory.volume left right := by
  apply (intervalIntegrable_pi_iff _ left right).2
  intro p
  fin_cases p
  · have hplus := (hprofile (left + distance) (right + distance)).comp_add_right
      distance
    have hscalar := (intervalIntegrable_pi_iff
      (fun x => profile (x + distance)) left right).1
        (by simpa only [add_sub_cancel_right] using hplus) 0
    simpa [leveque04_acousticTranslatedCoordinates] using hscalar
  · have hminus := (hprofile (left - distance) (right - distance)).comp_sub_right
      distance
    have hscalar := (intervalIntegrable_pi_iff
      (fun x => profile (x - distance)) left right).1
        (by simpa only [sub_add_cancel] using hminus) 1
    simpa [leveque04_acousticTranslatedCoordinates] using hscalar

/-- The reconstructed physical pressure--velocity solution inherits
interval integrability from its characteristic profiles. -/
theorem leveque04_acousticTranslatedField_intervalIntegrable
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (distance left right : ℝ) :
    IntervalIntegrable
      (fun x => (leveque04_acousticEigenbasis density soundSpeed
        himpedance).equivFun.symm
          (leveque04_acousticTranslatedCoordinates profile distance x))
      MeasureTheory.volume left right := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  have hcoords := leveque04_acousticTranslatedCoordinates_intervalIntegrable
    profile hprofile distance left right
  constructor
  · exact (basis.equivFun.symm.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
      hcoords.1
  · exact (basis.equivFun.symm.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
      hcoords.2

/-- For any integrable exact acoustic field, averaging then changing to
characteristic coordinates agrees with the two translated scalar averages. -/
theorem leveque04_acousticAverage_coordinates
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ) (distance : ℝ) (j : ℤ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b) :
    (leveque04_acousticEigenbasis density soundSpeed himpedance).equivFun
        (finiteVolumeCellAverageOn (CFLUnitShift.grid h hh)
          (fun x => (leveque04_acousticEigenbasis density soundSpeed
            himpedance).equivFun.symm
              (leveque04_acousticTranslatedCoordinates profile distance x)) j) =
      leveque04_acousticCharacteristicAverages h hh profile distance j := by
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  let coordinates := leveque04_acousticTranslatedCoordinates profile distance
  have hfield := leveque04_acousticTranslatedField_intervalIntegrable
    density soundSpeed himpedance profile hprofile distance
    ((CFLUnitShift.grid h hh).cellLeft j)
    ((CFLUnitShift.grid h hh).cellRight j)
  change basis.equivFun
      (oneDimensionalCellAverage (fun x => basis.equivFun.symm (coordinates x))
        ((CFLUnitShift.grid h hh).cellLeft j)
        ((CFLUnitShift.grid h hh).cellRight j)) =
    leveque04_acousticCharacteristicAverages h hh profile distance j
  rw [← oneDimensionalCellAverage_linearEquiv basis.equivFun
    (fun x => basis.equivFun.symm (coordinates x))
    _ _ hfield]
  simp only [LinearEquiv.apply_symm_apply]
  have hcoord : IntervalIntegrable coordinates MeasureTheory.volume
      ((CFLUnitShift.grid h hh).cellLeft j)
      ((CFLUnitShift.grid h hh).cellRight j) := by
    constructor
    · have hc :=
        (basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
          hfield.1
      change MeasureTheory.Integrable
        (fun x => basis.equivFun (basis.equivFun.symm (coordinates x))) _ at hc
      simpa only [LinearEquiv.apply_symm_apply] using hc
    · have hc :=
        (basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap).integrable_comp
          hfield.2
      change MeasureTheory.Integrable
        (fun x => basis.equivFun (basis.equivFun.symm (coordinates x))) _ at hc
      simpa only [LinearEquiv.apply_symm_apply] using hc
  funext p
  fin_cases p
  · change oneDimensionalCellAverage coordinates
        ((CFLUnitShift.grid h hh).cellLeft j)
        ((CFLUnitShift.grid h hh).cellRight j) 0 =
      leveque04_acousticCharacteristicAverages h hh profile distance j 0
    rw [oneDimensionalCellAverage_apply coordinates _ _ hcoord 0]
    have hplus : IntervalIntegrable (fun x => profile (x + distance))
        MeasureTheory.volume
        ((CFLUnitShift.grid h hh).cellLeft j)
        ((CFLUnitShift.grid h hh).cellRight j) := by
      simpa only [add_sub_cancel_right] using
        (hprofile (((CFLUnitShift.grid h hh).cellLeft j) + distance)
          (((CFLUnitShift.grid h hh).cellRight j) + distance)).comp_add_right
          distance
    simp [coordinates, leveque04_acousticCharacteristicAverages,
      leveque04_acousticTranslatedCoordinates, CFLUnitShift.averaged,
      finiteVolumeCellAverageOn, sub_neg_eq_add]
    exact (oneDimensionalCellAverage_apply
      (fun x => profile (x + distance)) _ _ hplus 0).symm
  · change oneDimensionalCellAverage coordinates
        ((CFLUnitShift.grid h hh).cellLeft j)
        ((CFLUnitShift.grid h hh).cellRight j) 1 =
      leveque04_acousticCharacteristicAverages h hh profile distance j 1
    rw [oneDimensionalCellAverage_apply coordinates _ _ hcoord 1]
    have hminus : IntervalIntegrable (fun x => profile (x - distance))
        MeasureTheory.volume
        ((CFLUnitShift.grid h hh).cellLeft j)
        ((CFLUnitShift.grid h hh).cellRight j) := by
      simpa only [sub_add_cancel] using
        (hprofile (((CFLUnitShift.grid h hh).cellLeft j) - distance)
          (((CFLUnitShift.grid h hh).cellRight j) - distance)).comp_sub_right
          distance
    simp [coordinates, leveque04_acousticCharacteristicAverages,
      leveque04_acousticTranslatedCoordinates, CFLUnitShift.averaged,
      finiteVolumeCellAverageOn]
    exact (oneDimensionalCellAverage_apply
      (fun x => profile (x - distance)) _ _ hminus 1).symm

/-- Physical pressure--velocity cell averages of the exact translated
two-characteristic acoustic solution. -/
noncomputable def leveque04_acousticExactCellAverage
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ) (distance : ℝ) (j : ℤ) : Fin 2 → ℝ :=
  finiteVolumeCellAverageOn (CFLUnitShift.grid h hh)
    (fun x => (leveque04_acousticEigenbasis density soundSpeed
      himpedance).equivFun.symm
        (leveque04_acousticTranslatedCoordinates profile distance x)) j

/-- The exact physical cell averages have the previously computed
characteristic-coordinate cell averages. -/
theorem leveque04_acousticExactCellAverage_coordinates
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (distance : ℝ) (j : ℤ) :
    (leveque04_acousticEigenbasis density soundSpeed himpedance).equivFun
      (leveque04_acousticExactCellAverage density soundSpeed himpedance
        h hh profile distance j) =
      leveque04_acousticCharacteristicAverages h hh profile distance j :=
  leveque04_acousticAverage_coordinates density soundSpeed himpedance
    h hh profile distance j hprofile

/-- For arbitrary locally integrable characteristic profiles, the
selected zero-background acoustic Godunov step reproduces the exact
physical cell averages after a one-cell sound-speed translation. -/
theorem leveque04_acousticGodunov_exactCellAverages
    (density soundSpeed : ℝ)
    (hspeed : 0 < soundSpeed)
    (himpedance : 0 < acousticImpedance density soundSpeed)
    (h : ℝ) (hh : 0 < h)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (distance : ℝ) (i : ℤ) :
    let basis := leveque04_acousticEigenbasis density soundSpeed
      (ne_of_gt himpedance)
    let old := leveque04_acousticExactCellAverage density soundSpeed
      (ne_of_gt himpedance) h hh profile distance
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0
        (ne_of_gt himpedance)) basis
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0
        (ne_of_gt himpedance))
    conservativeFluxDifferenceUpdateInt (1 / soundSpeed) old
        (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i =
      leveque04_acousticExactCellAverage density soundSpeed
        (ne_of_gt himpedance) h hh profile (distance + h) i := by
  let basis := leveque04_acousticEigenbasis density soundSpeed
    (ne_of_gt himpedance)
  let old := leveque04_acousticExactCellAverage density soundSpeed
    (ne_of_gt himpedance) h hh profile distance
  have hselected := leveque04_linearGodunovWaveStep_selected
    (convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0)
    (leveque04_acoustic_hyperbolic density soundSpeed 0
      (ne_of_gt himpedance)) basis
    (leveque04_acousticSpeeds 0 soundSpeed)
    (leveque04_acousticEigenbasis_eigen density soundSpeed 0
      (ne_of_gt himpedance)) old (1 / soundSpeed) i
  dsimp only at hselected ⊢
  rw [hselected]
  simp only [leveque04_acousticSpeeds, zero_sub, zero_add]
  apply basis.equivFun.injective
  funext p
  fin_cases p
  · change basis.equivFun
        (leveque04_linearGodunovWaveStep basis ![-soundSpeed, soundSpeed]
          (1 / soundSpeed) old i) 0 =
      basis.equivFun
        (leveque04_acousticExactCellAverage density soundSpeed
          (ne_of_gt himpedance) h hh profile (distance + h) i) 0
    calc
      _ = basis.equivFun (old (i + 1)) 0 :=
        leveque04_linearGodunov_negativeUnitShift basis soundSpeed hspeed old i
      _ = leveque04_acousticCharacteristicAverages h hh profile distance
          (i + 1) 0 := by
        exact congrFun (leveque04_acousticExactCellAverage_coordinates
          density soundSpeed (ne_of_gt himpedance) h hh profile hprofile
          distance (i + 1)) 0
      _ = leveque04_acousticCharacteristicAverages h hh profile
          (distance + h) i 0 :=
        (leveque04_acousticCharacteristicAverages_unitShift
          h hh profile distance i).1.symm
      _ = _ := by
        exact (congrFun (leveque04_acousticExactCellAverage_coordinates
          density soundSpeed (ne_of_gt himpedance) h hh profile hprofile
          (distance + h) i) 0).symm
  · change basis.equivFun
        (leveque04_linearGodunovWaveStep basis ![-soundSpeed, soundSpeed]
          (1 / soundSpeed) old i) 1 =
      basis.equivFun
        (leveque04_acousticExactCellAverage density soundSpeed
          (ne_of_gt himpedance) h hh profile (distance + h) i) 1
    calc
      _ = basis.equivFun (old (i - 1)) 1 :=
        leveque04_linearGodunov_positiveUnitShift basis soundSpeed hspeed old i
      _ = leveque04_acousticCharacteristicAverages h hh profile distance
          (i - 1) 1 := by
        exact congrFun (leveque04_acousticExactCellAverage_coordinates
          density soundSpeed (ne_of_gt himpedance) h hh profile hprofile
          distance (i - 1)) 1
      _ = leveque04_acousticCharacteristicAverages h hh profile
          (distance + h) i 1 :=
        (leveque04_acousticCharacteristicAverages_unitShift
          h hh profile distance i).2.symm
      _ = _ := by
        exact (congrFun (leveque04_acousticExactCellAverage_coordinates
          density soundSpeed (ne_of_gt himpedance) h hh profile hprofile
          (distance + h) i) 1).symm

/-- Exercise 4.2(c) in the source's time-step notation: when
`c Δt = Δx`, the certified Godunov update reproduces the exact
pressure--velocity cell averages of the characteristic solution. -/
theorem leveque04_exercise42c_exactAcousticCellAverages
    (density soundSpeed timeStep cellWidth : ℝ)
    (hspeed : 0 < soundSpeed) (hwidth : 0 < cellWidth)
    (himpedance : 0 < acousticImpedance density soundSpeed)
    (hcfl : soundSpeed * timeStep = cellWidth)
    (profile : ℝ → Fin 2 → ℝ)
    (hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b)
    (distance : ℝ) (i : ℤ) :
    let basis := leveque04_acousticEigenbasis density soundSpeed
      (ne_of_gt himpedance)
    let old := leveque04_acousticExactCellAverage density soundSpeed
      (ne_of_gt himpedance) cellWidth hwidth profile distance
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0
        (ne_of_gt himpedance)) basis
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0
        (ne_of_gt himpedance))
    conservativeFluxDifferenceUpdateInt (timeStep / cellWidth) old
        (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i =
      leveque04_acousticExactCellAverage density soundSpeed
        (ne_of_gt himpedance) cellWidth hwidth profile
        (distance + soundSpeed * timeStep) i := by
  have hratio : timeStep / cellWidth = 1 / soundSpeed := by
    apply (div_eq_iff hwidth.ne').mpr
    field_simp [hspeed.ne']
    nlinarith [hcfl]
  rw [hratio, hcfl]
  exact leveque04_acousticGodunov_exactCellAverages
    density soundSpeed hspeed himpedance cellWidth hwidth
    profile hprofile distance i

end NumStability
