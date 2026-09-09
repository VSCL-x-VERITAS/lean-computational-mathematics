/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Variation over actual coordinate edges

Each internal edge is counted once and each missing-neighbor exterior edge is retained.
A common cell shift cancels at internal edges; fixed-ghost boundary variation is bounded
by the actual boundary-edge count. Two-edge bounds explicitly require that count bound.
-/

namespace NumStability.FiniteCoordinate.LineCoordinates
open NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Line : Type*} {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The same once-per-left-edge sum as the physical-quality interface, with
an extra right edge only at missing next lookup. No ghost is an active cell. -/
noncomputable def onceEdgeVariation [Fintype Cell]
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line)
    (ghost : D → Line → ℤ → State) (current : Cell → State) : ℝ := by
  classical
  let actual := coord.withGhost ghost
  exact ∑ cell, if actual.cellLine d cell = line then
    ‖current cell - actual.extract d line current (actual.cellIndex d cell - 1)‖ +
      (if actual.lookup d line (actual.cellIndex d cell + 1) = none then
        ‖actual.extract d line current (actual.cellIndex d cell + 1) - current cell‖ else 0) else 0

/-- Actual boundary-edge count on a selected line. Holes produce additional
boundary edges; no universal two-edge assertion is built into this count. -/
noncomputable def boundaryCount [Fintype Cell]
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line) : ℕ := by
  classical
  exact ∑ cell, if coord.cellLine d cell = line then
    (if coord.lookup d line (coord.cellIndex d cell - 1) = none then 1 else 0) +
      (if coord.lookup d line (coord.cellIndex d cell + 1) = none then 1 else 0) else 0

theorem variation_add_le [Fintype Cell] (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (ghost : D → Line → ℤ → State) (current : Cell → State) (shift : State) :
    NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation coord d line ghost (fun cell => current cell + shift) ≤
      NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation coord d line ghost current +
        (boundaryCount coord d line : ℝ) * ‖shift‖ := by
  classical
  unfold NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation boundaryCount
  simp only [Nat.cast_sum, Finset.sum_mul, ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro cell _
  by_cases hl : coord.cellLine d cell = line
  · have hleft : ‖current cell + shift - ghost d line (coord.cellIndex d cell - 1)‖ ≤
        ‖current cell - ghost d line (coord.cellIndex d cell - 1)‖ + ‖shift‖ := by
      simpa [add_comm] using norm_sub_le_norm_sub_add_norm_sub
        (current cell + shift) (current cell) (ghost d line (coord.cellIndex d cell - 1))
    have hright : ‖ghost d line (coord.cellIndex d cell + 1) - (current cell + shift)‖ ≤
        ‖ghost d line (coord.cellIndex d cell + 1) - current cell‖ + ‖shift‖ := by
      simpa using norm_sub_le_norm_sub_add_norm_sub
        (ghost d line (coord.cellIndex d cell + 1)) (current cell) (current cell + shift)
    cases hp : coord.lookup d line (coord.cellIndex d cell - 1) <;>
      cases hn : coord.lookup d line (coord.cellIndex d cell + 1) <;>
        simp [LineCoordinates.withGhost, LineCoordinates.extract, hl, hp, hn] <;> linarith
  · simp [LineCoordinates.withGhost, hl]

theorem variation_add_le_two [Fintype Cell] (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (ghost : D → Line → ℤ → State) (current : Cell → State) (shift : State)
    (hcount : boundaryCount coord d line ≤ 2) :
    NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation coord d line ghost (fun cell => current cell + shift) ≤
      NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation coord d line ghost current + 2 * ‖shift‖ := by
  apply (variation_add_le coord d line ghost current shift).trans
  have hc : (boundaryCount coord d line : ℝ) ≤ 2 := by exact_mod_cast hcount
  exact add_le_add le_rfl (mul_le_mul_of_nonneg_right hc (norm_nonneg shift))

end NumStability.FiniteCoordinate.LineCoordinates
