/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityCoordinatesTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.CapacityBalanceTarget

/-!
# Capacity coordinates realized by a conservative field

The coordinate definition is coupled to the actual differential conservation
law. An evolving positive scalar field on a space-time rectangle realizes
nonconstant positive capacity, distinct weighted and unweighted states, and
nonzero flux and state rates. This witnesses the mathematical occurrence of
the model without identifying every possible physical application.
This is a proof-free proposal for independent source audit.
-/

open Set

namespace NumStability.Leveque02Tracer

/-- Capacity coordinates, their balance law, and a nontrivial conservative realization. -/
def capacityRealizationTarget : Prop :=
  capacityModelTarget ∧ capacityBalanceTarget ∧
  ∃ (capacity : ℝ → ℝ) (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ),
    capacity 0 ≠ capacity 1 ∧
    ∀ x ∈ Ioo (0 : ℝ) 1, ∀ t ∈ Ioo (0 : ℝ) 1,
      0 < capacity x ∧ 0 < q x t ∧
      (capacityStateFlux (capacity x) (q x t) flux).1 ≠ q x t ∧
      ∃ qt conservedRate fluxRate : ℝ,
        qt ≠ 0 ∧ fluxRate ≠ 0 ∧
        HasDerivAt (fun τ => q x τ) qt t ∧
        HasDerivAt (fun τ => (capacityStateFlux (capacity x) (q x τ) flux).1)
          conservedRate t ∧
        HasDerivAt (fun ξ => (capacityStateFlux (capacity ξ) (q ξ t) flux).2)
          fluxRate x ∧ conservedRate + fluxRate = 0

end NumStability.Leveque02Tracer
