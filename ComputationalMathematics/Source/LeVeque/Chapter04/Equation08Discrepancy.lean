/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.TotalMass
import Mathlib.Tactic.NormNum

/-!
# LeVeque Chapter 4, equation (4.8): flux-scale discrepancy

The printed equation retains `Δt / Δx` after summing weighted cell averages.
Multiplication by the cell width cancels that denominator; the corrected
boundary term is `Δt` times the exterior flux difference.
-/

open scoped BigOperators

namespace NumStability

/-- The literal coefficient in printed equation (4.8), over a consecutive
block of cells. -/
def leveque04_equation08_printed {m : ℕ}
    (timeStep cellWidth : ℝ)
    (before edgeFlux : ℕ → (Fin m → ℝ)) (start cellCount : ℕ) : Prop :=
  (∑ k ∈ Finset.range cellCount,
    cellWidth • conservativeFluxDifferenceUpdate
      (timeStep / cellWidth) before edgeFlux (start + k)) =
    (∑ k ∈ Finset.range cellCount, cellWidth • before (start + k)) -
      (timeStep / cellWidth) •
        (edgeFlux (start + cellCount) - edgeFlux start)

/-- One cell of width `2`, time step `1`, and unit outward flux refutes the
printed `Δt / Δx` boundary coefficient. -/
theorem leveque04_equation08_refuted :
    ¬ leveque04_equation08_printed (m := 1) 1 2
      (fun _ _ => 0) (fun j _ => (j : ℝ)) 0 1 := by
  intro h
  have h0 := congrArg (fun v : Fin 1 → ℝ => v 0) h
  norm_num [leveque04_equation08_printed,
    conservativeFluxDifferenceUpdate] at h0
  have hneq : (1 : ℝ) ≠ 1 / 2 * 1 := by norm_num
  exact hneq h0

/-- The corrected formula has `Δt` multiplying the exterior flux difference
for any consecutive block. This forwards the existing boundary-flux theorem. -/
theorem leveque04_equation08_corrected {m : ℕ}
    (timeStep cellWidth : ℝ) (hwidth : 0 < cellWidth)
    (before edgeFlux : ℕ → (Fin m → ℝ)) (start cellCount : ℕ) :
    (∑ k ∈ Finset.range cellCount,
      cellWidth • conservativeFluxDifferenceUpdate
        (timeStep / cellWidth) before edgeFlux (start + k)) =
      (∑ k ∈ Finset.range cellCount, cellWidth • before (start + k)) -
        timeStep • (edgeFlux (start + cellCount) - edgeFlux start) :=
  leveque04_totalMass_boundaryFlux_from
    timeStep cellWidth hwidth before edgeFlux start cellCount

end NumStability
