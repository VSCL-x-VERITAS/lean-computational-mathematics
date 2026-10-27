/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import Mathlib.Tactic.FieldSimp

/-!
# LeVeque Chapter 4: boundary-flux change of discrete total mass

For a uniform positive cell width, the weighted sum of a conservative update
changes only through the two exterior numerical fluxes. The approximation of
the continuous integral by the discrete sum is a separate source assertion.
-/

open scoped BigOperators

namespace NumStability

/-- The conservative step changes discrete total mass by its boundary flux
difference; all interior interface fluxes cancel. Natural index `0` represents
the book's first cell. -/
theorem leveque04_totalMass_boundaryFlux {m : ℕ}
    (timeStep cellWidth : ℝ) (hwidth : 0 < cellWidth)
    (before edgeFlux : ℕ → (Fin m → ℝ)) (cellCount : ℕ) :
    (∑ i ∈ Finset.range cellCount,
      cellWidth • conservativeFluxDifferenceUpdate
        (timeStep / cellWidth) before edgeFlux i) =
      (∑ i ∈ Finset.range cellCount, cellWidth • before i) -
        timeStep • (edgeFlux cellCount - edgeFlux 0) := by
  rw [← Finset.smul_sum, ← Finset.smul_sum,
    sum_conservativeFluxDifferenceUpdate, smul_sub, smul_smul]
  have hscale : cellWidth * (timeStep / cellWidth) = timeStep := by
    field_simp
  rw [hscale]

/-- The same cancellation over any consecutive block beginning at `start`.
Natural index `start` corresponds to the book's leftmost cell index `I`. -/
theorem leveque04_totalMass_boundaryFlux_from {m : ℕ}
    (timeStep cellWidth : ℝ) (hwidth : 0 < cellWidth)
    (before edgeFlux : ℕ → (Fin m → ℝ)) (start cellCount : ℕ) :
    (∑ k ∈ Finset.range cellCount,
      cellWidth • conservativeFluxDifferenceUpdate
        (timeStep / cellWidth) before edgeFlux (start + k)) =
      (∑ k ∈ Finset.range cellCount, cellWidth • before (start + k)) -
        timeStep • (edgeFlux (start + cellCount) - edgeFlux start) := by
  let shiftedBefore : ℕ → (Fin m → ℝ) := fun k => before (start + k)
  let shiftedFlux : ℕ → (Fin m → ℝ) := fun k => edgeFlux (start + k)
  have hupdate (k : ℕ) :
      conservativeFluxDifferenceUpdate (timeStep / cellWidth)
          shiftedBefore shiftedFlux k =
        conservativeFluxDifferenceUpdate (timeStep / cellWidth)
          before edgeFlux (start + k) := by
    simp [conservativeFluxDifferenceUpdate, shiftedBefore, shiftedFlux,
      Nat.add_assoc]
  have hsum := sum_conservativeFluxDifferenceUpdate
    (timeStep / cellWidth) shiftedBefore shiftedFlux cellCount
  have hscale : cellWidth * (timeStep / cellWidth) = timeStep := by
    field_simp
  calc
    (∑ k ∈ Finset.range cellCount,
      cellWidth • conservativeFluxDifferenceUpdate
        (timeStep / cellWidth) before edgeFlux (start + k)) =
        cellWidth • (∑ k ∈ Finset.range cellCount,
          conservativeFluxDifferenceUpdate
            (timeStep / cellWidth) shiftedBefore shiftedFlux k) := by
              rw [Finset.smul_sum]
              apply Finset.sum_congr rfl
              intro k _
              rw [hupdate]
    _ = cellWidth • ((∑ k ∈ Finset.range cellCount, shiftedBefore k) -
          (timeStep / cellWidth) •
            (shiftedFlux cellCount - shiftedFlux 0)) := by rw [hsum]
    _ = _ := by
      simp [shiftedBefore, shiftedFlux, smul_sub, smul_smul,
        hscale, Finset.smul_sum]

end NumStability
