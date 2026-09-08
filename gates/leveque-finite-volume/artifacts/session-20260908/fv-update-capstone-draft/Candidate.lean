import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
An unselected conditional-error capstone, assembled only from canonical owners.
The accuracy convention remains an unanswered source-scope choice.
-/

open MeasureTheory

namespace NumStability.FVUpdateCapstoneDraft

/-- The reference averages, weighted update error and conditional error bound
are linked to the same grid, independently supplied exact field, old numerical
array, two times, and full-array numerical flux rule. -/
theorem finiteVolumeUpdate_capstone {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) :
    ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q flux s t i) ∧
      grid.cellVolume i • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) • ((rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i) -
            (rule s t old (i + 1) - timeAveragedPhysicalFaceFlux grid q flux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i‖ ≤ leftBound →
        ‖rule s t old (i + 1) -
          timeAveragedPhysicalFaceFlux grid q flux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) := by
  intro i
  refine ⟨finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i,
    timeAveragedPhysicalFaceFlux_isCellAverage grid hq hst i,
    riemannFiniteVolumeUpdate_weighted_error grid hq rule hst old i, ?_⟩
  intro oldBound leftBound rightBound hold hleft hright
  exact riemannFiniteVolumeUpdate_error_le grid hq rule hst old i hold hleft hright

end NumStability.FVUpdateCapstoneDraft


/- Verification witness only; the checked standalone file prepends the candidate
and imports Mathlib.Analysis.SpecialFunctions.Integrals.Basic. -/
namespace NumStability.FVUpdateCapstoneDraft.Witness

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
    timeAveragedPhysicalFaceFlux grid q id 0 1 0 = (-1 / 2 : ℝ) • (1 : Fin 1 → ℝ) := by
  simp [timeAveragedPhysicalFaceFlux, oneDimensionalCellAverage, grid, q,
    intervalIntegral.integral_smul_const, intervalIntegral.integral_neg, integral_id]
  module

/-- Numerical input differs from the exact cell average; the physical reference
is time dependent and differs from the initial point flux; the numerical flux
is nonzero. All components of the error-balance theorem have an actual instance. -/
theorem roles_are_distinct :
    old 0 ≠ finiteVolumeCellAverageOn grid (fun x => q x 0) 0 ∧
      timeAveragedPhysicalFaceFlux grid q id 0 1 0 ≠ id (q (grid.cellLeft 0) 0) ∧
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
    grid.cellVolume 0 • (riemannFiniteVolumeUpdate grid (1 - 0) old (rule 0 1 old) 0 -
        finiteVolumeCellAverageOn grid (fun x => q x 1) 0) =
      grid.cellVolume 0 • (old 0 - finiteVolumeCellAverageOn grid (fun x => q x 0) 0) +
        (1 - 0 : ℝ) • ((rule 0 1 old 0 - timeAveragedPhysicalFaceFlux grid q id 0 1 0) -
          (rule 0 1 old 1 - timeAveragedPhysicalFaceFlux grid q id 0 1 1)) :=
  riemannFiniteVolumeUpdate_weighted_error grid q_conserved rule (by norm_num) old 0

end NumStability.FVUpdateCapstoneDraft.Witness
