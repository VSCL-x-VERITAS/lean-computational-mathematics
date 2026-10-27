/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LocalNumericalFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.ConservativeUpdatePhysicalReference
import Mathlib.Tactic.Abel

/-!
# Adjacent numerical fluxes and physical reference averages

The local two-state flux is expressed using the adjacent physical cell averages
and their signed approximation errors.
-/

namespace NumStability
open MeasureTheory

/-- Physical interpretations of both adjacent inputs and the interface
output. Signed errors express approximation roles without an invented bound. -/
theorem leveque04_equation06_physicalReference {m : ℕ}
    (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (face width time : ℝ) (hw : 0 < width) (ht : 0 < time)
    (hleft : IntervalIntegrable (fun x => q x 0) volume (face-width) face)
    (hright : IntervalIntegrable (fun x => q x 0) volume face (face+width))
    (hface : IntervalIntegrable (fun τ => flux (q face τ)) volume 0 time)
    (F : (Fin m → ℝ) → (Fin m → ℝ) → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ) (i : ℤ) :
    IsOneDimensionalCellAverage (fun x => q x 0) (face-width) face
      (oneDimensionalCellAverage (fun x => q x 0) (face-width) face) ∧
    IsOneDimensionalCellAverage (fun x => q x 0) face (face+width)
      (oneDimensionalCellAverage (fun x => q x 0) face (face+width)) ∧
    IsOneDimensionalCellAverage (fun τ => flux (q face τ)) 0 time
      (oneDimensionalCellAverage (fun τ => flux (q face τ)) 0 time) ∧
    leveque04_localInterfaceFlux F old i = F (old (i-1)) (old i) ∧
    leveque04_localInterfaceFlux F old i -
        oneDimensionalCellAverage (fun τ => flux (q face τ)) 0 time =
      F (oneDimensionalCellAverage (fun x => q x 0) (face-width) face +
          (old (i-1)-oneDimensionalCellAverage (fun x => q x 0) (face-width) face))
        (oneDimensionalCellAverage (fun x => q x 0) face (face+width) +
          (old i-oneDimensionalCellAverage (fun x => q x 0) face (face+width))) -
        oneDimensionalCellAverage (fun τ => flux (q face τ)) 0 time := by
  refine ⟨oneDimensionalCellAverage_isCellAverage _ (by linarith) hleft,
    oneDimensionalCellAverage_isCellAverage _ (by linarith) hright,
    oneDimensionalCellAverage_isCellAverage _ ht hface,
    leveque04_equation06 F old i,?_⟩
  simp only [←add_sub_assoc,add_sub_cancel_left,leveque04_localInterfaceFlux]

/-- On an actual uniform cell and positive forward step, the adjacent-state
numerical choice obeys the existing physical error identity. This compares
the numerical next average with the independent exact physical average. -/
theorem leveque04_equation07_physicalReference {m : ℕ}
    (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (left width time : ℝ) (hw : 0 < width) (ht : 0 < time)
    (hphysical : LocalConservationLaw.RectangleReferenceOn q flux left (left+width) time)
    (hleft : IntervalIntegrable (fun x => q x 0) volume (left-width) left)
    (hright : IntervalIntegrable (fun x => q x 0) volume (left+width) (left+2*width))
    (F : (Fin m → ℝ) → (Fin m → ℝ) → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ) (i : ℤ) :
    leveque04_finiteVolumeUpdate time width old (leveque04_localInterfaceFlux F old) i =
      old i-(time/width) • (F (old i) (old (i+1))-F (old (i-1)) (old i)) ∧
    IsOneDimensionalCellAverage (fun x => q x 0) (left-width) left
      (oneDimensionalCellAverage (fun x => q x 0) (left-width) left) ∧
    IsOneDimensionalCellAverage (fun x => q x 0) (left+width) (left+2*width)
      (oneDimensionalCellAverage (fun x => q x 0) (left+width) (left+2*width)) ∧
    IsOneDimensionalCellAverage (fun x => q x 0) left (left+width)
      (oneDimensionalCellAverage (fun x => q x 0) left (left+width)) ∧
    IsOneDimensionalCellAverage (fun x => q x time) left (left+width)
      (oneDimensionalCellAverage (fun x => q x time) left (left+width)) ∧
    IsOneDimensionalCellAverage (fun τ => flux (q left τ)) 0 time
      (oneDimensionalCellAverage (fun τ => flux (q left τ)) 0 time) ∧
    IsOneDimensionalCellAverage (fun τ => flux (q (left+width) τ)) 0 time
      (oneDimensionalCellAverage (fun τ => flux (q (left+width) τ)) 0 time) ∧
    width • (leveque04_finiteVolumeUpdate time width old (leveque04_localInterfaceFlux F old) i -
      oneDimensionalCellAverage (fun x => q x time) left (left+width)) =
      width • (old i-oneDimensionalCellAverage (fun x => q x 0) left (left+width)) +
        time • ((F (old (i-1)) (old i)-oneDimensionalCellAverage (fun τ => flux (q left τ)) 0 time) -
          (F (old i) (old (i+1))-oneDimensionalCellAverage (fun τ => flux (q (left+width) τ)) 0 time)) := by
  have h := leveque04_equation04_physicalReference q flux left (left+width) time
    (by linarith) ht hphysical old (leveque04_localInterfaceFlux F old) i
  have hwidth : left+width-left=width := by ring
  rw [hwidth] at h
  refine ⟨leveque04_equation07 time width F old i,
    oneDimensionalCellAverage_isCellAverage _ (by linarith) hleft,
    oneDimensionalCellAverage_isCellAverage _ (by linarith) hright,
    h.1,h.2.1,h.2.2.1,h.2.2.2.1,?_⟩
  simpa only [leveque04_localInterfaceFlux,add_sub_cancel_right] using h.2.2.2.2

end NumStability
