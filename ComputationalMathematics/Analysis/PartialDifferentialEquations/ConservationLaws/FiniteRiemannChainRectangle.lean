/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainRectangleAE

/-!
# Local conservation of an ordered finite Riemann chain

Local conservation of the individual profiles and the ordered-chain flux
identity yield conservation of the constructed field on a forward box.
No conserving global comparison evolution is assumed.
-/

open MeasureTheory
open NumStability.LocalConservationLaw

namespace NumStability

/-- At most one profile is active; earlier and later profiles have reached
their consecutive endpoint states. A gap may select any background state. -/
def IsOrderedFiniteRiemannChain {E : Type*}
    (states profiles : ℕ → E) (count : ℕ) : Prop :=
  (∃ k, k ≤ count ∧ (∀ j < k, profiles j = states (j + 1)) ∧
    (∀ j, k ≤ j → j < count → profiles j = states j)) ∨
  (∃ k, k < count ∧ (∀ j < k, profiles j = states (j + 1)) ∧
    (∀ j, k < j → j < count → profiles j = states j))

variable {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The actual constructed chain conserves the physical flux when its
range has the telescoping physical-flux identity on the forward box. -/
theorem finiteRiemannChain_rectangleReferenceOn_of_flux_eq
    (states : ℕ → State) (fields : ℕ → ℝ → ℝ → State) (count : ℕ)
    (flux : State → State) (left right horizon : ℝ) (horizon_nonneg : 0 ≤ horizon)
    (hfields : ∀ j < count, RectangleReferenceOn (fields j) flux left right horizon)
    (hflux : ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon,
      flux (finiteRiemannChainAssembly states (fun j => fields j x t) count) =
        finiteRiemannChainAssembly (fun j => flux (states j))
          (fun j => flux (fields j x t)) count) :
    RectangleReferenceOn
      (fun x t => finiteRiemannChainAssembly states (fun j => fields j x t) count)
      flux left right horizon := by
  apply finiteRiemannChain_rectangleReferenceOn_of_flux_eq_ae_time states fields count
    flux left right horizon horizon_nonneg hfields
  intro x hx
  exact Filter.Eventually.of_forall (fun t ht => hflux x hx t ht)

/-- An ordered noninteraction profile pattern supplies the flux identity
and hence the local conservation of the constructed nonlinear evolution. -/
theorem finiteRiemannChain_rectangleReferenceOn_of_ordered_profiles
    (states : ℕ → State) (fields : ℕ → ℝ → ℝ → State) (count : ℕ)
    (flux : State → State) (left right horizon : ℝ) (horizon_nonneg : 0 ≤ horizon)
    (hfields : ∀ j < count, RectangleReferenceOn (fields j) flux left right horizon)
    (hpattern : ∀ x ∈ Set.Icc left right, ∀ t ∈ Set.Icc 0 horizon,
      IsOrderedFiniteRiemannChain states (fun j => fields j x t) count) :
    RectangleReferenceOn
      (fun x t => finiteRiemannChainAssembly states (fun j => fields j x t) count)
      flux left right horizon := by
  apply finiteRiemannChain_rectangleReferenceOn_of_flux_eq states fields count flux left right horizon
    horizon_nonneg hfields
  intro x hx t ht
  rcases hpattern x hx t ht with ⟨k, hk, hbefore, hafter⟩ | ⟨k, hk, hbefore, hafter⟩
  · exact finiteRiemannChainAssembly_map_eq_of_state flux states (fun j => fields j x t)
      count k hk hbefore hafter
  · exact finiteRiemannChainAssembly_map_eq_of_profile flux states (fun j => fields j x t)
      count k hk hbefore hafter

end NumStability
