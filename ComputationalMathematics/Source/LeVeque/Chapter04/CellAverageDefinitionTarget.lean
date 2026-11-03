/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Cell
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# LeVeque equation (4.1): the exact physical reference cell average

Proof-free draft. The numerical quantity `Q_i^n` is described by the source as
an approximation to this reference; no equality of arbitrary numerical data
with the true solution average or unprinted quantitative accuracy is asserted.

The source cell is open. Ordinary definite-integral, open-cell and closed-cell
representations agree for real volume, without restrictions on endpoint values.
The source generally uses a uniform grid for simplicity and explicitly says
uniformity is not required. Arbitrary ordered interfaces, component formulas
and the volume-average certificate are disclosed mathematical elaborations of
the same normalized physical integral, rather than additional printed claims.
-/

namespace NumStability

open MeasureTheory
open scoped Interval

/-- The exact quantity approximated in (4.1), for every cell and sampled time
of an arbitrary finite real system. Only positive cell widths and local spatial
integrability are required; no evolution equation or numerical method is assumed. -/
def Leveque04CellAverageDefinitionTarget : Prop :=
  ∀ (m : ℕ), 0 < m →
    ∀ (interface : ℤ → ℝ) (time : ℕ → ℝ)
      (q : ℝ → ℝ → (Fin m → ℝ)),
      (∀ i, interface (i - 1) < interface i) →
      (∀ i n, IntervalIntegrable (fun x => q x (time n)) volume
        (interface (i - 1)) (interface i)) →
      ∀ i n,
        let profile := fun x => q x (time n)
        let left := interface (i - 1)
        let right := interface i
        let width := leveque04_cellWidth interface i
        let mean := oneDimensionalCellAverage profile left right
        0 < width ∧
          IsOneDimensionalCellAverage profile left right mean ∧
          mean = (1 / width) • (∫ x in left..right, profile x) ∧
          mean = (1 / width) • (∫ x in leveque04_cell interface i, profile x) ∧
          mean = (1 / width) • (∫ x in Set.Icc left right, profile x) ∧
          IsCellVolumeAverage volume (leveque04_cell interface i) profile mean ∧
          (∀ p : Fin m,
            mean p = (1 / width) *
              (∫ x in leveque04_cell interface i, profile x p))

end NumStability
