/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IntegralMassBalanceCumulativeTarget

/-!
# Pointwise balance from cumulative section conservation

The cumulative source-free balance gives the ordinary derivative in LeVeque
(2.2) when the signed net endpoint flux is continuous. This is a conditional
bridge: the printed equation does not state that regularity hypothesis.
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- A continuous net endpoint flux turns finite-time source-free conservation
into the pointwise section-mass derivative. -/
theorem integralMassBalance_fromCumulative : integralMassBalanceCumulativeTarget := by
  intro q leftFlux rightFlux a b t hconservation
  rcases hconservation with ⟨hab, hqIntegrable, hfluxContinuous, hbalance⟩
  refine ⟨hab, ?_, ?_⟩
  · exact Filter.Eventually.of_forall hqIntegrable
  · have hfluxDeriv :
        HasDerivAt
          (fun s => ∫ τ in t..s, leftFlux τ - rightFlux τ)
          (leftFlux t - rightFlux t) t :=
      intervalIntegral.integral_hasDerivAt_right
        (hfluxContinuous.intervalIntegrable t t)
        hfluxContinuous.aestronglyMeasurable.stronglyMeasurableAtFilter
        hfluxContinuous.continuousAt
    have hmassEq :
        (fun s => ∫ x in a..b, q x s) =
          (fun s => (∫ τ in t..s, leftFlux τ - rightFlux τ) +
            (∫ x in a..b, q x t)) := by
      funext s
      exact sub_eq_iff_eq_add.mp (hbalance s)
    rw [hmassEq]
    exact hfluxDeriv.add_const _

end NumStability.Leveque02Tracer
