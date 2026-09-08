import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep

import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface
/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference

/-!
# Draft: physical flux references and finite-volume error balance

The exact field and numerical array are independent. Every face is an actual
grid endpoint. Time-averaged physical fluxes are derived from the rectangle
law; no approximation tolerance or accuracy conclusion is assumed.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.FVFluxUpdateDraft

variable {m : ℕ}

/-- Physical reference through the left face of cell `j`, averaged in time. -/
noncomputable def physicalFaceAverage (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (s t : ℝ) (j : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft j) τ)) s t

/-- All numerical face fluxes may depend on the complete current array,
the face, and both time endpoints; a binary stencil is not imposed. -/
noncomputable def numericalUpdate (grid : OneDimensionalFiniteVolumeGrid)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    (s t : ℝ) (old : ℤ → (Fin m → ℝ)) : ℤ → (Fin m → ℝ) :=
  riemannFiniteVolumeUpdate grid (t - s) old (rule s t old)

theorem physicalFaceAverage_spec (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux) {s t : ℝ} (hst : s < t)
    (j : ℤ) :
    IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft j) τ)) s t
      (physicalFaceAverage grid q flux s t j) :=
  oneDimensionalCellAverage_isCellAverage _ hst (hq.2.1 _ _ _)

theorem timeStep_smul_physicalFaceAverage (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (j : ℤ) :
    (t - s) • physicalFaceAverage grid q flux s t j =
      ∫ τ in s..t, flux (q (grid.cellLeft j) τ) :=
  cellWidth_smul_oneDimensionalCellAverage _ hst

theorem exactCellAverage_spec (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux) (t : ℝ) (i : ℤ) :
    IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i) (grid.cellRight i)
      (finiteVolumeCellAverageOn grid (fun x => q x t) i) :=
  finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i

/-- The exact mass change is the time-integrated exchange at both real faces. -/
theorem exactCellAverage_mass_balance (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux) {s t : ℝ} (hst : s < t)
    (i : ℤ) :
    grid.cellVolume i • finiteVolumeCellAverageOn grid (fun x => q x t) i -
        grid.cellVolume i • finiteVolumeCellAverageOn grid (fun x => q x s) i =
      (t - s) • (physicalFaceAverage grid q flux s t i -
        physicalFaceAverage grid q flux s t (i + 1)) := by
  have hadj : grid.cellLeft (i + 1) = grid.cellRight i := by
    simpa using (grid.adjacent (i + 1)).symm
  rw [smul_sub, timeStep_smul_physicalFaceAverage grid q flux hst,
    timeStep_smul_physicalFaceAverage grid q flux hst, hadj]
  change (grid.cellRight i - grid.cellLeft i) •
      oneDimensionalCellAverage (fun x => q x t) _ _ -
      (grid.cellRight i - grid.cellLeft i) •
        oneDimensionalCellAverage (fun x => q x s) _ _ = _
  rw [cellWidth_smul_oneDimensionalCellAverage _ (grid.cell_nonempty i),
    cellWidth_smul_oneDimensionalCellAverage _ (grid.cell_nonempty i),
    hq.2.2, intervalIntegral.integral_sub (hq.2.1 _ _ _) (hq.2.1 _ _ _)]

/-- The weighted numerical update reuses the general cell-total producer. -/
theorem numericalUpdate_mass_balance (grid : OneDimensionalFiniteVolumeGrid)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    (s t : ℝ) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    grid.cellVolume i • numericalUpdate grid rule s t old i =
      grid.cellVolume i • old i -
        (t - s) • (rule s t old (i + 1) - rule s t old i) :=
  cellVolume_smul_finiteVolumeCellAverageUpdate (t - s) (grid.cellVolume i)
    (old i) (rule s t old (i + 1) - rule s t old i)
    (ne_of_gt (grid.cellVolume_pos i))

/-- Exact error accounting: numerical flux errors enter with physical
left-in/right-out orientation, and the old array need not be exact. -/
theorem numericalUpdate_weighted_error (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    grid.cellVolume i • (numericalUpdate grid rule s t old i -
        finiteVolumeCellAverageOn grid (fun x => q x t) i) =
      grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
        (t - s) • ((rule s t old i - physicalFaceAverage grid q flux s t i) -
          (rule s t old (i + 1) - physicalFaceAverage grid q flux s t (i + 1))) := by
  have hexact := exactCellAverage_mass_balance grid hq hst i
  have htime := eq_add_of_sub_eq hexact
  rw [smul_sub, numericalUpdate_mass_balance, htime]
  module

/-- Interior numerical flux errors cancel on any finite contiguous block,
including nonuniform cells. The physical boundary faces are `start` and
`start + count`, so exterior exchanges remain present. -/
theorem numericalUpdate_block_error (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count,
      grid.cellVolume (start + k) • (numericalUpdate grid rule s t old (start + k) -
        finiteVolumeCellAverageOn grid (fun x => q x t) (start + k))) =
      (∑ k ∈ Finset.range count,
        grid.cellVolume (start + k) • (old (start + k) -
          finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))) +
      (t - s) • ((rule s t old start - physicalFaceAverage grid q flux s t start) -
        (rule s t old (start + count) - physicalFaceAverage grid q flux s t (start + count))) := by
  let oldError : ℕ → (Fin m → ℝ) := fun k =>
    grid.cellVolume (start + k) • (old (start + k) -
      finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))
  let edgeError : ℕ → (Fin m → ℝ) := fun k =>
    rule s t old (start + k) - physicalFaceAverage grid q flux s t (start + k)
  calc
    _ = ∑ k ∈ Finset.range count,
        conservativeFluxDifferenceUpdate (t - s) oldError edgeError k := by
      apply Finset.sum_congr rfl
      intro k hk
      rw [numericalUpdate_weighted_error grid hq rule hst old]
      simp only [conservativeFluxDifferenceUpdate, oldError, edgeError,
        Nat.cast_add, Nat.cast_one, add_assoc]
      module
    _ = (∑ k ∈ Finset.range count, oldError k) -
        (t - s) • (edgeError count - edgeError 0) :=
      sum_conservativeFluxDifferenceUpdate _ _ _ _
    _ = _ := by
      simp only [oldError, edgeError, Nat.cast_zero, add_zero]
      module

end NumStability.FVFluxUpdateDraft

/- Checked quantitative consequences, not a source-selected accuracy convention. -/
namespace NumStability.FVFluxEstimateDraft

open NumStability.FVFluxUpdateDraft

theorem norm_le_of_weighted_balance {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E]
    {width dt oldBound leftBound rightBound : ℝ} (hw : 0 < width) (hdt : 0 ≤ dt)
    {nextError oldError leftError rightError : E}
    (hbalance : width • nextError = width • oldError + dt • (leftError - rightError))
    (hold : ‖oldError‖ ≤ oldBound) (hleft : ‖leftError‖ ≤ leftBound)
    (hright : ‖rightError‖ ≤ rightBound) :
    ‖nextError‖ ≤ oldBound + dt / width * (leftBound + rightBound) := by
  have hnorm : width * ‖nextError‖ ≤
      width * ‖oldError‖ + dt * (‖leftError‖ + ‖rightError‖) := by
    calc
      _ = ‖width • nextError‖ := by simp [norm_smul, abs_of_pos hw]
      _ = ‖width • oldError + dt • (leftError - rightError)‖ := congrArg norm hbalance
      _ ≤ ‖width • oldError‖ + ‖dt • (leftError - rightError)‖ := norm_add_le _ _
      _ ≤ _ := by
        simp only [norm_smul, Real.norm_eq_abs, abs_of_pos hw, abs_of_nonneg hdt]
        exact add_le_add le_rfl (mul_le_mul_of_nonneg_left (norm_sub_le leftError rightError) hdt)
  apply (mul_le_mul_iff_right₀ hw).mp
  calc
    width * ‖nextError‖ ≤ width * oldBound + dt * (leftBound + rightBound) :=
      hnorm.trans (add_le_add (mul_le_mul_of_nonneg_left hold hw.le)
        (mul_le_mul_of_nonneg_left (add_le_add hleft hright) hdt))
    _ = width * (oldBound + dt / width * (leftBound + rightBound)) := by
      field_simp

/-- Input errors and the two face-flux errors bound the new cell-average error. -/
theorem numericalUpdate_error_bound {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (i : ℤ)
    {oldBound leftBound rightBound : ℝ}
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound)
    (hleft : ‖rule s t old i - physicalFaceAverage grid q flux s t i‖ ≤ leftBound)
    (hright : ‖rule s t old (i + 1) - physicalFaceAverage grid q flux s t (i + 1)‖ ≤ rightBound) :
    ‖numericalUpdate grid rule s t old i - finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
      oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) :=
  norm_le_of_weighted_balance (grid.cellVolume_pos i) (sub_nonneg.mpr hst.le)
    (numericalUpdate_weighted_error grid hq rule hst old i) hold hleft hright

/-- Bound on the norm of total mass error in a contiguous block. This is not
a bound on the sum of absolute cell errors: interior errors can cancel. -/
theorem numericalUpdate_block_mass_error_bound {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (start : ℤ) (count : ℕ)
    (oldBound : ℕ → ℝ) {leftBound rightBound : ℝ}
    (hold : ∀ k ∈ Finset.range count,
      ‖old (start + k) - finiteVolumeCellAverageOn grid (fun x => q x s) (start + k)‖ ≤ oldBound k)
    (hleft : ‖rule s t old start - physicalFaceAverage grid q flux s t start‖ ≤ leftBound)
    (hright : ‖rule s t old (start + count) - physicalFaceAverage grid q flux s t (start + count)‖ ≤ rightBound) :
    ‖∑ k ∈ Finset.range count, grid.cellVolume (start + k) •
      (numericalUpdate grid rule s t old (start + k) -
        finiteVolumeCellAverageOn grid (fun x => q x t) (start + k))‖ ≤
      (∑ k ∈ Finset.range count, grid.cellVolume (start + k) * oldBound k) +
        (t - s) * (leftBound + rightBound) := by
  have hsum : ‖∑ k ∈ Finset.range count, grid.cellVolume (start + k) •
      (old (start + k) - finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))‖ ≤
      ∑ k ∈ Finset.range count, grid.cellVolume (start + k) * oldBound k := by
    apply (norm_sum_le _ _).trans
    apply Finset.sum_le_sum
    intro k hk
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos (grid.cellVolume_pos _)]
    exact mul_le_mul_of_nonneg_left (hold k hk) (grid.cellVolume_pos _).le
  have hbalance := numericalUpdate_block_error grid hq rule hst old start count
  have h := norm_le_of_weighted_balance (E := Fin m → ℝ) (width := 1)
    (by norm_num) (sub_nonneg.mpr hst.le) (by simpa using hbalance) hsum hleft hright
  simpa using h

/-- A pointwise flux-trace error bound yields a bound for its time average. -/
theorem average_difference_norm_le {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    {f g : ℝ → E} {s t bound : ℝ} (hst : s < t)
    (hf : IntervalIntegrable f volume s t) (hg : IntervalIntegrable g volume s t)
    (herror : ∀ τ ∈ Set.uIoc s t, ‖f τ - g τ‖ ≤ bound) :
    ‖oneDimensionalCellAverage f s t - oneDimensionalCellAverage g s t‖ ≤ bound := by
  have hw : 0 < t - s := sub_pos.mpr hst
  rw [oneDimensionalCellAverage, oneDimensionalCellAverage, ← smul_sub,
    ← intervalIntegral.integral_sub hf hg, norm_smul, Real.norm_eq_abs,
    abs_inv, abs_of_pos hw]
  calc
    _ ≤ (t - s)⁻¹ * (bound * (t - s)) := by
      apply mul_le_mul_of_nonneg_left _ (inv_nonneg.mpr hw.le)
      simpa only [abs_of_pos hw] using intervalIntegral.norm_integral_le_of_norm_le_const herror
    _ = bound := by field_simp

end NumStability.FVFluxEstimateDraft

/- The linear solver's own physical trace, distinguished from a global exact field. -/
namespace NumStability.FVFluxEstimateDraft

variable {m : ℕ}

noncomputable def selectedLinearSolve (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA)) :
    CertifiedRectangleRiemannSolution (linearHyperbolicConservationLaw A hA) problem :=
  (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial

noncomputable def selectedLinearFlux (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA)) : Fin m → ℝ :=
  (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).numericalFluxFromInformation
    ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).extractInformation
      (selectedLinearSolve A hA basis speeds heigen problem))

/-- For all ordered states, the selected method's actual output is the physical
flux of its particular returned solution at every positive ray-zero time. -/
theorem selectedLinearFlux_eq_physical_trace (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA))
    {τ : ℝ} (hτ : 0 < τ) :
    selectedLinearFlux A hA basis speeds heigen problem =
      A.mulVec ((selectedLinearSolve A hA basis speeds heigen problem).solution 0 τ) :=
  congrArg A.mulVec
    (linearRectangleRiemannInterfaceFluxMethod_information A hA basis speeds heigen problem hτ)

/-- Time integration gives an actual physical-flux reference for this solver,
not merely constant-state consistency. The possibly different value at time
zero is excluded by the oriented integral's almost-everywhere convention. -/
theorem selectedLinearFlux_eq_solver_average (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA))
    {dt : ℝ} (hdt : 0 < dt) :
    selectedLinearFlux A hA basis speeds heigen problem =
      oneDimensionalCellAverage
        (fun τ => A.mulVec ((selectedLinearSolve A hA basis speeds heigen problem).solution 0 τ))
        0 dt := by
  have hint : (∫ τ in (0 : ℝ)..dt,
      A.mulVec ((selectedLinearSolve A hA basis speeds heigen problem).solution 0 τ)) =
      ∫ _ in (0 : ℝ)..dt, selectedLinearFlux A hA basis speeds heigen problem := by
    apply intervalIntegral.integral_congr_ae
    exact Filter.Eventually.of_forall (fun τ hτ =>
      (selectedLinearFlux_eq_physical_trace A hA basis speeds heigen problem
        (by simpa only [min_eq_left hdt.le] using hτ.1)).symm)
  rw [oneDimensionalCellAverage, hint, intervalIntegral.integral_const]
  simp [smul_smul, hdt.ne']

/-- A Riemann-based numerical rule on arbitrary numerical arrays. Time
endpoints are accepted by the update API; the self-similar linear ray flux
does not depend on the positive duration. -/
noncomputable def linearRule (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (_s _t : ℝ) (old : ℤ → (Fin m → ℝ)) (j : ℤ) : Fin m → ℝ :=
  selectedLinearFlux A hA basis speeds heigen
    (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)

/-- The rule executes the existing canonical interface-flux function with the
selected total linear solver, rather than choosing an unrelated solution. -/
theorem linearRule_eq_rectangleRiemannInterfaceFlux (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (s t : ℝ) (old : ℤ → (Fin m → ℝ)) (j : ℤ) :
    linearRule A hA basis speeds heigen s t old j =
      rectangleRiemannInterfaceFlux
        (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen)
        old (fun _ => trivial) j := rfl

/-- A bound on the local solver's physical trace error against an independently
conserved field implies an averaged numerical-flux error bound. The trace
comparison is an explicit premise, not inferred from unrelated certificates. -/
theorem linearRule_flux_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q A.mulVec)
    (old : ℤ → (Fin m → ℝ)) {dt bound : ℝ} (hdt : 0 < dt) (j : ℤ)
    (htrace : ∀ τ ∈ Set.uIoc 0 dt,
      ‖A.mulVec ((selectedLinearSolve A hA basis speeds heigen
        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)).solution 0 τ) -
        A.mulVec (q (grid.cellLeft j) τ)‖ ≤ bound) :
    ‖linearRule A hA basis speeds heigen 0 dt old j -
      FVFluxUpdateDraft.physicalFaceAverage grid q A.mulVec 0 dt j‖ ≤ bound := by
  unfold linearRule FVFluxUpdateDraft.physicalFaceAverage
  rw [selectedLinearFlux_eq_solver_average A hA basis speeds heigen _ hdt]
  exact average_difference_norm_le hdt
    ((selectedLinearSolve A hA basis speeds heigen _).solves.2.2.1 _ _ _)
    (hq.2.1 _ _ _) htrace

/-- End-to-end conditional estimate: old numerical error and independently
justified solver-trace errors give a next-step error for the actual linear rule. -/
theorem linearRule_next_error_bound (grid : OneDimensionalFiniteVolumeGrid)
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q A.mulVec)
    (old : ℤ → (Fin m → ℝ)) {dt oldBound : ℝ} (hdt : 0 < dt) (i : ℤ)
    (faceBound : ℤ → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x 0) i‖ ≤ oldBound)
    (htrace : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖A.mulVec ((selectedLinearSolve A hA basis speeds heigen
        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)).solution 0 τ) -
        A.mulVec (q (grid.cellLeft j) τ)‖ ≤ faceBound j) :
    ‖FVFluxUpdateDraft.numericalUpdate grid (linearRule A hA basis speeds heigen) 0 dt old i -
      finiteVolumeCellAverageOn grid (fun x => q x dt) i‖ ≤
      oldBound + dt / grid.cellVolume i * (faceBound i + faceBound (i + 1)) := by
  simpa using numericalUpdate_error_bound grid hq (linearRule A hA basis speeds heigen)
    hdt old i hold
    (linearRule_flux_error_le grid A hA basis speeds heigen hq old hdt i (htrace i))
    (linearRule_flux_error_le grid A hA basis speeds heigen hq old hdt (i + 1) (htrace (i + 1)))

end NumStability.FVFluxEstimateDraft


/- Scratch foundation: actual coordinate-line finite-volume solves on a tensor grid. -/
namespace NumStability.TensorLinesDraft

open MeasureTheory
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D]

/-- Cartesian tensor-grid data. No logical-to-physical chart is postulated. -/
structure TensorGrid (D : Type*) where
  axis : D → OneDimensionalFiniteVolumeGrid
  directions : CoordinateDirectionFamily D

abbrev Cell (D : Type*) := D → ℤ

def TensorGrid.cellBox (grid : TensorGrid D) (cell : Cell D) : Set (D → ℝ) :=
  Set.pi Set.univ (fun d => Set.Ico ((grid.axis d).cellLeft (cell d))
    ((grid.axis d).cellRight (cell d)))

def TensorGrid.cellVolume (grid : TensorGrid D) (cell : Cell D) : ℝ :=
  ∏ d, (grid.axis d).cellVolume (cell d)

def TensorGrid.faceArea (grid : TensorGrid D) (d : D) (cell : Cell D) : ℝ :=
  ∏ e ∈ Finset.univ.erase d, (grid.axis e).cellVolume (cell e)

omit [DecidableEq D] in
theorem TensorGrid.cellVolume_pos (grid : TensorGrid D) (cell : Cell D) :
    0 < grid.cellVolume cell :=
  Finset.prod_pos (fun d _ => (grid.axis d).cellVolume_pos (cell d))

theorem TensorGrid.cellVolume_eq_width_mul_area (grid : TensorGrid D) (d : D)
    (cell : Cell D) :
    grid.cellVolume cell = (grid.axis d).cellVolume (cell d) * grid.faceArea d cell := by
  exact (Finset.mul_prod_erase _ _ (Finset.mem_univ d)).symm

omit [DecidableEq D] in
theorem TensorGrid.cellBox_volume (grid : TensorGrid D) (cell : Cell D) :
    (volume (grid.cellBox cell)).toReal = grid.cellVolume cell := by
  exact Real.volume_pi_Ico_toReal (fun d => (grid.axis d).cell_nonempty (cell d) |>.le)

/-- A full tensor-cell reference uses the existing normalized physical-volume
average. Numerical arrays below remain independent approximations to these values. -/
noncomputable def TensorGrid.reference {m : ℕ} (grid : TensorGrid D)
    (field : (D → ℝ) → Fin m → ℝ) (cell : Cell D) : Fin m → ℝ :=
  cellVolumeAverage volume (grid.cellBox cell) field

omit [DecidableEq D] in
theorem TensorGrid.reference_spec {m : ℕ} (grid : TensorGrid D)
    (field : (D → ℝ) → Fin m → ℝ) (cell : Cell D)
    (hint : IntegrableOn field (grid.cellBox cell) volume) :
    IsCellVolumeAverage volume (grid.cellBox cell) field (grid.reference field cell) := by
  have hp : 0 < (volume (grid.cellBox cell)).toReal := by
    rw [grid.cellBox_volume]
    exact grid.cellVolume_pos cell
  exact cellVolumeAverage_isCellVolumeAverage _ _ _
    (ne_of_gt (ENNReal.toReal_pos_iff.mp hp).1)
    (ne_of_lt (ENNReal.toReal_pos_iff.mp hp).2) hint

/-- Restrict the complete numerical state to a line by fixing every other index. -/
def line {E : Type*} (d : D) (base : Cell D) (state : Cell D → E) : ℤ → E :=
  fun j => state (Function.update base d j)

omit [Fintype D] in
@[simp] theorem line_at_base {E : Type*} (d : D) (base : Cell D)
    (state : Cell D → E) : line d base state (base d) = state base := by
  simp [line]

omit [Fintype D] in
@[simp] theorem line_update_base {E : Type*} (d : D) (base : Cell D)
    (state : Cell D → E) (j : ℤ) :
    line d (Function.update base d j) state = line d base state := by
  funext k
  simp [line, Function.update_idem]

/-- Total certified one-dimensional Riemann solver, with its actual output
flux tied to the physical flux of its returned solution on ray zero at time 1.
This is an explicit exact-interface class, not all high-resolution methods. -/
structure LineSolver (m : ℕ) where
  law : OneDimensionalHyperbolicConservationLaw (Fin m)
  method : RectangleRiemannInterfaceFluxMethod law (Fin m → ℝ)
  total : ∀ problem, method.domain problem
  flux_eq_solution_trace : ∀ problem,
    method.numericalFluxFromInformation
      (method.extractInformation (method.solve problem (total problem))) =
        law.physicalFlux ((method.solve problem (total problem)).solution 0 1)

namespace LineSolver
variable {m : ℕ}

noncomputable def faceFlux (solver : LineSolver m) (old : ℤ → Fin m → ℝ)
    (j : ℤ) : Fin m → ℝ :=
  rectangleRiemannInterfaceFlux solver.method old
    (fun i => solver.total (adjacentCellRiemannProblem solver.law old i)) j

theorem faceFlux_physical_trace (solver : LineSolver m) (old : ℤ → Fin m → ℝ)
    (j : ℤ) :
    solver.faceFlux old j = solver.law.physicalFlux
      ((solver.method.solve (adjacentCellRiemannProblem solver.law old j)
        (solver.total _)).solution 0 1) :=
  solver.flux_eq_solution_trace _

theorem face_problem_solves (solver : LineSolver m) (old : ℤ → Fin m → ℝ) (j : ℤ) :
    IsRiemannData
      (fun x => (solver.method.solve (adjacentCellRiemannProblem solver.law old j)
        (solver.total _)).solution x 0) (old (j - 1)) (old j) ∧
    IsRectangleConservationLawSolution
      (solver.method.solve (adjacentCellRiemannProblem solver.law old j)
        (solver.total _)).solution solver.law.physicalFlux :=
  (solver.method.solve _ (solver.total _)).solves

@[simp] theorem faceFlux_constant (solver : LineSolver m) (value : Fin m → ℝ)
    (j : ℤ) : solver.faceFlux (fun _ => value) j = solver.law.physicalFlux value :=
  solver.method.consistent_on_constant_states value

noncomputable def advance (solver : LineSolver m) (grid : OneDimensionalFiniteVolumeGrid)
    (dt : ℝ) (old : ℤ → Fin m → ℝ) : ℤ → Fin m → ℝ :=
  riemannFiniteVolumeUpdate grid dt old (solver.faceFlux old)

@[simp] theorem advance_constant (solver : LineSolver m) (grid : OneDimensionalFiniteVolumeGrid)
    (dt : ℝ) (value : Fin m → ℝ) :
    solver.advance grid dt (fun _ => value) = fun _ => value := by
  funext j
  simp [advance, riemannFiniteVolumeUpdate]

/-- The chosen linear eigensolver supplies every field of the stronger interface. -/
noncomputable def linear (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p) : LineSolver m where
  law := linearHyperbolicConservationLaw A hA
  method := linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen
  total := fun _ => trivial
  flux_eq_solution_trace := fun _ => rfl

/-- Exact reuse of the independently checked selected-solver numerical rule. -/
theorem linear_faceFlux_eq_rule (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (old : ℤ → Fin m → ℝ) (s t : ℝ) (j : ℤ) :
    (linear A hA basis speeds heigen).faceFlux old j =
      FVFluxEstimateDraft.linearRule A hA basis speeds heigen s t old j := rfl

theorem linear_faceFlux_eq_solver_average (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (old : ℤ → Fin m → ℝ) {dt : ℝ} (hdt : 0 < dt) (j : ℤ) :
    (linear A hA basis speeds heigen).faceFlux old j =
      oneDimensionalCellAverage
        (fun τ => A.mulVec ((FVFluxEstimateDraft.selectedLinearSolve A hA basis speeds heigen
          (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)).solution 0 τ))
        0 dt :=
  FVFluxEstimateDraft.selectedLinearFlux_eq_solver_average A hA basis speeds heigen _ hdt

end LineSolver

variable {m : ℕ}

noncomputable def advanceDirection (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) : Cell D → Fin m → ℝ :=
  fun cell => (solvers d).advance (grid.axis d) dt (line d cell state) (cell d)

omit [Fintype D] in
/-- Restricting the full-state update recovers the exact one-dimensional update
on that line, with the same state, duration, grid, and face solver. -/
theorem line_advanceDirection (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (base : Cell D) :
    line d base (advanceDirection grid solvers d dt state) =
      (solvers d).advance (grid.axis d) dt (line d base state) := by
  funext j
  simp [line, advanceDirection]

omit [Fintype D] in
/-- An update cannot read numerical values on another coordinate line. -/
theorem advanceDirection_line_local (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state other : Cell D → Fin m → ℝ) (base : Cell D)
    (hline : line d base state = line d base other) :
    line d base (advanceDirection grid solvers d dt state) =
      line d base (advanceDirection grid solvers d dt other) := by
  rw [line_advanceDirection, line_advanceDirection, hline]

omit [Fintype D] in
theorem advanceDirection_constant_line (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (base : Cell D) (value : Fin m → ℝ)
    (hline : line d base state = fun _ => value) :
    line d base (advanceDirection grid solvers d dt state) = fun _ => value := by
  rw [line_advanceDirection, hline, LineSolver.advance_constant]

omit [Fintype D] in
theorem advanceDirection_preserves_constants (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (value : Fin m → ℝ) :
    advanceDirection grid solvers d dt (fun _ => value) = fun _ => value := by
  funext cell
  change (solvers d).advance (grid.axis d) dt (fun _ => value) (cell d) = value
  rw [LineSolver.advance_constant]

omit [Fintype D] in
/-- Actual width-weighted conservative update, reusing the frozen 1D producer. -/
theorem advanceDirection_mass_balance (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    (grid.axis d).cellVolume (cell d) • advanceDirection grid solvers d dt state cell =
      (grid.axis d).cellVolume (cell d) • state cell - dt •
        ((solvers d).faceFlux (line d cell state) (cell d + 1) -
          (solvers d).faceFlux (line d cell state) (cell d)) := by
  simpa only [FVFluxUpdateDraft.numericalUpdate, zero_sub, sub_zero,
    LineSolver.advance, advanceDirection, line_at_base] using
      FVFluxUpdateDraft.numericalUpdate_mass_balance (grid.axis d)
        (fun _ _ old => (solvers d).faceFlux old) 0 dt (line d cell state) (cell d)

theorem advanceDirection_full_volume_balance (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    grid.cellVolume cell • advanceDirection grid solvers d dt state cell =
      grid.cellVolume cell • state cell - dt • (grid.faceArea d cell •
        ((solvers d).faceFlux (line d cell state) (cell d + 1) -
          (solvers d).faceFlux (line d cell state) (cell d))) := by
  have h := congrArg (fun v => grid.faceArea d cell • v)
    (advanceDirection_mass_balance grid solvers d dt state cell)
  rw [grid.cellVolume_eq_width_mul_area d cell]
  simpa only [smul_sub, smul_smul, mul_comm] using h

/-- The old sweep API is reused with its maps derived from actual line solves. -/
noncomputable def coordinateMethod (grid : TensorGrid D) (solvers : D → LineSolver m)
    (dt : ℝ) : CoordinateHighResolutionMethod D (Cell D) (Fin m → ℝ) where
  solveDirection := fun d =>
    { advanceCellAverages := fun fraction => advanceDirection grid solvers d (fraction * dt)
      preserves_constant_states := fun fraction value =>
        advanceDirection_preserves_constants grid solvers d (fraction * dt) value }
  timeFraction := fun _ => 1
  positive_timeFraction := fun _ => zero_lt_one
  timeFraction_le_one := fun _ => le_rfl

noncomputable def schedule (grid : TensorGrid D) (solvers : D → LineSolver m) (dt : ℝ) :=
  coordinateFractionalSchedule grid.directions (coordinateMethod grid solvers dt)

omit [Fintype D] in
theorem scheduled_directions (grid : TensorGrid D) (solvers : D → LineSolver m) (dt : ℝ) :
    (schedule grid solvers dt).map (fun step => step.direction) = grid.directions.directions := by
  simp [schedule, coordinateFractionalSchedule, Function.comp_def,
    CoordinateHighResolutionMethod.fractionalStep]

omit [Fintype D] in
theorem scheduled_step_is_line_update (grid : TensorGrid D) (solvers : D → LineSolver m)
    (dt : ℝ) (step : CoordinateFractionalStep D (Cell D) (Fin m → ℝ))
    (hstep : step ∈ schedule grid solvers dt) (state : Cell D → Fin m → ℝ) :
    step.advance state = advanceDirection grid solvers step.direction dt state := by
  obtain ⟨d, _, rfl⟩ := List.mem_map.mp hstep
  simp [CoordinateFractionalStep.advance, CoordinateHighResolutionMethod.fractionalStep,
    coordinateMethod]

omit [Fintype D] in
theorem scheduled_sweep_executes (grid : TensorGrid D) (solvers : D → LineSolver m)
    (dt : ℝ) (state : Cell D → Fin m → ℝ) :
    CoordinateSweepExecution (schedule grid solvers dt) state
      (coordinateFractionalSweep (schedule grid solvers dt) state)
      (coordinateFractionalTrace (schedule grid solvers dt) state) ∧
    (∀ step ∈ schedule grid solvers dt, ∀ current base,
      line step.direction base (step.advance current) =
        (solvers step.direction).advance (grid.axis step.direction) dt
          (line step.direction base current)) := by
  exact ⟨coordinateFractionalSweep_executes _ _, fun step hs current base => by
    rw [scheduled_step_is_line_update grid solvers dt step hs current,
      line_advanceDirection]⟩

omit [Fintype D] in
theorem two_direction_composition (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d e : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) :
    orderedOperatorSweep [advanceDirection grid solvers d dt,
      advanceDirection grid solvers e dt] state =
        advanceDirection grid solvers e dt (advanceDirection grid solvers d dt state) :=
  orderedOperatorSweep_two _ _ _

namespace Witness

def stripeState (cell : Cell (Fin 2)) : Fin 1 → ℝ := if cell 1 = 0 then 0 else 1

def upperCell : Cell (Fin 2) := ![0, 1]

def broadcastOrigin (state : Cell (Fin 2) → Fin 1 → ℝ) : Cell (Fin 2) → Fin 1 → ℝ :=
  fun _ => state 0

/-- The exact broadcast admitted by the old target fails this actual directional
update, for every permitted face solver and every duration. -/
theorem broadcast_is_not_directional_update (grid : TensorGrid (Fin 2))
    (solvers : Fin 2 → LineSolver 1) (dt : ℝ) :
    advanceDirection grid solvers 0 dt stripeState ≠ broadcastOrigin stripeState := by
  have hline : line 0 upperCell stripeState = fun _ => 1 := by
    funext j
    simp [line, stripeState, upperCell]
  have hgood := congrFun
    (advanceDirection_constant_line grid solvers 0 dt stripeState upperCell 1 hline) 0
  have hcell : advanceDirection grid solvers 0 dt stripeState upperCell = 1 := by
    simpa [line, upperCell] using hgood
  intro heq
  have hbad := congrFun (congrFun heq upperCell) 0
  rw [hcell] at hbad
  norm_num [broadcastOrigin, stripeState] at hbad

def unitGrid : OneDimensionalFiniteVolumeGrid where
  cellLeft := fun i => i
  cellRight := fun i => (i : ℝ) + 1
  cell_nonempty := fun _ => by linarith
  adjacent := fun i => by simp

def tensorGrid : TensorGrid (Fin 2) where
  axis := fun _ => unitGrid
  directions :=
    { directions := [0, 1]
      directions_nonempty := by simp
      directions_nodup := by decide
      directions_exhaustive := by intro d; fin_cases d <;> simp }

noncomputable def identitySolver : LineSolver 1 :=
  LineSolver.linear (1 : Matrix (Fin 1) (Fin 1) ℝ)
    ⟨fun _ => 1, Pi.basisFun ℝ (Fin 1), fun _ => by simp only [Matrix.one_mulVec, one_smul]⟩
    (Pi.basisFun ℝ (Fin 1)) (fun _ => 1)
    (fun _ => by simp only [Matrix.one_mulVec, one_smul])

theorem concrete_nonvacuity :
    Nonempty (LineSolver 1) ∧
      advanceDirection tensorGrid (fun _ => identitySolver) 0 1 stripeState ≠
        broadcastOrigin stripeState ∧
      CoordinateSweepExecution (schedule tensorGrid (fun _ => identitySolver) 1) stripeState
        (coordinateFractionalSweep (schedule tensorGrid (fun _ => identitySolver) 1) stripeState)
        (coordinateFractionalTrace (schedule tensorGrid (fun _ => identitySolver) 1) stripeState) :=
  ⟨⟨identitySolver⟩, broadcast_is_not_directional_update _ _ _,
    (scheduled_sweep_executes _ _ _ _).1⟩

end Witness
end NumStability.TensorLinesDraft


#check NumStability.TensorLinesDraft.TensorGrid.cellVolume_pos
#print axioms NumStability.TensorLinesDraft.TensorGrid.cellVolume_pos
#check NumStability.TensorLinesDraft.TensorGrid.cellVolume_eq_width_mul_area
#print axioms NumStability.TensorLinesDraft.TensorGrid.cellVolume_eq_width_mul_area
#check NumStability.TensorLinesDraft.TensorGrid.cellBox_volume
#print axioms NumStability.TensorLinesDraft.TensorGrid.cellBox_volume
#check NumStability.TensorLinesDraft.TensorGrid.reference_spec
#print axioms NumStability.TensorLinesDraft.TensorGrid.reference_spec
#check NumStability.TensorLinesDraft.line_at_base
#print axioms NumStability.TensorLinesDraft.line_at_base
#check NumStability.TensorLinesDraft.line_update_base
#print axioms NumStability.TensorLinesDraft.line_update_base
#check NumStability.TensorLinesDraft.LineSolver.faceFlux_physical_trace
#print axioms NumStability.TensorLinesDraft.LineSolver.faceFlux_physical_trace
#check NumStability.TensorLinesDraft.LineSolver.face_problem_solves
#print axioms NumStability.TensorLinesDraft.LineSolver.face_problem_solves
#check NumStability.TensorLinesDraft.LineSolver.faceFlux_constant
#print axioms NumStability.TensorLinesDraft.LineSolver.faceFlux_constant
#check NumStability.TensorLinesDraft.LineSolver.advance_constant
#print axioms NumStability.TensorLinesDraft.LineSolver.advance_constant
#check NumStability.TensorLinesDraft.LineSolver.linear_faceFlux_eq_rule
#print axioms NumStability.TensorLinesDraft.LineSolver.linear_faceFlux_eq_rule
#check NumStability.TensorLinesDraft.LineSolver.linear_faceFlux_eq_solver_average
#print axioms NumStability.TensorLinesDraft.LineSolver.linear_faceFlux_eq_solver_average
#check NumStability.TensorLinesDraft.line_advanceDirection
#print axioms NumStability.TensorLinesDraft.line_advanceDirection
#check NumStability.TensorLinesDraft.advanceDirection_line_local
#print axioms NumStability.TensorLinesDraft.advanceDirection_line_local
#check NumStability.TensorLinesDraft.advanceDirection_constant_line
#print axioms NumStability.TensorLinesDraft.advanceDirection_constant_line
#check NumStability.TensorLinesDraft.advanceDirection_preserves_constants
#print axioms NumStability.TensorLinesDraft.advanceDirection_preserves_constants
#check NumStability.TensorLinesDraft.advanceDirection_mass_balance
#print axioms NumStability.TensorLinesDraft.advanceDirection_mass_balance
#check NumStability.TensorLinesDraft.advanceDirection_full_volume_balance
#print axioms NumStability.TensorLinesDraft.advanceDirection_full_volume_balance
#check NumStability.TensorLinesDraft.scheduled_directions
#print axioms NumStability.TensorLinesDraft.scheduled_directions
#check NumStability.TensorLinesDraft.scheduled_step_is_line_update
#print axioms NumStability.TensorLinesDraft.scheduled_step_is_line_update
#check NumStability.TensorLinesDraft.scheduled_sweep_executes
#print axioms NumStability.TensorLinesDraft.scheduled_sweep_executes
#check NumStability.TensorLinesDraft.two_direction_composition
#print axioms NumStability.TensorLinesDraft.two_direction_composition
#check NumStability.TensorLinesDraft.Witness.broadcast_is_not_directional_update
#print axioms NumStability.TensorLinesDraft.Witness.broadcast_is_not_directional_update
#check NumStability.TensorLinesDraft.Witness.concrete_nonvacuity
#print axioms NumStability.TensorLinesDraft.Witness.concrete_nonvacuity


/-!
Cartesian specialization of the supplied-volume coordinate-line operation.
The frozen tensor solver is an exact-interface class using its own returned
solution at ray zero and time one. No broader solver/geometry interpretation.
-/
namespace NumStability.CartesianLineCompositionDraft

open TensorLinesDraft MeasureTheory
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

/-- The transverse Cartesian area is unchanged along the normal coordinate. -/
theorem faceArea_update (grid : TensorGrid D) (d : D) (cell : Cell D) (j : ℤ) :
    grid.faceArea d (Function.update cell d j) = grid.faceArea d cell := by
  unfold TensorGrid.faceArea
  apply Finset.prod_congr rfl
  intro e he
  rw [Function.update_of_ne (Finset.mem_erase.mp he).1]

/-- The actual transverse Cartesian box at a face indexed by its right cell.
Its measure is taken in the transverse coordinates, not ambient D-space. -/
def tangentialFaceBox (grid : TensorGrid D) (d : D) (cell : Cell D) :
    Set ({e : D // e ≠ d} → ℝ) :=
  Set.pi Set.univ (fun e => Set.Ico ((grid.axis e.1).cellLeft (cell e.1))
    ((grid.axis e.1).cellRight (cell e.1)))

theorem tangentialFaceBox_volume (grid : TensorGrid D) (d : D) (cell : Cell D) :
    (volume (tangentialFaceBox grid d cell)).toReal = grid.faceArea d cell := by
  rw [tangentialFaceBox, Real.volume_pi_Ico_toReal
    (fun e : {e : D // e ≠ d} => (grid.axis e.1).cell_nonempty (cell e.1) |>.le)]
  exact (Finset.prod_subtype (Finset.univ.erase d) (by simp)
    (fun e => (grid.axis e).cellVolume (cell e))).symm

omit [Fintype D] in
theorem tangentialFaceBox_update (grid : TensorGrid D) (d : D) (cell : Cell D) (j : ℤ) :
    tangentialFaceBox grid d (Function.update cell d j) = tangentialFaceBox grid d cell := by
  unfold tangentialFaceBox
  congr 1
  funext e
  rw [Function.update_of_ne e.property]

/-- Embedding of the transverse face coordinates at the left boundary of its right cell. -/
def facePoint (grid : TensorGrid D) (d : D) (cell : Cell D)
    (point : {e : D // e ≠ d} → ℝ) : D → ℝ :=
  fun e => if h : e = d then (grid.axis d).cellLeft (cell d) else point ⟨e, h⟩

omit [Fintype D] in
theorem facePoint_normal (grid : TensorGrid D) (d : D) (cell : Cell D)
    (point : {e : D // e ≠ d} → ℝ) :
    facePoint grid d cell point d = (grid.axis d).cellLeft (cell d) := by
  simp [facePoint]

omit [Fintype D] in
theorem facePoint_transverse (grid : TensorGrid D) (d : D) (cell : Cell D)
    (point : {e : D // e ≠ d} → ℝ) (e : D) (h : e ≠ d) :
    facePoint grid d cell point e = point ⟨e, h⟩ := by
  simp [facePoint, h]

omit [Fintype D] in
/-- Consecutive Cartesian cells share precisely the same coordinate face position. -/
theorem shared_face_position (grid : TensorGrid D) (d : D) (cell : Cell D) :
    (grid.axis d).cellRight (cell d) =
      (grid.axis d).cellLeft ((Function.update cell d (cell d + 1)) d) := by
  simpa using (grid.axis d).adjacent (cell d + 1)

/-- Contracting the supplied directional flux family with the positive Cartesian
coordinate normal selects exactly this one-dimensional physical flux. -/
theorem coordinate_normal_flux (solvers : D → LineSolver m) (d : D) (value : Fin m → ℝ) :
    (∑ e : D, (if e = d then (1 : ℝ) else 0) • (solvers e).law.physicalFlux value) =
      (solvers d).law.physicalFlux value := by
  simp

/-- Choose positive-coordinate orientation. The face output includes the actual
transverse area and the selected one-dimensional solver's physical flux.
The duration parameter is retained by the executor; this exact-interface rule
uses the frozen solver's time-one trace and does not assert time averaging. -/
noncomputable def cartesianRule (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (rightCell : Cell D) (_dt : ℝ) (old : ℤ → Fin m → ℝ) : Fin m → ℝ :=
  grid.faceArea d rightCell • (solvers d).faceFlux old (rightCell d)

theorem normalFaceFlux_eq (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    CoordinateLineBalance.normalFaceFlux (cartesianRule grid solvers) d dt state cell =
      grid.faceArea d cell • (solvers d).faceFlux (line d cell state) (cell d) := rfl

/-- The area-weighted flux uses the same adjacent-state problem and returned
field as the exact one-dimensional line solver. -/
theorem normalFaceFlux_physical_trace (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    CoordinateLineBalance.normalFaceFlux (cartesianRule grid solvers) d dt state cell =
      (volume (tangentialFaceBox grid d cell)).toReal •
        (solvers d).law.physicalFlux
          (((solvers d).method.solve
            (adjacentCellRiemannProblem (solvers d).law (line d cell state) (cell d))
            ((solvers d).total _)).solution 0 1) := by
  rw [normalFaceFlux_eq, tangentialFaceBox_volume, LineSolver.faceFlux_physical_trace]

omit [Fintype D] in
/-- The local initial values are the two actual neighboring values on this
same numerical line, and the returned field satisfies its actual flux law. -/
theorem selected_face_problem (solvers : D → LineSolver m) (d : D)
    (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    let result := (solvers d).method.solve
      (adjacentCellRiemannProblem (solvers d).law (line d cell state) (cell d))
      ((solvers d).total _)
    IsRiemannData (fun x => result.solution x 0)
      (state (Function.update cell d (cell d - 1))) (state cell) ∧
    IsRectangleConservationLawSolution result.solution (solvers d).law.physicalFlux := by
  simpa [line] using
    (solvers d).face_problem_solves (line d cell state) (cell d)

theorem netOutwardFlux_eq (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    CoordinateLineBalance.netOutwardFlux (cartesianRule grid solvers) d dt state cell =
      grid.faceArea d cell •
        ((solvers d).faceFlux (line d cell state) (cell d + 1) -
          (solvers d).faceFlux (line d cell state) (cell d)) := by
  rw [CoordinateLineBalance.netOutwardFlux, normalFaceFlux_eq, normalFaceFlux_eq,
    faceArea_update, line_update_base, Function.update_self, smul_sub]

/-- Equality of the actual executed operations, obtained from their common
positive-volume mass identity. No supplied equality of outputs is assumed. -/
theorem advance_eq_advanceDirection (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) :
    CoordinateLineBalance.advance grid.cellVolume (cartesianRule grid solvers) d dt state =
      advanceDirection grid solvers d dt state := by
  funext cell
  have hmass : grid.cellVolume cell •
      CoordinateLineBalance.advance grid.cellVolume (cartesianRule grid solvers) d dt state cell =
      grid.cellVolume cell • advanceDirection grid solvers d dt state cell := by
    rw [CoordinateLineBalance.advance_mass_balance _ grid.cellVolume_pos,
      advanceDirection_full_volume_balance, netOutwardFlux_eq]
  have h := congrArg (fun value => (grid.cellVolume cell)⁻¹ • value) hmass
  simpa only [smul_smul, inv_mul_cancel₀ (grid.cellVolume_pos cell).ne', one_smul] using h

/-- The supplied volume in this specialization is the measured Cartesian cell volume. -/
theorem measured_cell_update (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    (volume (grid.cellBox cell)).toReal •
      CoordinateLineBalance.advance grid.cellVolume (cartesianRule grid solvers) d dt state cell =
      (volume (grid.cellBox cell)).toReal • state cell - dt •
        CoordinateLineBalance.netOutwardFlux (cartesianRule grid solvers) d dt state cell := by
  rw [grid.cellBox_volume]
  exact CoordinateLineBalance.advance_mass_balance _ grid.cellVolume_pos _ _ _ _ _

/-- Restricting the canonical operation gives the frozen actual 1D line update. -/
theorem line_advance (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) (base : Cell D) :
    line d base
      (CoordinateLineBalance.advance grid.cellVolume (cartesianRule grid solvers) d dt state) =
      (solvers d).advance (grid.axis d) dt (line d base state) := by
  rw [advance_eq_advanceDirection, line_advanceDirection]

theorem strict_line_locality (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (state other : Cell D → Fin m → ℝ) (base : Cell D)
    (h : line d base state = line d base other) :
    line d base
      (CoordinateLineBalance.advance grid.cellVolume (cartesianRule grid solvers) d dt state) =
      line d base
        (CoordinateLineBalance.advance grid.cellVolume (cartesianRule grid solvers) d dt other) := by
  rw [line_advance, line_advance, h]

/-- Pointwise operator equality transports every finite ordered stage list. -/
theorem sweep_eq_tensor_operations (grid : TensorGrid D) (solvers : D → LineSolver m)
    (stages : List (D × ℝ)) (state : Cell D → Fin m → ℝ) :
    CoordinateLineBalance.sweep grid.cellVolume (cartesianRule grid solvers) stages state =
      orderedOperatorSweep (stages.map fun stage =>
        advanceDirection grid solvers stage.1 stage.2) state := by
  unfold CoordinateLineBalance.sweep
  congr 1
  apply List.map_congr_left
  intro stage _
  funext current
  exact advance_eq_advanceDirection grid solvers stage.1 stage.2 current

/-- Each remaining stage consumes the actual preceding Cartesian update. -/
theorem sweep_cons_actual_state (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d : D) (dt : ℝ) (stages : List (D × ℝ)) (state : Cell D → Fin m → ℝ) :
    CoordinateLineBalance.sweep grid.cellVolume (cartesianRule grid solvers)
      ((d, dt) :: stages) state =
      CoordinateLineBalance.sweep grid.cellVolume (cartesianRule grid solvers) stages
        (advanceDirection grid solvers d dt state) := by
  rw [CoordinateLineBalance.sweep_cons, advance_eq_advanceDirection]

theorem sweep_two_actual_states (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d e : D) (dt ds : ℝ) (state : Cell D → Fin m → ℝ) :
    CoordinateLineBalance.sweep grid.cellVolume (cartesianRule grid solvers)
      [(d, dt), (e, ds)] state =
      advanceDirection grid solvers e ds (advanceDirection grid solvers d dt state) := by
  rw [CoordinateLineBalance.sweep_two, advance_eq_advanceDirection, advance_eq_advanceDirection]

/-- The second face evaluation receives the first updated field, not the original one. -/
theorem sweep_two_measured_mass (grid : TensorGrid D) (solvers : D → LineSolver m)
    (d e : D) (dt ds : ℝ) (state : Cell D → Fin m → ℝ) (cell : Cell D) :
    (volume (grid.cellBox cell)).toReal •
      CoordinateLineBalance.sweep grid.cellVolume (cartesianRule grid solvers)
        [(d, dt), (e, ds)] state cell =
      (volume (grid.cellBox cell)).toReal • state cell -
        dt • CoordinateLineBalance.netOutwardFlux (cartesianRule grid solvers) d dt state cell -
        ds • CoordinateLineBalance.netOutwardFlux (cartesianRule grid solvers) e ds
          (advanceDirection grid solvers d dt state) cell := by
  rw [grid.cellBox_volume]
  simpa only [advance_eq_advanceDirection] using
    CoordinateLineBalance.sweep_two_mass_balance grid.cellVolume grid.cellVolume_pos
      (cartesianRule grid solvers) d e dt ds state cell

/-- Each step of the frozen fractional schedule agrees on every intermediate input. -/
theorem scheduled_step_eq_canonical (grid : TensorGrid D) (solvers : D → LineSolver m)
    (dt : ℝ) (step : CoordinateFractionalStep D (Cell D) (Fin m → ℝ))
    (hstep : step ∈ schedule grid solvers dt) (current : Cell D → Fin m → ℝ) :
    step.advance current = CoordinateLineBalance.advance grid.cellVolume
      (cartesianRule grid solvers) step.direction dt current := by
  rw [advance_eq_advanceDirection]
  exact scheduled_step_is_line_update grid solvers dt step hstep current

/-- Reuse the actual positive-dimensional solver and stripe witness. -/
theorem concrete_nonvacuity :
    Nonempty (LineSolver 1) ∧
      CoordinateLineBalance.advance Witness.tensorGrid.cellVolume
        (cartesianRule Witness.tensorGrid (fun _ => Witness.identitySolver)) 0 1
        Witness.stripeState ≠ Witness.broadcastOrigin Witness.stripeState ∧
      CoordinateLineBalance.sweep Witness.tensorGrid.cellVolume
        (cartesianRule Witness.tensorGrid (fun _ => Witness.identitySolver)) [(0, 1), (1, 1)]
        Witness.stripeState =
        advanceDirection Witness.tensorGrid (fun _ => Witness.identitySolver) 1 1
          (advanceDirection Witness.tensorGrid (fun _ => Witness.identitySolver) 0 1
            Witness.stripeState) := by
  refine ⟨⟨Witness.identitySolver⟩, ?_, sweep_two_actual_states _ _ _ _ _ _ _⟩
  rw [advance_eq_advanceDirection]
  exact Witness.broadcast_is_not_directional_update _ _ _

end NumStability.CartesianLineCompositionDraft


#check NumStability.CartesianLineCompositionDraft.faceArea_update
#print axioms NumStability.CartesianLineCompositionDraft.faceArea_update
#check NumStability.CartesianLineCompositionDraft.tangentialFaceBox
#print axioms NumStability.CartesianLineCompositionDraft.tangentialFaceBox
#check NumStability.CartesianLineCompositionDraft.tangentialFaceBox_volume
#print axioms NumStability.CartesianLineCompositionDraft.tangentialFaceBox_volume
#check NumStability.CartesianLineCompositionDraft.tangentialFaceBox_update
#print axioms NumStability.CartesianLineCompositionDraft.tangentialFaceBox_update
#check NumStability.CartesianLineCompositionDraft.facePoint
#print axioms NumStability.CartesianLineCompositionDraft.facePoint
#check NumStability.CartesianLineCompositionDraft.facePoint_normal
#print axioms NumStability.CartesianLineCompositionDraft.facePoint_normal
#check NumStability.CartesianLineCompositionDraft.facePoint_transverse
#print axioms NumStability.CartesianLineCompositionDraft.facePoint_transverse
#check NumStability.CartesianLineCompositionDraft.shared_face_position
#print axioms NumStability.CartesianLineCompositionDraft.shared_face_position
#check NumStability.CartesianLineCompositionDraft.coordinate_normal_flux
#print axioms NumStability.CartesianLineCompositionDraft.coordinate_normal_flux
#check NumStability.CartesianLineCompositionDraft.cartesianRule
#print axioms NumStability.CartesianLineCompositionDraft.cartesianRule
#check NumStability.CartesianLineCompositionDraft.normalFaceFlux_eq
#print axioms NumStability.CartesianLineCompositionDraft.normalFaceFlux_eq
#check NumStability.CartesianLineCompositionDraft.normalFaceFlux_physical_trace
#print axioms NumStability.CartesianLineCompositionDraft.normalFaceFlux_physical_trace
#check NumStability.CartesianLineCompositionDraft.selected_face_problem
#print axioms NumStability.CartesianLineCompositionDraft.selected_face_problem
#check NumStability.CartesianLineCompositionDraft.netOutwardFlux_eq
#print axioms NumStability.CartesianLineCompositionDraft.netOutwardFlux_eq
#check NumStability.CartesianLineCompositionDraft.advance_eq_advanceDirection
#print axioms NumStability.CartesianLineCompositionDraft.advance_eq_advanceDirection
#check NumStability.CartesianLineCompositionDraft.measured_cell_update
#print axioms NumStability.CartesianLineCompositionDraft.measured_cell_update
#check NumStability.CartesianLineCompositionDraft.line_advance
#print axioms NumStability.CartesianLineCompositionDraft.line_advance
#check NumStability.CartesianLineCompositionDraft.strict_line_locality
#print axioms NumStability.CartesianLineCompositionDraft.strict_line_locality
#check NumStability.CartesianLineCompositionDraft.sweep_eq_tensor_operations
#print axioms NumStability.CartesianLineCompositionDraft.sweep_eq_tensor_operations
#check NumStability.CartesianLineCompositionDraft.sweep_cons_actual_state
#print axioms NumStability.CartesianLineCompositionDraft.sweep_cons_actual_state
#check NumStability.CartesianLineCompositionDraft.sweep_two_actual_states
#print axioms NumStability.CartesianLineCompositionDraft.sweep_two_actual_states
#check NumStability.CartesianLineCompositionDraft.sweep_two_measured_mass
#print axioms NumStability.CartesianLineCompositionDraft.sweep_two_measured_mass
#check NumStability.CartesianLineCompositionDraft.scheduled_step_eq_canonical
#print axioms NumStability.CartesianLineCompositionDraft.scheduled_step_eq_canonical
#check NumStability.CartesianLineCompositionDraft.concrete_nonvacuity
#print axioms NumStability.CartesianLineCompositionDraft.concrete_nonvacuity


namespace NumStability.ReturnedFieldCoordinateSweepDraft

open MeasureTheory
open scoped BigOperators

variable {D : Type*} [DecidableEq D] {m : ℕ}
variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannFieldFluxMethod (laws d) (Result d) (Information d))

/-- Admission is for this face of this actual numerical state at this stage duration. -/
def FaceAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ) : Prop :=
  (methods d dt).domain (adjacentCellRiemannProblem (laws d)
    (fun j => state (Function.update cell d j)) (cell d))

def StageAdmitted (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) : Prop :=
  ∀ cell, FaceAdmitted methods d dt state cell

/-- Numerical information is extracted from the selected solve of the actual ordered pair. -/
def selectedFaceFlux (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) : Fin m → ℝ :=
  (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve
    (adjacentCellRiemannProblem (laws d) (fun j => state (Function.update cell d j)) (cell d)) h))

/-- Explicit total extension for the canonical algebraic API. The off-domain
fallback is not a Riemann solve and has no asserted physical meaning. -/
noncomputable def guardedRule (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (cell : D → ℤ) (dt : ℝ) (line : ℤ → Fin m → ℝ) : Fin m → ℝ := by
  classical
  exact if h : (methods d dt).domain (adjacentCellRiemannProblem (laws d) line (cell d)) then
    area d cell • (methods d dt).numericalFlux ((methods d dt).extract
      ((methods d dt).solve (adjacentCellRiemannProblem (laws d) line (cell d)) h))
  else fallback d cell dt line

theorem normalFaceFlux_of_admitted (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
      area d cell • selectedFaceFlux methods d dt state cell h := by
  unfold FaceAdmitted at h
  simp only [CoordinateLineBalance.normalFaceFlux, guardedRule, dif_pos h, selectedFaceFlux]

/-- The admitted observation retains the actual field, strict initial states,
all-real trace integrability, same-result extraction, and shared-face weight. -/
theorem admitted_face_observation (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    let problem := adjacentCellRiemannProblem (laws d)
      (fun j => state (Function.update cell d j)) (cell d)
    let result := (methods d dt).solve problem h
    problem.leftState = state (Function.update cell d (cell d - 1)) ∧
      problem.rightState = state cell ∧
      IsRiemannData (fun x => (methods d dt).field result x 0)
        (state (Function.update cell d (cell d - 1))) (state cell) ∧
      (∀ s t, IntervalIntegrable
        (fun τ => (laws d).physicalFlux ((methods d dt).field result 0 τ)) volume s t) ∧
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
        area d cell • (methods d dt).numericalFlux ((methods d dt).extract result) := by
  refine ⟨rfl, ?_, ?_, (methods d dt).trace_integrable _,
    normalFaceFlux_of_admitted methods area fallback d dt state cell h⟩
  · simp [adjacentCellRiemannProblem]
  · simpa [adjacentCellRiemannProblem] using
      (methods d dt).initial ((methods d dt).solve _ h)

theorem normalFaceFlux_fallback_independent (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (cell : D → ℤ)
    (h : FaceAdmitted methods d dt state cell) :
    CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt state cell =
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area other) d dt state cell := by
  rw [normalFaceFlux_of_admitted methods area fallback d dt state cell h,
    normalFaceFlux_of_admitted methods area other d dt state cell h]

theorem advance_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) :
    CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state =
      CoordinateLineBalance.advance volume (guardedRule methods area other) d dt state := by
  funext cell
  unfold CoordinateLineBalance.advance CoordinateLineBalance.netOutwardFlux
  rw [normalFaceFlux_fallback_independent methods area fallback other d dt state _ (h _),
    normalFaceFlux_fallback_independent methods area fallback other d dt state cell (h cell)]

/-- Every later admission is checked on the actual preceding update. This does
not assert preservation of the domain from admission of the initial state alone. -/
def SweepAdmitted (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ) :
    List (D × ℝ) → ((D → ℤ) → Fin m → ℝ) → Prop
  | [], _ => True
  | (d, dt) :: stages, state => StageAdmitted methods d dt state ∧
      SweepAdmitted volume area fallback stages
        (CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state)

theorem sweepAdmitted_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback stages state) :
    SweepAdmitted methods volume area other stages state := by
  induction stages generalizing state with
  | nil => trivial
  | cons step stages ih =>
    rcases step with ⟨d, dt⟩
    refine ⟨h.1, ?_⟩
    rw [← advance_fallback_independent methods volume area fallback other d dt state h.1]
    exact ih _ h.2

theorem sweep_fallback_independent (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback other : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback stages state) :
    CoordinateLineBalance.sweep volume (guardedRule methods area fallback) stages state =
      CoordinateLineBalance.sweep volume (guardedRule methods area other) stages state := by
  induction stages generalizing state with
  | nil => rfl
  | cons step stages ih =>
    rcases step with ⟨d, dt⟩
    rw [CoordinateLineBalance.sweep_cons, CoordinateLineBalance.sweep_cons,
      ← advance_fallback_independent methods volume area fallback other d dt state h.1]
    exact ih _ h.2

/-- Any selected stage in an admitted execution sees an admitted actual prefix state. -/
theorem admission_at_prefix (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (before : List (D × ℝ)) (d : D) (dt : ℝ) (after : List (D × ℝ))
    (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback (before ++ (d, dt) :: after) state) :
    StageAdmitted methods d dt
      (CoordinateLineBalance.sweep volume (guardedRule methods area fallback) before state) := by
  induction before generalizing state with
  | nil => exact h.1
  | cons step before ih =>
    rcases step with ⟨e, ds⟩
    rw [CoordinateLineBalance.sweep_cons]
    exact ih _ h.2

/-- No operational face observation in an admitted sweep uses the fallback. -/
theorem executed_face_uses_selected_solve (volume : (D → ℤ) → ℝ)
    (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (before : List (D × ℝ)) (d : D) (dt : ℝ) (after : List (D × ℝ))
    (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback (before ++ (d, dt) :: after) state)
    (cell : D → ℤ) :
    let current := CoordinateLineBalance.sweep volume (guardedRule methods area fallback) before state
    ∃ admitted : FaceAdmitted methods d dt current cell,
      CoordinateLineBalance.normalFaceFlux (guardedRule methods area fallback) d dt current cell =
        area d cell • selectedFaceFlux methods d dt current cell admitted := by
  exact ⟨admission_at_prefix methods volume area fallback before d dt after state h cell,
    normalFaceFlux_of_admitted methods area fallback d dt _ cell _⟩

/-- Strict line locality is inherited from the canonical line-reading operation. -/
theorem advance_line_local (volume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state other : (D → ℤ) → Fin m → ℝ) (base : D → ℤ)
    (hline : ∀ j, state (Function.update base d j) = other (Function.update base d j)) :
    ∀ j, CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
        (Function.update base d j) =
      CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt other
        (Function.update base d j) :=
  CoordinateLineBalance.advance_line_local volume _ d dt state other base hline

theorem admitted_cell_mass_balance (volume : (D → ℤ) → ℝ) (hvolume : ∀ cell, 0 < volume cell)
    (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (cell : D → ℤ) :
    volume cell • CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state cell =
      volume cell • state cell - dt •
        (area d (Function.update cell d (cell d + 1)) •
            selectedFaceFlux methods d dt state (Function.update cell d (cell d + 1)) (h _) -
          area d cell • selectedFaceFlux methods d dt state cell (h cell)) := by
  rw [CoordinateLineBalance.advance_mass_balance volume hvolume, CoordinateLineBalance.netOutwardFlux,
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _),
    normalFaceFlux_of_admitted methods area fallback d dt state cell (h cell)]

/-- Interior shared-face values cancel; only actual selected exterior solves remain. -/
theorem admitted_finite_line_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : D → ℤ) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count, volume (Function.update base d (start + k)) •
      CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
        (Function.update base d (start + k))) =
      (∑ k ∈ Finset.range count, volume (Function.update base d (start + k)) •
        state (Function.update base d (start + k))) - dt •
      (area d (Function.update base d (start + count)) •
          selectedFaceFlux methods d dt state (Function.update base d (start + count)) (h _) -
        area d (Function.update base d start) •
          selectedFaceFlux methods d dt state (Function.update base d start) (h _)) := by
  rw [CoordinateLineBalance.finite_line_mass_balance volume hvolume,
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _),
    normalFaceFlux_of_admitted methods area fallback d dt state _ (h _)]

/-- The second balance uses the first actual output, with its separate admission. -/
theorem admitted_two_stage_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → Fin m → ℝ)
    (h : SweepAdmitted methods volume area fallback [(d, dt), (e, ds)] state) (cell : D → ℤ) :
    let first := CoordinateLineBalance.advance volume (guardedRule methods area fallback) d dt state
    volume cell • CoordinateLineBalance.sweep volume (guardedRule methods area fallback)
        [(d, dt), (e, ds)] state cell = volume cell • state cell -
      dt • (area d (Function.update cell d (cell d + 1)) • selectedFaceFlux methods d dt state
          (Function.update cell d (cell d + 1)) (h.1 _) -
        area d cell • selectedFaceFlux methods d dt state cell (h.1 cell)) -
      ds • (area e (Function.update cell e (cell e + 1)) • selectedFaceFlux methods e ds first
          (Function.update cell e (cell e + 1)) (h.2.1 _) -
        area e cell • selectedFaceFlux methods e ds first cell (h.2.1 cell)) := by
  rw [CoordinateLineBalance.sweep_two]
  rw [admitted_cell_mass_balance methods volume hvolume area fallback e ds _ h.2.1,
    admitted_cell_mass_balance methods volume hvolume area fallback d dt state h.1]

end NumStability.ReturnedFieldCoordinateSweepDraft


namespace NumStability.ReturnedFieldCoordinateSweepDraft

open TensorLinesDraft MeasureTheory
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

/-- The frozen exact class embeds without changing its selected result/extractor. -/
def exactMethods (solvers : D → LineSolver m) (d : D) (_dt : ℝ) :
    RiemannFieldFluxMethod (solvers d).law (CertifiedRectangleRiemannSolution (solvers d).law)
      (Fin m → ℝ) :=
  RiemannFieldFluxMethod.ofExact (solvers d).method

theorem exact_rule_eq (grid : TensorGrid D) (solvers : D → LineSolver m)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ) :
    guardedRule (exactMethods solvers) grid.faceArea fallback =
      CartesianLineCompositionDraft.cartesianRule grid solvers := by
  funext d cell dt old
  unfold guardedRule
  dsimp only [exactMethods, RiemannFieldFluxMethod.ofExact]
  rw [dif_pos ((solvers d).total _)]
  rfl

theorem exact_advance_eq_tensor (grid : TensorGrid D) (solvers : D → LineSolver m)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ) :
    CoordinateLineBalance.advance grid.cellVolume
      (guardedRule (exactMethods solvers) grid.faceArea fallback) d dt state =
        TensorLinesDraft.advanceDirection grid solvers d dt state := by
  rw [exact_rule_eq]
  exact CartesianLineCompositionDraft.advance_eq_advanceDirection grid solvers d dt state

theorem exact_sweep_eq_tensor (grid : TensorGrid D) (solvers : D → LineSolver m)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : Cell D → Fin m → ℝ) :
    CoordinateLineBalance.sweep grid.cellVolume
      (guardedRule (exactMethods solvers) grid.faceArea fallback) stages state =
        orderedOperatorSweep (stages.map fun stage =>
          TensorLinesDraft.advanceDirection grid solvers stage.1 stage.2) state := by
  rw [exact_rule_eq]
  exact CartesianLineCompositionDraft.sweep_eq_tensor_operations grid solvers stages state

omit [Fintype D] in
theorem exact_sweep_admitted (solvers : D → LineSolver m)
    (volume : Cell D → ℝ) (area : D → Cell D → ℝ)
    (fallback : D → Cell D → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : Cell D → Fin m → ℝ) :
    SweepAdmitted (exactMethods solvers) volume area fallback stages state := by
  induction stages generalizing state with
  | nil => trivial
  | cons step stages ih =>
    exact ⟨fun cell => (solvers step.1).total _, ih _⟩

variable {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
variable {Information : D → Type*}
variable (methods : (d : D) → ℝ → RiemannFieldFluxMethod (laws d) (Result d) (Information d))

omit [Fintype D] in
theorem line_admission (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : Cell D) (j : ℤ) :
    (methods d dt).domain (adjacentCellRiemannProblem (laws d) (line d base state) j) := by
  simpa only [FaceAdmitted, line, Function.update_self, Function.update_idem] using
    h (Function.update base d j)

omit [Fintype D] in
theorem selectedFaceFlux_on_line (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : Cell D) (j : ℤ) :
    selectedFaceFlux methods d dt state (Function.update base d j) (h _) =
      (methods d dt).interfaceFlux (line d base state)
        (line_admission methods d dt state h base) j := by
  have hcongr (p q : HyperbolicRiemannProblem (laws d))
      (hp : (methods d dt).domain p) (hq : (methods d dt).domain q) (heq : p = q) :
      (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve p hp)) =
        (methods d dt).numericalFlux ((methods d dt).extract ((methods d dt).solve q hq)) := by
    cases heq
    rfl
  unfold selectedFaceFlux RiemannFieldFluxMethod.interfaceFlux
  apply hcongr
  simp only [Function.update_self, Function.update_idem]
  rfl

/-- Actual Cartesian line restriction, now for admitted inexact returned methods. -/
theorem cartesian_line_update (grid : TensorGrid D)
    (fallback : D → Cell D → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (base : Cell D) :
    line d base (CoordinateLineBalance.advance grid.cellVolume
        (guardedRule methods grid.faceArea fallback) d dt state) =
      riemannFiniteVolumeUpdate (grid.axis d) dt (line d base state)
        ((methods d dt).interfaceFlux (line d base state) (line_admission methods d dt state h base)) := by
  funext j
  let flux := (methods d dt).interfaceFlux (line d base state)
    (line_admission methods d dt state h base)
  have hline : (grid.axis d).cellVolume j •
      riemannFiniteVolumeUpdate (grid.axis d) dt (line d base state) flux j =
      (grid.axis d).cellVolume j • line d base state j - dt • (flux (j + 1) - flux j) :=
    cellVolume_smul_finiteVolumeCellAverageUpdate dt ((grid.axis d).cellVolume j)
      (line d base state j) (flux (j + 1) - flux j) ((grid.axis d).cellVolume_pos j).ne'
  have harea := congrArg (fun value => grid.faceArea d base • value) hline
  have hreference : grid.cellVolume (Function.update base d j) •
      riemannFiniteVolumeUpdate (grid.axis d) dt (line d base state) flux j =
      grid.cellVolume (Function.update base d j) • state (Function.update base d j) -
        dt • (grid.faceArea d base • flux (j + 1) - grid.faceArea d base • flux j) := by
    rw [grid.cellVolume_eq_width_mul_area d (Function.update base d j)]
    simp only [Function.update_self, CartesianLineCompositionDraft.faceArea_update]
    simpa only [line, smul_sub, smul_smul, mul_comm] using harea
  have hactual := admitted_cell_mass_balance methods grid.cellVolume grid.cellVolume_pos
    grid.faceArea fallback d dt state h (Function.update base d j)
  have hcellFlux :
      selectedFaceFlux methods d dt state
          (Function.update (Function.update base d j) d ((Function.update base d j) d + 1)) (h _) =
        selectedFaceFlux methods d dt state (Function.update base d (j + 1)) (h _) :=
    congrArg (fun cell => selectedFaceFlux methods d dt state cell (h cell)) (by simp)
  rw [hcellFlux] at hactual
  simp only [Function.update_self, Function.update_idem,
    CartesianLineCompositionDraft.faceArea_update] at hactual
  rw [selectedFaceFlux_on_line methods d dt state h base (j + 1),
    selectedFaceFlux_on_line methods d dt state h base j] at hactual
  have heq := hactual.trans hreference.symm
  have hc := congrArg (fun value => (grid.cellVolume (Function.update base d j))⁻¹ • value) heq
  simpa only [smul_smul, inv_mul_cancel₀ (grid.cellVolume_pos _).ne', one_smul] using hc

/-- Supplied volumes and face weights are the already measured Cartesian boxes. -/
theorem cartesian_measured_balance (grid : TensorGrid D)
    (fallback : D → Cell D → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : Cell D → Fin m → ℝ)
    (h : StageAdmitted methods d dt state) (cell : Cell D) :
    (volume (grid.cellBox cell)).toReal • CoordinateLineBalance.advance grid.cellVolume
      (guardedRule methods grid.faceArea fallback) d dt state cell =
      (volume (grid.cellBox cell)).toReal • state cell - dt •
        ((volume (CartesianLineCompositionDraft.tangentialFaceBox grid d
            (Function.update cell d (cell d + 1)))).toReal •
          selectedFaceFlux methods d dt state (Function.update cell d (cell d + 1)) (h _) -
        (volume (CartesianLineCompositionDraft.tangentialFaceBox grid d cell)).toReal •
          selectedFaceFlux methods d dt state cell (h cell)) := by
  rw [grid.cellBox_volume, CartesianLineCompositionDraft.tangentialFaceBox_volume,
    CartesianLineCompositionDraft.tangentialFaceBox_volume]
  exact admitted_cell_mass_balance methods grid.cellVolume grid.cellVolume_pos
    grid.faceArea fallback d dt state h cell

/-- Reuse the actual stationary, nonconserved returned field; no exact certificate is added. -/
noncomputable def stationaryMethods (_d : Fin 2) (_dt : ℝ) :
    RiemannFieldFluxMethod (StationaryRiemannField.transportLaw (m := 1))
      StationaryRiemannField.StationaryResult (Fin 1 → ℝ) :=
  StationaryRiemannField.method

theorem stationary_rule (area : Fin 2 → Cell (Fin 2) → ℝ)
    (fallback : Fin 2 → Cell (Fin 2) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ)
    (d : Fin 2) (cell : Cell (Fin 2)) (dt : ℝ) (old : ℤ → Fin 1 → ℝ) :
    guardedRule stationaryMethods area fallback d cell dt old = area d cell • old (cell d - 1) := by
  simp [guardedRule, stationaryMethods, StationaryRiemannField.method,
    StationaryRiemannField.stationary, adjacentCellRiemannProblem]

theorem stationary_sweep_admitted (volume : Cell (Fin 2) → ℝ)
    (area : Fin 2 → Cell (Fin 2) → ℝ)
    (fallback : Fin 2 → Cell (Fin 2) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ)
    (stages : List (Fin 2 × ℝ)) (state : Cell (Fin 2) → Fin 1 → ℝ) :
    SweepAdmitted stationaryMethods volume area fallback stages state := by
  induction stages generalizing state with
  | nil => trivial
  | cons step stages ih => exact ⟨fun _ => trivial, ih _⟩

/-- The positive unit-time, unit-volume update is an actual one-cell upwind shift. -/
theorem stationary_unit_update
    (fallback : Fin 2 → Cell (Fin 2) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ)
    (d : Fin 2) (state : Cell (Fin 2) → Fin 1 → ℝ) (cell : Cell (Fin 2)) :
    CoordinateLineBalance.advance (fun _ => 1)
      (guardedRule stationaryMethods (fun _ _ => 1) fallback) d 1 state cell =
        state (Function.update cell d (cell d - 1)) := by
  simp [CoordinateLineBalance.advance, finiteVolumeCellAverageUpdate,
    CoordinateLineBalance.netOutwardFlux, CoordinateLineBalance.normalFaceFlux, stationary_rule]

theorem stationary_two_stage_nonvacuity
    (fallback : Fin 2 → Cell (Fin 2) → ℝ → (ℤ → Fin 1 → ℝ) → Fin 1 → ℝ) :
    SweepAdmitted stationaryMethods (fun _ => 1) (fun _ _ => 1) fallback [(0, 1), (1, 1)]
      TensorLinesDraft.Witness.stripeState ∧
    CoordinateLineBalance.sweep (fun _ => 1)
      (guardedRule stationaryMethods (fun _ _ => 1) fallback) [(0, 1), (1, 1)]
      TensorLinesDraft.Witness.stripeState ![0, 1] = 0 ∧
    CoordinateLineBalance.sweep (fun _ => 1)
      (guardedRule stationaryMethods (fun _ _ => 1) fallback) [(0, 1), (1, 1)]
      TensorLinesDraft.Witness.stripeState ![0, 2] = 1 ∧
    (∃ problem : HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := 1)),
      ¬ IsRectangleConservationLawSolution
        ((stationaryMethods 0 1).field ((stationaryMethods 0 1).solve problem trivial))
        StationaryRiemannField.transportLaw.physicalFlux) := by
  refine ⟨stationary_sweep_admitted _ _ _ _ _, ?_, ?_, ?_⟩
  · rw [CoordinateLineBalance.sweep_two, stationary_unit_update, stationary_unit_update]
    simp [TensorLinesDraft.Witness.stripeState]
  · rw [CoordinateLineBalance.sweep_two, stationary_unit_update, stationary_unit_update]
    simp [TensorLinesDraft.Witness.stripeState]
  · obtain ⟨problem, _, h⟩ := StationaryRiemannField.nonexact_instance
    exact ⟨problem, h⟩

end NumStability.ReturnedFieldCoordinateSweepDraft


#check NumStability.ReturnedFieldCoordinateSweepDraft.FaceAdmitted
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.FaceAdmitted
#check NumStability.ReturnedFieldCoordinateSweepDraft.StageAdmitted
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.StageAdmitted
#check NumStability.ReturnedFieldCoordinateSweepDraft.selectedFaceFlux
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.selectedFaceFlux
#check NumStability.ReturnedFieldCoordinateSweepDraft.guardedRule
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.guardedRule
#check NumStability.ReturnedFieldCoordinateSweepDraft.normalFaceFlux_of_admitted
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.normalFaceFlux_of_admitted
#check NumStability.ReturnedFieldCoordinateSweepDraft.admitted_face_observation
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.admitted_face_observation
#check NumStability.ReturnedFieldCoordinateSweepDraft.normalFaceFlux_fallback_independent
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.normalFaceFlux_fallback_independent
#check NumStability.ReturnedFieldCoordinateSweepDraft.advance_fallback_independent
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.advance_fallback_independent
#check NumStability.ReturnedFieldCoordinateSweepDraft.SweepAdmitted
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.SweepAdmitted
#check NumStability.ReturnedFieldCoordinateSweepDraft.sweepAdmitted_fallback_independent
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.sweepAdmitted_fallback_independent
#check NumStability.ReturnedFieldCoordinateSweepDraft.sweep_fallback_independent
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.sweep_fallback_independent
#check NumStability.ReturnedFieldCoordinateSweepDraft.admission_at_prefix
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.admission_at_prefix
#check NumStability.ReturnedFieldCoordinateSweepDraft.executed_face_uses_selected_solve
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.executed_face_uses_selected_solve
#check NumStability.ReturnedFieldCoordinateSweepDraft.advance_line_local
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.advance_line_local
#check NumStability.ReturnedFieldCoordinateSweepDraft.admitted_cell_mass_balance
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.admitted_cell_mass_balance
#check NumStability.ReturnedFieldCoordinateSweepDraft.admitted_finite_line_mass_balance
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.admitted_finite_line_mass_balance
#check NumStability.ReturnedFieldCoordinateSweepDraft.admitted_two_stage_balance
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.admitted_two_stage_balance
#check NumStability.ReturnedFieldCoordinateSweepDraft.exactMethods
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.exactMethods
#check NumStability.ReturnedFieldCoordinateSweepDraft.exact_rule_eq
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.exact_rule_eq
#check NumStability.ReturnedFieldCoordinateSweepDraft.exact_advance_eq_tensor
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.exact_advance_eq_tensor
#check NumStability.ReturnedFieldCoordinateSweepDraft.exact_sweep_eq_tensor
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.exact_sweep_eq_tensor
#check NumStability.ReturnedFieldCoordinateSweepDraft.exact_sweep_admitted
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.exact_sweep_admitted
#check NumStability.ReturnedFieldCoordinateSweepDraft.line_admission
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.line_admission
#check NumStability.ReturnedFieldCoordinateSweepDraft.selectedFaceFlux_on_line
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.selectedFaceFlux_on_line
#check NumStability.ReturnedFieldCoordinateSweepDraft.cartesian_line_update
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.cartesian_line_update
#check NumStability.ReturnedFieldCoordinateSweepDraft.cartesian_measured_balance
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.cartesian_measured_balance
#check NumStability.ReturnedFieldCoordinateSweepDraft.stationaryMethods
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.stationaryMethods
#check NumStability.ReturnedFieldCoordinateSweepDraft.stationary_rule
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.stationary_rule
#check NumStability.ReturnedFieldCoordinateSweepDraft.stationary_sweep_admitted
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.stationary_sweep_admitted
#check NumStability.ReturnedFieldCoordinateSweepDraft.stationary_unit_update
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.stationary_unit_update
#check NumStability.ReturnedFieldCoordinateSweepDraft.stationary_two_stage_nonvacuity
#print axioms NumStability.ReturnedFieldCoordinateSweepDraft.stationary_two_stage_nonvacuity
