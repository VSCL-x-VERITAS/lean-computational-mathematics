/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassBalanceModel

/-!
# Fixed-section mass balance with internal production

This auxiliary predicate separates boundary transport from net creation inside
the section. Setting the internal-production rate to zero expresses the
physical premise immediately before LeVeque equation (2.2).
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- Section mass changes by endpoint transport plus net internal production. -/
def IsSectionMassBalanceWithProductionAt (q : ℝ → ℝ → ℝ)
    (leftFlux rightFlux : ℝ → ℝ) (internalProduction a b t : ℝ) : Prop :=
  a < b ∧
    (∀ᶠ τ in 𝓝 t, IntervalIntegrable (fun x => q x τ) volume a b) ∧
    HasDerivAt (fun τ => ∫ x in a..b, q x τ)
      (leftFlux t - rightFlux t + internalProduction) t

end NumStability.Leveque02Tracer

