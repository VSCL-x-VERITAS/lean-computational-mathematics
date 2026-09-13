/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Autonomous flux rewrite with locally defined mass

The mass integrals exist at nearby times used by the actual time derivative.
-/

open MeasureTheory Filter
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- Autonomous endpoint substitution for an ordinary, locally defined mass integral. -/
def autonomousIntegralFluxLocalTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ) (leftFlux rightFlux : ℝ → ℝ)
    (a b t : ℝ), a ≤ b →
    (∀ᶠ τ in 𝓝 t, IntervalIntegrable (fun x => q x τ) volume a b) →
    leftFlux t = flux (q a t) → rightFlux t = flux (q b t) →
    (HasDerivAt (fun τ => ∫ x in a..b, q x τ) (leftFlux t - rightFlux t) t ↔
      HasDerivAt (fun τ => ∫ x in a..b, q x τ) (flux (q a t) - flux (q b t)) t)

end NumStability.Leveque02Tracer
