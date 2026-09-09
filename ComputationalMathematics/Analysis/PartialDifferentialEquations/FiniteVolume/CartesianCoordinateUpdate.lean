/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationCoordinateUpdate

/-!
# Cartesian consumers of full-line numerical flux rules

Area weighting gives the actual one-dimensional finite-volume line restriction
for an arbitrary full-line flux rule. Admitted information routines specialize
that correspondence. Consistency or accuracy is not inferred for arbitrary rules.
The local line notation expands to a lambda and introduces no public alias.
-/

namespace NumStability.CartesianCoordinateUpdate

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))

open MeasureTheory RiemannInformationCoordinate

local notation "line" => (fun (d : D) (base : D → ℤ)
  (state : (D → ℤ) → Fin m → ℝ) (j : ℤ) => state (Function.update base d j))

/-- Area weighting of a full-line flux rule. `rule d cell dt old` is the per-unit-area normal
flux through the `d`-face indexed by `cell`, read from the coordinate line `old`; scaling it by
the tangential face area `CartesianGrid.faceArea axes d cell` gives the area-integrated flux
that `CoordinateLineBalance.advance` consumes, so the line restriction of that advance is the
one-dimensional update `riemannFiniteVolumeUpdate (axes d)` (`cartesian_full_line_update`). -/
def areaWeightedRule (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (cell : (D → ℤ)) (dt : ℝ) (old : ℤ → Fin m → ℝ) : Fin m → ℝ :=
  (CartesianGrid.faceArea axes) d cell • rule d cell dt old

theorem cartesian_full_line_update (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (base : (D → ℤ)) :
    line d base (CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
      (areaWeightedRule axes rule) d dt state) =
      riemannFiniteVolumeUpdate (axes d) dt (line d base state)
        (fun j => rule d (Function.update base d j) dt (line d base state)) := by
  funext j
  let flux := fun k => rule d (Function.update base d k) dt (line d base state)
  have hline : (axes d).cellVolume j •
      riemannFiniteVolumeUpdate (axes d) dt (line d base state) flux j =
      (axes d).cellVolume j • line d base state j - dt • (flux (j + 1) - flux j) :=
    cellVolume_smul_finiteVolumeCellAverageUpdate dt ((axes d).cellVolume j)
      (line d base state j) (flux (j + 1) - flux j) ((axes d).cellVolume_pos j).ne'
  have harea := congrArg (fun value => (CartesianGrid.faceArea axes) d base • value) hline
  have hreference : (CartesianGrid.cellVolume axes) (Function.update base d j) •
      riemannFiniteVolumeUpdate (axes d) dt (line d base state) flux j =
      (CartesianGrid.cellVolume axes) (Function.update base d j) • state (Function.update base d j) -
        dt • ((CartesianGrid.faceArea axes) d base • flux (j + 1) - (CartesianGrid.faceArea axes) d base • flux j) := by
    rw [(CartesianGrid.cellVolume_eq_width_mul_area axes) d (Function.update base d j)]
    simp only [Function.update_self, CartesianGrid.faceArea_update]
    simpa only [smul_sub, smul_smul, mul_comm] using harea
  have hactual := CoordinateLineBalance.advance_mass_balance (CartesianGrid.cellVolume axes) (CartesianGrid.cellVolume_pos axes)
    (areaWeightedRule axes rule) d dt state (Function.update base d j)
  simp only [CoordinateLineBalance.netOutwardFlux, CoordinateLineBalance.normalFaceFlux,
    areaWeightedRule, Function.update_self, Function.update_idem,
    CartesianGrid.faceArea_update] at hactual
  have hmass : (CartesianGrid.cellVolume axes) (Function.update base d j) •
      line d base (CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
        (areaWeightedRule axes rule) d dt state) j =
      (CartesianGrid.cellVolume axes) (Function.update base d j) •
        riemannFiniteVolumeUpdate (axes d) dt (line d base state) flux j := by
    simpa only [flux] using hactual.trans hreference.symm
  have hc := congrArg (fun value => ((CartesianGrid.cellVolume axes) (Function.update base d j))⁻¹ • value) hmass
  simpa only [smul_smul, inv_mul_cancel₀ ((CartesianGrid.cellVolume_pos axes) _).ne', one_smul] using hc

omit [Fintype D] in
theorem line_admission (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : (D → ℤ)) (j : ℤ) :
    (methods d dt).domain (adjacentCellRiemannProblem (laws d) (line d base state) j) := by
  simpa only [FaceAdmitted, Function.update_self, Function.update_idem] using
    h (Function.update base d j)

omit [Fintype D] in
theorem selectedFaceFlux_on_line (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : (D → ℤ)) (j : ℤ) :
    selectedFaceFlux methods d dt state (Function.update base d j) (h _) =
      (methods d dt).interfaceFlux (line d base state)
        (line_admission methods d dt state h base) j := by
  have hcongr (p q : HyperbolicRiemannProblem (laws d))
      (hp : (methods d dt).domain p) (hq : (methods d dt).domain q) (heq : p = q) :
      (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve p hp)) =
        (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve q hq)) := by
    cases heq
    rfl
  unfold selectedFaceFlux RiemannInformationFluxMethod.interfaceFlux
  apply hcongr
  simp only [Function.update_self, Function.update_idem]

theorem guardedRule_eq_areaWeightedRule (axes : D → OneDimensionalFiniteVolumeGrid)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ) :
    guardedRule methods (CartesianGrid.faceArea axes) fallback =
      areaWeightedRule axes (guardedRule methods (fun _ _ => 1)
        (fun d cell dt old => ((CartesianGrid.faceArea axes) d cell)⁻¹ • fallback d cell dt old)) := by
  classical
  funext d cell dt old
  have harea : (CartesianGrid.faceArea axes) d cell ≠ 0 := by
    exact ne_of_gt (Finset.prod_pos (fun e _ => (axes e).cellVolume_pos (cell e)))
  unfold areaWeightedRule guardedRule
  split <;> simp_all [smul_smul]

theorem cartesian_line_update (axes : D → OneDimensionalFiniteVolumeGrid)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : (D → ℤ)) :
    line d base (CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
        (guardedRule methods (CartesianGrid.faceArea axes) fallback) d dt state) =
      riemannFiniteVolumeUpdate (axes d) dt (line d base state)
        ((methods d dt).interfaceFlux (line d base state) (line_admission methods d dt state h base)) := by
  rw [guardedRule_eq_areaWeightedRule, cartesian_full_line_update]
  apply congrArg (riemannFiniteVolumeUpdate (axes d) dt (line d base state))
  funext j
  have hguard := line_admission methods d dt state h base ((Function.update base d j) d)
  unfold guardedRule
  rw [dif_pos hguard, one_smul]
  change (methods d dt).interfaceFlux (line d base state)
      (line_admission methods d dt state h base) ((Function.update base d j) d) = _
  rw [Function.update_self]

theorem cartesian_measured_balance (axes : D → OneDimensionalFiniteVolumeGrid)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (cell : (D → ℤ)) :
    (volume ((CartesianGrid.cellBox axes) cell)).toReal • CoordinateLineBalance.advance (CartesianGrid.cellVolume axes)
      (guardedRule methods (CartesianGrid.faceArea axes) fallback) d dt state cell =
      (volume ((CartesianGrid.cellBox axes) cell)).toReal • state cell - dt •
        ((volume ((CartesianGrid.tangentialFaceBox axes) d
            (Function.update cell d (cell d + 1)))).toReal •
          selectedFaceFlux methods d dt state (Function.update cell d (cell d + 1)) (h _) -
        (volume ((CartesianGrid.tangentialFaceBox axes) d cell)).toReal •
          selectedFaceFlux methods d dt state cell (h cell)) := by
  rw [(CartesianGrid.cellBox_volume axes), CartesianGrid.tangentialFaceBox_volume,
    CartesianGrid.tangentialFaceBox_volume]
  exact admitted_cell_mass_balance methods (CartesianGrid.cellVolume axes) (CartesianGrid.cellVolume_pos axes)
    (CartesianGrid.faceArea axes) fallback d dt state h cell

end NumStability.CartesianCoordinateUpdate
