/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainSpacePattern
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainEntropyAE

/-!
# Entropy of asymmetric noninteracting Riemann chains

Actual asymmetric wave noninteraction transports constituent entropy inequalities to the constructed finite field throughout the entire closed forward step.
-/

open MeasureTheory
namespace NumStability

/-- Actual asymmetric wave noninteraction transports individual entropy
inequalities to the constructed field on the entire closed forward step. -/
theorem finiteRiemannChain_entropy_rectangle_of_affine_fronts
    {E : Type*} [AddCommGroup E] (states : ℕ → E) (fields : ℕ → ℝ → ℝ → E)
    (centers leftSpeed rightSpeed : ℕ → ℝ) (count : ℕ)
    (entropy entropyFlux : E → ℝ) (a b s t horizon : ℝ)
    (hab : a ≤ b) (hst : s ≤ t) (hs : 0 ≤ s) (ht : t ≤ horizon)
    (hcenters : ∀ i j, i < j → j < count → centers i < centers j)
    (hspeeds : ∀ j < count, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j, j + 1 < count →
      centers j + rightSpeed j * horizon ≤ centers (j + 1) + leftSpeed (j + 1) * horizon)
    (hleft : ∀ j < count, ∀ x, ∀ time ∈ Set.Icc 0 horizon,
      x < centers j + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ j < count, ∀ x, ∀ time ∈ Set.Icc 0 horizon,
      centers j + rightSpeed j * time < x → fields j x time = states (j + 1))
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
    have hτ' : τ ∈ Set.Icc 0 horizon := by
      rcases (show τ = s ∨ τ = t by simpa using hτ) with heq | heq
      · subst τ; exact ⟨hs, hst.trans ht⟩
      · subst τ; exact ⟨hs.trans hst, ht⟩
    have hp := isOrderedFiniteRiemannChain_of_affine_fronts_ae_space states fields
      centers leftSpeed rightSpeed count horizon τ hcenters hspeeds hτ' hinteraction
      (fun j hj x => hleft j hj x τ hτ') (fun j hj x => hright j hj x τ hτ')
    exact hp.mono (fun x hx _ => hx)
  · intro x _
    have hp := isOrderedFiniteRiemannChain_of_affine_fronts_ae_time states fields
      centers leftSpeed rightSpeed count horizon x hcenters hspeeds hinteraction
      (fun j hj τ hτ => hleft j hj x τ hτ) (fun j hj τ hτ => hright j hj x τ hτ)
    exact hp.mono (fun τ hτ hτ' => hτ ⟨hs.trans hτ'.1, hτ'.2.trans ht⟩)
  · exact hspace
  · exact hflux
  · exact hlocal

end NumStability
