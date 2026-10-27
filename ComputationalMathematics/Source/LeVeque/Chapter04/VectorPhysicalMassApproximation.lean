/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.TotalMass
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageMass

/-!
# LeVeque Chapter 4: physical mass for finite systems

Exact averages reconstruct the physical integral, and supplied cellwise
norm tolerances give the weighted mass-error bound. This is the PDF87
prose contract; the literal printed equation (4.8), its refutation and the
separately named corrected boundary law remain distinct source objects.
-/

namespace NumStability
open MeasureTheory intervalIntegral
open scoped BigOperators
def Leveque04VectorPhysicalMassTarget : Prop :=
  (∀ (m : ℕ) (edge : ℕ → ℝ) (field : ℝ → Fin m → ℝ) (N : ℕ),
    (∀ k < N, edge k < edge (k+1)) →
    (∀ k < N, IntervalIntegrable field volume (edge k) (edge (k+1))) →
    (∑ k ∈ Finset.range N, (edge (k+1)-edge k) •
      oneDimensionalCellAverage field (edge k) (edge (k+1))) =
      ∫ x in edge 0..edge N, field x) ∧
  (∀ (m : ℕ) (edge : ℕ → ℝ) (field : ℝ → Fin m → ℝ)
    (values : ℕ → Fin m → ℝ) (error : ℕ → ℝ) (N : ℕ),
    (∀ k < N, edge k < edge (k+1)) →
    (∀ k < N, IntervalIntegrable field volume (edge k) (edge (k+1))) →
    (∀ k < N, ‖values k-oneDimensionalCellAverage field (edge k) (edge (k+1))‖ ≤ error k) →
    ‖(∑ k ∈ Finset.range N, (edge (k+1)-edge k) • values k) -
      ∫ x in edge 0..edge N, field x‖ ≤
      ∑ k ∈ Finset.range N, (edge (k+1)-edge k)*error k)

theorem leveque04_vectorPhysicalMassApproximation :
    Leveque04VectorPhysicalMassTarget := by
  constructor
  · intro m edge field N hcell hint
    exact cellAverage_massProjection edge field N hcell hint
  · intro m edge field values error N hcell hint herror
    exact cellAverage_massError edge field values error N hcell hint herror

end NumStability
