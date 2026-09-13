/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Integral flux derivative with locally defined mass

The mass integrals exist throughout a neighborhood of the selected time.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The FTC flux rewrite preserves the actual derivative of the locally defined mass. -/
def integralFluxDerivativeLocalTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ) (fluxDerivative : ℝ → ℝ)
    (a b t : ℝ), a ≤ b →
    (∀ᶠ τ in 𝓝 t, IntervalIntegrable (fun x => q x τ) volume a b) →
    ContinuousOn (fun x => flux (q x t)) (Icc a b) →
    (∀ x ∈ Ioo a b, HasDerivAt (fun ξ => flux (q ξ t)) (fluxDerivative x) x) →
    IntervalIntegrable fluxDerivative volume a b →
    (HasDerivAt (fun τ => ∫ x in a..b, q x τ) (flux (q a t) - flux (q b t)) t ↔
      HasDerivAt (fun τ => ∫ x in a..b, q x τ) (-(∫ x in a..b, fluxDerivative x)) t)

end NumStability.Leveque02Tracer
