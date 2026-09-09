import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import Mathlib.MeasureTheory.Integral.Pi
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage

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

open MeasureTheory
open scoped BigOperators
namespace NumStability.CartesianProjectionRepair
variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

theorem integral_cellBox_projection (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (q : ℝ → Fin m → ℝ)
    (hq : IntervalIntegrable q volume ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))) :
    (∫ x in CartesianGrid.cellBox axes cell, q (x d)) =
      CartesianGrid.faceArea axes d cell •
        ∫ x in (axes d).cellLeft (cell d)..(axes d).cellRight (cell d), q x := by
  let μ : D → Measure ℝ := fun e => volume.restrict
    (Set.Ico ((axes e).cellLeft (cell e)) ((axes e).cellRight (cell e)))
  haveI (e : D) : IsFiniteMeasure (μ e) := ⟨by
    simp [μ, Real.volume_Ico]⟩
  have hμ : volume.restrict (CartesianGrid.cellBox axes cell) = Measure.pi μ := by
    exact Measure.restrict_pi_pi (μ := fun _ : D => (volume : Measure ℝ))
      (fun e => Set.Ico ((axes e).cellLeft (cell e)) ((axes e).cellRight (cell e)))
  have hqμ : Integrable q (μ d) := by
    dsimp [μ]
    rw [Measure.restrict_congr_set (Ico_ae_eq_Ioc (μ := volume))]
    exact (intervalIntegrable_iff_integrableOn_Ioc_of_le ((axes d).cell_nonempty (cell d)).le).mp hq
  have hmap : AEStronglyMeasurable q ((Measure.pi μ).map (Function.eval d)) := by
    rw [Measure.pi_map_eval]
    exact hqμ.aestronglyMeasurable.smul_measure _
  have harea : (∏ e ∈ Finset.univ.erase d, μ e Set.univ).toReal = CartesianGrid.faceArea axes d cell := by
    simp only [ENNReal.toReal_prod, μ, Measure.restrict_apply_univ, Real.volume_Ico]
    unfold CartesianGrid.faceArea
    apply Finset.prod_congr rfl
    intro e _
    exact ENNReal.toReal_ofReal (sub_nonneg.mpr ((axes e).cell_nonempty (cell e)).le)
  calc
    _ = ∫ x, q (x d) ∂Measure.pi μ := by rw [hμ]
    _ = ∫ x, q x ∂(Measure.pi μ).map (Function.eval d) :=
      (integral_map (measurable_pi_apply d).aemeasurable hmap).symm
    _ = (∏ e ∈ Finset.univ.erase d, μ e Set.univ).toReal • ∫ x, q x ∂μ d := by
      rw [Measure.pi_map_eval, integral_smul_measure]
    _ = _ := by
      rw [harea]
      dsimp [μ]
      rw [Measure.restrict_congr_set (Ico_ae_eq_Ioc (μ := volume)),
        ← intervalIntegral.integral_of_le ((axes d).cell_nonempty (cell d)).le]

theorem cellVolumeAverage_projection (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (q : ℝ → Fin m → ℝ)
    (hq : IntervalIntegrable q volume ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))) :
    cellVolumeAverage volume (CartesianGrid.cellBox axes cell) (fun x => q (x d)) =
      finiteVolumeCellAverageOn (axes d) q (cell d) := by
  rw [cellVolumeAverage, CartesianGrid.cellBox_volume, integral_cellBox_projection axes d cell q hq,
    CartesianGrid.cellVolume_eq_width_mul_area, smul_smul]
  have harea : 0 < CartesianGrid.faceArea axes d cell := by
    exact Finset.prod_pos (fun e _ => (axes e).cellVolume_pos (cell e))
  have hwidth := (axes d).cellVolume_pos (cell d)
  unfold finiteVolumeCellAverageOn oneDimensionalCellAverage
  change (((axes d).cellVolume (cell d) * CartesianGrid.faceArea axes d cell)⁻¹ *
    CartesianGrid.faceArea axes d cell) • _ = ((axes d).cellVolume (cell d))⁻¹ • _
  congr 1
  field_simp

end NumStability.CartesianProjectionRepair

namespace NumStability.DirectionalGeometryRepair
open MeasureTheory DirectionalFiniteVolume
variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
variable {FacePoint : Type*} [MeasurableSpace FacePoint]

theorem CartesianIdentification.cellMean_lift
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : ℝ → ℝ → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (t : ℝ)
    (hq : IntervalIntegrable (fun x => q x t) volume
      ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d))) :
    data.cellMean (fun x τ => q (x d) τ) cell t =
      finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cell d) := by
  rw [h.cellMean_eq]
  exact CartesianProjectionRepair.cellVolumeAverage_projection axes d cell (fun x => q x t) hq

theorem CartesianIdentification.faceFlux_lift
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : ℝ → ℝ → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (t : ℝ) :
    data.faceFlux d (fun x τ => q (x d) τ) cell t =
      CartesianGrid.faceArea axes d cell • flux d (q ((axes d).cellLeft (cell d)) t) := by
  have hnormal : ∀ᵐ x ∂Measure.map (CartesianGrid.facePoint axes d cell)
      (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell)),
      x d = (axes d).cellLeft (cell d) := by
    rw [ae_map_iff (cartesian_facePoint_measurable axes d cell).aemeasurable
      (measurableSet_eq_fun (measurable_pi_apply d) measurable_const)]
    exact Filter.Eventually.of_forall (CartesianGrid.facePoint_normal axes d cell)
  have hm : AEStronglyMeasurable (fun x : D → ℝ => flux d (q (x d) t))
      (Measure.map (CartesianGrid.facePoint axes d cell)
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d cell))) := by
    apply (aestronglyMeasurable_const (b := flux d (q ((axes d).cellLeft (cell d)) t))).congr
    filter_upwards [hnormal] with x hx
    rw [hx]
  rw [h.faceFlux_eq _ d cell t hm]
  simp only [CartesianGrid.facePoint_normal, setIntegral_const,
    measureReal_def, CartesianGrid.tangentialFaceBox_volume]

/-- The actual identified field, cell means and boundary fluxes form the
Cartesian directional reference; no unrelated physical flux is quantified. -/
theorem CartesianIdentification.directional_reference_lift
    {data : PhysicalData D (D → ℝ) FacePoint m}
    {axes : D → OneDimensionalFiniteVolumeGrid} {flux : D → (Fin m → ℝ) → Fin m → ℝ}
    (h : CartesianIdentification data axes flux) (q : ℝ → ℝ → Fin m → ℝ)
    (d : D) (hq : IsRectangleConservationLawSolution q (flux d)) (s t : ℝ) :
    IsDirectionalReference data.cellVolume
      (data.cellMean (fun x τ => q (x d) τ))
      (data.faceFlux d (fun x τ => q (x d) τ)) d s t := by
  have hvol : data.cellVolume = CartesianGrid.cellVolume axes := funext h.cellVolume_eq
  have havg : data.cellMean (fun x τ => q (x d) τ) =
      fun cell τ => finiteVolumeCellAverageOn (axes d) (fun x => q x τ) (cell d) := by
    funext cell τ
    exact h.cellMean_lift q d cell τ (hq.1 _ _ τ)
  have hface : data.faceFlux d (fun x τ => q (x d) τ) =
      fun cell τ => CartesianGrid.faceArea axes d cell • flux d (q ((axes d).cellLeft (cell d)) τ) := by
    funext cell τ
    exact h.faceFlux_lift q d cell τ
  rw [hvol, havg, hface]
  exact DirectionalFiniteVolume.cartesian_reference axes d (flux d) q hq s t

end NumStability.DirectionalGeometryRepair

#check NumStability.DirectionalGeometryRepair.CartesianIdentification.cellMean_lift
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.cellMean_lift
#check NumStability.DirectionalGeometryRepair.CartesianIdentification.faceFlux_lift
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.faceFlux_lift
#check NumStability.DirectionalGeometryRepair.CartesianIdentification.directional_reference_lift
#print axioms NumStability.DirectionalGeometryRepair.CartesianIdentification.directional_reference_lift
