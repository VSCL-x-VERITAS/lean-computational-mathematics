/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ScalarUpwindExactAverages
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42SonicExactAverages
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42AcousticExactAverages
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovCharacteristicStep
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsOrderWitness
import ComputationalMathematics.Source.LeVeque.Chapter04.UpwindWavePropagation
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42AcousticAlignment

/-!
# Physical exactness criteria for Exercise 4.2

Exactness predicates and characteristic-alignment criteria for the selected
physical acoustic Godunov update.
-/

namespace NumStability

/-- Universal exactness of the selected certified physical acoustic Godunov
update, initialized with actual averages of arbitrary characteristic profiles.
The invertible acoustic basis parametrizes every locally integrable physical
initial pressure--velocity field. Time, mesh, and background are fixed parameters;
the profile is universally quantified. -/
def IsLeveque04PhysicalAcousticGodunovExact
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (background width : ℝ) (hwidth : 0 < width) (timeStep : ℝ) : Prop :=
  ∀ (profile : ℝ → Fin 2 → ℝ),
    (∀ a b, IntervalIntegrable profile MeasureTheory.volume a b) →
    ∀ (t : ℝ) (j : ℤ),
    let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
    let old := leveque04_sonicExactCellAverage density soundSpeed himpedance
      background width hwidth profile t
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density background
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed background himpedance)
      basis (leveque04_acousticSpeeds background soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed background himpedance)
    conservativeFluxDifferenceUpdateInt (timeStep / width) old
      (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) j =
      leveque04_sonicExactCellAverage density soundSpeed himpedance
        background width hwidth profile (t + timeStep) j

/-- Complete physical-data exactness criterion for the convected acoustic
system. The nonzero-background cases are precisely the two sonic cases. -/
def Leveque04PhysicalAcousticGodunovExactnessCriterion : Prop :=
  ∀ (density soundSpeed background width timeStep : ℝ)
    (_hsound : 0 < soundSpeed) (hwidth : 0 < width) (_htime : 0 < timeStep)
    (himpedance : 0 < acousticImpedance density soundSpeed),
    IsLeveque04PhysicalAcousticGodunovExact density soundSpeed
      (ne_of_gt himpedance) background width hwidth timeStep ↔
    (background = 0 ∧ soundSpeed * timeStep = width) ∨
      ((background = soundSpeed ∨ background = -soundSpeed) ∧
        2 * soundSpeed * timeStep = width)

end NumStability

namespace NumStability

/-- The selected signed Godunov/upwind step inherits the canonical quadratic
necessity test through its verified characteristic recurrence. -/
theorem leveque04_signedUpwindQuadraticExactnessNecessity
    (width timeStep speed : ℝ) (hwidth : 0 < width) (htime : 0 < timeStep)
    (hexact : leveque04_signedUpwindStep timeStep width speed
      (leveque04_quadraticCellAverage width) 0 =
      oneDimensionalCellAverage (fun x : ℝ => (x-speed*timeStep)^2)
        (-width/2) (width/2)) :
    IsLeveque04GridAlignedSpeed speed timeStep width := by
  apply signedUpwind_quadraticAverage_exactness_necessity width timeStep speed hwidth htime
  rw [leveque04_equation35] at hexact
  norm_num [leveque04_quadraticCellAverage, leveque04_leftWaveJump,
    leveque04_rightWaveJump] at hexact
  simp only [leveque04_positiveVelocity, leveque04_negativeVelocity] at hexact
  convert hexact using 1
  ring

theorem leveque04_acousticGodunov_exactness_iff :
    Leveque04PhysicalAcousticGodunovExactnessCriterion := by
  intro density soundSpeed background width timeStep hsound hwidth htime himpedance
  let basis := leveque04_acousticEigenbasis density soundSpeed (ne_of_gt himpedance)
  let speeds := leveque04_acousticSpeeds background soundSpeed
  let coefficient := convectedLinearAcousticsMatrix (density*soundSpeed^2) density background
  constructor
  · intro hexact
    let profile : ℝ → Fin 2 → ℝ := fun x _ => (x+width/2)^2
    have hprofile : ∀ a b, IntervalIntegrable profile MeasureTheory.volume a b :=
      (continuous_pi (fun _ => (continuous_id.add continuous_const).pow 2)).intervalIntegrable
    let old := leveque04_sonicExactCellAverage density soundSpeed (ne_of_gt himpedance)
      background width hwidth profile 0
    have hstep := hexact profile hprofile 0 0
    dsimp only at hstep
    rw [leveque04_linearGodunovWaveStep_selected] at hstep
    have halign (p : Fin 2) : IsLeveque04GridAlignedSpeed (speeds p) timeStep width := by
      have hcoord := congrArg (fun state => basis.equivFun state p) hstep
      dsimp only [basis] at hcoord
      rw [leveque04_linearGodunovWaveStep_characteristic] at hcoord
      have hav (j : ℤ) : basis.equivFun (old j) p = leveque04_quadraticCellAverage width j := by
        dsimp only [basis, old]
        rw [leveque04_sonicExactCellAverage_coordinates density soundSpeed
          (ne_of_gt himpedance) background width hwidth profile hprofile 0 j p]
        simp only [mul_zero]
        change CFLUnitShift.averaged width hwidth
          (fun x : ℝ => fun _ : Fin 2 => (x+width/2)^2) 0 j p = _
        rw [CFLUnitShift.averaged_quadratic_offset width hwidth 0 j p]
        simp only [sub_zero, leveque04_quadraticCellAverage]
      have hnext : basis.equivFun
          (leveque04_sonicExactCellAverage density soundSpeed (ne_of_gt himpedance)
            background width hwidth profile (0+timeStep) 0) p =
          oneDimensionalCellAverage (fun x : ℝ => (x-speeds p*timeStep)^2)
            (-width/2) (width/2) := by
        dsimp only [basis]
        rw [leveque04_sonicExactCellAverage_coordinates density soundSpeed
          (ne_of_gt himpedance) background width hwidth profile hprofile (0+timeStep) 0 p]
        rw [CFLUnitShift.averaged_quadratic_offset]
        have ht := leveque04_translatedQuadraticAverage 0 width (speeds p*timeStep) hwidth
        simp only [zero_sub, zero_add] at ht
        rw [neg_div, ht]
        simp only [Int.cast_zero, zero_mul, zero_sub, zero_add]
        rfl
      change basis.equivFun (old 0) p - timeStep/width *
        (leveque04_positiveVelocity (speeds p) *
          (basis.equivFun (old 0) p-basis.equivFun (old (0-1)) p) +
        leveque04_negativeVelocity (speeds p) *
          (basis.equivFun (old (0+1)) p-basis.equivFun (old 0) p)) = _ at hcoord
      simp only [hav] at hcoord
      rw [hnext] at hcoord
      apply leveque04_signedUpwindQuadraticExactnessNecessity width timeStep (speeds p)
        hwidth htime
      rw [leveque04_equation35]
      exact hcoord
    have hleft : IsLeveque04GridAlignedSpeed (background-soundSpeed) timeStep width := by
      simpa [speeds, leveque04_acousticSpeeds] using halign 0
    have hright : IsLeveque04GridAlignedSpeed (background+soundSpeed) timeStep width := by
      simpa [speeds, leveque04_acousticSpeeds] using halign 1
    have hclass := leveque04_acousticGridAlignment_classification background soundSpeed
      timeStep width hsound htime hwidth hleft hright
    rcases hclass with hzero | hpos | hneg
    · left
      refine ⟨hzero, ?_⟩
      rw [hzero] at hright
      rcases hright with hn | hz | hp <;> nlinarith [mul_pos hsound htime]
    · right
      refine ⟨Or.inl hpos, ?_⟩
      rw [hpos] at hright
      rcases hright with hn | hz | hp <;> nlinarith [mul_pos hsound htime]
    · right
      refine ⟨Or.inr hneg, ?_⟩
      rw [hneg] at hleft
      rcases hleft with hn | hz | hp <;> nlinarith [mul_pos hsound htime]
  · intro hconfiguration
    have hboth : IsLeveque04GridAlignedSpeed (background-soundSpeed) timeStep width ∧
        IsLeveque04GridAlignedSpeed (background+soundSpeed) timeStep width := by
      rcases hconfiguration with ⟨hzero, hcfl⟩ | ⟨hsonic, hcfl⟩
      · rw [hzero]
        exact ⟨Or.inl (by nlinarith), Or.inr (Or.inr (by nlinarith))⟩
      · rcases hsonic with hpos | hneg
        · rw [hpos]
          exact ⟨Or.inr (Or.inl (by ring)), Or.inr (Or.inr (by nlinarith))⟩
        · rw [hneg]
          exact ⟨Or.inl (by nlinarith), Or.inr (Or.inl (by ring))⟩
    have halign (p : Fin 2) : IsLeveque04GridAlignedSpeed (speeds p) timeStep width := by
      fin_cases p
      · simpa [speeds, leveque04_acousticSpeeds] using hboth.1
      · simpa [speeds, leveque04_acousticSpeeds] using hboth.2
    intro profile hprofile t j
    dsimp only
    rw [leveque04_linearGodunovWaveStep_selected]
    apply basis.equivFun.injective
    funext p
    rw [leveque04_linearGodunovWaveStep_characteristic]
    dsimp only [basis]
    simp only [leveque04_sonicExactCellAverage_coordinates density soundSpeed
      (ne_of_gt himpedance) background width hwidth profile hprofile]
    have hs := signedUpwind_exact_average_of_gridAligned width timeStep (speeds p)
      hwidth htime (halign p) profile hprofile (speeds p*t) j p
    have htravel : speeds p*(t+timeStep)=speeds p*t+speeds p*timeStep := by ring
    rw [htravel]
    exact hs

end NumStability
