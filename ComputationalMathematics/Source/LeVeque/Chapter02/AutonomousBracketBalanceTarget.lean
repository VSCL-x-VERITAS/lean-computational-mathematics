/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Endpoint-bracket form of the autonomous integral law

LeVeque (2.7) writes the endpoint difference in (2.6) as the negative
endpoint bracket. The premise is the ordinary section-mass derivative from
(2.6); this target records only the signed rewriting.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- The endpoint bracket in (2.7) has the sign of the mass balance in (2.6). -/
def autonomousBracketBalanceTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ) (a b t : ℝ),
    a < b →
      (HasDerivAt (fun τ => ∫ x in a..b, q x τ)
          (flux (q a t) - flux (q b t)) t ↔
        HasDerivAt (fun τ => ∫ x in a..b, q x τ)
          (-(flux (q b t) - flux (q a t))) t)

end NumStability.Leveque02Tracer
