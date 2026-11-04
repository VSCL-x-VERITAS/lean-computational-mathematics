/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersFlux

/-!
# Actual Burgers physical fluctuations and the scalar entropy correction

The concrete-model reading of equations (4.37), (4.52), and (4.53) uses the
physical definition (12.6), the qualified wave representation (12.8), and the
transonic replacement (12.9). A continuous rarefaction is not a single jump.
The separately defined fan/shock contributions give a derived representation
of the same physical fluctuations, with no split identity assumed.
-/

namespace NumStability

/-- The physical flux of the actual selected positive-time zero-ray state. -/
noncomputable def leveque04_burgersPhysicalInterfaceFlux (left right : ℝ) : ℝ :=
  (leveque04_burgersSelectedInterfaceState left right) ^ 2 / 2

/-- The physical negative fluctuation as defined in source (12.6). -/
noncomputable def leveque04_burgersPhysicalMinusFluctuation (left right : ℝ) : ℝ :=
  leveque04_burgersPhysicalInterfaceFlux left right - left ^ 2 / 2

/-- The physical positive fluctuation as defined in source (12.6). -/
noncomputable def leveque04_burgersPhysicalPlusFluctuation (left right : ℝ) : ℝ :=
  right ^ 2 / 2 - leveque04_burgersPhysicalInterfaceFlux left right

/-- Independently computed negative net effect of the selected fan or shock.
The fan integral is a derived representation, not a literal finite jump sum. -/
noncomputable def leveque04_burgersFanShockMinusContribution (left right : ℝ) : ℝ :=
  if left ≤ right then ∫ speed in left..right, min 0 speed
  else min 0 ((left + right) / 2) * (right - left)

/-- Independently computed positive net effect of the selected fan or shock. -/
noncomputable def leveque04_burgersFanShockPlusContribution (left right : ℝ) : ℝ :=
  if left ≤ right then ∫ speed in left..right, max 0 speed
  else max 0 ((left + right) / 2) * (right - left)

/-- The physical per-cell fluctuation update. The positive fluctuation comes
from the left interface and the negative one from the right interface. -/
noncomputable def leveque04_burgersPhysicalFluctuationUpdate
    (timeStep cellWidth left center right : ℝ) : ℝ :=
  center - (timeStep / cellWidth) *
    (leveque04_burgersPhysicalPlusFluctuation left center +
      leveque04_burgersPhysicalMinusFluctuation center right)

/-- The complete all-state pair correspondence, physical time average,
entropy-corrected wave representation and conservative per-cell update.
Exact assembled-grid REA identification retains its separate CFL hypotheses. -/
def Leveque04BurgersPhysicalFluctuationsTarget : Prop :=
  (∀ left right : ℝ,
    (∀ time : ℝ, 0 < time →
      leveque04_burgersSelectedField left right 0 time =
        leveque04_burgersSelectedInterfaceState left right) ∧
    (∀ duration : ℝ, 0 < duration →
      (∫ time in (0 : ℝ)..duration,
        (leveque04_burgersSelectedField left right 0 time) ^ 2 / 2) / duration =
          leveque04_burgersPhysicalInterfaceFlux left right) ∧
    leveque04_burgersPhysicalInterfaceFlux left right =
      max ((max 0 left) ^ 2 / 2) ((min 0 right) ^ 2 / 2) ∧
    leveque04_burgersFanShockMinusContribution left right =
      leveque04_burgersPhysicalMinusFluctuation left right ∧
    leveque04_burgersFanShockPlusContribution left right =
      leveque04_burgersPhysicalPlusFluctuation left right ∧
    (leveque04_burgersPhysicalMinusFluctuation left right,
      leveque04_burgersPhysicalPlusFluctuation left right) =
      (if left < 0 ∧ 0 < right then (-(left ^ 2) / 2, right ^ 2 / 2)
       else (min 0 ((left + right) / 2) * (right - left),
         max 0 ((left + right) / 2) * (right - left))) ∧
    leveque04_burgersPhysicalInterfaceFlux left right =
      left ^ 2 / 2 + leveque04_burgersPhysicalMinusFluctuation left right ∧
    leveque04_burgersPhysicalInterfaceFlux left right =
      right ^ 2 / 2 - leveque04_burgersPhysicalPlusFluctuation left right ∧
    leveque04_burgersPhysicalMinusFluctuation left right +
      leveque04_burgersPhysicalPlusFluctuation left right = right ^ 2 / 2 - left ^ 2 / 2 ∧
    (right < left → left + right = 0 → ∀ representative : ℝ,
      representative = left ∨ representative = right →
        representative ^ 2 / 2 = leveque04_burgersPhysicalInterfaceFlux left right ∧
        leveque04_burgersPhysicalMinusFluctuation left right = 0 ∧
        leveque04_burgersPhysicalPlusFluctuation left right = 0)) ∧
  ∀ left center right timeStep cellWidth : ℝ,
    0 < timeStep → 0 < cellWidth →
      leveque04_burgersPhysicalFluctuationUpdate timeStep cellWidth left center right =
        center - (timeStep / cellWidth) *
          (leveque04_burgersPhysicalInterfaceFlux center right -
            leveque04_burgersPhysicalInterfaceFlux left center)

end NumStability
