/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry

/-!
Identification of the same finite physical cells, means and normal fluxes with actual Cartesian geometry, and rectangle-law transport.
-/

namespace NumStability.FiniteCartesian
open MeasureTheory FiniteCoordinate
open scoped BigOperators
variable {D Cell Face FacePoint : Type*} [Fintype D] [DecidableEq D]
variable [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The actual finite physical partition and actual face measures represent
these Cartesian cells/faces. The directional flux is the same law throughout;
this is not a match of volume scalars with unrelated geometry. -/
structure CartesianIdentification
    (data : PhysicalData D Cell Face (D → ℝ) FacePoint m)
    (axes : D → OneDimensionalFiniteVolumeGrid)
    (cellPosition : Cell → D → ℤ) (facePosition : D → Face → D → ℤ)
    (flux : D → State → State) : Prop where
  left_position : ∀ d cell, facePosition d (data.leftFace d cell) = cellPosition cell
  right_position : ∀ d cell, facePosition d (data.rightFace d cell) =
    Function.update (cellPosition cell) d (cellPosition cell d + 1)
  cell_measure : ∀ cell, data.measure.restrict (data.cells.cellRegion cell) =
    volume.restrict (CartesianGrid.cellBox axes (cellPosition cell))
  face_measurable : ∀ d face, AEMeasurable (data.facePoint d face) (data.faceMeasure d face)
  face_measure : ∀ d face, Measure.map (data.facePoint d face) (data.faceMeasure d face) =
    Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face)))
  normal_flux : ∀ d face, ∀ᵐ point ∂data.faceMeasure d face,
    ∀ value, data.normalFlux d face point value = flux d value

variable {data : PhysicalData D Cell Face (D → ℝ) FacePoint m}
variable {axes : D → OneDimensionalFiniteVolumeGrid}
variable {cellPosition : Cell → D → ℤ} {facePosition : D → Face → D → ℤ}
variable {flux : D → (Fin m → ℝ) → Fin m → ℝ}

theorem CartesianIdentification.cellVolume_eq
    (h : CartesianIdentification data axes cellPosition facePosition flux) (cell : Cell) :
    data.cellVolume cell = CartesianGrid.cellVolume axes (cellPosition cell) := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  rw [PhysicalData.cellVolume, hm, CartesianGrid.cellBox_volume]

theorem CartesianIdentification.cellMean_eq
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : (D → ℝ) → ℝ → State) (cell : Cell) (t : ℝ) :
    data.cellMean q cell t =
      cellVolumeAverage volume (CartesianGrid.cellBox axes (cellPosition cell)) (fun x => q x t) := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  simp only [PhysicalData.cellMean, cellVolumeAverage, hm]
  rw [h.cell_measure cell]

theorem CartesianIdentification.faceFlux_eq
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : (D → ℝ) → ℝ → State) (d : D) (face : Face) (t : ℝ)
    (hmeas : AEStronglyMeasurable (fun x => flux d (q x t))
      (Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face))))) :
    data.faceFlux d q face t =
      ∫ point in CartesianGrid.tangentialFaceBox axes d (facePosition d face),
        flux d (q (CartesianGrid.facePoint axes d (facePosition d face) point) t) := by
  unfold PhysicalData.faceFlux
  calc
    _ = ∫ point, flux d (q (data.facePoint d face point) t) ∂data.faceMeasure d face := by
      apply integral_congr_ae
      filter_upwards [h.normal_flux d face] with point hp
      exact hp _
    _ = ∫ x, flux d (q x t) ∂Measure.map (data.facePoint d face) (data.faceMeasure d face) := by
      symm
      exact integral_map (h.face_measurable d face) (by rw [h.face_measure]; exact hmeas)
    _ = _ := by
      rw [h.face_measure]
      exact integral_map
        (FiniteCartesian.facePoint_measurable axes d (facePosition d face)).aemeasurable hmeas

theorem CartesianIdentification.cellMean_lift
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : ℝ → ℝ → State) (d : D) (cell : Cell) (t : ℝ)
    (hq : IntervalIntegrable (fun x => q x t) volume
      ((axes d).cellLeft (cellPosition cell d)) ((axes d).cellRight (cellPosition cell d))) :
    data.cellMean (fun x τ => q (x d) τ) cell t =
      finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cellPosition cell d) := by
  rw [h.cellMean_eq]
  exact CartesianGrid.cellVolumeAverage_projection axes d (cellPosition cell) (fun x => q x t) hq

theorem CartesianIdentification.faceFlux_lift
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : ℝ → ℝ → State) (d : D) (face : Face) (t : ℝ) :
    data.faceFlux d (fun x τ => q (x d) τ) face t =
      CartesianGrid.faceArea axes d (facePosition d face) •
        flux d (q ((axes d).cellLeft (facePosition d face d)) t) := by
  have hnormal : ∀ᵐ x ∂Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face))),
      x d = (axes d).cellLeft (facePosition d face d) := by
    rw [ae_map_iff
      (FiniteCartesian.facePoint_measurable axes d (facePosition d face)).aemeasurable
      (measurableSet_eq_fun (measurable_pi_apply d) measurable_const)]
    exact Filter.Eventually.of_forall (CartesianGrid.facePoint_normal axes d (facePosition d face))
  have hm : AEStronglyMeasurable (fun x : D → ℝ => flux d (q (x d) t))
      (Measure.map (CartesianGrid.facePoint axes d (facePosition d face))
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d (facePosition d face)))) := by
    apply (aestronglyMeasurable_const (b := flux d (q ((axes d).cellLeft (facePosition d face d)) t))).congr
    filter_upwards [hnormal] with x hx
    rw [hx]
  rw [h.faceFlux_eq _ d face t hm]
  simp only [CartesianGrid.facePoint_normal, setIntegral_const,
    measureReal_def, CartesianGrid.tangentialFaceBox_volume]

/-- The same physical cell mass and same two boundary fluxes satisfy every
subinterval balance, by the supplied one-dimensional rectangle PDE law. -/
theorem CartesianIdentification.rectangle_balance_lift
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : ℝ → ℝ → State) (d : D) (hq : IsRectangleConservationLawSolution q (flux d))
    (cell : Cell) (s t : ℝ) :
    data.cellVolume cell • (data.cellMean (fun x τ => q (x d) τ) cell t -
      data.cellMean (fun x τ => q (x d) τ) cell s) =
      ∫ τ in s..t, data.faceFlux d (fun x τ => q (x d) τ) (data.leftFace d cell) τ -
        data.faceFlux d (fun x τ => q (x d) τ) (data.rightFace d cell) τ := by
  have href := DirectionalFiniteVolume.cartesian_reference axes d (flux d) q hq s t
  have hb := href.2 (cellPosition cell)
  rw [h.cellVolume_eq, h.cellMean_lift q d cell t (hq.1 _ _ t),
    h.cellMean_lift q d cell s (hq.1 _ _ s)]
  simpa only [h.faceFlux_lift, h.left_position, h.right_position] using hb

end NumStability.FiniteCartesian
