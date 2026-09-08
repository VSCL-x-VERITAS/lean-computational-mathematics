/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
# Measured Cartesian finite-volume geometry

The data are an axis family of existing one-dimensional grids. Cell volume is
the product of widths; face area is the measure in transverse coordinates.
No nominal tensor-grid wrapper, logical chart, or PDE solver is introduced.
-/

namespace NumStability.CartesianGrid

open MeasureTheory
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D]

def cellBox (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) : Set (D → ℝ) :=
  Set.pi Set.univ (fun d => Set.Ico ((axes d).cellLeft (cell d))
    ((axes d).cellRight (cell d)))

def cellVolume (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) : ℝ :=
  ∏ d, (axes d).cellVolume (cell d)

def faceArea (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) : ℝ :=
  ∏ e ∈ Finset.univ.erase d, (axes e).cellVolume (cell e)

omit [DecidableEq D] in
theorem cellVolume_pos (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) :
    0 < CartesianGrid.cellVolume axes cell :=
  Finset.prod_pos (fun d _ => (axes d).cellVolume_pos (cell d))

theorem cellVolume_eq_width_mul_area (axes : D → OneDimensionalFiniteVolumeGrid) (d : D)
    (cell : (D → ℤ)) :
    CartesianGrid.cellVolume axes cell = (axes d).cellVolume (cell d) * CartesianGrid.faceArea axes d cell := by
  exact (Finset.mul_prod_erase _ _ (Finset.mem_univ d)).symm

omit [DecidableEq D] in
theorem cellBox_volume (axes : D → OneDimensionalFiniteVolumeGrid) (cell : (D → ℤ)) :
    (volume (CartesianGrid.cellBox axes cell)).toReal = CartesianGrid.cellVolume axes cell := by
  exact Real.volume_pi_Ico_toReal (fun d => (axes d).cell_nonempty (cell d) |>.le)

theorem faceArea_update (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) (j : ℤ) :
    CartesianGrid.faceArea axes d (Function.update cell d j) = CartesianGrid.faceArea axes d cell := by
  unfold CartesianGrid.faceArea
  apply Finset.prod_congr rfl
  intro e he
  rw [Function.update_of_ne (Finset.mem_erase.mp he).1]

def tangentialFaceBox (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) :
    Set ({e : D // e ≠ d} → ℝ) :=
  Set.pi Set.univ (fun e => Set.Ico ((axes e.1).cellLeft (cell e.1))
    ((axes e.1).cellRight (cell e.1)))

theorem tangentialFaceBox_volume (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) :
    (volume (tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell := by
  rw [tangentialFaceBox, Real.volume_pi_Ico_toReal
    (fun e : {e : D // e ≠ d} => (axes e.1).cell_nonempty (cell e.1) |>.le)]
  exact (Finset.prod_subtype (Finset.univ.erase d) (by simp)
    (fun e => (axes e).cellVolume (cell e))).symm

omit [Fintype D] in
theorem tangentialFaceBox_update (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) (j : ℤ) :
    tangentialFaceBox axes d (Function.update cell d j) = tangentialFaceBox axes d cell := by
  unfold tangentialFaceBox
  congr 1
  funext e
  rw [Function.update_of_ne e.property]

def facePoint (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ))
    (point : {e : D // e ≠ d} → ℝ) : D → ℝ :=
  fun e => if h : e = d then (axes d).cellLeft (cell d) else point ⟨e, h⟩

omit [Fintype D] in
theorem facePoint_normal (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ))
    (point : {e : D // e ≠ d} → ℝ) :
    facePoint axes d cell point d = (axes d).cellLeft (cell d) := by
  simp [facePoint]

omit [Fintype D] in
theorem facePoint_transverse (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ))
    (point : {e : D // e ≠ d} → ℝ) (e : D) (h : e ≠ d) :
    facePoint axes d cell point e = point ⟨e, h⟩ := by
  simp [facePoint, h]

omit [Fintype D] in
theorem shared_face_position (axes : D → OneDimensionalFiniteVolumeGrid) (d : D) (cell : (D → ℤ)) :
    (axes d).cellRight (cell d) =
      (axes d).cellLeft ((Function.update cell d (cell d + 1)) d) := by
  simpa using (axes d).adjacent (cell d + 1)

end NumStability.CartesianGrid
