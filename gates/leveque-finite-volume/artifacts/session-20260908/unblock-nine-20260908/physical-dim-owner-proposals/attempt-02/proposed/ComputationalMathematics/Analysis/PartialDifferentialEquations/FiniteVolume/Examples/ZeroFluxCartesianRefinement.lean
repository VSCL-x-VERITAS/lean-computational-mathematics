/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.RefiningCartesianBoundary
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalRefinementQuality

/-!
# A complete zero-flux physical refinement example

The growing measured Cartesian family, actual boundary regions and zero-flux capacity
method instantiate the full quality contract. A fixed spatially nonconstant stationary
C-infinity field belongs to its genuine reference class at every level. Stability is
proved separately. This example does not assert solver availability for arbitrary laws.
-/

namespace NumStability.ZeroFluxCartesianRefinement
open NumStability MeasureTheory Set Filter
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian
open scoped BigOperators Topology
open NumStability.RefiningCartesianGrid (Direction State Point Position Cell)

def zeroFlux : Direction → State → State := fun _ _ => 0

theorem zero_hyperbolic : ∀ d, IsHyperbolicFluxOn (zeroFlux d) univ :=
  fun _ => NumStability.constantFlux_isHyperbolicOn 0 univ

noncomputable def data (n : ℕ) := NumStability.RefiningCartesianGrid.physicalWith n zeroFlux zero_hyperbolic
noncomputable def coordinates (n : ℕ) := NumStability.RefiningCartesianGrid.coord n (fun _ _ _ => 0)

noncomputable def method (n : ℕ) : NumStability.CapacityCoordinate.Method (data n) (coordinates n) where
  incidence := {
    left_line := fun _ _ => rfl
    right_line := by
      intro d cell
      simp [coordinates, NumStability.RefiningCartesianGrid.coord, data,
        NumStability.RefiningCartesianGrid.physicalWith, FiniteCartesian.data]
    left_index := fun _ _ => rfl
    right_index := by
      intro d cell
      simp [coordinates, NumStability.RefiningCartesianGrid.coord, data,
        NumStability.RefiningCartesianGrid.physicalWith, FiniteCartesian.data] }
  numericalFlux := fun _ _ _ _ _ => 0
  admitted := fun _ _ _ _ => True

/-- A complete inhabitant of the frozen physical-family interface. The
measured grid and physical diameters are the already verified growing boxes;
the zero tensor flux is fixed across all refinement levels. -/
noncomputable def family : NumStability.PhysicalRefinementQuality.Family Direction Point 1 where
  Cell := Cell
  Face := fun _ => Position
  Line := fun _ => Position
  finiteCell := fun _ => inferInstance
  data := data
  coordinates := coordinates
  method := method
  measure := volume
  measure_eq := fun _ => rfl
  states := fun _ => univ
  states_nonempty := fun _ => ⟨0, mem_univ _⟩
  states_eq := fun _ _ => rfl
  physicalFlux := fun _ _ _ => 0
  normal := fun _ d _ _ => NumStability.RefiningCartesianGrid.normal d
  normal_flux_eq := by
    intro n d face point state
    simp [data, NumStability.RefiningCartesianGrid.physicalWith, FiniteCartesian.data, zeroFlux]
  region := NumStability.RefiningCartesianGrid.region
  target := NumStability.RefiningCartesianGrid.target
  target_interior_nonempty := by
    rw [NumStability.RefiningCartesianGrid.target_open.interior_eq]
    exact NumStability.RefiningCartesianGrid.target_nonempty
  target_inside := NumStability.RefiningCartesianGrid.target_inside.trans interior_subset
  active_inside := NumStability.RefiningCartesianGrid.active_inside
  target_covered := NumStability.RefiningCartesianGrid.target_covered
  bounded_cells := fun n cell => NumStability.RefiningCartesianGrid.box_bounded n cell.val
  mesh := NumStability.RefiningCartesianGrid.actualMesh
  mesh_actual := fun _ => rfl
  mesh_pos := NumStability.RefiningCartesianGrid.actualMesh_positive
  mesh_tendsto := NumStability.RefiningCartesianGrid.actualMesh_tendsto
  horizon := 1
  horizon_pos := by norm_num
  boundaryRegion := NumStability.RefiningCartesianGrid.boundaryRegion
  boundary_measurable := NumStability.RefiningCartesianGrid.boundary_measurable
  boundary_positive := fun n d line j =>
    ne_of_gt (NumStability.RefiningCartesianGrid.boundary_positive_finite n d line j).1
  boundary_finite := fun n d line j =>
    ne_of_lt (NumStability.RefiningCartesianGrid.boundary_positive_finite n d line j).2
  boundary_inside := NumStability.RefiningCartesianGrid.boundary_inside

theorem family_quality : family.HasHighResolution :=
  family.zero_flux_quality (by intros; rfl) (by intros; trivial) (by intros; rfl)

theorem family_stable (n : ℕ) (d : Direction) (dt : ℝ) :
    (family.method n).StableAt d dt 1 :=
  family.zero_flux_stable (by intros; rfl) n d dt

def stationary (x : Point) (_t : ℝ) : State := fun _ => x 0 + x 1

theorem stationary_smooth :
    ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry stationary) := by
  exact contDiff_pi.mpr (fun _ => ((contDiff_apply ℝ ℝ 0).comp contDiff_fst).add
    ((contDiff_apply ℝ ℝ 1).comp contDiff_fst))

theorem stationary_nonconstant :
    ∃ x ∈ family.target, ∃ y ∈ family.target, stationary x 0 ≠ stationary y 0 := by
  refine ⟨fun _ => 1/4, ?_, fun _ => 3/4, ?_, ?_⟩
  · norm_num [family, NumStability.RefiningCartesianGrid.target]
  · norm_num [family, NumStability.RefiningCartesianGrid.target]
  · intro he
    have he0 := congrFun he (0 : Fin 1)
    norm_num [stationary] at he0

theorem stationary_box_integrable (n : ℕ) (pos : Position) (t : ℝ) :
    IntegrableOn (fun x => stationary x t)
      (CartesianGrid.cellBox (NumStability.RefiningCartesianGrid.axes n) pos) volume := by
  have hc : Continuous (fun x => stationary x t) :=
    continuous_pi (fun _ => (continuous_apply 0).add (continuous_apply 1))
  apply (hc.integrableOn_Icc
    (a := fun d => (NumStability.RefiningCartesianGrid.axes n d).cellLeft (pos d))
    (b := fun d => (NumStability.RefiningCartesianGrid.axes n d).cellRight (pos d))).mono_set
  intro x hx
  exact ⟨fun e => (hx e (mem_univ e)).1, fun e => (hx e (mem_univ e)).2.le⟩

theorem faceFlux_zero (n : ℕ) (d : Direction) (q : Point → ℝ → State) (face : Position) (t : ℝ) :
    (data n).faceFlux d q face t = 0 := by
  simp [PhysicalData.faceFlux, data, NumStability.RefiningCartesianGrid.physicalWith,
    FiniteCartesian.data, zeroFlux]

theorem stationary_reference (n : ℕ) (d : Direction) (s t : ℝ) :
    (data n).ReferenceOn d stationary s t := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro cell τ _
    exact stationary_box_integrable n cell.val τ
  · intro cell τ _
    exact ⟨integrable_zero _ _ _, integrable_zero _ _ _⟩
  · intro x hx τ hτ
    exact mem_univ _
  · intro u hu v hv
    refine ⟨?_, ?_⟩
    · intro cell
      simp only [show (data n).faceFlux d stationary = fun _ _ => 0 from funext (fun f => funext (faceFlux_zero n d stationary f))]
      exact ⟨intervalIntegrable_const, intervalIntegrable_const⟩
    · intro cell
      simp only [faceFlux_zero, sub_self, intervalIntegral.integral_zero]
      have hmean : (data n).cellMean stationary cell v = (data n).cellMean stationary cell u := rfl
      rw [hmean, sub_self, smul_zero]

theorem stationary_in_reference_class (d : Direction) : family.SmoothReference d stationary := by
  refine ⟨stationary_smooth.contDiffOn, ?_, ?_⟩
  · intro n
    exact stationary_reference n d 0 1
  · intro n line j
    exact stationary_box_integrable n _ 0

theorem stationary_certificates (d : Direction) :
    ∃ p : ℝ, 1 < p ∧ Nonempty (family.AccuracyCertificate d stationary p) := by
  obtain ⟨p, hp, certificates⟩ := family_quality.order d
  exact ⟨p, hp, certificates stationary (stationary_in_reference_class d)⟩

/-- The same fixed nonconstant reference belongs to the genuine class used
by the full quality theorem; its class is not an arbitrary eligibility tag. -/
theorem nonconstant_full_quality :
    family.HasHighResolution ∧
    (∃ x ∈ family.target, ∃ y ∈ family.target, stationary x 0 ≠ stationary y 0) ∧
    (∀ d, family.SmoothReference d stationary) ∧
    (∀ n, 0 < family.mesh n) ∧ Tendsto family.mesh atTop (𝓝 0) :=
  ⟨family_quality, stationary_nonconstant, stationary_in_reference_class,
    family.mesh_pos, family.mesh_tendsto⟩

end NumStability.ZeroFluxCartesianRefinement
