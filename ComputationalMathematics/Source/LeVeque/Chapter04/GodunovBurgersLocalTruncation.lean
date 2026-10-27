/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageFluxTruncation
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersMixedSpatial
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersTemporalFlux

/-!
# One-step truncation error of the actual Burgers flux on exact averages

The exact comparison uses physical rectangle balance. Spatial consistency
and the time regularity of the physical divergence give the two error terms.
-/

open MeasureTheory

namespace NumStability

/-- Physical rectangle balance and smooth exact averages give a first-order
normalized local error for the actual Burgers Godunov flux. -/
theorem leveque04_burgersGodunov_exactAverage_localTruncation
    (q : ℝ → ℝ → ℝ) (qX : ℝ → ℝ)
    (B M K D center width oldTime timeStep : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ x, HasDerivAt (fun y => q y oldTime) (qX x) x)
    (hvalue : ∀ x, 0 ≤ q x oldTime ∧ |q x oldTime| ≤ B)
    (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|)
    (hTime : ∀ τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance :
      (∫ x in center - width / 2..center + width / 2, q x (oldTime + timeStep)) -
          (∫ x in center - width / 2..center + width / 2, q x oldTime) =
        ∫ τ in oldTime..oldTime + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2)) :
    let avg := fun τ c => oneDimensionalCellAverage (fun x => q x τ) (c - width / 2) (c + width / 2)
    let numericalNext := avg oldTime center - timeStep / width *
      ((leveque04_burgersSelectedInterfaceState (avg oldTime center) (avg oldTime (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg oldTime (center - width)) (avg oldTime center)) ^ 2 / 2)
    |(numericalNext - avg (oldTime + timeStep) center) / timeStep| ≤
      2 * (B * K + M ^ 2) * width + D * timeStep := by
  let avg := fun τ c => oneDimensionalCellAverage (fun x => q x τ) (c - width / 2) (c + width / 2)
  let numericalG :=
    ((leveque04_burgersSelectedInterfaceState (avg oldTime center) (avg oldTime (center + width))) ^ 2 / 2 -
      (leveque04_burgersSelectedInterfaceState (avg oldTime (center - width)) (avg oldTime center)) ^ 2 / 2) / width
  have hspatial := leveque04_burgersGodunov_exactAverage_physicalSpatial_error (fun x => q x oldTime) qX
    B M K center width hB hM hK hwidth hq hvalue hderiv hLip
  have h := cellAverage_step_error_of_divergence q (fun u => u ^ 2 / 2)
    numericalG (2 * (B * K + M ^ 2) * width) D center width oldTime timeStep
    hD hwidth htime hspatial hTime hbalance
  dsimp only at h ⊢
  have hid : timeStep / width *
      ((leveque04_burgersSelectedInterfaceState (avg oldTime center) (avg oldTime (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg oldTime (center - width)) (avg oldTime center)) ^ 2 / 2) =
      timeStep * numericalG := by dsimp [numericalG]; ring
  change |((avg oldTime center - _) - avg (oldTime + timeStep) center) / timeStep| ≤ _
  rw [hid]
  exact h

/-- Physical rectangle balance gives the mixed-sign actual-flux local error
from its derived spatial consistency estimate. -/
theorem leveque04_burgersGodunov_mixed_exactAverage_localTruncation
    (q : ℝ → ℝ → ℝ) (qX : ℝ → ℝ)
    (B M K D center width oldTime timeStep : ℝ)
    (hB : 0 ≤ B) (hM : 0 ≤ M) (hK : 0 ≤ K) (hD : 0 ≤ D)
    (hwidth : 0 < width) (htime : 0 < timeStep)
    (hq : ∀ x, HasDerivAt (fun y => q y oldTime) (qX x) x)
    (hvalue : ∀ x, |q x oldTime| ≤ B)
    (hderiv : ∀ x, |qX x| ≤ M)
    (hLip : ∀ x y, |qX x - qX y| ≤ K * |x - y|)
    (hTime : ∀ τ σ,
      |leveque04_burgersPhysicalFaceDivergence q center width τ -
        leveque04_burgersPhysicalFaceDivergence q center width σ| ≤ D * |τ - σ|)
    (hbalance :
      (∫ x in center - width / 2..center + width / 2, q x (oldTime + timeStep)) -
          (∫ x in center - width / 2..center + width / 2, q x oldTime) =
        ∫ τ in oldTime..oldTime + timeStep,
          (q (center - width / 2) τ ^ 2 / 2 - q (center + width / 2) τ ^ 2 / 2)) :
    let avg := fun τ c => oneDimensionalCellAverage (fun x => q x τ) (c - width / 2) (c + width / 2)
    let numericalNext := avg oldTime center - timeStep / width *
      ((leveque04_burgersSelectedInterfaceState (avg oldTime center) (avg oldTime (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg oldTime (center - width)) (avg oldTime center)) ^ 2 / 2)
    |(numericalNext - avg (oldTime + timeStep) center) / timeStep| ≤
      (3 * (B * K + M ^ 2) + M ^ 2) * width + D * timeStep := by
  let avg := fun τ c => oneDimensionalCellAverage (fun x => q x τ) (c - width / 2) (c + width / 2)
  let numericalG :=
    ((leveque04_burgersSelectedInterfaceState (avg oldTime center) (avg oldTime (center + width))) ^ 2 / 2 -
      (leveque04_burgersSelectedInterfaceState (avg oldTime (center - width)) (avg oldTime center)) ^ 2 / 2) / width
  have hspatial := leveque04_burgersGodunov_mixed_exactAverage_physicalSpatial_error (fun x => q x oldTime) qX
    B M K center width hB hM hK hwidth hq hvalue hderiv hLip
  have h := cellAverage_step_error_of_divergence q (fun u => u ^ 2 / 2)
    numericalG ((3 * (B * K + M ^ 2) + M ^ 2) * width) D center width oldTime timeStep
    hD hwidth htime hspatial hTime hbalance
  dsimp only at h ⊢
  have hid : timeStep / width *
      ((leveque04_burgersSelectedInterfaceState (avg oldTime center) (avg oldTime (center + width))) ^ 2 / 2 -
        (leveque04_burgersSelectedInterfaceState (avg oldTime (center - width)) (avg oldTime center)) ^ 2 / 2) =
      timeStep * numericalG := by dsimp [numericalG]; ring
  change |((avg oldTime center - _) - avg (oldTime + timeStep) center) / timeStep| ≤ _
  rw [hid]
  exact h

end NumStability
