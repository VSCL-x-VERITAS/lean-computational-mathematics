/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainEntropyAE

/-!
# Entropy inequality for an ordered finite Riemann chain

The pointwise nonlinear map identity transports the individual entropy
inequalities to the constructed field. Spatial and boundary entropy-flux
integrability are explicit hypotheses; no global comparison field is used.
-/

open MeasureTheory
namespace NumStability

/-- Ordered noninteracting profiles transport individual entropy inequalities
to the actual constructed field, for arbitrary scalar entropy/entropy flux. -/
theorem finiteRiemannChain_entropy_rectangle_of_ordered_profiles
    {E : Type*} [AddCommGroup E]
    (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E) (count : ℕ)
    (entropy entropyFlux : E → ℝ) (a b s t : ℝ) (hab : a ≤ b) (hst : s ≤ t)
    (hpattern : ∀ x ∈ Set.Icc a b, ∀ τ ∈ Set.Icc s t,
      IsOrderedFiniteRiemannChain states (fun j => fields j x τ) count)
    (hspace : ∀ j < count, ∀ τ ∈ ({s, t} : Set ℝ),
      IntervalIntegrable (fun x => entropy (fields j x τ)) volume a b)
    (hflux : ∀ j < count, ∀ x ∈ ({a, b} : Set ℝ),
      IntervalIntegrable (fun τ => entropyFlux (fields j x τ)) volume s t)
    (hlocal : ∀ j < count,
      (∫ x in a..b, entropy (fields j x t)) -
        (∫ x in a..b, entropy (fields j x s)) ≤
          ∫ τ in s..t, entropyFlux (fields j a τ) - entropyFlux (fields j b τ)) :
    (∫ x in a..b, entropy (finiteRiemannChainAssembly states (fun j => fields j x t) count)) -
      (∫ x in a..b, entropy (finiteRiemannChainAssembly states (fun j => fields j x s) count)) ≤
        ∫ τ in s..t,
          entropyFlux (finiteRiemannChainAssembly states (fun j => fields j a τ) count) -
          entropyFlux (finiteRiemannChainAssembly states (fun j => fields j b τ) count) := by
  apply finiteRiemannChain_entropy_rectangle_of_ae_ordered_profiles states fields count
    entropy entropyFlux a b s t hab hst
  · intro τ hτ
    have hτ' : τ ∈ Set.Icc s t := by
      rcases (show τ = s ∨ τ = t by simpa using hτ) with heq | heq
      · subst τ; exact ⟨le_rfl, hst⟩
      · subst τ; exact ⟨hst, le_rfl⟩
    exact Filter.Eventually.of_forall (fun x hx => hpattern x hx τ hτ')
  · intro x hx
    have hx' : x ∈ Set.Icc a b := by
      rcases (show x = a ∨ x = b by simpa using hx) with heq | heq
      · subst x; exact ⟨le_rfl, hab⟩
      · subst x; exact ⟨hab, le_rfl⟩
    exact Filter.Eventually.of_forall (fun τ hτ => hpattern x hx' τ hτ)
  · exact hspace
  · exact hflux
  · exact hlocal

end NumStability
