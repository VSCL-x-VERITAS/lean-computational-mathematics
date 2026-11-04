/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernel
import Mathlib.MeasureTheory.Integral.BoundedContinuousFunction
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
# The canonical whole-line Gaussian heat evolution

The positive-time field is the actual Lebesgue convolution with the fixed
Gaussian heat kernel. The nonpositive-time branch merely totalizes the function;
only its value at zero is part of the Cauchy interpretation. No assertion about
backward heat flow or uniqueness among arbitrary classical solutions is made.
-/

namespace NumStability

open MeasureTheory

/-- The canonical Gaussian convolution, with the initial value assigned at zero.
For arbitrary raw data the integral is Mathlib's total Bochner integral; analytic
claims about it require the explicitly selected bounded continuous data class. -/
noncomputable def gaussianHeatFlow (diffusion : ℝ) (initial : ℝ → ℝ)
    (space time : ℝ) : ℝ :=
  if 0 < time then
    ∫ location : ℝ, gaussianHeatKernel diffusion time (space - location) * initial location
  else initial space

/-- Exactly the raw functions represented by bounded continuous real functions.
This is the whole bounded continuous class, rather than only compactly supported
profiles used to witness local influence. -/
def IsBoundedContinuousHeatData (initial : ℝ → ℝ) : Prop :=
  ∃ bundled : BoundedContinuousFunction ℝ ℝ, (bundled : ℝ → ℝ) = initial

end NumStability
