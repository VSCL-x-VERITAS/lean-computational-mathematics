/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticEigenbasis
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovCharacteristicStep

/-!
# LeVeque Chapter 4, Exercise 4.2(c): certified zero-background acoustics step

The selected Riemann solver for the physical acoustics matrix agrees at
unit sound-speed Courant number with the explicit pressure--velocity
characteristic shift formulas.
-/

namespace NumStability

/-- The selected physical-acoustics Godunov step at `c Δt/Δx = 1`
equals the pressure--velocity characteristic-shift update. -/
theorem leveque04_acousticGodunov_zeroBackground_unitShift
    (density soundSpeed : ℝ)
    (hspeed : 0 < soundSpeed)
    (himpedance : 0 < acousticImpedance density soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let basis := leveque04_acousticEigenbasis density soundSpeed
      (ne_of_gt himpedance)
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0
        (ne_of_gt himpedance)) basis
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0
        (ne_of_gt himpedance))
    conservativeFluxDifferenceUpdateInt (1 / soundSpeed) old
        (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i =
      leveque04_acousticUnitShiftStep
        (acousticImpedance density soundSpeed) old i := by
  let basis := leveque04_acousticEigenbasis density soundSpeed
    (ne_of_gt himpedance)
  let Z := acousticImpedance density soundSpeed
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
  · have hshift := leveque04_linearGodunov_negativeUnitShift
      basis soundSpeed hspeed old i
    have hold := (leveque04_acousticEigenbasis_characteristicForms
      density soundSpeed himpedance (old (i + 1))).1
    have hnext := (leveque04_acousticEigenbasis_characteristicForms
      density soundSpeed himpedance
        (leveque04_acousticUnitShiftStep Z old i)).1
    have hchar := leveque04_acousticUnitShift_leftCharacteristic
      Z (ne_of_gt himpedance) old i
    change basis.equivFun
        (leveque04_linearGodunovWaveStep basis ![-soundSpeed, soundSpeed]
          (1 / soundSpeed) old i) 0 =
      basis.equivFun (leveque04_acousticUnitShiftStep Z old i) 0
    rw [hshift, hold, hnext, hchar]
  · have hshift := leveque04_linearGodunov_positiveUnitShift
      basis soundSpeed hspeed old i
    have hold := (leveque04_acousticEigenbasis_characteristicForms
      density soundSpeed himpedance (old (i - 1))).2
    have hnext := (leveque04_acousticEigenbasis_characteristicForms
      density soundSpeed himpedance
        (leveque04_acousticUnitShiftStep Z old i)).2
    have hchar := leveque04_acousticUnitShift_rightCharacteristic
      Z (ne_of_gt himpedance) old i
    change basis.equivFun
        (leveque04_linearGodunovWaveStep basis ![-soundSpeed, soundSpeed]
          (1 / soundSpeed) old i) 1 =
      basis.equivFun (leveque04_acousticUnitShiftStep Z old i) 1
    rw [hshift, hold, hnext, hchar]

/-- Pressure and particle-velocity components of the certified
zero-background Godunov update at acoustic unit CFL. -/
theorem leveque04_acousticGodunov_zeroBackground_components
    (density soundSpeed : ℝ)
    (hspeed : 0 < soundSpeed)
    (himpedance : 0 < acousticImpedance density soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let Z := acousticImpedance density soundSpeed
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density 0
    let basis := leveque04_acousticEigenbasis density soundSpeed
      (ne_of_gt himpedance)
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed 0
        (ne_of_gt himpedance)) basis
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0
        (ne_of_gt himpedance))
    let next := conservativeFluxDifferenceUpdateInt (1 / soundSpeed) old
      (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i
    next 0 = (old (i - 1) 0 + old (i + 1) 0 +
        Z * (old (i - 1) 1 - old (i + 1) 1)) / 2 ∧
      next 1 = (old (i - 1) 1 + old (i + 1) 1) / 2 +
        (old (i - 1) 0 - old (i + 1) 0) / (2 * Z) := by
  dsimp only
  rw [leveque04_acousticGodunov_zeroBackground_unitShift
    density soundSpeed hspeed himpedance old i]
  exact ⟨leveque04_acousticUnitShift_pressure
      (acousticImpedance density soundSpeed) old i,
    leveque04_acousticUnitShift_velocity
      (acousticImpedance density soundSpeed)
      (ne_of_gt himpedance) old i⟩

end NumStability
