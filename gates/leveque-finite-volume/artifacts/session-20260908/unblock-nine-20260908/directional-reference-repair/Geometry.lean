import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import Mathlib.MeasureTheory.Integral.Pi

open MeasureTheory
open scoped BigOperators
namespace NumStability.DirectionalGeometryRepair
open DirectionalFiniteVolume
variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
variable {FacePoint : Type*} [MeasurableSpace FacePoint]

/-- Identification of actual cell measures and actual shared physical faces.
Equality of restricted measures records null-boundary conventions explicitly;
it is substantially stronger than equality of numerical volume scalars.
The same directional law occurs in the face-flux identification. -/
structure CartesianIdentification
    (data : PhysicalData D (D → ℝ) FacePoint m)
    (axes : D → OneDimensionalFiniteVolumeGrid) (flux : D → (Fin m → ℝ) → Fin m → ℝ) : Prop where
  cell_measure : ∀ cell, data.measure.restrict (data.cells.cellRegion cell) =
    volume.restrict (CartesianGrid.cellBox axes cell)
  face_measurable : ∀ d cell, AEMeasurable (data.facePoint d cell) (data.faceMeasure d cell)
  face_measure : ∀ d cell, Measure.map (data.facePoint d cell) (data.faceMeasure d cell) =
    Measure.map (CartesianGrid.facePoint axes d cell)
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell))
  normal_flux : ∀ d cell, ∀ᵐ point ∂data.faceMeasure d cell,
    ∀ value, data.normalFlux d cell point value = flux d value

theorem CartesianIdentification.cellVolume_eq
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (cell : D → ℤ) :
    data.cellVolume cell = CartesianGrid.cellVolume axes cell := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  rw [PhysicalData.cellVolume, hm, CartesianGrid.cellBox_volume]

theorem CartesianIdentification.cellMean_eq
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : (D → ℝ) → ℝ → Fin m → ℝ)
    (cell : D → ℤ) (t : ℝ) :
    data.cellMean q cell t = cellVolumeAverage volume (CartesianGrid.cellBox axes cell) (fun x => q x t) := by
  have hm := congrArg (fun μ : Measure (D → ℝ) => μ Set.univ) (h.cell_measure cell)
  simp only [Measure.restrict_apply_univ] at hm
  simp only [PhysicalData.cellMean, cellVolumeAverage, hm, h.cell_measure cell]

theorem cartesian_facePoint_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) : Measurable (CartesianGrid.facePoint axes d cell) := by
  apply measurable_pi_lambda
  intro e
  by_cases he : e = d
  · subst e
    simpa only [CartesianGrid.facePoint_normal] using
      (measurable_const : Measurable (fun _ : {e : D // e ≠ d} → ℝ => (axes d).cellLeft (cell d)))
  · simpa only [CartesianGrid.facePoint_transverse axes d cell _ e he] using
      (measurable_pi_apply (⟨e, he⟩ : {e : D // e ≠ d}))

/-- Actual physical face integrals, with their actual field evaluation, are
transported to the corresponding Cartesian face of the same directional law. -/
theorem CartesianIdentification.faceFlux_eq
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : (D → ℝ) → ℝ → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (t : ℝ)
    (hmeas : AEStronglyMeasurable (fun x => flux d (q x t))
      (Measure.map (CartesianGrid.facePoint axes d cell)
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell)))) :
    data.faceFlux d q cell t =
      ∫ point in CartesianGrid.tangentialFaceBox axes d cell,
        flux d (q (CartesianGrid.facePoint axes d cell point) t) := by
  unfold PhysicalData.faceFlux
  calc
    _ = ∫ point, flux d (q (data.facePoint d cell point) t) ∂data.faceMeasure d cell := by
      apply integral_congr_ae
      filter_upwards [h.normal_flux d cell] with point hp
      exact hp _
    _ = ∫ x, flux d (q x t) ∂Measure.map (data.facePoint d cell) (data.faceMeasure d cell) := by
      symm
      exact integral_map (h.face_measurable d cell) (by rw [h.face_measure]; exact hmeas)
    _ = ∫ point in CartesianGrid.tangentialFaceBox axes d cell,
        flux d (q (CartesianGrid.facePoint axes d cell point) t) := by
      rw [h.face_measure]
      exact integral_map (cartesian_facePoint_measurable axes d cell).aemeasurable hmeas

end NumStability.DirectionalGeometryRepair

#check NumStability.DirectionalGeometryRepair.CartesianIdentification
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification
#check NumStability.DirectionalGeometryRepair.CartesianIdentification.cellVolume_eq
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.cellVolume_eq
#check NumStability.DirectionalGeometryRepair.CartesianIdentification.cellMean_eq
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.cellMean_eq
#check NumStability.DirectionalGeometryRepair.cartesian_facePoint_measurable
#print axioms NumStability.DirectionalGeometryRepair.cartesian_facePoint_measurable
#check NumStability.DirectionalGeometryRepair.CartesianIdentification.faceFlux_eq
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.faceFlux_eq
