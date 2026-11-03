/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictor

/-!
# A scalar step-data application of the Richtmyer method

This separately specified supporting application uses the actual numerical
method in equations (4.4), (4.22), and (4.23). It does not quantify the word
"often" in the section 4.7 oscillation remark or assert a nonlinear-system result.
-/

namespace NumStability

/-- Unit step grid values with the jump to the right of cell zero. -/
def leveque04_richtmyerUnitStepData (j : ℤ) : ℝ :=
  if 0 < j then 1 else 0

/-- Cell zero after one actual Richtmyer step for scalar flux `speed * state`. -/
noncomputable def leveque04_richtmyerUnitStepAtOrigin
    (speed timeStep cellWidth : ℝ) : ℝ :=
  leveque04_finiteVolumeUpdate timeStep cellWidth
    (fun (j : ℤ) (_ : Fin 1) => leveque04_richtmyerUnitStepData j)
    (leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep cellWidth
        (fun (state : Fin 1 → ℝ) (_ : Fin 1) => speed * state 0))
      (fun (j : ℤ) (_ : Fin 1) => leveque04_richtmyerUnitStepData j)) 0 0

/-- The specified unit step is nonnegative, while every positive subunit
Courant choice produces the stated strict undershoot in its first update.
This is a supporting application, not a characterization of spurious oscillation.
-/
def Leveque04RichtmyerUnitStepUndershootTarget : Prop :=
  (∀ j : ℤ, 0 ≤ leveque04_richtmyerUnitStepData j ∧
    leveque04_richtmyerUnitStepData j ≤ 1) ∧
  ∀ speed timeStep cellWidth : ℝ,
    0 < speed → 0 < timeStep → 0 < cellWidth →
      speed * timeStep / cellWidth < 1 →
        leveque04_richtmyerUnitStepAtOrigin speed timeStep cellWidth =
            (speed * timeStep / cellWidth) *
              (speed * timeStep / cellWidth - 1) / 2 ∧
          leveque04_richtmyerUnitStepAtOrigin speed timeStep cellWidth < 0

end NumStability
