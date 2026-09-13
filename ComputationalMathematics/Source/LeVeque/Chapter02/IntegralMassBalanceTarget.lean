/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassBalanceModel

/-!
# Proof-free target for LeVeque equation (2.2)

The target exposes the complete mathematical content of fixed-section mass
conservation: ordered endpoints, locally meaningful mass integrals, and the
actual time derivative equal to signed left flux minus signed right flux.
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The fixed-section conservation predicate is precisely equation (2.2). -/
def integralMassBalanceTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (leftFlux rightFlux : ℝ → ℝ) (a b t : ℝ),
    IsSectionMassConservationAt q leftFlux rightFlux a b t ↔
      a < b ∧
        (∀ᶠ τ in 𝓝 t, IntervalIntegrable (fun x => q x τ) volume a b) ∧
        HasDerivAt (fun τ => ∫ x in a..b, q x τ)
          (leftFlux t - rightFlux t) t

end NumStability.Leveque02Tracer
