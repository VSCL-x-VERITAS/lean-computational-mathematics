/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalFluxAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference

/-!
# Exact finite-volume error identities

Numerical arrays are independent of exact cell averages. An arbitrary
time-dependent full-array flux rule gives a local weighted error identity;
finite contiguous blocks retain only their two exterior face errors.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

variable {m : ℕ}

private theorem cellVolume_smul_riemannFiniteVolumeUpdate_fromRule (grid : OneDimensionalFiniteVolumeGrid)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    (s t : ℝ) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    grid.cellVolume i • riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i =
      grid.cellVolume i • old i -
        (t - s) • (rule s t old (i + 1) - rule s t old i) :=
  cellVolume_smul_finiteVolumeCellAverageUpdate (t - s) (grid.cellVolume i)
    (old i) (rule s t old (i + 1) - rule s t old i)
    (ne_of_gt (grid.cellVolume_pos i))

/-- Old numerical error and numerical-minus-physical face errors give the exact new error. -/
theorem riemannFiniteVolumeUpdate_weighted_error (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    grid.cellVolume i • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
        finiteVolumeCellAverageOn grid (fun x => q x t) i) =
      grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
        (t - s) • ((rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i) -
          (rule s t old (i + 1) - timeAveragedPhysicalFaceFlux grid q flux s t (i + 1))) := by
  have hexact := finiteVolumeCellAverageOn_mass_balance grid hq hst i
  have htime := eq_add_of_sub_eq hexact
  rw [smul_sub, cellVolume_smul_riemannFiniteVolumeUpdate_fromRule, htime]
  module

/-- Interior flux errors cancel on every finite contiguous block, including nonuniform cells. -/
theorem riemannFiniteVolumeUpdate_block_error (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count,
      grid.cellVolume (start + k) • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) (start + k) -
        finiteVolumeCellAverageOn grid (fun x => q x t) (start + k))) =
      (∑ k ∈ Finset.range count,
        grid.cellVolume (start + k) • (old (start + k) -
          finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))) +
      (t - s) • ((rule s t old start - timeAveragedPhysicalFaceFlux grid q flux s t start) -
        (rule s t old (start + count) - timeAveragedPhysicalFaceFlux grid q flux s t (start + count))) := by
  let oldError : ℕ → (Fin m → ℝ) := fun k =>
    grid.cellVolume (start + k) • (old (start + k) -
      finiteVolumeCellAverageOn grid (fun x => q x s) (start + k))
  let edgeError : ℕ → (Fin m → ℝ) := fun k =>
    rule s t old (start + k) - timeAveragedPhysicalFaceFlux grid q flux s t (start + k)
  calc
    _ = ∑ k ∈ Finset.range count,
        conservativeFluxDifferenceUpdate (t - s) oldError edgeError k := by
      apply Finset.sum_congr rfl
      intro k hk
      rw [riemannFiniteVolumeUpdate_weighted_error grid hq rule hst old]
      simp only [conservativeFluxDifferenceUpdate, oldError, edgeError,
        Nat.cast_add, Nat.cast_one, add_assoc]
      module
    _ = (∑ k ∈ Finset.range count, oldError k) -
        (t - s) • (edgeError count - edgeError 0) :=
      sum_conservativeFluxDifferenceUpdate _ _ _ _
    _ = _ := by
      simp only [oldError, edgeError, Nat.cast_zero, add_zero]
      module

end NumStability
