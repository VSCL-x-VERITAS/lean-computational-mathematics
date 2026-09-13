/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Fixed-section mass conservation

This predicate records LeVeque's basic integral conservation law for an
ordered one-dimensional pipe section. The density is integrable at nearby
times, and its actual section mass derivative equals left endpoint influx
minus right endpoint outflux.
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- Mass in an ordered fixed section changes only by signed endpoint flux. -/
def IsSectionMassConservationAt (q : ℝ → ℝ → ℝ)
    (leftFlux rightFlux : ℝ → ℝ) (a b t : ℝ) : Prop :=
  a < b ∧
    (∀ᶠ τ in 𝓝 t, IntervalIntegrable (fun x => q x τ) volume a b) ∧
    HasDerivAt (fun τ => ∫ x in a..b, q x τ)
      (leftFlux t - rightFlux t) t

end NumStability.Leveque02Tracer
