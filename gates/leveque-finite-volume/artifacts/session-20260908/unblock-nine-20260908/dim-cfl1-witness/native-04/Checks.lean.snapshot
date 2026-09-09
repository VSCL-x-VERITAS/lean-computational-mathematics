import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Analysis.Calculus.ContDiff.Operations

/-!
Explicit CFL-one transport witness. The integer array is an explicit extension
outside the finite active window, including the entering left boundary value.
Window variation is compared with the shifted input window. Exactness here is
specific to unit-speed transport and time step equal to cell width; it is not
a general high-order claim about upwind methods or nonlinear shock formation.
-/

open MeasureTheory Filter
open scoped BigOperators Topology
open NumStability

namespace CFL1RefinementWitness

def grid (h : ℝ) (hh : 0 < h) : OneDimensionalFiniteVolumeGrid where
  cellLeft j := ((j : ℝ) - 1) * h
  cellRight j := (j : ℝ) * h
  cell_nonempty j := by nlinarith
  adjacent j := by simp

theorem grid_volume (h : ℝ) (hh : 0 < h) (j : ℤ) :
    (grid h hh).cellVolume j = h := by
  simp only [OneDimensionalFiniteVolumeGrid.cellVolume, grid]
  ring

noncomputable def advance {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) : ℤ → ι → ℝ :=
  riemannFiniteVolumeUpdate (grid h hh) h Q (fun j => Q (j - 1))

theorem advance_eq_shift {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) (j : ℤ) : advance h hh Q j = Q (j - 1) := by
  simp only [advance, riemannFiniteVolumeUpdate, grid_volume, div_self (ne_of_gt hh),
    add_sub_cancel_right, one_smul]
  abel

noncomputable def averaged {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (φ : ℝ → ι → ℝ) (t : ℝ) (j : ℤ) : ι → ℝ :=
  finiteVolumeCellAverageOn (grid h hh) (fun x => φ (x - t)) j

theorem averaged_eq_shift {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (φ : ℝ → ι → ℝ) (t : ℝ) (j : ℤ) :
    averaged h hh φ (t + h) j = averaged h hh φ t (j - 1) := by
  simp only [averaged, finiteVolumeCellAverageOn, oneDimensionalCellAverage,
    grid, Int.cast_sub, Int.cast_one, intervalIntegral.integral_comp_sub_right]
  congr 2 <;> ring

theorem advance_averaged_exact {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (φ : ℝ → ι → ℝ) (t : ℝ) (j : ℤ) :
    advance h hh (averaged h hh φ t) j = averaged h hh φ (t + h) j := by
  rw [advance_eq_shift, averaged_eq_shift]

theorem averaged_is_cell_average {ι : Type*} [Fintype ι]
    (h : ℝ) (hh : 0 < h) (φ : ℝ → ι → ℝ)
    (hφ : ∀ a b, IntervalIntegrable φ volume a b) (t : ℝ) (j : ℤ) :
    IsOneDimensionalCellAverage (fun x => φ (x - t))
      ((grid h hh).cellLeft j) ((grid h hh).cellRight j)
      (averaged h hh φ t j) := by
  apply finiteVolumeCellAverageOn_spec
  intro i
  simpa only [travelingWave, one_mul] using
    travelingWave_intervalIntegrable_space φ hφ 1
      ((grid h hh).cellLeft i) ((grid h hh).cellRight i) t

theorem translated_is_conserved {ι : Type*} [Fintype ι]
    (φ : ℝ → ι → ℝ) (hφ : ∀ a b, IntervalIntegrable φ volume a b) :
    IsRectangleConservationLawSolution (fun x t => φ (x - t)) id := by
  simpa only [IsRectangleConservationLawSolution, travelingWave, one_mul, one_smul, id_eq] using
    travelingWave_isRectangleConservationLawSolution φ hφ 1

/-- Every locally integrable physical translated profile has zero defect;
the constant zero is uniform in mesh, time, cell and profile. -/
theorem physical_exactness {ι : Type*} [Fintype ι]
    (φ : ℝ → ι → ℝ) (hφ : ∀ a b, IntervalIntegrable φ volume a b)
    (h : ℝ) (hh : 0 < h) (t : ℝ) (j : ℤ) (p : ℝ) (_hp : 1 < p) :
    IsRectangleConservationLawSolution (fun x t => φ (x - t)) id ∧
    IsOneDimensionalCellAverage (fun x => φ (x - t))
      ((grid h hh).cellLeft j) ((grid h hh).cellRight j) (averaged h hh φ t j) ∧
    ‖advance h hh (averaged h hh φ t) j - averaged h hh φ (t + h) j‖ ≤
      (0 : ℝ) * h ^ p := by
  refine ⟨translated_is_conserved φ hφ, averaged_is_cell_average h hh φ hφ t j, ?_⟩
  simp only [advance_averaged_exact, sub_self, norm_zero, zero_mul, le_refl]

def window {E : Type*} (Q : ℤ → E) (start : ℤ) (N : ℕ) : Fin N → E :=
  fun i => Q (start + (i.val : ℤ))

theorem advance_window {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) (start : ℤ) (N : ℕ) :
    window (advance h hh Q) start N = window Q (start - 1) N := by
  funext i
  simp only [window, advance_eq_shift]
  congr 1; ring

/-- Sum of internal adjacent jumps in a finite window, with arbitrary start. -/
noncomputable def windowTV {ι : Type*} [Fintype ι]
    (Q : ℤ → ι → ℝ) (start : ℤ) (N : ℕ) : ℝ :=
  ∑ i ∈ Finset.range (N - 1),
    ‖Q (start + (i : ℤ) + 1) - Q (start + (i : ℤ))‖

theorem advance_windowTV {ι : Type*} [Fintype ι] (h : ℝ) (hh : 0 < h)
    (Q : ℤ → ι → ℝ) (start : ℤ) (N : ℕ) :
    windowTV (advance h hh Q) start N = windowTV Q (start - 1) N := by
  unfold windowTV
  apply Finset.sum_congr rfl
  intro i _hi
  simp only [advance_eq_shift]
  have hleft : start + (i : ℤ) + 1 - 1 = start - 1 + (i : ℤ) + 1 := by ring
  have hright : start + (i : ℤ) - 1 = start - 1 + (i : ℤ) := by ring
  rw [hleft, hright]

theorem advance_no_overshoot (h : ℝ) (hh : 0 < h)
    (Q : ℤ → Fin 1 → ℝ) (start : ℤ) (N : ℕ) (lower upper : ℝ)
    (hbound : ∀ i : Fin N, lower ≤ window Q (start - 1) N i 0 ∧
      window Q (start - 1) N i 0 ≤ upper) :
    ∀ i : Fin N, lower ≤ window (advance h hh Q) start N i 0 ∧
      window (advance h hh Q) start N i 0 ≤ upper := by
  rw [advance_window]
  exact hbound

theorem advance_preserves_monotone (h : ℝ) (hh : 0 < h)
    (Q : ℤ → Fin 1 → ℝ) (start : ℤ) (N : ℕ)
    (hmono : Monotone (fun i : Fin N => window Q (start - 1) N i 0)) :
    Monotone (fun i : Fin N => window (advance h hh Q) start N i 0) := by
  rw [advance_window]
  exact hmono

noncomputable def meshSize (n : ℕ) : ℝ := 1 / ((n : ℝ) + 1)

theorem meshSize_pos (n : ℕ) : 0 < meshSize n := by unfold meshSize; positivity

theorem meshSize_tendsto_zero : Tendsto meshSize atTop (𝓝 0) :=
  tendsto_one_div_add_atTop_nhds_zero_nat

/-- The numerical flux uses exactly the left adjacent value. -/
theorem flux_locality {ι : Type*} (Q R : ℤ → ι → ℝ) (face : ℤ)
    (h : Q (face - 1) = R (face - 1)) :
    (fun j => Q (j - 1)) face = (fun j => R (j - 1)) face := h

/-- Only the shifted finite input window is needed for the active output.
Thus a ghost extension agreeing there gives exactly the same finite output. -/
theorem advance_extension_independent {ι : Type*} (h : ℝ) (hh : 0 < h)
    (Q R : ℤ → ι → ℝ) (start : ℤ) (N : ℕ)
    (heq : window Q (start - 1) N = window R (start - 1) N) :
    window (advance h hh Q) start N = window (advance h hh R) start N := by
  rw [advance_window, advance_window, heq]

/-- A single constant works at every refinement, time, cell and finite window.
The physical profile is arbitrary subject to local interval integrability;
the conclusion therefore applies in particular to every smooth such profile. -/
theorem refinement_accuracy {ι : Type*} [Fintype ι]
    (φ : ℝ → ι → ℝ) (hφ : ∀ a b, IntervalIntegrable φ volume a b)
    (p : ℝ) (_hp : 1 < p) :
    IsRectangleConservationLawSolution (fun x t => φ (x - t)) id ∧
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (t : ℝ) (start : ℤ) (N : ℕ) (i : Fin N),
      ‖window (advance (meshSize n) (meshSize_pos n)
          (averaged (meshSize n) (meshSize_pos n) φ t)) start N i -
        window (averaged (meshSize n) (meshSize_pos n) φ (t + meshSize n)) start N i‖
        ≤ C * meshSize n * (meshSize n) ^ p := by
  refine ⟨translated_is_conserved φ hφ, 0, le_rfl, ?_⟩
  intro n t start N i
  simp only [window, advance_averaged_exact, sub_self, norm_zero, zero_mul, le_refl]

/-- Zero growth and zero defect in a uniform quantitative variation bound.
The shifted input window includes entering boundary variation explicitly. -/
theorem refinement_oscillation {ι : Type*} [Fintype ι]
    (Q : ℤ → ι → ℝ) (n : ℕ) (start : ℤ) (N : ℕ) :
    windowTV (advance (meshSize n) (meshSize_pos n) Q) start N ≤
      (1 + (0 : ℝ) * meshSize n) * windowTV Q (start - 1) N + 0 := by
  simp only [advance_windowTV, zero_mul, add_zero, one_mul, le_refl]

def smoothProfile (x : ℝ) : Fin 1 → ℝ := fun _ => x

theorem smoothProfile_smooth : ContDiff ℝ ⊤ smoothProfile := by
  exact contDiff_pi.mpr (fun _ => contDiff_id)

theorem smoothProfile_integrable (a b : ℝ) :
    IntervalIntegrable smoothProfile volume a b :=
  smoothProfile_smooth.continuous.intervalIntegrable a b

theorem smoothProfile_nonconstant : smoothProfile 0 ≠ smoothProfile 1 := by
  intro h
  have h0 := congrFun h 0
  norm_num [smoothProfile] at h0

noncomputable def stepProfile : ℝ → Fin 1 → ℝ := riemannData 1 0 0

theorem stepProfile_integrable (a b : ℝ) :
    IntervalIntegrable stepProfile volume a b := riemannData_intervalIntegrable _ _ _ a b

theorem stepProfile_discontinuous : ¬ ContinuousAt stepProfile 0 := by
  apply (riemannData_isRiemannData (1 : Fin 1 → ℝ) 0 0).not_continuousAt_zero
  intro h
  have h0 := congrFun h 0
  norm_num at h0

/-- The smooth nonconstant profile actually meets the family contract. -/
theorem smooth_refinement (p : ℝ) (hp : 1 < p) :
    ContDiff ℝ ⊤ smoothProfile ∧ smoothProfile 0 ≠ smoothProfile 1 ∧
    IsRectangleConservationLawSolution (fun x t => smoothProfile (x - t)) id ∧
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (t : ℝ) (start : ℤ) (N : ℕ) (i : Fin N),
      ‖window (advance (meshSize n) (meshSize_pos n)
          (averaged (meshSize n) (meshSize_pos n) smoothProfile t)) start N i -
        window (averaged (meshSize n) (meshSize_pos n) smoothProfile (t + meshSize n))
          start N i‖ ≤ C * meshSize n * (meshSize n) ^ p :=
  ⟨smoothProfile_smooth, smoothProfile_nonconstant,
    refinement_accuracy smoothProfile smoothProfile_integrable p hp⟩

/-- A discontinuous transport profile also meets the same physical exactness
and refinement bound; this is a transported jump, not a nonlinear shock. -/
theorem step_refinement (p : ℝ) (hp : 1 < p) :
    (¬ ContinuousAt stepProfile 0) ∧
    IsRectangleConservationLawSolution (fun x t => stepProfile (x - t)) id ∧
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (n : ℕ) (t : ℝ) (start : ℤ) (N : ℕ) (i : Fin N),
      ‖window (advance (meshSize n) (meshSize_pos n)
          (averaged (meshSize n) (meshSize_pos n) stepProfile t)) start N i -
        window (averaged (meshSize n) (meshSize_pos n) stepProfile (t + meshSize n))
          start N i‖ ≤ C * meshSize n * (meshSize n) ^ p :=
  ⟨stepProfile_discontinuous, refinement_accuracy stepProfile stepProfile_integrable p hp⟩

end CFL1RefinementWitness

#check CFL1RefinementWitness.grid
#print axioms CFL1RefinementWitness.grid
#check CFL1RefinementWitness.grid_volume
#print axioms CFL1RefinementWitness.grid_volume
#check CFL1RefinementWitness.advance
#print axioms CFL1RefinementWitness.advance
#check CFL1RefinementWitness.advance_eq_shift
#print axioms CFL1RefinementWitness.advance_eq_shift
#check CFL1RefinementWitness.averaged
#print axioms CFL1RefinementWitness.averaged
#check CFL1RefinementWitness.averaged_eq_shift
#print axioms CFL1RefinementWitness.averaged_eq_shift
#check CFL1RefinementWitness.advance_averaged_exact
#print axioms CFL1RefinementWitness.advance_averaged_exact
#check CFL1RefinementWitness.averaged_is_cell_average
#print axioms CFL1RefinementWitness.averaged_is_cell_average
#check CFL1RefinementWitness.translated_is_conserved
#print axioms CFL1RefinementWitness.translated_is_conserved
#check CFL1RefinementWitness.physical_exactness
#print axioms CFL1RefinementWitness.physical_exactness
#check CFL1RefinementWitness.window
#print axioms CFL1RefinementWitness.window
#check CFL1RefinementWitness.advance_window
#print axioms CFL1RefinementWitness.advance_window
#check CFL1RefinementWitness.windowTV
#print axioms CFL1RefinementWitness.windowTV
#check CFL1RefinementWitness.advance_windowTV
#print axioms CFL1RefinementWitness.advance_windowTV
#check CFL1RefinementWitness.advance_no_overshoot
#print axioms CFL1RefinementWitness.advance_no_overshoot
#check CFL1RefinementWitness.advance_preserves_monotone
#print axioms CFL1RefinementWitness.advance_preserves_monotone
#check CFL1RefinementWitness.meshSize
#print axioms CFL1RefinementWitness.meshSize
#check CFL1RefinementWitness.meshSize_pos
#print axioms CFL1RefinementWitness.meshSize_pos
#check CFL1RefinementWitness.meshSize_tendsto_zero
#print axioms CFL1RefinementWitness.meshSize_tendsto_zero
#check CFL1RefinementWitness.flux_locality
#print axioms CFL1RefinementWitness.flux_locality
#check CFL1RefinementWitness.advance_extension_independent
#print axioms CFL1RefinementWitness.advance_extension_independent
#check CFL1RefinementWitness.refinement_accuracy
#print axioms CFL1RefinementWitness.refinement_accuracy
#check CFL1RefinementWitness.refinement_oscillation
#print axioms CFL1RefinementWitness.refinement_oscillation
#check CFL1RefinementWitness.smoothProfile
#print axioms CFL1RefinementWitness.smoothProfile
#check CFL1RefinementWitness.smoothProfile_smooth
#print axioms CFL1RefinementWitness.smoothProfile_smooth
#check CFL1RefinementWitness.smoothProfile_integrable
#print axioms CFL1RefinementWitness.smoothProfile_integrable
#check CFL1RefinementWitness.smoothProfile_nonconstant
#print axioms CFL1RefinementWitness.smoothProfile_nonconstant
#check CFL1RefinementWitness.stepProfile
#print axioms CFL1RefinementWitness.stepProfile
#check CFL1RefinementWitness.stepProfile_integrable
#print axioms CFL1RefinementWitness.stepProfile_integrable
#check CFL1RefinementWitness.stepProfile_discontinuous
#print axioms CFL1RefinementWitness.stepProfile_discontinuous
#check CFL1RefinementWitness.smooth_refinement
#print axioms CFL1RefinementWitness.smooth_refinement
#check CFL1RefinementWitness.step_refinement
#print axioms CFL1RefinementWitness.step_refinement
