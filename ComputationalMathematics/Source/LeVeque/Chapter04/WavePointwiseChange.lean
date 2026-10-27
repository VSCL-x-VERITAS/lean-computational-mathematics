/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ScalarAdvectionCellAverage
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Pointwise passage of an advection wave

LeVeque's printed page 75 describes the negative jump at each point swept
by a positive-speed wave. The uniform grid and one-cell CFL restriction
are the surrounding source context. Strict inequalities leave the value
at the discontinuity unrestricted.
-/

namespace NumStability

/-- Every strictly swept point changes by the negative neighboring-state jump. -/
theorem leveque04_wavePointwiseChange :
  ∀ (origin width speed elapsed : ℝ) (old : ℤ → ℝ) (initial : ℝ → ℝ),
    0 < width → 0 < speed → 0 < elapsed → speed * elapsed ≤ width →
    IsLeveque04PiecewiseConstantReconstruction
      (leveque04_uniformInterface origin width) old initial →
    ∀ (i : ℤ) (x : ℝ),
      leveque04_uniformInterface origin width (i - 1) < x →
      x < leveque04_uniformInterface origin width (i - 1) + speed * elapsed →
      leveque04_scalarAdvectedField initial speed x elapsed - initial x =
        -(old i - old (i - 1)) := by
  intro origin width speed elapsed old initial hwidth hspeed helapsed hcfl hrec
    i x hxleft hxright
  let interface := leveque04_uniformInterface origin width
  let left := interface (i - 1)
  let y := x - speed * elapsed
  have hxleftLocal : left < x := by
    simpa [left, interface] using hxleft
  have hxrightLocal : x < left + speed * elapsed := by
    simpa [left, interface] using hxright
  have hgrid (j : ℤ) : interface (j - 1) + width = interface j := by
    dsimp [interface, leveque04_uniformInterface]
    push_cast
    ring
  have hleftGrid : interface ((i - 1) - 1) + width = left := by
    simpa only [left] using hgrid (i - 1)
  have hrightGrid : left + width = interface i := by
    simpa only [left] using hgrid i
  have hxupper : x < interface i := by
    rw [← hrightGrid]
    apply lt_of_lt_of_le hxrightLocal
    simpa only [add_comm] using add_le_add_left hcfl left
  have hyupper : y < left := by
    dsimp [y]
    linarith [hxrightLocal]
  have hylower : interface ((i - 1) - 1) < y := by
    dsimp [y]
    linarith [hxleftLocal, hcfl, hleftGrid]
  have hxcell : x ∈ leveque04_cell interface i := by
    change interface (i - 1) < x ∧ x < interface i
    exact ⟨hxleftLocal, hxupper⟩
  have hycell : y ∈ leveque04_cell interface (i - 1) := by
    change interface ((i - 1) - 1) < y ∧ y < interface (i - 1)
    exact ⟨hylower, hyupper⟩
  have hxvalue := hrec i x hxcell
  have hyvalue := hrec (i - 1) y hycell
  have hshift : initial (x - speed * elapsed) = old (i - 1) := by
    simpa [y] using hyvalue
  calc
    leveque04_scalarAdvectedField initial speed x elapsed - initial x =
        old (i - 1) - old i := by
      rw [leveque04_scalarAdvectedField, hshift, hxvalue]
    _ = -(old i - old (i - 1)) := by ring

end NumStability
