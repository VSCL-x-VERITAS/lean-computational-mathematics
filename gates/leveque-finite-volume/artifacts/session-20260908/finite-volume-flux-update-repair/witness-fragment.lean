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
