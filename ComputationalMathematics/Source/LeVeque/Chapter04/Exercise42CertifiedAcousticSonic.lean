/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticEigenbasis
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42SonicShifts

/-!
# LeVeque Chapter 4, Exercise 4.2(d): physical acoustics solver at sonic speeds

The certified linear Riemann solver is instantiated with the actual
convected pressure--velocity matrix and its acoustic eigenbasis.
-/

namespace NumStability

/-- At background velocity `+c`, the actual acoustic Godunov update
keeps the left family stationary and shifts the right family one cell. -/
theorem leveque04_acousticGodunov_positiveSonicShifts
    (density soundSpeed : ℝ)
    (hspeed : 0 < soundSpeed)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density soundSpeed
    let eigenbasis := leveque04_acousticEigenbasis
      density soundSpeed himpedance
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed soundSpeed himpedance)
      eigenbasis (leveque04_acousticSpeeds soundSpeed soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed soundSpeed himpedance)
    let next := conservativeFluxDifferenceUpdateInt (1 / (2 * soundSpeed))
      old (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i
    eigenbasis.equivFun next 0 = eigenbasis.equivFun (old i) 0 ∧
      eigenbasis.equivFun next 1 = eigenbasis.equivFun (old (i - 1)) 1 := by
  simpa only [leveque04_acousticSpeeds] using
    leveque04_selectedGodunov_positiveSonicShifts
      (convectedLinearAcousticsMatrix
        (density * soundSpeed ^ 2) density soundSpeed)
      (leveque04_acoustic_hyperbolic density soundSpeed soundSpeed himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      soundSpeed hspeed
      (leveque04_acousticEigenbasis_eigen density soundSpeed soundSpeed himpedance)
      old i

/-- At background velocity `-c`, the actual acoustic Godunov update
shifts the left family one cell and keeps the right family stationary. -/
theorem leveque04_acousticGodunov_negativeSonicShifts
    (density soundSpeed : ℝ)
    (hspeed : 0 < soundSpeed)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let coefficient := convectedLinearAcousticsMatrix
      (density * soundSpeed ^ 2) density (-soundSpeed)
    let eigenbasis := leveque04_acousticEigenbasis
      density soundSpeed himpedance
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      (leveque04_acoustic_hyperbolic density soundSpeed (-soundSpeed) himpedance)
      eigenbasis (leveque04_acousticSpeeds (-soundSpeed) soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed (-soundSpeed) himpedance)
    let next := conservativeFluxDifferenceUpdateInt (1 / (2 * soundSpeed))
      old (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i
    eigenbasis.equivFun next 0 = eigenbasis.equivFun (old (i + 1)) 0 ∧
      eigenbasis.equivFun next 1 = eigenbasis.equivFun (old i) 1 := by
  simpa only [leveque04_acousticSpeeds] using
    leveque04_selectedGodunov_negativeSonicShifts
      (convectedLinearAcousticsMatrix
        (density * soundSpeed ^ 2) density (-soundSpeed))
      (leveque04_acoustic_hyperbolic density soundSpeed (-soundSpeed) himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      soundSpeed hspeed
      (leveque04_acousticEigenbasis_eigen density soundSpeed (-soundSpeed) himpedance)
      old i

end NumStability
