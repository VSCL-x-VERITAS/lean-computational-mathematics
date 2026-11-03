/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonDiffusion
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.WholeLineDiffusionL2Evolution

/-!
# The whole-line CN stencil and LeVeque's conservative flux equation

This bridge identifies the literal midpoint-divergence equation with the
actual source-facing conservative update (4.13). It holds for arbitrary arrays
and coefficients at positive physical mesh width.
-/

namespace NumStability

/-- The generic whole-line equation is exactly the actual conservative
Crank–Nicolson flux equation for positive cell width. -/
theorem leveque04_crankNicolson_wholeLineStep_iff
    (b before after : ℤ → ℝ) (width timeStep : ℝ) (hwidth : 0 < width) :
    IsWholeLineWeightedDiffusionCNStep b width timeStep before after ↔
      IsLeveque04CrankNicolsonStep timeStep width b before after := by
  rw [leveque04_equation13_iff timeStep width b before after hwidth]
  have halgebra (i : ℤ) :
      timeStep / 2 *
          ((b (i + 1) * ((after (i + 1) + before (i + 1)) - (after i + before i)) -
            b i * ((after i + before i) - (after (i - 1) + before (i - 1)))) / width ^ 2) =
        timeStep / (2 * width ^ 2) *
          (b (i + 1) * (before (i + 1) - before i) -
            b i * (before i - before (i - 1)) +
            b (i + 1) * (after (i + 1) - after i) -
            b i * (after i - after (i - 1))) := by
    field_simp [ne_of_gt hwidth]
    ring
  constructor
  · intro h i
    have hi := h i
    rw [halgebra] at hi
    linarith
  · intro h i
    rw [halgebra]
    linarith [h i]

end NumStability
