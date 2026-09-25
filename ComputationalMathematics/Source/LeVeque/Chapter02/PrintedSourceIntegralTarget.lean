/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

/-!
# The printed integral balance with an internal source

This proof-free target retains the plus sign before the spatial flux
derivative in the unnumbered display immediately preceding (2.28).
The explicit derivative and interchange premises give the displayed
formal calculation its usual smooth interpretation.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The unnumbered source-balance integral as printed on page 22. -/
def printedSourceIntegralTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ)
    (sourceDensity : ℝ → ℝ → ℝ → ℝ)
    (qt fluxDerivative : ℝ → ℝ) (a b t massRate : ℝ),
    a < b →
    (∀ x ∈ Icc a b,
      HasDerivAt (fun τ => q x τ) (qt x) t ∧
      HasDerivAt (fun ξ => flux (q ξ t)) (fluxDerivative x) x ∧
      qt x + fluxDerivative x = sourceDensity (q x t) x t) →
    HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t →
    HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t →
    HasDerivAt (fun τ => ∫ x in a..b, q x τ)
      ((∫ x in a..b, fluxDerivative x) +
        ∫ x in a..b, sourceDensity (q x t) x t) t

end NumStability.Leveque02Tracer
