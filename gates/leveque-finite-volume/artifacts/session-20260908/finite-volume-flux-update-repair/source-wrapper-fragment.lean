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
