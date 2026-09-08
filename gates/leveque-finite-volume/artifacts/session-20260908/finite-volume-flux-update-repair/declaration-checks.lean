import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
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

/- Source-wrapper proposal only; the checked standalone file prepends candidate.lean. -/
namespace NumStability.FVFluxUpdateDraft

/-- Proposed finite-volume process contract under an explicit finite-rectangle
temporal convention. Accuracy is represented by an exact error identity,
not a supplied tolerance. Source interpretation remains a separate review. -/
theorem sourceContract {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (hq : IsRectangleConservationLawSolution q flux)
    (old : ℤ → (Fin m → ℝ))
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    (s t : ℝ) (hst : s < t) :
    0 < t - s ∧
      (∀ i τ, IsOneDimensionalCellAverage (fun x => q x τ)
        (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x τ) i)) ∧
      (∀ j, IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft j) τ)) s t
        (physicalFaceAverage grid q flux s t j)) ∧
      ∃ updated : ℤ → (Fin m → ℝ),
        (∀ i, updated i = old i - ((t - s) / grid.cellVolume i) •
          (rule s t old (i + 1) - rule s t old i)) ∧
        (∀ i, grid.cellVolume i • (updated i -
            finiteVolumeCellAverageOn grid (fun x => q x t) i) =
          grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
            (t - s) • ((rule s t old i - physicalFaceAverage grid q flux s t i) -
              (rule s t old (i + 1) - physicalFaceAverage grid q flux s t (i + 1)))) ∧
        (∀ start count,
          (∑ k ∈ Finset.range count, grid.cellVolume (start + k) • (updated (start + k) -
            finiteVolumeCellAverageOn grid (fun x => q x t) (start + k))) =
          (∑ k ∈ Finset.range count, grid.cellVolume (start + k) • (old (start + k) -
            finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))) +
          (t - s) • ((rule s t old start - physicalFaceAverage grid q flux s t start) -
            (rule s t old (start + count) - physicalFaceAverage grid q flux s t (start + count)))) := by
  refine ⟨sub_pos.mpr hst, ?_, ?_, numericalUpdate grid rule s t old, ?_, ?_, ?_⟩
  · intro i τ
    exact exactCellAverage_spec grid hq τ i
  · exact physicalFaceAverage_spec grid hq hst
  · intro i
    rfl
  · exact numericalUpdate_weighted_error grid hq rule hst old
  · exact numericalUpdate_block_error grid hq rule hst old

end NumStability.FVFluxUpdateDraft

/- Verification witness only; the checked standalone file prepends the candidate
and imports Mathlib.Analysis.SpecialFunctions.Integrals.Basic. -/
namespace NumStability.FVFluxUpdateDraft.Witness

noncomputable def grid : OneDimensionalFiniteVolumeGrid where
  cellLeft i := i
  cellRight i := (i : ℝ) + 1
  cell_nonempty i := by linarith
  adjacent i := by push_cast; ring

noncomputable def q (x t : ℝ) : Fin 1 → ℝ := (x - t) • (1 : Fin 1 → ℝ)

theorem q_conserved : IsRectangleConservationLawSolution q id := by
  have hp : ∀ a b, IntervalIntegrable (fun x : ℝ => x • (1 : Fin 1 → ℝ)) volume a b :=
    fun a b => (continuous_id.smul continuous_const).intervalIntegrable a b
  have hq : travelingWave (fun x : ℝ => x • (1 : Fin 1 → ℝ)) 1 = q := by
    funext x t
    simp [q, travelingWave]
  have hf : (fun state : Fin 1 → ℝ => (1 : ℝ) • state) = id := by
    funext state
    simp
  rw [← hq, ← hf]
  exact travelingWave_isRectangleConservationLawSolution _ hp 1

noncomputable def old : ℤ → (Fin 1 → ℝ) := fun _ => 0

noncomputable def rule (s t : ℝ) (data : ℤ → (Fin 1 → ℝ)) (j : ℤ) : Fin 1 → ℝ :=
  data (j + 2) + (t - s) • (1 : Fin 1 → ℝ)

theorem exact_initial_average :
    finiteVolumeCellAverageOn grid (fun x => q x 0) 0 = (1 / 2 : ℝ) • (1 : Fin 1 → ℝ) := by
  simp [finiteVolumeCellAverageOn, oneDimensionalCellAverage, grid, q,
    intervalIntegral.integral_smul_const, integral_id]

theorem physical_reference :
    physicalFaceAverage grid q id 0 1 0 = (-1 / 2 : ℝ) • (1 : Fin 1 → ℝ) := by
  simp [physicalFaceAverage, oneDimensionalCellAverage, grid, q,
    intervalIntegral.integral_smul_const, intervalIntegral.integral_neg, integral_id]
  module

/-- Numerical input differs from the exact cell average; the physical reference
is time dependent and differs from the initial point flux; the numerical flux
is nonzero. All components of the error-balance theorem have an actual instance. -/
theorem roles_are_distinct :
    old 0 ≠ finiteVolumeCellAverageOn grid (fun x => q x 0) 0 ∧
      physicalFaceAverage grid q id 0 1 0 ≠ id (q (grid.cellLeft 0) 0) ∧
      rule 0 1 old 0 ≠ 0 := by
  rw [exact_initial_average, physical_reference]
  constructor
  · intro h
    have hh := congrFun h 0
    norm_num [old] at hh
  constructor
  · intro h
    have hh := congrFun h 0
    norm_num [q, grid] at hh
  · intro h
    exact (one_ne_zero : (1 : ℝ) ≠ 0) (by simpa [rule, old] using congrFun h 0)

theorem actual_error_identity :
    grid.cellVolume 0 • (numericalUpdate grid rule 0 1 old 0 -
        finiteVolumeCellAverageOn grid (fun x => q x 1) 0) =
      grid.cellVolume 0 • (old 0 - finiteVolumeCellAverageOn grid (fun x => q x 0) 0) +
        (1 - 0 : ℝ) • ((rule 0 1 old 0 - physicalFaceAverage grid q id 0 1 0) -
          (rule 0 1 old 1 - physicalFaceAverage grid q id 0 1 1)) :=
  numericalUpdate_weighted_error grid q_conserved rule (by norm_num) old 0

end NumStability.FVFluxUpdateDraft.Witness

#check NumStability.FVFluxUpdateDraft.physicalFaceAverage
#print axioms NumStability.FVFluxUpdateDraft.physicalFaceAverage
#check NumStability.FVFluxUpdateDraft.numericalUpdate
#print axioms NumStability.FVFluxUpdateDraft.numericalUpdate
#check NumStability.FVFluxUpdateDraft.physicalFaceAverage_spec
#print axioms NumStability.FVFluxUpdateDraft.physicalFaceAverage_spec
#check NumStability.FVFluxUpdateDraft.timeStep_smul_physicalFaceAverage
#print axioms NumStability.FVFluxUpdateDraft.timeStep_smul_physicalFaceAverage
#check NumStability.FVFluxUpdateDraft.exactCellAverage_spec
#print axioms NumStability.FVFluxUpdateDraft.exactCellAverage_spec
#check NumStability.FVFluxUpdateDraft.exactCellAverage_mass_balance
#print axioms NumStability.FVFluxUpdateDraft.exactCellAverage_mass_balance
#check NumStability.FVFluxUpdateDraft.numericalUpdate_mass_balance
#print axioms NumStability.FVFluxUpdateDraft.numericalUpdate_mass_balance
#check NumStability.FVFluxUpdateDraft.numericalUpdate_weighted_error
#print axioms NumStability.FVFluxUpdateDraft.numericalUpdate_weighted_error
#check NumStability.FVFluxUpdateDraft.numericalUpdate_block_error
#print axioms NumStability.FVFluxUpdateDraft.numericalUpdate_block_error
#check NumStability.FVFluxUpdateDraft.sourceContract
#print axioms NumStability.FVFluxUpdateDraft.sourceContract
#check NumStability.FVFluxUpdateDraft.Witness.grid
#print axioms NumStability.FVFluxUpdateDraft.Witness.grid
#check NumStability.FVFluxUpdateDraft.Witness.q
#print axioms NumStability.FVFluxUpdateDraft.Witness.q
#check NumStability.FVFluxUpdateDraft.Witness.q_conserved
#print axioms NumStability.FVFluxUpdateDraft.Witness.q_conserved
#check NumStability.FVFluxUpdateDraft.Witness.old
#print axioms NumStability.FVFluxUpdateDraft.Witness.old
#check NumStability.FVFluxUpdateDraft.Witness.rule
#print axioms NumStability.FVFluxUpdateDraft.Witness.rule
#check NumStability.FVFluxUpdateDraft.Witness.exact_initial_average
#print axioms NumStability.FVFluxUpdateDraft.Witness.exact_initial_average
#check NumStability.FVFluxUpdateDraft.Witness.physical_reference
#print axioms NumStability.FVFluxUpdateDraft.Witness.physical_reference
#check NumStability.FVFluxUpdateDraft.Witness.roles_are_distinct
#print axioms NumStability.FVFluxUpdateDraft.Witness.roles_are_distinct
#check NumStability.FVFluxUpdateDraft.Witness.actual_error_identity
#print axioms NumStability.FVFluxUpdateDraft.Witness.actual_error_identity
#check NumStability.IsRectangleConservationLawSolution
#print axioms NumStability.IsRectangleConservationLawSolution
#check NumStability.oneDimensionalCellAverage
#print axioms NumStability.oneDimensionalCellAverage
#check NumStability.oneDimensionalCellAverage_isCellAverage
#print axioms NumStability.oneDimensionalCellAverage_isCellAverage
#check NumStability.cellWidth_smul_oneDimensionalCellAverage
#print axioms NumStability.cellWidth_smul_oneDimensionalCellAverage
#check NumStability.OneDimensionalFiniteVolumeGrid.cellVolume_pos
#print axioms NumStability.OneDimensionalFiniteVolumeGrid.cellVolume_pos
#check NumStability.finiteVolumeCellAverageOn_spec
#print axioms NumStability.finiteVolumeCellAverageOn_spec
#check NumStability.riemannFiniteVolumeUpdate
#print axioms NumStability.riemannFiniteVolumeUpdate
#check NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate
#print axioms NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate
#check NumStability.sum_conservativeFluxDifferenceUpdate
#print axioms NumStability.sum_conservativeFluxDifferenceUpdate
#check NumStability.travelingWave_isRectangleConservationLawSolution
#print axioms NumStability.travelingWave_isRectangleConservationLawSolution
#check intervalIntegral.integral_sub
#print axioms intervalIntegral.integral_sub
#check intervalIntegral.integral_smul_const
#print axioms intervalIntegral.integral_smul_const
#check integral_id
#print axioms integral_id
