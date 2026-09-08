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
  simp [schedule, coordinateFractionalSchedule, CoordinateHighResolutionMethod.fractionalStep]

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
