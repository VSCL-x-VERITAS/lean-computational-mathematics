import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting
import Mathlib.MeasureTheory.Integral.Pi

open MeasureTheory
open scoped BigOperators
namespace NumStability.FiniteDirectionalRepair

/-- Finite active physical cells with shared face IDs. Exterior faces require
incidence with their active cell only; no fictitious exterior physical cell
or unspecified boundary condition is introduced. -/
structure PhysicalData (D Cell Face Point FacePoint : Type*)
    [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] (m : ℕ) where
  cells : FiniteVolumeCellPartition Cell Point
  measure : Measure Point
  positive : ∀ cell, measure (cells.cellRegion cell) ≠ 0
  finite : ∀ cell, measure (cells.cellRegion cell) ≠ ⊤
  leftFace : D → Cell → Face
  rightFace : D → Cell → Face
  faceMeasure : D → Face → Measure FacePoint
  facePoint : D → Face → FacePoint → Point
  left_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (leftFace d cell),
    facePoint d (leftFace d cell) point ∈ closure (cells.cellRegion cell)
  right_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (rightFace d cell),
    facePoint d (rightFace d cell) point ∈ closure (cells.cellRegion cell)
  admissibleStates : D → Set (Fin m → ℝ)
  normalFlux : D → Face → FacePoint → (Fin m → ℝ) → Fin m → ℝ
  hyperbolic : ∀ d face point, IsHyperbolicFluxOn (normalFlux d face point) (admissibleStates d)

variable {D Cell Face Point FacePoint : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

noncomputable def PhysicalData.cellVolume (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : ℝ := (data.measure (data.cells.cellRegion cell)).toReal

theorem PhysicalData.cellVolume_pos (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : 0 < data.cellVolume cell := ENNReal.toReal_pos (data.positive cell) (data.finite cell)

noncomputable def PhysicalData.cellMean (data : PhysicalData D Cell Face Point FacePoint m)
    (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)

noncomputable def PhysicalData.faceFlux (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (face : Face) (t : ℝ) : State :=
  ∫ point, data.normalFlux d face point (q (data.facePoint d face point) t) ∂data.faceMeasure d face

/-- Every subinterval has an actual physical integral balance. All regularity
and trace premises are restricted to active cells and their incident faces. -/
def PhysicalData.ReferenceOn (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (s t : ℝ) : Prop :=
  (∀ cell, ∀ τ ∈ Set.uIcc s t, IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure) ∧
  (∀ cell, ∀ τ ∈ Set.uIcc s t,
    Integrable (fun point => data.normalFlux d (data.leftFace d cell) point
      (q (data.facePoint d (data.leftFace d cell) point) τ)) (data.faceMeasure d (data.leftFace d cell)) ∧
    Integrable (fun point => data.normalFlux d (data.rightFace d cell) point
      (q (data.facePoint d (data.rightFace d cell) point) τ)) (data.faceMeasure d (data.rightFace d cell))) ∧
  (∀ x ∈ data.cells.domain, ∀ τ ∈ Set.uIcc s t, q x τ ∈ data.admissibleStates d) ∧
  ∀ u ∈ Set.uIcc s t, ∀ v ∈ Set.uIcc s t,
    (∀ cell, IntervalIntegrable (data.faceFlux d q (data.leftFace d cell)) volume u v ∧
      IntervalIntegrable (data.faceFlux d q (data.rightFace d cell)) volume u v) ∧
    ∀ cell, data.cellVolume cell • (data.cellMean q cell v - data.cellMean q cell u) =
      ∫ τ in u..v, data.faceFlux d q (data.leftFace d cell) τ - data.faceFlux d q (data.rightFace d cell) τ

/-- Boundary/ghost inputs may be closed over in `rule`; the current numerical
array contains only actual active cell values. Shared face IDs ensure the
same numerical flux is reused by both incident cells. -/
noncomputable def advance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) : State :=
  finiteVolumeCellAverageUpdate dt (data.cellVolume cell) (current cell)
    (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell))

noncomputable def sweep (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (stages : List (D × ℝ)) (current : Cell → State) : Cell → State :=
  orderedOperatorSweep (stages.map fun stage => advance data rule stage.1 stage.2) current

theorem advance_mass_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    data.cellVolume cell • advance data rule d dt current cell =
      data.cellVolume cell • current cell - dt •
        (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell)) :=
  cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _ (data.cellVolume_pos cell).ne'

/-- The finite active-cell balance retains all exterior boundary transfers. -/
theorem finite_mass_balance [Fintype Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) :
    (∑ cell, data.cellVolume cell • advance data rule d dt current cell) =
      (∑ cell, data.cellVolume cell • current cell) - dt •
        ∑ cell, (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell)) := by
  simp_rw [advance_mass_balance]
  rw [Finset.sum_sub_distrib, Finset.smul_sum]

theorem sweep_cons (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (stages : List (D × ℝ)) (current : Cell → State) :
    sweep data rule ((d, dt) :: stages) current =
      sweep data rule stages (advance data rule d dt current) := rfl

theorem sweep_split (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (before after : List (D × ℝ)) (d : D) (dt : ℝ) (current : Cell → State) :
    sweep data rule (before ++ (d, dt) :: after) current =
      sweep data rule after (advance data rule d dt (sweep data rule before current)) := by
  simp [sweep, orderedOperatorSweep, List.foldl_append]

def LineLocal [DecidableEq Cell]
    (stencil : D → Face → Finset Cell)
    (rule : D → ℝ → (Cell → State) → Face → State) : Prop :=
  ∀ d dt current other face,
    (∀ cell ∈ stencil d face, current cell = other cell) →
      rule d dt current face = rule d dt other face

theorem advance_local [DecidableEq Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (stencil : D → Face → Finset Cell)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (hlocal : LineLocal stencil rule) (d : D) (dt : ℝ)
    (current other : Cell → State) (cell : Cell)
    (hagree : ∀ j ∈ insert cell (stencil d (data.leftFace d cell) ∪ stencil d (data.rightFace d cell)),
      current j = other j) : advance data rule d dt current cell = advance data rule d dt other cell := by
  have hc := hagree cell (by simp)
  have hl := hlocal d dt current other (data.leftFace d cell)
    (fun j hj => hagree j (by simp [hj]))
  have hr := hlocal d dt current other (data.rightFace d cell)
    (fun j hj => hagree j (by simp [hj]))
  simp only [advance, hc, hl, hr]

/-- An auxiliary local estimate uses independent physical averages and flux
histories; it is not the high-resolution class or a stand-in for that class. -/
theorem advance_error_le (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound leftBound rightBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hleft : ‖rule d (t - s) current (data.leftFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t‖ ≤ leftBound)
    (hright : ‖rule d (t - s) current (data.rightFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t‖ ≤ rightBound) :
    ‖advance data rule d (t - s) current cell - data.cellMean q cell t‖ ≤
      oldBound + (t - s) / data.cellVolume cell * (leftBound + rightBound) := by
  have href' := href.2.2.2 s Set.left_mem_uIcc t Set.right_mem_uIcc
  have hb := href'.2 cell
  rw [intervalIntegral.integral_sub (href'.1 cell).1 (href'.1 cell).2] at hb
  rw [smul_sub] at hb
  rw [← cellWidth_smul_oneDimensionalCellAverage _ hst,
    ← cellWidth_smul_oneDimensionalCellAverage _ hst] at hb
  have he : data.cellVolume cell • (advance data rule d (t - s) current cell - data.cellMean q cell t) =
      data.cellVolume cell • (current cell - data.cellMean q cell s) +
      (t - s) • ((rule d (t - s) current (data.leftFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t) -
        (rule d (t - s) current (data.rightFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t)) := by
    rw [smul_sub, advance_mass_balance, eq_add_of_sub_eq hb]
    module
  exact norm_le_of_weighted_error_balance (data.cellVolume_pos cell) (sub_nonneg.mpr hst.le)
    he hold hleft hright

end NumStability.FiniteDirectionalRepair

#check NumStability.FiniteDirectionalRepair.PhysicalData
#print axioms NumStability.FiniteDirectionalRepair.PhysicalData
#check NumStability.FiniteDirectionalRepair.PhysicalData.ReferenceOn
#print axioms NumStability.FiniteDirectionalRepair.PhysicalData.ReferenceOn
#check NumStability.FiniteDirectionalRepair.advance_mass_balance
#print axioms NumStability.FiniteDirectionalRepair.advance_mass_balance
#check NumStability.FiniteDirectionalRepair.finite_mass_balance
#print axioms NumStability.FiniteDirectionalRepair.finite_mass_balance
#check NumStability.FiniteDirectionalRepair.sweep_cons
#print axioms NumStability.FiniteDirectionalRepair.sweep_cons
#check NumStability.FiniteDirectionalRepair.sweep_split
#print axioms NumStability.FiniteDirectionalRepair.sweep_split
#check NumStability.FiniteDirectionalRepair.LineLocal
#print axioms NumStability.FiniteDirectionalRepair.LineLocal
#check NumStability.FiniteDirectionalRepair.advance_local
#print axioms NumStability.FiniteDirectionalRepair.advance_local
#check NumStability.FiniteDirectionalRepair.advance_error_le
#print axioms NumStability.FiniteDirectionalRepair.advance_error_le

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
namespace NumStability.FiniteCartesianRepair
open MeasureTheory FiniteDirectionalRepair
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
variable {flux : D → State → State}

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
  simp only [PhysicalData.cellMean, cellVolumeAverage, hm, h.cell_measure cell]

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
        (DirectionalGeometryRepair.cartesian_facePoint_measurable axes d (facePosition d face)).aemeasurable hmeas

theorem CartesianIdentification.cellMean_lift
    (h : CartesianIdentification data axes cellPosition facePosition flux)
    (q : ℝ → ℝ → State) (d : D) (cell : Cell) (t : ℝ)
    (hq : IntervalIntegrable (fun x => q x t) volume
      ((axes d).cellLeft (cellPosition cell d)) ((axes d).cellRight (cellPosition cell d))) :
    data.cellMean (fun x τ => q (x d) τ) cell t =
      finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cellPosition cell d) := by
  rw [h.cellMean_eq]
  exact CartesianProjectionRepair.cellVolumeAverage_projection axes d (cellPosition cell) (fun x => q x t) hq

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
      (DirectionalGeometryRepair.cartesian_facePoint_measurable axes d (facePosition d face)).aemeasurable
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

end NumStability.FiniteCartesianRepair
#check NumStability.FiniteCartesianRepair.CartesianIdentification
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification
#check NumStability.FiniteCartesianRepair.CartesianIdentification.cellVolume_eq
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification.cellVolume_eq
#check NumStability.FiniteCartesianRepair.CartesianIdentification.faceFlux_lift
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification.faceFlux_lift
#check NumStability.FiniteCartesianRepair.CartesianIdentification.rectangle_balance_lift
#print axioms NumStability.FiniteCartesianRepair.CartesianIdentification.rectangle_balance_lift
