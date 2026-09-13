/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Pointwise classical conservation from all interval identities

Proof-free target for (2.10). Actual partial derivative witnesses identify the
residual, and its continuity includes the endpoints of a nondegenerate section.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- Vanishing integrals on every subinterval force the actual conservation residual to vanish. -/
def pointwiseConservationTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ) (qt fluxDerivative : ℝ → ℝ)
    (L R t : ℝ), L < R →
    (∀ x ∈ Icc L R, HasDerivAt (q x) (qt x) t) →
    (∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => flux (q ξ t)) (fluxDerivative x) (Icc L R) x) →
    ContinuousOn (fun x => qt x + fluxDerivative x) (Icc L R) →
    (∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      ∫ x in a..b, (qt x + fluxDerivative x) = 0) →
    ∀ x ∈ Icc L R, qt x + fluxDerivative x = 0

end NumStability.Leveque02Tracer
