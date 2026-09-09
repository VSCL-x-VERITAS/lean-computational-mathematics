import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.MeasureTheory.Function.LocallyIntegrable

/-! Artifact-only genuine directional reference. Each q_d solves its selected
unit-speed directional problem; no unsplit multi-directional PDE is asserted. -/
namespace CartesianDirectionalAffineReference
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.FiniteCartesian
open scoped BigOperators
abbrev Direction := Fin 2
abbrev Point := Direction → ℝ
abbrev State := Fin 1 → ℝ

def profile (x t : ℝ) : State := CFLUnitShift.smoothProfile (x - t)
def reference (d : Direction) (x : Point) (t : ℝ) : State := profile (x d) t

theorem reference_smooth (d : Direction) :
    ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry (reference d)) := by
  exact contDiff_pi.mpr (fun _ => ((contDiff_apply ℝ ℝ d).comp contDiff_fst).sub contDiff_snd)

theorem reference_nonconstant (d : Direction) :
    reference d (fun _ => 0) 0 ≠ reference d (fun _ => 1) 0 := by
  intro h
  apply CFLUnitShift.smoothProfile_nonconstant
  simpa only [reference, profile, sub_zero] using h

theorem profile_rectangle : IsRectangleConservationLawSolution profile id :=
  CFLUnitShift.translated_is_conserved _ CFLUnitShift.smoothProfile_integrable

theorem interval_mean {a b : ℝ} (hab : a < b) (t : ℝ) :
    oneDimensionalCellAverage (fun x => profile x t) a b = fun _ => (a + b) / 2 - t := by
  have hf : (fun x => profile x t) = fun x => (x - t) • (1 : State) := by
    funext x i
    simp [profile, CFLUnitShift.smoothProfile]
  rw [hf, oneDimensionalCellAverage, intervalIntegral.integral_smul_const]
  rw [intervalIntegral.integral_sub (f := fun x : ℝ => x) (g := fun _ => t)
    (continuous_id.intervalIntegrable a b) (continuous_const.intervalIntegrable a b),
    integral_id, intervalIntegral.integral_const]
  ext i
  simp only [Pi.smul_apply, smul_eq_mul, Pi.one_apply, mul_one]
  field_simp [ne_of_gt (sub_pos.mpr hab)]
  nlinarith

variable (axes : Direction → OneDimensionalFiniteVolumeGrid)
variable (active : Finset (Direction → ℤ)) (hne : active.Nonempty)
variable (hflux : ∀ _ : Direction, IsHyperbolicFluxOn (id : State → State) Set.univ)

noncomputable def physical := FiniteCartesian.data axes active hne (fun _ => Set.univ) (fun _ => id) hflux

theorem identification : CartesianIdentification (physical axes active hne hflux) axes Subtype.val
    (fun _ face => face) (fun _ => id) where
  left_position := fun _ _ => rfl
  right_position := fun _ _ => rfl
  cell_measure := fun _ => rfl
  face_measurable := data_face_measurable axes active hne _ _ hflux
  face_measure := data_face_measure axes active hne _ _ hflux
  normal_flux := data_normal_flux axes active hne _ _ hflux

theorem box_integrable (d : Direction) (position : Direction → ℤ) (t : ℝ) :
    IntegrableOn (fun x => reference d x t) (CartesianGrid.cellBox axes position) volume := by
  have hc : Continuous (fun x : Point => reference d x t) := by
    exact continuous_pi fun _ => (continuous_apply d).sub continuous_const
  apply (hc.integrableOn_Icc (a := fun e => (axes e).cellLeft (position e))
    (b := fun e => (axes e).cellRight (position e))).mono_set
  intro x hx
  exact ⟨fun e => (hx e (mem_univ e)).1, fun e => (hx e (mem_univ e)).2.le⟩

theorem face_integrable (d : Direction) (face : Direction → ℤ) (t : ℝ) :
    Integrable (fun x => reference d x t) (FiniteCartesian.faceMeasure axes d face) := by
  have hp : 0 < (FiniteCartesian.faceMeasure axes d face Set.univ).toReal := by
    rw [FiniteCartesian.faceMeasure_area]
    exact Finset.prod_pos (fun e _ => (axes e).cellVolume_pos (face e))
  haveI : IsFiniteMeasure (FiniteCartesian.faceMeasure axes d face) :=
    ⟨(ENNReal.toReal_pos_iff.mp hp).2⟩
  have hn : ∀ᵐ x ∂FiniteCartesian.faceMeasure axes d face,
      x d = (axes d).cellLeft (face d) := by
    rw [FiniteCartesian.faceMeasure, ae_map_iff
      (FiniteCartesian.facePoint_measurable axes d face).aemeasurable
      (measurableSet_eq_fun (measurable_pi_apply d) measurable_const)]
    exact Filter.Eventually.of_forall (CartesianGrid.facePoint_normal axes d face)
  apply (integrable_const (profile ((axes d).cellLeft (face d)) t)).congr
  filter_upwards [hn] with x hx
  simp only [reference, hx]

theorem cell_mean (d : Direction) (cell : ↥active) (t : ℝ) :
    (physical axes active hne hflux).cellMean (reference d) cell t =
      fun _ => ((axes d).cellLeft (cell.val d) + (axes d).cellRight (cell.val d)) / 2 - t := by
  unfold reference
  rw [(identification axes active hne hflux).cellMean_lift profile d cell t (profile_rectangle.1 _ _ t)]
  exact interval_mean ((axes d).cell_nonempty (cell.val d)) t

theorem face_flux (d : Direction) (face : Direction → ℤ) (t : ℝ) :
    (physical axes active hne hflux).faceFlux d (reference d) face t =
      CartesianGrid.faceArea axes d face • profile ((axes d).cellLeft (face d)) t :=
  (identification axes active hne hflux).faceFlux_lift profile d face t

theorem face_time_integrable (d : Direction) (face : Direction → ℤ) (s t : ℝ) :
    IntervalIntegrable ((physical axes active hne hflux).faceFlux d (reference d) face) volume s t := by
  have he : (physical axes active hne hflux).faceFlux d (reference d) face =
      fun τ => CartesianGrid.faceArea axes d face • profile ((axes d).cellLeft (face d)) τ :=
    funext (face_flux axes active hne hflux d face)
  rw [he]
  exact (profile_rectangle.2.1 ((axes d).cellLeft (face d)) s t).smul
    (CartesianGrid.faceArea axes d face)

theorem reference_valid (d : Direction) (s t : ℝ) :
    (physical axes active hne hflux).ReferenceOn d (reference d) s t := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro cell τ _
    exact box_integrable axes d cell.val τ
  · intro cell τ _
    exact ⟨face_integrable axes d cell.val τ,
      face_integrable axes d (Function.update cell.val d (cell.val d + 1)) τ⟩
  · intro x hx τ hτ
    exact Set.mem_univ _
  · intro u hu v hv
    refine ⟨?_, ?_⟩
    · intro cell
      exact ⟨face_time_integrable axes active hne hflux d cell.val u v,
        face_time_integrable axes active hne hflux d
          (Function.update cell.val d (cell.val d + 1)) u v⟩
    · intro cell
      exact (identification axes active hne hflux).rectangle_balance_lift profile d profile_rectangle cell u v

/-- An actual Ico ghost box has the same measured mean; it need not be an
active cell. No boundary condition or finite lookup is asserted here. -/
theorem ghost_box_mean (d : Direction) (position : Direction → ℤ) :
    cellVolumeAverage volume (CartesianGrid.cellBox axes position)
      (fun x => reference d x 0) =
      fun _ => ((axes d).cellLeft (position d) + (axes d).cellRight (position d)) / 2 := by
  unfold reference
  rw [CartesianGrid.cellVolumeAverage_projection axes d position (fun x => profile x 0)
    (profile_rectangle.1 _ _ 0)]
  simpa only [sub_zero] using interval_mean ((axes d).cell_nonempty (position d)) 0

end CartesianDirectionalAffineReference

#check CartesianDirectionalAffineReference.reference_smooth
#print axioms CartesianDirectionalAffineReference.reference_smooth
#check CartesianDirectionalAffineReference.reference_nonconstant
#print axioms CartesianDirectionalAffineReference.reference_nonconstant
#check CartesianDirectionalAffineReference.profile_rectangle
#print axioms CartesianDirectionalAffineReference.profile_rectangle
#check CartesianDirectionalAffineReference.interval_mean
#print axioms CartesianDirectionalAffineReference.interval_mean
#check CartesianDirectionalAffineReference.identification
#print axioms CartesianDirectionalAffineReference.identification
#check CartesianDirectionalAffineReference.box_integrable
#print axioms CartesianDirectionalAffineReference.box_integrable
#check CartesianDirectionalAffineReference.face_integrable
#print axioms CartesianDirectionalAffineReference.face_integrable
#check CartesianDirectionalAffineReference.cell_mean
#print axioms CartesianDirectionalAffineReference.cell_mean
#check CartesianDirectionalAffineReference.face_flux
#print axioms CartesianDirectionalAffineReference.face_flux
#check CartesianDirectionalAffineReference.reference_valid
#print axioms CartesianDirectionalAffineReference.reference_valid
#check CartesianDirectionalAffineReference.face_time_integrable
#print axioms CartesianDirectionalAffineReference.face_time_integrable
#check CartesianDirectionalAffineReference.ghost_box_mean
#print axioms CartesianDirectionalAffineReference.ghost_box_mean
