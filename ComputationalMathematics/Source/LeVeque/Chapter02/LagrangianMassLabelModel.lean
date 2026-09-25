/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Initial-density mass labels for one-dimensional Lagrangian particles
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- The oriented initial mass from an arbitrary reference location to `x`.
On an interval where the initial density is integrable, this is the particle
label in LeVeque equation (2.102). -/
noncomputable def lagrangianMassLabel
    (initialDensity : ℝ → ℝ) (referenceLocation x : ℝ) : ℝ :=
  ∫ s in referenceLocation..x, initialDensity s

end NumStability.Leveque02Tracer
