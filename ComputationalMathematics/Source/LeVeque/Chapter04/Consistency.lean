/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LocalNumericalFlux
import Mathlib.Topology.Continuous
import Mathlib.Analysis.Normed.Group.Real

/-!
# LeVeque Chapter 4, equation (4.14): constant-state consistency

The source requires a two-state numerical flux to agree with the physical
flux when both arguments are the same constant state. This condition applies
to a proposed numerical flux; it is not true of every arbitrary function.
-/

open Filter
open scoped Topology

namespace NumStability

/-- The equal-state condition (4.14) for a two-state numerical flux. -/
def IsLeveque04ConsistentFlux {m : ℕ}
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ)) : Prop :=
  ∀ state, numericalFlux state state = physicalFlux state

/-- Equation (4.14), stated for every constant state of a flux satisfying
the consistency condition. -/
theorem leveque04_equation14 {m : ℕ}
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ))
    (hconsistent : IsLeveque04ConsistentFlux physicalFlux numericalFlux)
    (state : Fin m → ℝ) :
    numericalFlux state state = physicalFlux state :=
  hconsistent state

/-- A consistent two-state flux preserves a spatially constant state under
the conservative three-point update. -/
theorem leveque04_consistent_constantStep {m : ℕ}
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ))
    (hconsistent : IsLeveque04ConsistentFlux physicalFlux numericalFlux)
    (timeStep cellWidth : ℝ) (state : Fin m → ℝ) (i : ℤ) :
    leveque04_finiteVolumeUpdate timeStep cellWidth (fun _ => state)
      (leveque04_localInterfaceFlux numericalFlux (fun _ => state)) i = state := by
  simp [leveque04_finiteVolumeUpdate, conservativeFluxDifferenceUpdateInt,
    leveque04_localInterfaceFlux, hconsistent state]

/-- Under equation (4.14), joint continuity at the equal reference pair gives
    the paired numerical-flux limit stated on printed page 68. -/
theorem IsLeveque04ConsistentFlux.tendsto_diagonal_of_continuousAt
    {m : ℕ}
    {physicalFlux : (Fin m → ℝ) → (Fin m → ℝ)}
    {numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ)}
    {reference : Fin m → ℝ}
    (hconsistent : IsLeveque04ConsistentFlux physicalFlux numericalFlux)
    (hcontinuous : ContinuousAt
      (fun p : (Fin m → ℝ) × (Fin m → ℝ) => numericalFlux p.1 p.2)
      (reference, reference)) :
    Tendsto (fun p : (Fin m → ℝ) × (Fin m → ℝ) => numericalFlux p.1 p.2)
      (𝓝 (reference, reference)) (𝓝 (physicalFlux reference)) := by
  have hdiagonal := hconsistent reference
  simpa [hdiagonal] using hcontinuous.tendsto

end NumStability
