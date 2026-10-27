/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation09DifferenceForm
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage

/-!
# LeVeque Chapter 4: numerical and physical average interpretation

The update (4.4) and difference residual (4.9) compare numerical data with
the actual local physical averages used in (4.2)–(4.5), printed pages 65–66.
The numerical data stay arbitrary. Their signed discrepancies remain explicit
in an exact error identity; no accuracy rate or convergence is asserted.

Positive spatial width and a forward time interval keep these averages in
their physical domain. The reference field supplies actual local integral
conservation and integrability, including discontinuous fields when certified.
-/

namespace NumStability
open MeasureTheory

/-- Arbitrary numerical old values and interface fluxes are compared
with an independent actual local physical reference. The error identity
specifies their interpretation without assuming an accuracy rate. -/
theorem leveque04_equation04_physicalReference {m : ℕ}
    (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (a b time : ℝ) (hab : a < b) (ht : 0 < time)
    (hphysical : LocalConservationLaw.RectangleReferenceOn q flux a b time)
    (old numericalFlux : ℤ → Fin m → ℝ) (i : ℤ) :
    IsOneDimensionalCellAverage (fun x => q x 0) a b
      (oneDimensionalCellAverage (fun x => q x 0) a b) ∧
    IsOneDimensionalCellAverage (fun x => q x time) a b
      (oneDimensionalCellAverage (fun x => q x time) a b) ∧
    IsOneDimensionalCellAverage (fun τ => flux (q a τ)) 0 time
      (oneDimensionalCellAverage (fun τ => flux (q a τ)) 0 time) ∧
    IsOneDimensionalCellAverage (fun τ => flux (q b τ)) 0 time
      (oneDimensionalCellAverage (fun τ => flux (q b τ)) 0 time) ∧
    (b-a) • (leveque04_finiteVolumeUpdate time (b-a) old numericalFlux i -
      oneDimensionalCellAverage (fun x => q x time) a b) =
      (b-a) • (old i-oneDimensionalCellAverage (fun x => q x 0) a b) +
      time • ((numericalFlux i-oneDimensionalCellAverage (fun τ => flux (q a τ)) 0 time) -
        (numericalFlux (i+1)-oneDimensionalCellAverage (fun τ => flux (q b τ)) 0 time)) := by
  have ha : a ∈ Set.Icc a b := ⟨le_refl _,hab.le⟩
  have hb : b ∈ Set.Icc a b := ⟨hab.le,le_refl _⟩
  have hzero : (0 : ℝ) ∈ Set.Icc 0 time := ⟨le_refl _,ht.le⟩
  have htime : time ∈ Set.Icc 0 time := ⟨ht.le,le_refl _⟩
  let physicalFace := fun face : Bool => if face then (fun τ => flux (q b τ)) else (fun τ => flux (q a τ))
  let rule := fun _old : ℤ → Fin m → ℝ => fun face : Bool => if face then numericalFlux (i+1) else numericalFlux i
  have h := finiteVolumeLocalCell_error_contract (fun x => q x 0) (fun x => q x time)
    physicalFace old rule i false true hab ht
    (hphysical.1 0 hzero) (hphysical.1 time htime)
    (hphysical.2.1 a ha) (hphysical.2.1 b hb)
    (hphysical.2.2 a ha b hb 0 hzero time htime)
  dsimp only [physicalFace,rule] at h
  simp only [Bool.false_eq_true,ite_false,ite_true,sub_zero] at h
  rcases h with ⟨h0,hT,hL,hR,_volume,_face,_numeric,herror,_bounds⟩
  refine ⟨h0,hT,hL,hR,?_⟩
  simpa only [leveque04_finiteVolumeUpdate,conservativeFluxDifferenceUpdateInt,
    finiteVolumeCellAverageUpdate] using herror

/-- The exact physical averages obey the same difference-form residual
as the numerical update, directly from actual local conservation. -/
theorem leveque04_equation09_physicalReference {m : ℕ}
    (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (a b time : ℝ) (hab : a < b) (ht : 0 < time)
    (hphysical : LocalConservationLaw.RectangleReferenceOn q flux a b time)
    (p : Fin m) :
    (oneDimensionalCellAverage (fun x => q x time) a b p -
      oneDimensionalCellAverage (fun x => q x 0) a b p)/time +
      (oneDimensionalCellAverage (fun τ => flux (q b τ)) 0 time p -
        oneDimensionalCellAverage (fun τ => flux (q a τ)) 0 time p)/(b-a)=0 := by
  have h := rectangleReferenceOn_cellAverage_step_of_initial q flux
    (oneDimensionalCellAverage (fun x => q x 0) a b) a b time a b hphysical
    ⟨le_refl _,hab.le⟩ ⟨hab.le,le_refl _⟩ hab ht rfl
  have hc := congrFun h p
  simp only [Pi.sub_apply,Pi.smul_apply,smul_eq_mul] at hc
  rw [hc]
  field_simp
  ring

end NumStability
