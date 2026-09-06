/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Module
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Module

/-!
# Conservative finite-volume flux differences

Source-independent data for a one-dimensional conservative update.  Interface
flux `edgeFlux i` is the flux through the left edge of cell `i`, so the update
subtracts the right-minus-left flux difference.  The finite-sum theorem makes
the resulting boundary-flux conservation exact.
-/

open scoped BigOperators

namespace NumStability

/-- One conservative flux-difference update of cell `i`.

`timeStepOverCellWidth` is the usual ratio `Δt / Δx`; keeping it abstract
also covers non-dimensionalized updates. -/
def conservativeFluxDifferenceUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (i : ℕ) : E :=
  cellAverages i -
    timeStepOverCellWidth • (edgeFlux (i + 1) - edgeFlux i)

/-- The same conservative edge-flux update on integer-indexed cells. -/
def conservativeFluxDifferenceUpdateInt
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℤ → E) (i : ℤ) : E :=
  cellAverages i -
    timeStepOverCellWidth • (edgeFlux (i + 1) - edgeFlux i)

/-- Summing a conservative flux-difference update over the first `cellCount`
cells cancels every interior interface flux.  Only the two boundary fluxes
remain. -/
theorem sum_conservativeFluxDifferenceUpdate
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (cellCount : ℕ) :
    ∑ i ∈ Finset.range cellCount,
        conservativeFluxDifferenceUpdate
          timeStepOverCellWidth cellAverages edgeFlux i =
      (∑ i ∈ Finset.range cellCount, cellAverages i) -
        timeStepOverCellWidth •
          (edgeFlux cellCount - edgeFlux 0) := by
  induction cellCount with
  | zero => simp
  | succ cellCount ih =>
      rw [Finset.sum_range_succ, Finset.sum_range_succ, ih]
      simp only [conservativeFluxDifferenceUpdate]
      module

/-- If the two boundary fluxes agree, a finite block's total cell average is
unchanged by the conservative update. -/
theorem sum_conservativeFluxDifferenceUpdate_of_boundaryFlux_eq
    {E : Type*} [AddCommGroup E] [Module ℝ E]
    (timeStepOverCellWidth : ℝ)
    (cellAverages edgeFlux : ℕ → E) (cellCount : ℕ)
    (hboundary : edgeFlux cellCount = edgeFlux 0) :
    ∑ i ∈ Finset.range cellCount,
        conservativeFluxDifferenceUpdate
          timeStepOverCellWidth cellAverages edgeFlux i =
      ∑ i ∈ Finset.range cellCount, cellAverages i := by
  rw [sum_conservativeFluxDifferenceUpdate, hboundary, sub_self,
    smul_zero, sub_zero]

end NumStability
