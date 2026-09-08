import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannFluxAverage
import Lean

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


/- Exact old-to-new statement equality after transparent expansion of removed aliases.
   Private declarations are resolved from the imported environment, never guessed. -/
open Lean Elab Command Meta in
run_cmd do
  let pairs : List (String × String) := [
    ("NumStability.FVFluxUpdateDraft.physicalFaceAverage", "timeAveragedPhysicalFaceFlux"),
    ("NumStability.FVFluxUpdateDraft.physicalFaceAverage_spec", "timeAveragedPhysicalFaceFlux_isCellAverage"),
    ("NumStability.FVFluxUpdateDraft.timeStep_smul_physicalFaceAverage", "timeStep_smul_timeAveragedPhysicalFaceFlux"),
    ("NumStability.FVFluxUpdateDraft.exactCellAverage_mass_balance", "finiteVolumeCellAverageOn_mass_balance"),
    ("NumStability.FVFluxUpdateDraft.numericalUpdate_mass_balance", "cellVolume_smul_riemannFiniteVolumeUpdate_fromRule"),
    ("NumStability.FVFluxUpdateDraft.numericalUpdate_weighted_error", "riemannFiniteVolumeUpdate_weighted_error"),
    ("NumStability.FVFluxUpdateDraft.numericalUpdate_block_error", "riemannFiniteVolumeUpdate_block_error"),
    ("NumStability.FVFluxEstimateDraft.numericalUpdate_error_bound", "riemannFiniteVolumeUpdate_error_le"),
    ("NumStability.FVFluxEstimateDraft.numericalUpdate_block_mass_error_bound", "riemannFiniteVolumeUpdate_block_mass_error_le"),
    ("NumStability.FVFluxEstimateDraft.average_difference_norm_le", "norm_oneDimensionalCellAverage_sub_le"),
    ("NumStability.FVFluxEstimateDraft.selectedLinearFlux_eq_physical_trace", "linearRectangleRiemannInterfaceFluxMethod_flux_eq_physicalTrace"),
    ("NumStability.FVFluxEstimateDraft.selectedLinearFlux_eq_solver_average", "linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage"),
    ("NumStability.FVFluxEstimateDraft.linearRule_flux_error_le", "linearRectangleRiemannInterfaceFlux_error_le"),
    ("NumStability.FVFluxEstimateDraft.linearRule_next_error_bound", "linearRectangleRiemannInterfaceFlux_update_error_le"),
    ("NumStability.FVFluxEstimateDraft.norm_le_of_weighted_balance", "norm_le_of_weighted_balance")]
  let env ← getEnv
  for (oldString, newSuffix) in pairs do
    let oldName := oldString.toName
    let publicName := ("NumStability." ++ newSuffix).toName
    let candidates := env.constants.toList.filter fun (n, _) =>
      n == publicName || (n.toString.startsWith "_private.ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume." &&
        n.toString.endsWith (".NumStability." ++ newSuffix))
    unless candidates.length == 1 do
      throwError "Expected exactly one canonical declaration for {newSuffix}: {candidates.map Prod.fst}"
    let newName := candidates[0]!.1
    elabCommand (← `(command| #check $(mkIdent newName)))
    elabCommand (← `(command| #print axioms $(mkIdent newName)))
    let axioms ← Lean.collectAxioms newName
    let allowed := [``propext, ``Classical.choice, ``Quot.sound]
    for axiomName in axioms do
      unless allowed.contains axiomName do
        throwError "Disallowed axiom {axiomName} in {newName}"
    liftTermElabM do
      let oldInfo ← getConstInfo oldName
      let newInfo ← getConstInfo newName
      unless oldInfo.levelParams.length == newInfo.levelParams.length do
        throwError "Universe count mismatch: {oldName} / {newName}"
      let levels := oldInfo.levelParams.map Level.param
      let newType := newInfo.type.instantiateLevelParams newInfo.levelParams levels
      unless ← withTransparency .all (isDefEq oldInfo.type newType) do
        throwError "Statement mismatch: {oldName} / {newName}"
      logInfo m!"TYPE_PRESERVED {oldName} => {newName}"
  logInfo m!"CHECKED_CANONICAL_DECLARATIONS {pairs.length}"
