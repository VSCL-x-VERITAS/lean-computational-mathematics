/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Momentum in the one-dimensional fluid model

Density is mass per unit length, velocity is signed, and their product is
momentum per unit length. Integrating this density over an ordered section
gives its momentum when the product is integrable. These definitions record
the physical quantities without imposing conservation on arbitrary fields.
-/

namespace NumStability.Leveque02Tracer

/-- Momentum density of the fluid, with its actual density and velocity. -/
noncomputable def fluidMomentumDensity
    (density velocity : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  density x t * velocity x t

/-- Momentum in a spatial section at the selected time. -/
noncomputable def fluidSectionMomentum
    (density velocity : ℝ → ℝ → ℝ) (a b t : ℝ) : ℝ :=
  ∫ x in a..b, fluidMomentumDensity density velocity x t

end NumStability.Leveque02Tracer
